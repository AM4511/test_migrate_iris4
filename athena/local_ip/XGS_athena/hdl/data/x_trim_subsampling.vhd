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
    aclk_en      : in std_logic;
    aclk_init    : in std_logic;
    aclk_data_in : in std_logic_vector(63 downto 0);
    aclk_ben_in  : in std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    aclk_data_out : out std_logic_vector(63 downto 0);
    aclk_ben_out  : out std_logic_vector(7 downto 0)
    );
end x_trim_subsampling;


architecture rtl of x_trim_subsampling is


  attribute mark_debug : string;
  attribute keep       : string;



  type CNTR_ARRAY is array (7 downto 0) of unsigned(4 downto 0);


  signal subs_cntr   : CNTR_ARRAY;
  signal subs_lut    : unsigned(15 downto 0);
  signal pix_per_clk : unsigned(4 downto 0);
  signal subs_ben    : std_logic_vector(7 downto 0);

begin


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_subs_lut : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        subs_lut <= "1111111111111111";
      else
        if (aclk_init = '1') then
          case aclk_x_subsampling is
            when "0000" => subs_lut <= "1111111111111111";
            when "0001" => subs_lut <= "0101010101010101";
            when "0010" => subs_lut <= "1001001001001001";
            when "0011" => subs_lut <= "0001000100010001";
            when "0100" => subs_lut <= "1000010000100001";
            when "0101" => subs_lut <= "0001000001000001";
            when "0110" => subs_lut <= "1100000010000001";
            when "0111" => subs_lut <= "0000000100000001";
            when "1000" => subs_lut <= "0000001000000001";
            when "1001" => subs_lut <= "0000010000000001";
            when "1010" => subs_lut <= "0000100000000001";
            when "1011" => subs_lut <= "0001000000000001";
            when "1100" => subs_lut <= "0010000000000001";
            when "1101" => subs_lut <= "0100000000000001";
            when "1110" => subs_lut <= "1000000000000001";
            when "1111" => subs_lut <= "0000000000000001";
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
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
        if (aclk_init = '1') then
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
                subs_cntr(4) <= "00010";
                subs_cntr(5) <= "00010";
                subs_cntr(6) <= "00010";
                subs_cntr(7) <= "00010";
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
            if (sum >= unsigned('0' & aclk_x_subsampling)) then
              subs_cntr(i) <= sum - unsigned('0' & aclk_x_subsampling);
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
  -- 
  -----------------------------------------------------------------------------
  P_subs_ben : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        subs_ben <= (others => '0');
      else
        for i in 0 to 7 loop
          for j in 0 to 15 loop
            if (to_unsigned(j, 5) = subs_cntr(i)) then
              subs_ben(i) <= subs_lut(j);
              exit;
            end if;
          end loop;
        end loop;
      end if;
    end if;
  end process;

  
end architecture rtl;
