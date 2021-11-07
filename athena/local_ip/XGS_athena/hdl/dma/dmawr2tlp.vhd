-----------------------------------------------------------------------
-- 
-- MAX_PCIE_PAYLOAD_SIZE : see PCIe 2.1 spec; section 7.8.4. Device
--                         Control Register (Offset 08h)              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Work library
library work;
use work.regfile_xgs_athena_pack.all;
use work.dma_pack.all;


entity dmawr2tlp is
  generic (
    COLOR                 : integer := 0;
    MAX_PCIE_PAYLOAD_SIZE : integer := 128
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    sclk   : in std_logic;
    srst_n : in std_logic;

    ---------------------------------------------------------------------
    -- IRQ I/F
    ---------------------------------------------------------------------
    intevent : out std_logic;

    ---------------------------------------------------------------------
    -- System I/F
    ---------------------------------------------------------------------
    context_strb : in    std_logic_vector(1 downto 0);
    --load_dma_context
    ---------------------------------------------------------------------
    -- RegisterFile I/F
    ---------------------------------------------------------------------
    regfile      : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file

    ----------------------------------------------------
    -- AXI stream interface (Slave port)
    ----------------------------------------------------
    tready : out std_logic;
    tvalid : in  std_logic;
    tdata  : in  std_logic_vector(63 downto 0);
    tuser  : in  std_logic_vector(3 downto 0);
    tlast  : in  std_logic;


    ---------------------------------------------------------------------
    -- PCIe Configuration space info (sclk)
    ---------------------------------------------------------------------
    cfg_bus_mast_en : in std_logic;
    cfg_setmaxpld   : in std_logic_vector(2 downto 0);

    ---------------------------------------------------------------------
    -- TLP Interface
    ---------------------------------------------------------------------
    tlp_req_to_send : out std_logic := '0';
    tlp_grant       : in  std_logic;

    tlp_fmt_type     : out std_logic_vector(6 downto 0);
    tlp_length_in_dw : out std_logic_vector(9 downto 0);

    tlp_src_rdy_n : out std_logic;
    tlp_dst_rdy_n : in  std_logic;
    tlp_data      : out std_logic_vector(63 downto 0);

    -- for master request transmit
    tlp_address     : out std_logic_vector(63 downto 2);
    tlp_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_attr           : out std_logic_vector(1 downto 0);
    tlp_transaction_id : out std_logic_vector(23 downto 0);
    tlp_byte_count     : out std_logic_vector(12 downto 0);
    tlp_lower_address  : out std_logic_vector(6 downto 0)

    );
end dmawr2tlp;


architecture rtl of dmawr2tlp is


  component axi_stream_in is
    generic (
      AXIS_DATA_WIDTH       : integer := 64;
      AXIS_USER_WIDTH       : integer := 4;
      DMA_ADDR_WIDTH        : integer := 11;  -- in bits
      BUFFER_LINE_PTR_WIDTH : integer := 2
      );
    port (
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      sclk   : in std_logic;
      srst_n : in std_logic;

      ----------------------------------------------------
      -- Line buffer config (Register file I/F)
      ----------------------------------------------------
      planar_en                   : in  std_logic;
      clr_max_line_buffer_cnt     : in  std_logic;
      line_ptr_width              : in  std_logic_vector(1 downto 0);
      max_line_buffer_cnt         : out std_logic_vector(3 downto 0);
      pcie_back_pressure_detected : out std_logic;

      ----------------------------------------------------
      -- AXI stream interface (Slave port)
      ----------------------------------------------------
      s_axis_tready : out std_logic;
      s_axis_tvalid : in  std_logic;
      s_axis_tdata  : in  std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
      s_axis_tlast  : in  std_logic;
      s_axis_tuser  : in  std_logic_vector(AXIS_USER_WIDTH-1 downto 0);

      ----------------------------------------------------
      -- Line buffer I/F
      ----------------------------------------------------
      start_of_frame  : out std_logic;
      line_ready      : out std_logic;
      line_transfered : in  std_logic;
      end_of_dma      : out std_logic;

      line_buffer_read_en      : in  std_logic;
      line_buffer_read_address : in  std_logic_vector(DMA_ADDR_WIDTH-1 downto 0);
      line_buffer_read_data    : out std_logic_vector(63 downto 0)
      );
  end component;


  component dma_write is
    generic (
      NUMBER_OF_PLANE       : integer range 1 to 3 := 1;
      READ_ADDRESS_MSB      : integer              := 10;
      MAX_PCIE_PAYLOAD_SIZE : integer              := 128
      );
    port (
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- Configuration space info (sys_clk)
      ---------------------------------------------------------------------
      cfg_bus_mast_en : in std_logic;
      cfg_setmaxpld   : in std_logic_vector(2 downto 0);

      ---------------------------------------------------------------------
      -- PCIe tx (sys_clk)
      ---------------------------------------------------------------------
      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_req_to_send : out std_logic := '0';
      tlp_grant       : in  std_logic;

      tlp_fmt_type     : out std_logic_vector(6 downto 0);
      tlp_length_in_dw : out std_logic_vector(9 downto 0);

      tlp_src_rdy_n : out std_logic;
      tlp_dst_rdy_n : in  std_logic;
      tlp_data      : out std_logic_vector(63 downto 0);

      -- for master request transmit
      tlp_address     : out std_logic_vector(63 downto 2);
      tlp_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_attr           : out std_logic_vector(1 downto 0);
      tlp_transaction_id : out std_logic_vector(23 downto 0);
      tlp_byte_count     : out std_logic_vector(12 downto 0);
      tlp_lower_address  : out std_logic_vector(6 downto 0);

      -- DMA transfer parameters
      host_number_of_plane : in integer;
      host_write_address   : in HOST_ADDRESS_ARRAY(NUMBER_OF_PLANE-1 downto 0);
      host_line_pitch      : in std_logic_vector(regfile.DMA.LINE_PITCH.VALUE'range);
      host_line_size       : in std_logic_vector(regfile.DMA.LINE_SIZE.VALUE'range);
      host_reverse_y       : in std_logic;

      -- To Sensor interface, grab abort logic
      dma_idle       : out std_logic;
      dma_pcie_state : out std_logic_vector(2 downto 0);

      -- Interface to read data, on read_clk
      start_of_frame  : in  std_logic;
      line_ready      : in  std_logic;
      line_transfered : out std_logic;
      end_of_dma      : in  std_logic;

      read_enable_out : buffer std_logic;
      read_address    : buffer std_logic_vector(READ_ADDRESS_MSB downto 0);
      read_data       : in     std_logic_vector(63 downto 0)
      );
  end component;

  attribute mark_debug : string;
  attribute keep       : string;

  constant C_S_AXI_ADDR_WIDTH  : integer := 8;
  constant C_S_AXI_DATA_WIDTH  : integer := 32;
  constant AXIS_DATA_WIDTH     : integer := 64;
  constant AXIS_USER_WIDTH     : integer := 4;
  constant DMA_ADDR_WIDTH      : integer := 9+(2*COLOR);  --Mono 4KB/8 or Color 16KB/8
  --constant BUFFER_ADDR_WIDTH   : integer := 11+(2*COLOR);
  constant BUFFER_PTR_WIDTH    : integer := 2;
  constant BUFFER_ADDR_WIDTH   : integer := DMA_ADDR_WIDTH+BUFFER_PTR_WIDTH;
  --constant READ_ADDRESS_MSB    : integer := 10;
  constant MAX_NUMBER_OF_PLANE : integer := 3;




  signal dma_idle                    : std_logic;
  signal dma_pcie_state              : std_logic_vector(2 downto 0);
  signal start_of_frame              : std_logic;
  signal line_ready                  : std_logic;
  signal line_transfered             : std_logic;
  signal end_of_dma                  : std_logic;
  signal line_buffer_read_en         : std_logic;
  signal line_buffer_read_address    : std_logic_vector(DMA_ADDR_WIDTH-1 downto 0);
  signal line_buffer_read_data       : std_logic_vector(63 downto 0);
  signal color_space                 : std_logic_vector(2 downto 0);
  signal clr_max_line_buffer_cnt     : std_logic;
  signal line_ptr_width              : std_logic_vector(BUFFER_PTR_WIDTH-1 downto 0);
  signal max_line_buffer_cnt         : std_logic_vector(3 downto 0);
  signal pcie_back_pressure_detected : std_logic;
  signal dbg_fifo_error              : std_logic;
  signal planar_en                   : std_logic;


  -----------------------------------------------------------------------------
  -- Register context structure
  -----------------------------------------------------------------------------
  signal context_strb_P1     : std_logic_vector(context_strb'range);
  signal dma_context_mapping : DMA_CONTEXT_TYPE;
  signal dma_context_p0      : DMA_CONTEXT_TYPE;
  signal dma_context_P1      : DMA_CONTEXT_TYPE;
  signal dma_context_mux     : DMA_CONTEXT_TYPE;

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of dbg_fifo_error : signal is "true";

begin


  -----------------------------------------------------------------------------
  -- Registerfile remapping
  -----------------------------------------------------------------------------
  dma_context_mapping.frame_start(0) <= regfile.DMA.FSTART_HIGH.VALUE & regfile.DMA.FSTART.VALUE;
  dma_context_mapping.frame_start(1) <= regfile.DMA.FSTART_G_HIGH.VALUE & regfile.DMA.FSTART_G.VALUE;
  dma_context_mapping.frame_start(2) <= regfile.DMA.FSTART_R_HIGH.VALUE & regfile.DMA.FSTART_R.VALUE;
  dma_context_mapping.line_pitch     <= regfile.DMA.LINE_PITCH.VALUE;
  dma_context_mapping.line_size      <= regfile.DMA.LINE_SIZE.VALUE;
  dma_context_mapping.reverse_y      <= regfile.DMA.CSC.REVERSE_Y;

  dma_context_mapping.numb_plane <= 3 when (regfile.DMA.CSC.COLOR_SPACE = "011") else  --RGB PLANAR - 3 BUFFERS
                                    1;


  regfile.DMA.TLP.MAX_PAYLOAD   <= std_logic_vector(to_unsigned(MAX_PCIE_PAYLOAD_SIZE, 12));
  regfile.DMA.TLP.CFG_MAX_PLD   <= cfg_setmaxpld;
  regfile.DMA.TLP.BUS_MASTER_EN <= cfg_bus_mast_en;


  -- Debug probe
  dbg_fifo_error <= regfile.HISPI.STATUS.FIFO_ERROR;


  -----------------------------------------------------------------------------
  -- Grab context pipeline
  --
  -- Les contextes doivent etre loades sur le rising edge du signal. Il a été allongé 
  -- a 4 clk sysclk ds le controlleur pour l'envoyer dans le domaine pclk.
  -----------------------------------------------------------------------------
  P_dma_context : process(sclk)
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        context_strb_P1 <= (others => '0');
        dma_context_p0  <= INIT_DMA_CONTEXT_TYPE;
        dma_context_p1  <= INIT_DMA_CONTEXT_TYPE;
      else
        context_strb_P1 <= context_strb;
        if (context_strb(0) = '1' and context_strb_P1(0) = '0') then
          dma_context_p0 <= dma_context_mapping;
        end if;
        if (context_strb(1) = '1' and context_strb_P1(1) = '0') then
          dma_context_p1 <= dma_context_p0;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Grab context selection MUX
  -----------------------------------------------------------------------------
  dma_context_mux <= dma_context_p1 when (regfile.DMA.CTRL.GRAB_QUEUE_EN = '1') else
                     dma_context_mapping;


  regfile.DMA.OUTPUT_BUFFER.MAX_LINE_BUFF_CNT      <= max_line_buffer_cnt;
  line_ptr_width                                   <= regfile.DMA.OUTPUT_BUFFER.LINE_PTR_WIDTH;
  regfile.DMA.OUTPUT_BUFFER.ADDRESS_BUS_WIDTH      <= std_logic_vector(to_unsigned(BUFFER_ADDR_WIDTH, 4));
  clr_max_line_buffer_cnt                          <= regfile.DMA.OUTPUT_BUFFER.CLR_MAX_LINE_BUFF_CNT;
  regfile.DMA.OUTPUT_BUFFER.PCIE_BACK_PRESSURE_set <= pcie_back_pressure_detected;


  -----------------------------------------------------------------------------
  -- Enable the planar Mode in the line buffer of the axi_stream_in
  -----------------------------------------------------------------------------
  planar_en <= '1' when (dma_context_mux.numb_plane > 1) else
               '0';


  xaxi_stream_in : axi_stream_in
    generic map(
      AXIS_DATA_WIDTH       => AXIS_DATA_WIDTH,
      AXIS_USER_WIDTH       => AXIS_USER_WIDTH,
      DMA_ADDR_WIDTH        => DMA_ADDR_WIDTH,
      BUFFER_LINE_PTR_WIDTH => BUFFER_PTR_WIDTH
      )
    port map(
      sclk                        => sclk,
      srst_n                      => srst_n,
      planar_en                   => planar_en,
      clr_max_line_buffer_cnt     => clr_max_line_buffer_cnt,
      line_ptr_width              => line_ptr_width,
      max_line_buffer_cnt         => max_line_buffer_cnt,
      pcie_back_pressure_detected => pcie_back_pressure_detected,
      s_axis_tready               => tready,
      s_axis_tvalid               => tvalid,
      s_axis_tdata                => tdata,
      s_axis_tlast                => tlast,
      s_axis_tuser                => tuser,
      start_of_frame              => start_of_frame,
      line_ready                  => line_ready,
      line_transfered             => line_transfered,
      end_of_dma                  => end_of_dma,
      line_buffer_read_en         => line_buffer_read_en,
      line_buffer_read_address    => line_buffer_read_address,
      line_buffer_read_data       => line_buffer_read_data
      );


  xdma_write : dma_write
    generic map(
      NUMBER_OF_PLANE       => MAX_NUMBER_OF_PLANE,
      --READ_ADDRESS_MSB      => (BUFFER_ADDR_WIDTH-1),
      READ_ADDRESS_MSB      => (DMA_ADDR_WIDTH-1),
      MAX_PCIE_PAYLOAD_SIZE => MAX_PCIE_PAYLOAD_SIZE
      )
    port map(
      sys_clk              => sclk,
      sys_reset_n          => srst_n,
      cfg_bus_mast_en      => cfg_bus_mast_en,
      cfg_setmaxpld        => cfg_setmaxpld,
      tlp_req_to_send      => tlp_req_to_send,
      tlp_grant            => tlp_grant,
      tlp_fmt_type         => tlp_fmt_type,
      tlp_length_in_dw     => tlp_length_in_dw,
      tlp_src_rdy_n        => tlp_src_rdy_n,
      tlp_dst_rdy_n        => tlp_dst_rdy_n,
      tlp_data             => tlp_data,
      tlp_address          => tlp_address,
      tlp_ldwbe_fdwbe      => tlp_ldwbe_fdwbe,
      tlp_attr             => tlp_attr,
      tlp_transaction_id   => tlp_transaction_id,
      tlp_byte_count       => tlp_byte_count,
      tlp_lower_address    => tlp_lower_address,
      host_number_of_plane => dma_context_mux.numb_plane,
      host_write_address   => dma_context_mux.frame_start,
      host_line_pitch      => dma_context_mux.line_pitch,
      host_line_size       => dma_context_mux.line_size,
      host_reverse_y       => dma_context_mux.reverse_y,
      dma_idle             => dma_idle,
      dma_pcie_state       => dma_pcie_state,
      start_of_frame       => start_of_frame,
      line_ready           => line_ready,
      line_transfered      => line_transfered,
      end_of_dma           => end_of_dma,
      read_enable_out      => line_buffer_read_en,
      read_address         => line_buffer_read_address,
      read_data            => line_buffer_read_data
      );

  -----------------------------------------------------------------------------
  -- End of DMA transfer
  -----------------------------------------------------------------------------
  intevent <= end_of_dma;

end rtl;

