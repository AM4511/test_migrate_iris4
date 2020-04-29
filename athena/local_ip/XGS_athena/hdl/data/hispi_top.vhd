-------------------------------------------------------------------------------
-- MODULE      : hispi_top
--
-- DESCRIPTION : 
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.regfile_hispi_registerfile_pack.all;
use work.mtx_types_pkg.all;
use work.hispi_pack.all;


entity hispi_top is
  generic (
    FPGA_MANUFACTURER : string  := "XILINX";
    NUMBER_OF_LANE    : integer := 6;
    MUX_RATIO         : integer := 4;
    PIXELS_PER_LINE   : integer := 4176;
    LINES_PER_FRAME   : integer := 3102;
    PIXEL_SIZE        : integer := 12
    );
  port (
    sysclk     : in std_logic;
    sysrst     : in std_logic;
    idelay_clk : in std_logic;

    ------------------------------------------------------------------------------------
    -- Interface name : registerFileIF
    ------------------------------------------------------------------------------------
    reg_read          : in  std_logic;
    reg_write         : in  std_logic;
    reg_addr          : in  std_logic_vector(7 downto 2);
    reg_beN           : in  std_logic_vector(3 downto 0);
    reg_writedata     : in  std_logic_vector(31 downto 0);
    reg_readdatavalid : out std_logic;
    reg_readdata      : out std_logic_vector(31 downto 0);

    ------------------------------------------------------------------------------------
    -- Interface name : HiSPI
    ------------------------------------------------------------------------------------
    hispi_serial_clk_p : in std_logic_vector(1 downto 0);
    hispi_serial_clk_n : in std_logic_vector(1 downto 0);
    hispi_data_p       : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);
    hispi_data_n       : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);

    ---------------------------------------------------------------------------
    -- Interface name : AXI Master stream
    ---------------------------------------------------------------------------
    m_axis_tready : in  std_logic;
    m_axis_tvalid : out std_logic;
    m_axis_tuser  : out std_logic;
    m_axis_tlast  : out std_logic;
    m_axis_tdata  : out std_logic_vector(63 downto 0)
    );
end entity hispi_top;


architecture rtl of hispi_top is


  component hispi_phy is
    generic (
      LANE_PER_PHY : integer := 3;      -- Physical lane
      PIXEL_SIZE   : integer := 12      -- Pixel size in bits
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      -- Register file interface
      idle_character       : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      hispi_phy_en         : in  std_logic;
      hispi_soft_reset     : in  std_logic;
      hispi_serial_clk_p   : in  std_logic;
      hispi_serial_clk_n   : in  std_logic;
      hispi_serial_input_p : in  std_logic_vector(LANE_PER_PHY - 1 downto 0);
      hispi_serial_input_n : in  std_logic_vector(LANE_PER_PHY - 1 downto 0);
      fifo_read_clk        : in  std_logic;
      fifo_read_en         : in  std_logic_vector(LANE_PER_PHY-1 downto 0);
      fifo_empty           : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      fifo_read_data_valid : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      fifo_read_data       : out std32_logic_vector(LANE_PER_PHY-1 downto 0);
      -- Flags detected
      embeded_data         : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sof_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      eof_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sol_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      eol_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0)
      );
  end component;


  component lane_packer is
    generic (
      LANE_PACKER_ID            : integer              := 0;
      LINE_BUFFER_DATA_WIDTH    : integer              := 64;
      LINE_BUFFER_ADDRESS_WIDTH : integer              := 11;
      NUMBER_OF_LINE_BUFFER     : integer range 1 to 4 := 4;
      NUMBER_OF_LANE            : integer              := 6;
      MUX_RATIO                 : integer              := 4;
      PIXELS_PER_LINE           : integer              := 4176;
      LINES_PER_FRAME           : integer              := 3102;
      PIXEL_SIZE                : integer              := 12
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      -- registers
      packer_fifo_overrun  : out std_logic;
      packer_fifo_underrun : out std_logic;

      enable         : in  std_logic;
      init           : in  std_logic;
      flush          : in  std_logic;
      odd_line       : in  std_logic;
      line_valid     : in  std_logic;
      busy           : out std_logic;
      line_buffer_id : in  std_logic_vector(1 downto 0);
      sync           : in  std_logic_vector(1 downto 0);

      -- Lane
      top_fifo_read_en            : out std_logic;
      top_fifo_empty              : in  std_logic;
      top_fifo_read_data_valid    : in  std_logic;
      top_fifo_read_data          : in  std_logic_vector(31 downto 0);
      bottom_fifo_read_en         : out std_logic;
      bottom_fifo_empty           : in  std_logic;
      bottom_fifo_read_data_valid : in  std_logic;
      bottom_fifo_read_data       : in  std_logic_vector(31 downto 0);

      -- Stripe buffer
      sbuff_en         : in  std_logic;
      sbuff_clr        : in  std_logic_vector(3 downto 0);
      sbuff_rdy        : out std_logic_vector(3 downto 0);
      sbuff_rden       : in  std_logic;
      sbuff_rdaddr     : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      sbuff_count      : out std_logic_vector(11 downto 0);
      sbuff_data_valid : out std_logic;
      sbuff_rddata     : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
      );
  end component;


  component axi_line_streamer is
    generic (
      NUMB_PACKER               : integer := 3;
      NUMB_LINE_BUFFER          : integer := 4;
      LINE_BUFFER_DATA_WIDTH    : integer := 64;
      LINE_BUFFER_ADDRESS_WIDTH : integer := 10
      );
    port (
      ---------------------------------------------------------------------------
      -- System clock interface
      ---------------------------------------------------------------------------
      sysclk : in std_logic;
      sysrst : in std_logic;

      ---------------------------------------------------------------------------
      -- Control interface
      ---------------------------------------------------------------------------
      streamer_en          : in  std_logic;
      streamer_busy        : out std_logic;
      transfert_done       : out std_logic;
      init_line_buffer_ptr : in  std_logic;
      transaction_en       : in  std_logic;

      ---------------------------------------------------------------------------
      -- Octal lane packer I/F
      ---------------------------------------------------------------------------
      sbuff_packer_sel : out std_logic_vector(1 downto 0);
      sbuff_buffer_sel : out std_logic_vector(1 downto 0);
      sbuff_clr        : out std_logic;
      sbuff_rden       : out std_logic;
      sbuff_rdaddr     : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      sbuff_data_valid : in  std_logic;
      sbuff_count      : in  std_logic_vector(11 downto 0);
      sbuff_rddata     : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Master stream interface
      ---------------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tuser  : out std_logic;
      m_axis_tlast  : out std_logic;
      m_axis_tdata  : out std_logic_vector(63 downto 0)
      );
  end component;


  component regfile_hispi_registerfile is
    port (
      resetN        : in    std_logic;
      sysclk        : in    std_logic;
      regfile       : inout REGFILE_HISPI_REGISTERFILE_TYPE := INIT_REGFILE_HISPI_REGISTERFILE_TYPE;  -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;
      reg_write     : in    std_logic;
      reg_addr      : in    std_logic_vector(7 downto 2);
      reg_beN       : in    std_logic_vector(3 downto 0);
      reg_writedata : in    std_logic_vector(31 downto 0);
      reg_readdata  : out   std_logic_vector(31 downto 0)
      );
  end component;


  attribute IODELAY_GROUP                : string;
  attribute IODELAY_GROUP of xIDELAYCTRL : label is "hispi_phy_xilinx_group";

  constant LANE_PER_PHY     : integer := NUMBER_OF_LANE/2;
  constant PHY_OUTPUT_WIDTH : integer := 6;

  constant LINE_BUFFER_DATA_WIDTH : integer := 64;


  constant LINE_BUFFER_ADDRESS_WIDTH : integer := 11;

  constant NUMB_LINE_BUFFER : integer                                 := 3;
  constant NUMB_LANE_PACKER : integer                                 := NUMBER_OF_LANE/2;
  constant C_IDLE_CHARACTER : std_logic_vector(PIXEL_SIZE-1 downto 0) := X"3A6";

  type FSM_TYPE is (S_IDLE, S_INIT, S_DISABLED, S_PACK, S_SOF, S_EOF, S_SOL, S_EOL, S_STREAM_INIT, S_STREAM, S_DONE);

  type PIX_CNTR_ARRAY_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of unsigned(11 downto 0);
  type SBUFF_RDDATA_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  signal idle_character           : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal new_line_pending         : std_logic;
  signal new_frame_pending        : std_logic;
  signal top_lanes_p              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_lanes_n              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_embeded_data         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_sof_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_eof_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_sol_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_eol_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_lanes_p           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_lanes_n           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_embeded_data      : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_sof_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_eof_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_sol_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_eol_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_en         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_empty           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_data_valid : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_data       : std32_logic_vector(LANE_PER_PHY-1 downto 0);

  signal bottom_fifo_read_en         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_empty           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_data_valid : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_data       : std32_logic_vector(LANE_PER_PHY-1 downto 0);
  signal hispi_phy_en                : std_logic;


  signal regfile     : REGFILE_HISPI_REGISTERFILE_TYPE := INIT_REGFILE_HISPI_REGISTERFILE_TYPE;
  signal sysrst_n    : std_logic;
  signal state       : FSM_TYPE;
  signal band_offset : PIX_CNTR_ARRAY_TYPE;

  signal row_id            : std_logic_vector(11 downto 0);
  signal buffer_enable     : std_logic;
  signal flush_lane_packer : std_logic;
  signal packer_busy       : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal all_packer_busy   : std_logic;
  signal init_lane_packer  : std_logic;

  signal init_lane_buffer : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);

  signal line_buffer_id       : std_logic_vector(1 downto 0);
  signal line_buffer_read     : std_logic;
  signal line_buffer_address  : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal line_buffer_data     : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  signal lane_packer_req      : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_ack      : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal buff_write           : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal packer_fifo_overrun  : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal packer_fifo_underrun : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);

  signal buff_addr           : std11_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal buff_data           : std64_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal line_buffer_count   : std_logic_vector(11 downto 0);
  signal line_buffer_line_id : std_logic_vector(11 downto 0);
  signal frame_cntr          : integer;
  signal line_cntr           : integer range 0 to LINES_PER_FRAME-1;
  signal line_valid          : std_logic;

  signal start                : std_logic;
  signal transfert_done       : std_logic;
  signal dest_address         : std_logic_vector(31 downto 0);
  signal transaction_id       : std_logic_vector(3 downto 0);
  signal init_line_buffer     : std_logic;
  signal init_line_buffer_ptr : std_logic;

  signal transaction_en : std_logic;

  signal w_buffer_init : std_logic;
  signal w_buffer_incr : std_logic;

  signal sbuff_rden        : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal sbuff_en          : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal sbuff_rdaddr      : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal sbuff_data_valid  : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal sbuff_rddata      : SBUFF_RDDATA_TYPE;
  signal sbuff_clr         : std_logic_vector(3 downto 0);
  signal sbuff_rdy         : std4_logic_vector(3 downto 0);
  signal sbuff_count_array : std12_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal sync              : std_logic_vector(1 downto 0);

  signal strm_packer_sel       : std_logic_vector(1 downto 0);
  signal strm_buffer_sel       : std_logic_vector(1 downto 0);
  signal strm_sbuff_clr        : std_logic;
  signal strm_sbuff_rden       : std_logic;
  signal strm_sbuff_data_valid : std_logic;
  signal strm_sbuff_rddata     : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  signal strm_sbuff_count      : std_logic_vector(11 downto 0);

begin

  sysrst_n <= not sysrst;


  -- TBD : will eventually come from a register
  idle_character <= C_IDLE_CHARACTER;


  -- TBD : manage line valid, RoI, embeded data
  line_valid <= '1';

  -- TBD : manage buffer control
  buffer_enable <= '1';


  -----------------------------------------------------------------------------
  -- Module      : regfile_hispi_registerfile
  -- Description : IP-Core main registerfile. This file is generated by the
  --               Matrox FDK-IDE tool
  -----------------------------------------------------------------------------
  xregfile_hispi_registerfile : regfile_hispi_registerfile
    port map(
      resetN        => sysrst_n,
      sysclk        => sysclk,
      regfile       => regfile,
      reg_read      => reg_read,
      reg_write     => reg_write,
      reg_addr      => reg_addr,
      reg_beN       => reg_beN,
      reg_writedata => reg_writedata,
      reg_readdata  => reg_readdata
      );


  -----------------------------------------------------------------------------
  -- Process     : P_reg_readdatavalid
  -- Description : register file read data valid. Indicates when the data is
  --               return from the registerfile. By default the Matrox FDKIde
  --               does not generates by default a read data valid flag. Only
  --               when an External section is declared. In case of regular
  --               FF register, the read latency is 1 clock cycle.
  -----------------------------------------------------------------------------
  P_reg_readdatavalid : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        reg_readdatavalid <= '0';
      else
        reg_readdatavalid <= reg_read;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- HiSPi lane remapping
  -----------------------------------------------------------------------------
  G_lanes : for i in 0 to NUMBER_OF_LANE/2 - 1 generate
    -- Top lanes are the even ID lanes (Lanes 0,2,4)
    top_lanes_p(i) <= hispi_data_p(2*i);
    top_lanes_n(i) <= hispi_data_n(2*i);

    -- Bottom lanes are the odd ID lanes (Lanes 1,3,5)
    bottom_lanes_p(i) <= hispi_data_p(2*i+1);
    bottom_lanes_n(i) <= hispi_data_n(2*i+1);
  end generate G_lanes;


  -----------------------------------------------------------------------------
  -- Module      : hispi_phy
  -- Description : TOP lanes hispi phy. Provides one serdes for interfacing
  --               all the XGS sensor top lanes.
  -----------------------------------------------------------------------------
  top_hispi_phy : hispi_phy
    generic map(
      LANE_PER_PHY => LANE_PER_PHY,
      PIXEL_SIZE   => PIXEL_SIZE
      )
    port map(
      sysclk               => sysclk,
      sysrst               => sysrst,
      idle_character       => idle_character,
      hispi_phy_en         => hispi_phy_en,
      hispi_soft_reset     => regfile.core.ctrl.reset,
      hispi_serial_clk_p   => hispi_serial_clk_p(0),
      hispi_serial_clk_n   => hispi_serial_clk_n(0),
      hispi_serial_input_p => top_lanes_p,
      hispi_serial_input_n => top_lanes_n,
      fifo_read_clk        => sysclk,
      fifo_read_en         => top_fifo_read_en,
      fifo_empty           => top_fifo_empty,
      fifo_read_data_valid => top_fifo_read_data_valid,
      fifo_read_data       => top_fifo_read_data,
      embeded_data         => top_embeded_data,
      sof_flag             => top_sof_flag,
      eof_flag             => top_eof_flag,
      sol_flag             => top_sol_flag,
      eol_flag             => top_eol_flag
      );


  -----------------------------------------------------------------------------
  -- Module      : hispi_phy
  -- Description : Bottom lanes hispi phy. Provides one serdes for interfacing
  --               all the XGS sensor bottom lanes.
  -----------------------------------------------------------------------------
  bottom_hispi_phy : hispi_phy
    generic map(
      LANE_PER_PHY => LANE_PER_PHY,
      PIXEL_SIZE   => PIXEL_SIZE
      )
    port map(
      sysclk               => sysclk,
      sysrst               => sysrst,
      idle_character       => idle_character,
      hispi_phy_en         => hispi_phy_en,
      hispi_soft_reset     => regfile.core.ctrl.reset,
      hispi_serial_clk_p   => hispi_serial_clk_p(1),
      hispi_serial_clk_n   => hispi_serial_clk_n(1),
      hispi_serial_input_p => bottom_lanes_p,
      hispi_serial_input_n => bottom_lanes_n,
      fifo_read_clk        => sysclk,
      fifo_read_en         => bottom_fifo_read_en,
      fifo_empty           => bottom_fifo_empty,
      fifo_read_data_valid => bottom_fifo_read_data_valid,
      fifo_read_data       => bottom_fifo_read_data,
      embeded_data         => bottom_embeded_data,
      sof_flag             => bottom_sof_flag,
      eof_flag             => bottom_eof_flag,
      sol_flag             => bottom_sol_flag,
      eol_flag             => bottom_eol_flag
      );


  -----------------------------------------------------------------------------
  -- Process     : P_new_frame_pending
  -- Description : Flag used to indicates when a start of frame is decoded from
  --               any top lane. This flag is asserted on the detection of any
  --               top SOF and cleared when it is processed by the main state
  --               machine.
  -----------------------------------------------------------------------------
  P_new_frame_pending : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        new_frame_pending <= '0';
      else
        -- A SOF is detected on any top lane
        if (top_sof_flag /= (top_sof_flag'range => '0')) then
          new_frame_pending <= '1';

        -- This flag is cleared once processed by the state
        -- machine
        elsif (state <= S_SOF) then
          new_frame_pending <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_new_line_pending
  -- Description : Flag used to indicates when a start of line is decoded from
  --               any top lane. This flag is asserted on the detection of any
  --               top SOL and cleared when it is processed by the main state
  --               machine.
  -----------------------------------------------------------------------------
  P_new_line_pending : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        new_line_pending <= '0';
      else
        -- A SOL is detected on any top lane
        if (top_sol_flag /= (top_sol_flag'range => '0')) then
          new_line_pending <= '1';

        -- This flag is cleared once processed by the state
        -- machine
        elsif (state <= S_SOL) then
          new_line_pending <= '0';
        end if;
      end if;
    end if;
  end process;


  flush_lane_packer <= '1' when (bottom_eof_flag(LANE_PER_PHY-1) = '1' or bottom_eol_flag(LANE_PER_PHY-1) = '1') else
                       '0';


  init_lane_packer <= '1' when (state = S_INIT) else
                      '0';


  init_line_buffer <= '1' when (state = S_INIT) else
                      '0';



  sbuff_clr <= "0000";                  --TBD

  all_packer_busy <= '1' when (packer_busy /= (packer_busy'range => '0')) else
                     '0';


  hispi_phy_en <= '1' when (regfile.core.ctrl.capture_enable = '1') else
                  '0';


  -----------------------------------------------------------------------------
  -- Process     : P_line_buffer_id
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_id : process (sysclk) is

  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        line_buffer_id <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Initialize the offset counter
        -----------------------------------------------------------------------
        if (state = S_INIT) then
          line_buffer_id <= (others => '0');

        elsif (state = S_DONE) then
          line_buffer_id <= std_logic_vector(unsigned(line_buffer_id)+1);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Main FSM
  -----------------------------------------------------------------------------
  P_state : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        state <= S_DISABLED;
      else
        if (regfile.core.ctrl.capture_enable = '0') then
          state <= S_DISABLED;
        else

          case state is
            ---------------------------------------------------------------------
            -- S_DISABLED : Starting point
            ---------------------------------------------------------------------
            when S_DISABLED =>
              state <= S_IDLE;

            ---------------------------------------------------------------------
            -- S_IDLE : Parking state
            ---------------------------------------------------------------------
            when S_IDLE =>
              if (new_frame_pending = '1') then
                state <= S_SOF;
              elsif (new_line_pending = '1') then
                state <= S_SOL;
              end if;

            ---------------------------------------------------------------------
            -- S_SOL : Start of line detected
            ---------------------------------------------------------------------
            when S_SOL =>
              state <= S_INIT;

            ---------------------------------------------------------------------
            -- S_SOF : Start of frame detected
            ---------------------------------------------------------------------
            when S_SOF =>
              state <= S_INIT;

            ---------------------------------------------------------------------
            -- S_INIT : Initialize the IP state
            ---------------------------------------------------------------------
            when S_INIT =>
              state <= S_PACK;

            ---------------------------------------------------------------------
            -- S_PACK : Pack incomming data from the XGS sensor to form lines
            --          in the line buffer.
            ---------------------------------------------------------------------
            when S_PACK =>
              if (bottom_eof_flag(0) = '1') then
                state <= S_EOF;

              elsif (bottom_eol_flag(0) = '1') then
                state <= S_EOL;
              else
                state <= S_PACK;

              end if;

            ---------------------------------------------------------------------
            -- S_EOL : End of line detected 
            ---------------------------------------------------------------------
            when S_EOL =>
              if (all_packer_busy = '0') then
                state <= S_STREAM_INIT;
              else
                state <= S_EOL;
              end if;

            ---------------------------------------------------------------------
            -- S_EOF : End of frame detected
            ---------------------------------------------------------------------
            when S_EOF =>
              if (all_packer_busy = '0') then
                state <= S_STREAM_INIT;
              else
                state <= S_EOF;
              end if;

            ---------------------------------------------------------------------
            -- 
            ---------------------------------------------------------------------
            when S_STREAM_INIT =>
              state <= S_DONE;

            ---------------------------------------------------------------------
            -- 
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
  -- 00 : SOF
  -- 01 : EOL
  -- 10 : CONT
  -- 11 : EOF
  -----------------------------------------------------------------------------
  P_sync : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        sync <= "10";
      else
        case state is
          when S_SOF  => sync <= "00";
          when S_EOF  => sync <= "11";
          when S_EOL  => sync <= "01";
          when others => sync <= "10";
        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_frame_cntr
  -- Description : Count the complete number of frame received
  -----------------------------------------------------------------------------
  P_frame_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        frame_cntr <= 0;
      else
        if (state = S_EOF and all_packer_busy = '0') then
          frame_cntr <= frame_cntr+1;
        end if;
      end if;
    end if;
  end process;


  w_buffer_init <= '1' when (state = S_SOF) else
                   '0';


  w_buffer_incr <= '1' when (state = S_SOL) else
                   '0';


  -----------------------------------------------------------------------------
  -- Process     : P_frame_cntr
  -- Description : Count the complete number of lines received in the current
  --               frame
  -----------------------------------------------------------------------------
  P_line_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        line_cntr <= 0;
      else
        if (state = S_SOF) then
          line_cntr <= 0;
        elsif (state = S_EOL and all_packer_busy = '0') then
          line_cntr <= line_cntr+1;
        end if;
      end if;
    end if;
  end process;


  row_id <= std_logic_vector(unsigned(to_unsigned(line_cntr, row_id'length)));


  transaction_en <= '1' when (state = S_STREAM_INIT) else
                    '0';


  init_line_buffer_ptr <= '1' when (state = S_SOF) else
                          '0';


  G_lane_packer : for i in 0 to NUMB_LANE_PACKER - 1 generate

    sbuff_en(i) <= '1' when (to_integer(unsigned(strm_packer_sel)) = i) else
                   '0';

    sbuff_rden(i) <= strm_sbuff_rden when (to_integer(unsigned(strm_packer_sel)) = i) else
                     '0';

    ---------------------------------------------------------------------------
    -- Octal lane packer
    ---------------------------------------------------------------------------
    xlane_packer : lane_packer
      generic map(
        LANE_PACKER_ID            => i,
        LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
        LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH,
        NUMBER_OF_LANE            => NUMBER_OF_LANE,
        MUX_RATIO                 => MUX_RATIO,
        PIXELS_PER_LINE           => PIXELS_PER_LINE,
        LINES_PER_FRAME           => LINES_PER_FRAME,
        PIXEL_SIZE                => PIXEL_SIZE
        )
      port map(
        sysclk                      => sysclk,
        sysrst                      => sysrst,
        packer_fifo_overrun         => packer_fifo_overrun(i),
        packer_fifo_underrun        => packer_fifo_underrun(i),
        enable                      => '1',
        init                        => init_lane_packer,
        flush                       => flush_lane_packer,
        odd_line                    => row_id(0),
        line_valid                  => line_valid,
        busy                        => packer_busy(i),
        line_buffer_id              => line_buffer_id,
        sync                        => sync,
        top_fifo_read_en            => top_fifo_read_en(i),
        top_fifo_empty              => top_fifo_empty(i),
        top_fifo_read_data_valid    => top_fifo_read_data_valid(i),
        top_fifo_read_data          => top_fifo_read_data(i),
        bottom_fifo_read_en         => bottom_fifo_read_en(i),
        bottom_fifo_empty           => bottom_fifo_empty(i),
        bottom_fifo_read_data_valid => bottom_fifo_read_data_valid(i),
        bottom_fifo_read_data       => bottom_fifo_read_data(i),
        sbuff_en                    => sbuff_en(i),
        sbuff_clr                   => sbuff_clr,
        sbuff_rdy                   => sbuff_rdy(i),
        sbuff_rden                  => sbuff_rden(i),
        sbuff_rdaddr                => sbuff_rdaddr,
        sbuff_count                 => sbuff_count_array(i),
        sbuff_data_valid            => sbuff_data_valid(i),
        sbuff_rddata                => sbuff_rddata(i)
        );
  end generate G_lane_packer;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_strm_sbuff_rddata : process (strm_packer_sel, sbuff_rddata) is
  begin  -- process P_MUX
    for i in 0 to NUMB_LANE_PACKER-1 loop
      if (to_integer(unsigned(strm_packer_sel)) = i) then
        strm_sbuff_rddata <= sbuff_rddata(i);
        exit;
      else
        strm_sbuff_rddata <= sbuff_rddata(0);
      end if;
    end loop;
  end process P_strm_sbuff_rddata;

  
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_strm_sbuff_data_valid : process (strm_packer_sel, sbuff_data_valid) is
  begin  -- process P_MUX
    for i in 0 to NUMB_LANE_PACKER-1 loop
      if (to_integer(unsigned(strm_packer_sel)) = i) then
        strm_sbuff_data_valid <= sbuff_data_valid(i);
        exit;
      else
        strm_sbuff_data_valid <= sbuff_data_valid(0);
      end if;
    end loop;
  end process P_strm_sbuff_data_valid;


  xaxi_line_streamer : axi_line_streamer
    generic map(
      NUMB_PACKER               => 3,
      NUMB_LINE_BUFFER          => 4,
      LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
      LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH
      )
    port map (
      sysclk               => sysclk,
      sysrst               => sysrst,
      streamer_en          => '1',
      streamer_busy        => open,
      transfert_done       => transfert_done,
      init_line_buffer_ptr => init_line_buffer_ptr,
      transaction_en       => transaction_en,
      sbuff_packer_sel     => strm_packer_sel,
      sbuff_buffer_sel     => strm_buffer_sel,
      sbuff_clr            => strm_sbuff_clr,
      sbuff_rden           => strm_sbuff_rden,
      sbuff_rdaddr         => sbuff_rdaddr,
      sbuff_data_valid     => strm_sbuff_data_valid,
      sbuff_count          => sbuff_count_array(0),  -- TBD!!!!!!!!!!!!
      sbuff_rddata         => strm_sbuff_rddata,
      m_axis_tready        => m_axis_tready,
      m_axis_tvalid        => m_axis_tvalid,
      m_axis_tuser         => m_axis_tuser,
      m_axis_tlast         => m_axis_tlast,
      m_axis_tdata         => m_axis_tdata
      );


  -----------------------------------------------------------------------------
  -- IDELAYCTRL is needed for SERDES calibration. 
  -----------------------------------------------------------------------------
  xIDELAYCTRL : IDELAYCTRL
    port map (
      RDY    => regfile.phy.status.pll_locked,
      REFCLK => idelay_clk,
      RST    => regfile.phy.ctrl.reset_idelayctrl
      );

end architecture rtl;
