-------------------------------------------------------------------------------
-- MODULE      : lane_packer
--
-- DESCRIPTION : Pack data from 2 opposite lanes (Even lane from the sensor
--               top side and the opposite bottom odd lane)
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mtx_types_pkg.all;
use work.regfile_xgs_athena_pack.all;

entity lane_packer is
  generic (
    LANE_PACKER_ID            : integer := 0;
    LINE_BUFFER_DATA_WIDTH    : integer := 64;
    LINE_BUFFER_ADDRESS_WIDTH : integer := 11
    );
  port (
    ---------------------------------------------------------------------------
    -- Registerfile  clock domain
    ---------------------------------------------------------------------------
    rclk       : in    std_logic;
    rclk_reset : in    std_logic;
    regfile    : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

    ---------------------------------------------------------------------------
    -- sclk clock domain
    ---------------------------------------------------------------------------
    sclk       : in std_logic;
    sclk_reset : in std_logic;


    enable         : in  std_logic;
    init_packer    : in  std_logic;
    odd_line       : in  std_logic;
    line_valid     : in  std_logic;
    busy           : out std_logic;
    line_buffer_id : in  std_logic_vector(1 downto 0);

    -- Top Lane
    top_sync                 : in  std_logic_vector(3 downto 0);
    top_fifo_read_en         : out std_logic;
    top_fifo_empty           : in  std_logic;
    top_fifo_read_data_valid : in  std_logic;
    top_fifo_read_data       : in  std_logic_vector(31 downto 0);

    -- Bottom Lane
    bottom_sync                 : in  std_logic_vector(3 downto 0);
    bottom_fifo_read_en         : out std_logic;
    bottom_fifo_empty           : in  std_logic;
    bottom_fifo_read_data_valid : in  std_logic;
    bottom_fifo_read_data       : in  std_logic_vector(31 downto 0);

    -- Line buffer interface
    lane_packer_ack   : in  std_logic;
    lane_packer_req   : out std_logic;
    lane_packer_write : out std_logic;
    lane_packer_addr  : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
    lane_packer_data  : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
    );

end entity lane_packer;


architecture rtl of lane_packer is

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  function log2 (x : positive) return natural is
    variable i : natural;
  begin
    i := 0;
    while (2**i < x) and i < 31 loop
      i := i + 1;
    end loop;
    return i;
  end log2;


  component mtx_resync is
    port
      (
        aClk  : in  std_logic;
        aClr  : in  std_logic;
        aDin  : in  std_logic;
        bclk  : in  std_logic;
        bclr  : in  std_logic;
        bDout : out std_logic;
        bRise : out std_logic;
        bFall : out std_logic
        );
  end component;

  component mtxSCFIFO is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        clk   : in  std_logic;
        sclr  : in  std_logic;
        wren  : in  std_logic;
        data  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rden  : in  std_logic;
        q     : out std_logic_vector (DATAWIDTH-1 downto 0);
        usedw : out std_logic_vector (ADDRWIDTH downto 0);
        empty : out std_logic;
        full  : out std_logic
        );
  end component;


  constant FIFO_ADDRESS_WIDTH : natural := 10;
  constant FIFO_DATA_WIDTH    : natural := LINE_BUFFER_DATA_WIDTH + LINE_BUFFER_ADDRESS_WIDTH;


  type PACKER_ADDRESS_ARRAY_TYPE is array (0 to 3) of natural;
  type INTEGER_ARRAY_TYPE is array (natural range <>) of natural;

  type PACK_FSM_TYPE is (S_IDLE, S_INIT, S_PACK, S_SOF, S_EOF, S_EOL, S_FLUSH, S_LINE_BUFFER_OVERFLOW, S_DONE);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_REQ, S_WRITE, S_DONE);


  signal state            : PACK_FSM_TYPE;
  signal output_state     : OUTPUT_FSM_TYPE;
  signal packer_max_count : natural range 0 to 2 := 2;
  signal load_data        : std_logic;

  signal pix_packer_wren     : std_logic;
  signal pix_packer          : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  signal pix_offset_stripe_0 : natural := 0;
  signal pix_offset_stripe_1 : natural := 0;
  signal pix_offset_stripe_2 : natural := 0;
  signal pix_offset_stripe_3 : natural := 0;
  signal pix_offset_mux      : natural := 0;
  signal pix_in_cntr         : integer := 0;

  signal line_buffer_offset : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);

  signal lane_decoder_read : std_logic;
  signal lane_id           : natural range 0 to 3;
  signal pix_even          : std_logic_vector(15 downto 0) := (others => '0');
  signal pix_odd           : std_logic_vector(15 downto 0) := (others => '0');

  signal fifo_rd              : std_logic;
  signal fifo_wr              : std_logic;
  signal fifo_wdata           : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
  signal fifo_rdata           : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
  signal fifo_full            : std_logic;
  signal fifo_empty           : std_logic;
  signal fifo_usedw           : std_logic_vector(FIFO_ADDRESS_WIDTH downto 0);
  signal fifo_usedw_max       : std_logic_vector(FIFO_ADDRESS_WIDTH downto 0);
  signal packer_fifo_overrun  : std_logic;
  signal packer_fifo_underrun : std_logic;

  signal rclk_packer_fifo_overrun  : std_logic;
  signal rclk_packer_fifo_underrun : std_logic;

  signal rclk_pixel_per_lane   : natural;
  signal rclk_pixel_mux_ratio  : natural;
  signal rclk_pixel_per_packer : natural;
  signal rclk_pixel_per_stripe : natural;


begin

  rclk_pixel_per_lane  <= to_integer(unsigned(regfile.HISPI.PHY.PIXEL_PER_LANE));
  rclk_pixel_mux_ratio <= to_integer(unsigned(regfile.HISPI.PHY.MUX_RATIO));

  rclk_pixel_per_stripe <= 2 * rclk_pixel_per_lane;
  rclk_pixel_per_packer <= rclk_pixel_per_stripe*rclk_pixel_mux_ratio;


  -----------------------------------------------------------------------------
  -- FiFo error flags
  -----------------------------------------------------------------------------
  packer_fifo_overrun <= '1' when(fifo_wr = '1' and fifo_full = '1') else
                         '0';

  packer_fifo_underrun <= '1' when(fifo_rd = '1' and fifo_empty = '1') else
                          '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  M_rclk_packer_fifo_underrun : mtx_resync
    port map
    (
      aClk  => sclk,
      aClr  => sclk_reset,
      aDin  => packer_fifo_underrun,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_packer_fifo_underrun,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  M_rclk_packer_fifo_overrun : mtx_resync
    port map
    (
      aClk  => sclk,
      aClr  => sclk_reset,
      aDin  => packer_fifo_overrun,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_packer_fifo_overrun,
      bFall => open
      );


  regfile.HISPI.LANE_PACKER_STATUS(LANE_PACKER_ID).FIFO_OVERRUN_set  <= rclk_packer_fifo_overrun;
  regfile.HISPI.LANE_PACKER_STATUS(LANE_PACKER_ID).FIFO_UNDERRUN_set <= rclk_packer_fifo_underrun;


  -----------------------------------------------------------------------------
  -- FiFo read flag. Read data from the top and bottom HiSPi phy
  -----------------------------------------------------------------------------
  lane_decoder_read <= '1' when(state = S_PACK and top_fifo_empty = '0' and bottom_fifo_empty = '0') else
                       '0';


  -----------------------------------------------------------------------------
  -- FiFo read flag remapping (Top and bottom)
  -----------------------------------------------------------------------------
  top_fifo_read_en    <= lane_decoder_read;
  bottom_fifo_read_en <= lane_decoder_read;


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Lane packer main FSM. Control the top and bottom XGS lane
  --               packing.
  -----------------------------------------------------------------------------
  P_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        state <= S_IDLE;
      else
        if (init_packer = '1') then
          state <= S_IDLE;
        else
          case state is
            ---------------------------------------------------------------------
            -- S_IDLE : Parking state
            ---------------------------------------------------------------------
            when S_IDLE =>
              if (enable = '1'and (top_fifo_empty = '0' and bottom_fifo_empty = '0')) then
                state <= S_INIT;
              else
                state <= S_IDLE;
              end if;

            ---------------------------------------------------------------------
            -- S_INIT : Initialize the data packing process
            ---------------------------------------------------------------------
            when S_INIT =>
              state <= S_PACK;

            ---------------------------------------------------------------------
            -- S_PACK : In this state the lane packer module pack data until a
            --          flush request occures from the hispi_top module.
            ---------------------------------------------------------------------
            when S_PACK =>
              -- If EOL or EOF
              if (top_sync(1) = '1' or top_sync(3) = '1') then
                if (pix_in_cntr = rclk_pixel_per_packer) then
                  state <= S_FLUSH;
                else
                  state <= S_LINE_BUFFER_OVERFLOW;
                end if;
              end if;

           ---------------------------------------------------------------------
           -- S_FLUSH : Flush process 
           ---------------------------------------------------------------------
            when S_FLUSH =>
              if (output_state = S_DONE) then
                state <= S_DONE;
              else
                state <= S_FLUSH;
              end if;

            ---------------------------------------------------------------------
            -- S_LINE_BUFFER_OVERFLOW : This is an error state. We should never
            --                          arrive here. This means that the data
            --                          is not evacuated fast enough from the
            --                          line buffer.
            ---------------------------------------------------------------------
            when S_LINE_BUFFER_OVERFLOW =>
              -- synthesis translate_off
              assert (false) report "LINE BUFFER OVERFLOW. XGS sent new line before line_packer module flushed the lane decoder FiFo" severity failure;
              -- synthesis translate_on
              state <= S_FLUSH;

            ---------------------------------------------------------------------
            -- S_DONE : Flush process is completed. The FSM can return in S_IDLE
            --          and wait for the current line.
            ---------------------------------------------------------------------
            when S_DONE =>
              state <= S_IDLE;
              
           ---------------------------------------------------------------------
           -- 
           ---------------------------------------------------------------------
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process P_state;


  -----------------------------------------------------------------------------
  -- Process     : P_busy
  -- Description : the busy flag indicates that a transfer is presently running
  -----------------------------------------------------------------------------
  P_busy : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        busy <= '0';
      else
        if (state = S_INIT) then
          busy <= '1';
        elsif (state = S_DONE) then
          busy <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Pack each lane individually
  -----------------------------------------------------------------------------
  load_data <= '1' when (top_fifo_read_data_valid = '1' and bottom_fifo_read_data_valid = '1') else
               '0';


  -----------------------------------------------------------------------------
  -- Process     : P_pix_packer
  -- Description : Packer buffer. The top lane data and the associated bottom
  --               lane data is packe in this process. 
  -----------------------------------------------------------------------------
  P_pix_packer : process (sclk) is
    variable msb            : natural;
    variable lsb            : natural;
    variable nxt_packer_ptr : natural;
  begin
    if (rising_edge(sclk)) then

      if (load_data = '1') then
        if (odd_line = '1') then
          pix_packer(15 downto 0)  <= top_fifo_read_data(15 downto 0);
          pix_packer(31 downto 16) <= bottom_fifo_read_data(15 downto 0);
          pix_packer(47 downto 32) <= top_fifo_read_data(31 downto 16);
          pix_packer(63 downto 48) <= bottom_fifo_read_data(31 downto 16);
        else
          pix_packer(15 downto 0)  <= bottom_fifo_read_data(15 downto 0);
          pix_packer(31 downto 16) <= top_fifo_read_data(15 downto 0);
          pix_packer(47 downto 32) <= bottom_fifo_read_data(31 downto 16);
          pix_packer(63 downto 48) <= top_fifo_read_data(31 downto 16);
        end if;
      end if;
    end if;
  end process;



  lane_id <= to_integer(unsigned(pix_packer(61 downto 60)));




  -----------------------------------------------------------------------------
  -- Process     : P_pix_offset_stripe_[3:0]
  -- Description : Calculate the pixel offset in the line buffer 
  --               the packed segment of pixel shouls be stored> Units are in
  --               WORDS (LINE_BUFFER_DATA_WIDTH)
  -----------------------------------------------------------------------------
  P_line_buffer_offset : process (sclk) is
    variable packer_offset_in_pix : natural;
    variable line_offset_in_pix   : INTEGER_ARRAY_TYPE(3 downto 0);

  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        pix_offset_stripe_0 <= 0;
        pix_offset_stripe_1 <= 0;
        pix_offset_stripe_2 <= 0;
        pix_offset_stripe_3 <= 0;

      else
        -----------------------------------------------------------------------
        -- Initialize the offset counter
        -----------------------------------------------------------------------
        if (state = S_INIT) then
          pix_offset_stripe_0 <= (0*rclk_pixel_per_stripe + (LANE_PACKER_ID*rclk_pixel_per_packer))/4;
          pix_offset_stripe_1 <= (1*rclk_pixel_per_stripe + (LANE_PACKER_ID*rclk_pixel_per_packer))/4;
          pix_offset_stripe_2 <= (2*rclk_pixel_per_stripe + (LANE_PACKER_ID*rclk_pixel_per_packer))/4;
          pix_offset_stripe_3 <= (3*rclk_pixel_per_stripe + (LANE_PACKER_ID*rclk_pixel_per_packer))/4;

        elsif (pix_packer_wren = '1') then
          ---------------------------------------------------------------------
          -- Add 2 pixel to the associated lane counter
          ---------------------------------------------------------------------
          case lane_id is
            when 0      => pix_offset_stripe_0 <= pix_offset_stripe_0 + 1;
            when 1      => pix_offset_stripe_1 <= pix_offset_stripe_1 + 1;
            when 2      => pix_offset_stripe_2 <= pix_offset_stripe_2 + 1;
            when 3      => pix_offset_stripe_3 <= pix_offset_stripe_3 + 1;
            when others => null;
          end case;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  pix_offset_mux <= pix_offset_stripe_0 when (lane_id = 0) else
                    pix_offset_stripe_1 when (lane_id = 1) else
                    pix_offset_stripe_2 when (lane_id = 2) else
                    pix_offset_stripe_3;


  -----------------------------------------------------------------------------
  -- Process     : P_pix_packer_wren
  -- Description : Packer fifo write enable (Write port) 
  -----------------------------------------------------------------------------
  P_pix_packer_wren : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (load_data = '1') then
        pix_packer_wren <= '1';
      else
        pix_packer_wren <= '0';
      end if;
    end if;
  end process;


  line_buffer_offset <= std_logic_vector(to_unsigned(pix_offset_mux, line_buffer_offset'length));

  --fifo_wdata <= pix_offset_mux & pix_packer;
  fifo_wdata <= line_buffer_offset & pix_packer;

  fifo_wr <= '1' when (pix_packer_wren = '1') else
             '0';


  xoutput_fifo : mtxSCFIFO
    generic map (
      DATAWIDTH => FIFO_DATA_WIDTH,
      ADDRWIDTH => FIFO_ADDRESS_WIDTH
      )
    port map (
      clk   => sclk,
      sclr  => sclk_reset,
      wren  => fifo_wr,
      data  => fifo_wdata,
      rden  => fifo_rd,
      q     => fifo_rdata,
      usedw => fifo_usedw,
      empty => fifo_empty,
      full  => fifo_full
      );

  -----------------------------------------------------------------------------
  -- Process     : P_fifo_usedw_max
  -- Description :  
  -----------------------------------------------------------------------------
  P_fifo_usedw_max : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        fifo_usedw_max <= (others => '0');
      else
        if (unsigned(fifo_usedw) > unsigned(fifo_usedw_max)) then
          fifo_usedw_max <= fifo_usedw;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_output_state
  -- Description : Lane packer main FSM. Control the top and bottom XGS lane
  --               packing.
  -----------------------------------------------------------------------------
  P_output_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        output_state <= S_IDLE;
      else
        if (init_packer = '1') then
          output_state <= S_IDLE;
        else
          case output_state is
            ---------------------------------------------------------------------
            -- S_IDLE : Parking state
            ---------------------------------------------------------------------
            when S_IDLE =>
              if (enable = '1' and fifo_empty = '0') then
                output_state <= S_REQ;
              else
                output_state <= S_IDLE;
              end if;

            ---------------------------------------------------------------------
            -- S_REQ : Request data transfer
            ---------------------------------------------------------------------
            when S_REQ =>
              if (lane_packer_ack = '1') then
                output_state <= S_WRITE;
              else
                output_state <= S_REQ;
              end if;

           ---------------------------------------------------------------------
           -- S_WRITE : 
           ---------------------------------------------------------------------
            when S_WRITE =>
              if (fifo_empty = '1') then
                output_state <= S_DONE;
              else
                output_state <= S_WRITE;
              end if;


            ---------------------------------------------------------------------
            -- S_DONE : 
            ---------------------------------------------------------------------
            when S_DONE =>
              output_state <= S_IDLE;

            ---------------------------------------------------------------------
            -- 
            ---------------------------------------------------------------------
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process P_output_state;


  fifo_rd <= '1' when (output_state = S_WRITE and fifo_empty = '0') else
             '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_lane_packer_write : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        lane_packer_write <= '0';
      else
        lane_packer_write <= fifo_rd;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_lane_packer_req : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        lane_packer_req <= '0';
      else
        if (output_state = S_REQ) then
          lane_packer_req <= '1';
        elsif (fifo_empty = '1') then
          lane_packer_req <= '0';
        end if;
      end if;
    end if;
  end process;


  lane_packer_addr <= fifo_rdata(fifo_wdata'left downto LINE_BUFFER_DATA_WIDTH);
  lane_packer_data <= fifo_rdata(LINE_BUFFER_DATA_WIDTH-1 downto 0);


  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  P_pix_in_cntr : process (sclk) is

  begin
    if (rising_edge(sclk)) then

      if (sclk_reset = '1')then
        pix_in_cntr <= 0;
      else
        if (state = S_INIT) then
          pix_in_cntr <= 0;
        elsif (fifo_wr = '1') then
          pix_in_cntr <= pix_in_cntr+4;

          -- synthesis translate_off
          assert (pix_in_cntr <= rclk_pixel_per_packer) report "LanePacker : WROTE TOO MANY PIXEL" severity error;
          -- synthesis translate_on

        end if;
      end if;
    end if;
  end process;

  
end architecture rtl;
