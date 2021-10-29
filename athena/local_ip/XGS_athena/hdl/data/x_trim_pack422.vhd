-----------------------------------------------------------------------
-- MODULE        : x_trim_pack422
-- 
-- DESCRIPTION   : Pack data YUV444 to YUV422 whe bclk_pack_en = '1'
--                 otherwise this module act as a simple pipeline
--                 (bypass).
-- 
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity x_trim_pack422 is
  port (
    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    bclk       : in std_logic;
    bclk_reset : in std_logic;

    ---------------------------------------------------------------------------
    -- 
    ---------------------------------------------------------------------------
    bclk_pack_en : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    bclk_tready : out std_logic;
    bclk_tvalid : in  std_logic;
    bclk_tuser  : in  std_logic_vector(3 downto 0);
    bclk_tlast  : in  std_logic;
    bclk_tdata  : in  std_logic_vector(63 downto 0);

    ---------------------------------------------------------------------------
    -- AXI master stream output interface
    ---------------------------------------------------------------------------
    bclk_tready_out : in  std_logic;
    bclk_tvalid_out : out std_logic;
    bclk_tuser_out  : out std_logic_vector(3 downto 0);
    bclk_tlast_out  : out std_logic;
    bclk_tdata_out  : out std_logic_vector(63 downto 0)
    );
end;


architecture rtl of x_trim_pack422 is


  attribute mark_debug : string;
  attribute keep       : string;

  type FSM_TYPE is (S_IDLE, S_SOF, S_SOL, S_TRANSFER, S_FLUSH, S_EOL, S_DONE);


  signal bclk_state      : FSM_TYPE := S_IDLE;
  signal bclk_load       : std_logic;
  signal bclk_ready      : std_logic;
  signal bclk_word_cntr  : unsigned(0 downto 0);
  signal bclk_data_valid : std_logic;
  signal bclk_data       : std_logic_vector(63 downto 0);
  signal bclk_load_data  : std_logic;


  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of bclk_tready          : signal is "true";


begin


  -----------------------------------------------------------------------------
  -- Flag used to indicate when the pipeline is ready to load a new data beat
  -----------------------------------------------------------------------------
  bclk_ready <= '1' when (bclk_tvalid = '1' and bclk_data_valid = '0') else
                '1' when (bclk_tvalid = '1' and bclk_tready_out = '1') else
                '0';
  
  -----------------------------------------------------------------------------
  -- Flag used to load the data beat. We load when there is data on the stream
  -- input port and the pipeline is ready to accept data.
  -----------------------------------------------------------------------------
  bclk_load <= '1'when (bclk_tvalid = '1' and bclk_ready = '1') else
               '0';


  bclk_tready <= bclk_ready;




  -----------------------------------------------------------------------------
  -- Process     : P_bclk_state
  -- Description : FSM
  -----------------------------------------------------------------------------
  P_bclk_state : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_state <= S_IDLE;
      else

        case bclk_state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (bclk_tvalid = '1' and bclk_ready = '1') then
              if (bclk_tuser(0) = '1') then
                bclk_state <= S_SOF;
              elsif (bclk_tuser(2) = '1') then
                bclk_state <= S_SOL;
              end if;
            else
              bclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_SOF =>
            bclk_state <= S_TRANSFER;


          -------------------------------------------------------------------
          -- S_SOL : Start of line detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_SOL =>
            bclk_state <= S_TRANSFER;


          -------------------------------------------------------------------
          --  S_TRANSFER : Indicates line transfer pocess
          -------------------------------------------------------------------
          when S_TRANSFER =>
            if (bclk_tvalid = '1' and bclk_ready = '1') then
              if (bclk_tlast = '1') then
                bclk_state <= S_EOL;
              else
                bclk_state <= S_TRANSFER;
              end if;
            end if;


          -------------------------------------------------------------------
          -- S_EOL : End of line encounter
          -------------------------------------------------------------------
          when S_EOL =>
            bclk_state <= S_DONE;


          -------------------------------------------------------------------
          -- S_DONE : Line transfer completed
          -------------------------------------------------------------------
          when S_DONE =>
            bclk_state <= S_IDLE;

          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_bclk_state;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_word_cntr
  -- Description : Packing counter. Used to generate the 422 packing pattern
  -----------------------------------------------------------------------------
  P_bclk_word_cntr : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_word_cntr <= (others => '0');
      else
        if (bclk_state = S_DONE) then
          bclk_word_cntr <= (others => '0');
        elsif (bclk_load = '1') then
          bclk_word_cntr <= bclk_word_cntr+1;
        end if;
      end if;
    end if;
  end process;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_data
  -- Description : Pack data in 422 format. Convert YUV from 444 to 422 (YUYV)
  ---------------------------------------------------------------------------
  P_bclk_data : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_data <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- If in pack data mode
        -----------------------------------------------------------------------
        if (bclk_pack_en = '1') then
          if (bclk_load = '1') then
            --if (bclk_tuser(0) = '1' or bclk_tuser(2) = '1' or (bclk_word_cntr = 0)) then
            if (bclk_word_cntr = 0) then
              bclk_data(7 downto 0)   <= bclk_tdata(7 downto 0);    -- Y0
              bclk_data(15 downto 8)  <= bclk_tdata(15 downto 8);   -- U0
              bclk_data(23 downto 16) <= bclk_tdata(39 downto 32);  -- Y1
              bclk_data(31 downto 24) <= bclk_tdata(23 downto 16);  -- V0
              --bclk_data(31 downto 24) <= bclk_tdata(55 downto 48);  -- V1
              bclk_data(63 downto 32) <= (others => '0');

            --elsif (bclk_word_cntr = 1) then
            else
              bclk_data(39 downto 32) <= bclk_tdata(7 downto 0);    -- Y2
              bclk_data(47 downto 40) <= bclk_tdata(15 downto 8);   -- U2
              bclk_data(55 downto 48) <= bclk_tdata(39 downto 32);  -- Y3
              bclk_data(63 downto 56) <= bclk_tdata(23 downto 16);  -- V2
              --bclk_data(63 downto 56) <= bclk_tdata(55 downto 48);  -- V3
            end if;
          end if;

        -----------------------------------------------------------------------
        -- If in bypass mode
        -----------------------------------------------------------------------
        else
          if (bclk_load = '1') then
            bclk_data <= bclk_tdata;
          end if;
        end if;
      end if;
    end if;
  end process;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_data_valid
  -- Description : Flag indicating that data is valid on the AXI stream output
  --               port I/F
  ---------------------------------------------------------------------------
  P_bclk_data_valid : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_data_valid <= '0';
      else
        -----------------------------------------------------------------------
        -- Packing mode
        -----------------------------------------------------------------------
        if (bclk_pack_en = '1') then

          -- When we full the packer or load the last data of the line
          if (bclk_load = '1' and (bclk_word_cntr = "1" or bclk_tlast = '1')) then
            bclk_data_valid <= '1';
          elsif (bclk_tready_out = '1') then
            bclk_data_valid <= '0';
          end if;


        -----------------------------------------------------------------------
        -- Bypass mode
        -----------------------------------------------------------------------
        else
          if (bclk_load = '1') then
            bclk_data_valid <= '1';
          elsif (bclk_tready_out = '1') then
            bclk_data_valid <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_tuser_out
  -- Description : 
  ---------------------------------------------------------------------------
  P_bclk_tuser_out : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_tuser_out <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Packing mode
        -----------------------------------------------------------------------
        if (bclk_pack_en = '1') then
          ---------------------------------------------------------------------
          -- When we have a SYNC we load immediately otherwise we load on
          -- bclk_word_cntr = '1'
          ---------------------------------------------------------------------
          if (bclk_load = '1') then
            if (bclk_tuser /= "0000" or (bclk_word_cntr = "0" and bclk_state = S_TRANSFER)) then
              bclk_tuser_out <= bclk_tuser;
            end if;
          end if;

        -----------------------------------------------------------------------
        -- Bypass mode
        -----------------------------------------------------------------------
        else
          if (bclk_load = '1') then
            bclk_tuser_out <= bclk_tuser;
          end if;
        end if;
      end if;
    end if;
  end process;



  ---------------------------------------------------------------------------
  -- Process     : P_bclk_tlast_out
  -- Description : 
  ---------------------------------------------------------------------------
  P_bclk_tlast_out : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_tlast_out <= '0';
      else
        if (bclk_load = '1') then
          bclk_tlast_out <= bclk_tlast;
        end if;
      end if;
    end if;
  end process;

  bclk_tvalid_out <= bclk_data_valid;
  bclk_tdata_out  <= bclk_data;

end architecture rtl;
