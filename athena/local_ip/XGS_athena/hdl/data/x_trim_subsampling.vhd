-----------------------------------------------------------------------
-- MODULE        : x_trim_subsampling
-- 
-- DESCRIPTION   : 
--              
--
-- ToDO: Implement sub-sampling
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity x_trim_subsampling is
  port (
    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    aclk       : in std_logic;
    aclk_reset : in std_logic;

    ---------------------------------------------------------------------------
    -- 
    ---------------------------------------------------------------------------
    aclk_pixel_width   : in std_logic_vector(2 downto 0);
    aclk_x_subsampling : in std_logic_vector(3 downto 0);

    ---------------------------------------------------------------------------
    -- Input stream
    ---------------------------------------------------------------------------
    aclk_en   : in std_logic;
    aclk_init : in std_logic;

    aclk_last_data_in : in std_logic;
    aclk_data_in      : in std_logic_vector(63 downto 0);
    aclk_ben_in       : in std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    aclk_empty          : out std_logic;
    aclk_data_valid_out : out std_logic;
    aclk_last_data_out  : out std_logic;
    aclk_data_out       : out std_logic_vector(63 downto 0);
    aclk_ben_out        : out std_logic_vector(7 downto 0)
    );
end x_trim_subsampling;


architecture rtl of x_trim_subsampling is


  attribute mark_debug : string;
  attribute keep       : string;


  type FSM_TYPE is (S_IDLE, S_INIT, S_SUB_SAMPLE, S_FLUSH, S_DONE);
  type CNTR_ARRAY is array (7 downto 0) of unsigned(4 downto 0);


  signal state        : FSM_TYPE := S_IDLE;
  signal subs_cntr    : CNTR_ARRAY;
  signal subs_lut     : unsigned(15 downto 0);
  signal pix_per_clk  : unsigned(4 downto 0);
  signal modulo_count : unsigned(4 downto 0);
  signal subs_ben     : std_logic_vector(7 downto 0);
  signal subs_mask    : std_logic_vector(7 downto 0);
  
  signal p1_ld        : std_logic;
  signal p1_valid     : std_logic;
  signal p1_last_data : std_logic;
  signal p1_data      : std_logic_vector(63 downto 0);
  signal p1_ben       : std_logic_vector(7 downto 0);

  signal p2_ld        : std_logic;
  signal p2_valid     : std_logic;
  signal p2_last_data : std_logic;
  signal p2_data      : std_logic_vector(63 downto 0);
  signal p2_ben       : std_logic_vector(7 downto 0);
  signal p2_byte_cnt  : unsigned(3 downto 0);

  signal p3_ld        : std_logic;
  signal p3_valid     : std_logic;
  signal p3_last_data : std_logic;
  signal p3_data      : std_logic_vector(63 downto 0);
  signal p3_ben       : std_logic_vector(7 downto 0);
  signal p3_byte_ptr  : unsigned(3 downto 0);


begin

  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Subsampling controller main state machine
  -----------------------------------------------------------------------------
  P_state : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        state <= S_IDLE;
      else

        case state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (aclk_init = '1') then
              state <= S_INIT;

            else
              state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_INIT =>
            state <= S_SUB_SAMPLE;


          -------------------------------------------------------------------
          -- S_SOL : Start of line; initialize the current buffer for a new
          --         line storage
          -------------------------------------------------------------------
          when S_SUB_SAMPLE =>
            if (aclk_last_data_in = '1') then
              state <= S_FLUSH;
            else
              state <= S_SUB_SAMPLE;
            end if;


          -------------------------------------------------------------------
          --  S_WRITE : 
          -------------------------------------------------------------------
          when S_FLUSH =>
            if (p1_valid = '0' and p2_valid = '0') then
              state <= S_DONE;
            else
              state <= S_FLUSH;

            end if;


          -------------------------------------------------------------------
          -- S_DONE : Switch line buffer
          -------------------------------------------------------------------
          when S_DONE =>
            state <= S_IDLE;

          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_subs_lut
  -- Description : Subsampling lookup table
  -----------------------------------------------------------------------------
  P_subs_lut : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        subs_lut <= "1111111111111111";
      else
        if (state = S_INIT) then
          -- Create lookup table vs the subsampling factor (0-based)
          case aclk_x_subsampling is
            when "0000" => subs_lut <= "1111111111111111"; -- subs. by 1
            when "0001" => subs_lut <= "--------01010101"; -- subs. by 2
            when "0010" => subs_lut <= "1001001001001001"; -- subs. by 3
            when "0011" => subs_lut <= "0001000100010001"; -- subs. by 4
            when "0100" => subs_lut <= "1000010000100001"; -- subs. by 5
            when "0101" => subs_lut <= "0001000001000001"; -- subs. by 6
            when "0110" => subs_lut <= "0100000010000001"; -- subs. by 7
            when "0111" => subs_lut <= "0000000100000001"; -- subs. by 8
            when "1000" => subs_lut <= "0000001000000001"; -- subs. by 9
            when "1001" => subs_lut <= "0000010000000001"; -- subs. by 10
            when "1010" => subs_lut <= "0000100000000001"; -- subs. by 11
            when "1011" => subs_lut <= "0001000000000001"; -- subs. by 12
            when "1100" => subs_lut <= "0010000000000001"; -- subs. by 13
            when "1101" => subs_lut <= "0100000000000001"; -- subs. by 14
            when "1110" => subs_lut <= "1000000000000001"; -- subs. by 15
            when "1111" => subs_lut <= "0000000000000001"; -- subs. by 16
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

  
  -----------------------------------------------------------------------------
  -- Process     : P_modulo_count
  -- Description : Modulo counter treshold
  -----------------------------------------------------------------------------
  P_modulo_count : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        modulo_count <= (others => '0');
      else
        if (state = S_INIT) then
          case aclk_x_subsampling is
            when "0000" => modulo_count <= "01000";  -- mod 8
            when "0001" => modulo_count <= "01000";  -- mod 8
            when "0010" => modulo_count <= "01001";  -- mod 9
            when "0011" => modulo_count <= "01000";  -- mod 8
            when "0100" => modulo_count <= "01010";  -- mod 10
            when "0101" => modulo_count <= "01100";  -- mod 12
            when "0110" => modulo_count <= "01110";  -- mod 14
            when "0111" => modulo_count <= "01000";  -- mod 8
            when "1000" => modulo_count <= "01001";  -- mod 9
            when "1001" => modulo_count <= "01010";  -- mod 10
            when "1010" => modulo_count <= "01011";  -- mod 11
            when "1011" => modulo_count <= "01100";  -- mod 12
            when "1100" => modulo_count <= "01101";  -- mod 13
            when "1101" => modulo_count <= "01110";  -- mod 14
            when "1110" => modulo_count <= "01111";  -- mod 15
            when "1111" => modulo_count <= "10000";  -- mod 16
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_subs_cntr
  -- Description : 8 Subsampling counters in parallel (one per byte)
  -----------------------------------------------------------------------------
  P_subs_cntr : process (aclk) is
    variable sum : unsigned(4 downto 0);
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        subs_cntr(0) <= "00000";
        subs_cntr(1) <= "00001";
        subs_cntr(2) <= "00010";
        subs_cntr(3) <= "00011";
        subs_cntr(4) <= "00100";
        subs_cntr(5) <= "00101";
        subs_cntr(6) <= "00110";
        subs_cntr(7) <= "00111";
        pix_per_clk  <= "01000";
      else
        -----------------------------------------------------------------------
        -- Sub-sampling counters initialisation
        -----------------------------------------------------------------------
        if (state = S_INIT) then
          for i in 0 to 7 loop
            case aclk_pixel_width is
              when "001" =>
                subs_cntr(0) <= "00000";
                subs_cntr(1) <= "00001";
                subs_cntr(2) <= "00010";
                subs_cntr(3) <= "00011";
                subs_cntr(4) <= "00100";
                subs_cntr(5) <= "00101";
                subs_cntr(6) <= "00110";
                subs_cntr(7) <= "00111";
                pix_per_clk  <= "01000";
              when "010" =>
                subs_cntr(0) <= "00000";
                subs_cntr(1) <= "00000";
                subs_cntr(2) <= "00001";
                subs_cntr(3) <= "00001";
                subs_cntr(4) <= "00010";
                subs_cntr(5) <= "00010";
                subs_cntr(6) <= "00011";
                subs_cntr(7) <= "00011";
                pix_per_clk  <= "00100";
              when "100" =>
                subs_cntr(0) <= "00000";
                subs_cntr(1) <= "00000";
                subs_cntr(2) <= "00000";
                subs_cntr(3) <= "00000";
                subs_cntr(4) <= "00001";
                subs_cntr(5) <= "00001";
                subs_cntr(6) <= "00001";
                subs_cntr(7) <= "00001";
                pix_per_clk  <= "00010";
              when others =>
                subs_cntr(0) <= "00000";
                subs_cntr(1) <= "00001";
                subs_cntr(2) <= "00010";
                subs_cntr(3) <= "00011";
                subs_cntr(4) <= "00100";
                subs_cntr(5) <= "00101";
                subs_cntr(6) <= "00110";
                subs_cntr(7) <= "00111";
                pix_per_clk  <= "01000";
            end case;
          end loop;

        -----------------------------------------------------------------------
        -- Modulo aclk_x_subsampling count 
        -----------------------------------------------------------------------
        elsif (aclk_en = '1') then
          for i in 0 to 7 loop
            sum := subs_cntr(i) + pix_per_clk;

            -- Wrap around
            if (sum >= modulo_count) then
              subs_cntr(i) <= sum - modulo_count;
            --  Regular count
            else
              subs_cntr(i) <= sum;
            end if;
          end loop;

        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_subs_ben
  -- Description : Deternmine the byte enable value based on the modulo counter
  --               and the ben lookup-table
  -----------------------------------------------------------------------------
  P_subs_ben : process (subs_cntr, subs_lut) is
  begin  -- process P_aa
    for i in 0 to 7 loop
      for j in 0 to 15 loop
        if (to_unsigned(j, 5) = subs_cntr(i)) then
          subs_ben(i) <= subs_lut(j);
          exit;
        else
          subs_ben(i) <= '0';
        end if;
      end loop;
    end loop;
  end process;


  p1_ld <= '1' when (aclk_en = '1' and state = S_SUB_SAMPLE) else
           '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p1_valid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p1_valid <= '0';
      else
        if (p1_ld = '1' and (subs_mask /= "00000000")) then
          p1_valid <= '1';
        elsif (p2_ld = '1') then
          p1_valid <= '0';
        end if;
      end if;
    end if;
  end process;

  subs_mask <= subs_ben and aclk_ben_in;
  
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p1_ben : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p1_ben <= (others => '0');
      else
        if (p1_ld = '1') then
          p1_ben <= subs_mask;
        elsif (p2_ld = '1') then
          p1_ben <= (others => '0');
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p1_data : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p1_data <= (others => '0');
      else
        if (p1_ld = '1') then
          p1_data <= aclk_data_in;
        end if;
      end if;
    end if;
  end process;


  p2_ld <= '1' when (p1_valid = '1' and (aclk_en = '1' or state = S_FLUSH)) else
           '0';

  
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p2_valid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p2_valid <= '0';
      else
        if (p2_ld = '1') then
          p2_valid <= '1';
        elsif (p3_ld = '1') then
          p2_valid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p2_data : process (aclk) is
    variable shift_value : integer;
    variable byte_ptr    : integer;
    variable byte_cnt    : integer;
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p2_ben      <= (others => '0');
        p2_data     <= (others => '0');
        p2_byte_cnt <= (others => '0');
      else
        if (p2_ld = '1') then
          p2_ben      <= (others => '0');
          p2_data     <= (others => '0');
          p2_byte_cnt <= (others => '0');
          byte_cnt    := 0;
          for i in 0 to 7 loop
            if (p1_ben(i) = '1') then
              shift_value := 0;
              byte_cnt    := byte_cnt+1;
              if (i > 0) then
                for j in i-1 downto 0 loop
                  if (p1_ben(j) = '0') then
                    shift_value := shift_value + 1;
                  end if;
                end loop;  -- j
              end if;
              byte_ptr                                := i-shift_value;
              p2_ben(byte_ptr)                        <= p1_ben(i);
              p2_data(7+8*byte_ptr downto 8*byte_ptr) <= p1_data(7+8*i downto 8*i);
              p2_byte_cnt                             <= to_unsigned(byte_cnt, 4);
            end if;

          end loop;  -- i 
        elsif (p3_ld = '1') then
          p2_ben      <= (others => '0');
          p2_byte_cnt <= (others => '0');
        end if;
      end if;
    end if;
  end process;


  p3_ld <= '1' when (p2_valid = '1'and (aclk_en = '1' or state = S_FLUSH)) else
           '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p3_valid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p3_valid <= '0';
      else
        if (p3_ld = '1') then
          p3_valid <= '1';
        elsif (p3_byte_ptr(3) = '1') then
          p3_valid <= '0';
        elsif (p3_last_data = '1') then
          p3_valid <= '0';
        end if;
      end if;
    end if;
  end process;



  p3_last_data <= '1' when (state = S_FLUSH and p1_valid = '0' and p2_valid = '0' and p3_valid = '1') else
                  '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p3_byte_ptr : process (aclk) is
    variable sum : unsigned(3 downto 0);
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then

        p3_byte_ptr <= (others => '0');
      else
        if (state = S_INIT) then
          p3_byte_ptr <= (others => '0');
        elsif (p3_ld = '1') then
          sum := p3_byte_ptr+p2_byte_cnt;
          if (p3_byte_ptr > "0111") then
            p3_byte_ptr <= sum - "1000";
          else
            p3_byte_ptr <= sum;
          end if;
        elsif (p3_byte_ptr(3) = '1' or p3_last_data = '1') then
          p3_byte_ptr <= (others => '0');
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_p3_data : process (aclk) is
    variable shift_value : integer;
    variable byte_ptr    : integer;
    variable byte_cnt    : integer;
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        p3_ben  <= (others => '0');
        p3_data <= (others => '0');
      else
        if (p3_ld = '1') then
          case p3_byte_ptr(2 downto 0) is
            when "000" =>
              p3_ben  <= p2_ben;
              p3_data <= p2_data;
            when "001" =>
              p3_ben(7 downto 1)   <= p2_ben(6 downto 0);
              p3_data(63 downto 8) <= p2_data(55 downto 0);
            when "010" =>
              p3_ben(7 downto 2)    <= p2_ben(5 downto 0);
              p3_data(63 downto 16) <= p2_data(47 downto 0);
            when "011" =>
              p3_ben(7 downto 3)    <= p2_ben(4 downto 0);
              p3_data(63 downto 24) <= p2_data(39 downto 0);
            when "100" =>
              p3_ben(7 downto 4)    <= p2_ben(3 downto 0);
              p3_data(63 downto 32) <= p2_data(31 downto 0);
            when "101" =>
              p3_ben(7 downto 5)    <= p2_ben(2 downto 0);
              p3_data(63 downto 40) <= p2_data(23 downto 0);
            when "110" =>
              p3_ben(7 downto 6)    <= p2_ben(1 downto 0);
              p3_data(63 downto 48) <= p2_data(15 downto 0);
            when "111" =>
              p3_ben(7)             <= p2_ben(0);
              p3_data(63 downto 56) <= p2_data(7 downto 0);
            when others => null;
          end case;

        elsif (p3_last_data = '1') then
          p3_ben <= (others => '0');
        end if;
      end if;
    end if;
  end process;


  aclk_empty <= '1' when (p1_valid = '0' and p2_valid = '0' and p3_valid = '0') else
                '0';

  
  aclk_last_data_out <= p3_last_data;


  aclk_data_valid_out <= '1' when (p3_byte_ptr(3) = '1' or p3_last_data = '1') else
                         '0';

  
  aclk_data_out <= p3_data;
  aclk_ben_out  <= p3_ben;

end architecture rtl;
