-----------------------------------------------------------------------
-- 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Work library
library work;
use work.regfile_dmawr2tlp_pack.all;
use work.dma_pack.all;


entity dmawr2tlp is
  generic (
    MAX_PCIE_PAYLOAD_SIZE : integer := 128
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    axi_clk     : in std_logic;
    axi_reset_n : in std_logic;

    ---------------------------------------------------------------------
    -- IRQ I/F
    ---------------------------------------------------------------------
    intevent : out std_logic;

    ---------------------------------------------------------------------
    -- System I/F
    ---------------------------------------------------------------------
    context_strb : in std_logic_vector(1 downto 0);

    ---------------------------------------------------------------------
    -- RegisterFile I/F
    ---------------------------------------------------------------------
    s_axi_awaddr  : in  std_logic_vector(7 downto 0);
    s_axi_awprot  : in  std_logic_vector(2 downto 0);
    s_axi_awvalid : in  std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in  std_logic_vector(31 downto 0);
    s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    s_axi_wvalid  : in  std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bresp   : out std_logic_vector(1 downto 0);
    s_axi_bvalid  : out std_logic;
    s_axi_bready  : in  std_logic;
    s_axi_araddr  : in  std_logic_vector(7 downto 0);
    s_axi_arprot  : in  std_logic_vector(2 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata   : out std_logic_vector(31 downto 0);
    s_axi_rresp   : out std_logic_vector(1 downto 0);
    s_axi_rvalid  : out std_logic;
    s_axi_rready  : in  std_logic;


    ----------------------------------------------------
    -- AXI stream interface (Slave port)
    ----------------------------------------------------
    s_axis_tready : out std_logic;
    s_axis_tvalid : in  std_logic;
    s_axis_tdata  : in  std_logic_vector(63 downto 0);
    s_axis_tuser  : in  std_logic_vector(3 downto 0);
    s_axis_tlast  : in  std_logic;


    ---------------------------------------------------------------------
    -- PCIe Configuration space info (axi_clk)
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


  component axiSlave2RegFile
    generic(
      -- Width of S_AXI data bus
      C_S_AXI_DATA_WIDTH : integer := 32;
      -- Width of S_AXI address bus
      C_S_AXI_ADDR_WIDTH : integer := 9
      );
    port(
      ---------------------------------------------------------------------------
      -- Axi slave clock interface
      ---------------------------------------------------------------------------
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;

      ---------------------------------------------------------------------------
      -- Axi write address channel
      ---------------------------------------------------------------------------
      axi_awvalid : in  std_logic;
      axi_awready : out std_logic;
      axi_awprot  : in  std_logic_vector(2 downto 0);
      axi_awaddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi write data channel
      ---------------------------------------------------------------------------
      axi_wvalid : in  std_logic;
      axi_wready : out std_logic;
      axi_wstrb  : in  std_logic_vector((C_S_AXI_DATA_WIDTH / 8) - 1 downto 0);
      axi_wdata  : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi write response channel
      ---------------------------------------------------------------------------
      axi_bready : in  std_logic;
      axi_bvalid : out std_logic;
      axi_bresp  : out std_logic_vector(1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi read address channel
      ---------------------------------------------------------------------------
      axi_arvalid : in  std_logic;
      axi_arready : out std_logic;
      axi_arprot  : in  std_logic_vector(2 downto 0);
      axi_araddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi read data channel
      ---------------------------------------------------------------------------
      axi_rready : in  std_logic;
      axi_rvalid : out std_logic;
      axi_rdata  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
      axi_rresp  : out std_logic_vector(1 downto 0);


      ---------------------------------------------------------------------------
      -- FDK IDE registerfile interface
      ---------------------------------------------------------------------------
      reg_read          : out std_logic;
      reg_write         : out std_logic;
      reg_addr          : out std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
      reg_beN           : out std_logic_vector((C_S_AXI_DATA_WIDTH / 8) - 1 downto 0);
      reg_writedata     : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
      reg_readdataValid : in  std_logic;
      reg_readdata      : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0)
      );
  end component axiSlave2RegFile;


  component regfile_dmawr2tlp is
    port (
      resetN        : in    std_logic;  -- System reset
      sysclk        : in    std_logic;  -- System clock
      regfile       : inout REGFILE_DMAWR2TLP_TYPE := INIT_REGFILE_DMAWR2TLP_TYPE;  -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;  -- Read
      reg_write     : in    std_logic;  -- Write
      reg_addr      : in    std_logic_vector(7 downto 2);   -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);   -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);  -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)   -- Read data
      );
  end component regfile_dmawr2tlp;


  component axi_stream_in is
    generic (
      AXIS_DATA_WIDTH   : integer := 64;
      AXIS_USER_WIDTH   : integer := 4;
      BUFFER_ADDR_WIDTH : integer := 10
      );
    port (
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;

      ----------------------------------------------------
      -- Control I/F
      ----------------------------------------------------

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
      line_buffer_read_address : in  std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
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
      host_line_pitch      : in std_logic_vector(15 downto 0);
      host_line_size       : in std_logic_vector(13 downto 0);
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


  constant C_S_AXI_ADDR_WIDTH  : integer := 8;
  constant C_S_AXI_DATA_WIDTH  : integer := 32;
  constant AXIS_DATA_WIDTH     : integer := 64;
  constant AXIS_USER_WIDTH     : integer := 4;
  constant BUFFER_ADDR_WIDTH   : integer := 11;
  constant READ_ADDRESS_MSB    : integer := 10;
  constant MAX_NUMBER_OF_PLANE : integer := 3;

  signal reg_read          : std_logic;
  signal reg_write         : std_logic;
  signal reg_addr          : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal reg_beN           : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal reg_writedata     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal reg_readdatavalid : std_logic;
  signal reg_readdata      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal regfile           : REGFILE_DMAWR2TLP_TYPE                          := INIT_REGFILE_DMAWR2TLP_TYPE;

  signal dma_idle                 : std_logic;
  signal dma_pcie_state           : std_logic_vector(2 downto 0);
  signal start_of_frame           : std_logic;
  signal line_ready               : std_logic;
  signal line_transfered          : std_logic;
  signal end_of_dma               : std_logic;
  signal line_buffer_read_en      : std_logic;
  signal line_buffer_read_address : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal line_buffer_read_data    : std_logic_vector(63 downto 0);
  signal color_space              : std_logic_vector(2 downto 0);


  -----------------------------------------------------------------------------
  -- Register context structure
  -----------------------------------------------------------------------------
  signal dma_context_mapping : DMA_CONTEXT_TYPE;
  signal dma_context_p0      : DMA_CONTEXT_TYPE;
  signal dma_context_P1      : DMA_CONTEXT_TYPE;
  signal dma_context_mux     : DMA_CONTEXT_TYPE;


begin

  -----------------------------------------------------------------------------
  -- AXI Slave Interface
  -----------------------------------------------------------------------------
  xaxiSlave2RegFile : axiSlave2RegFile
    generic map(
      C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
      )
    port map(
      axi_clk           => axi_clk,
      axi_reset_n       => axi_reset_n,
      axi_awvalid       => s_axi_awvalid,
      axi_awready       => s_axi_awready,
      axi_awprot        => s_axi_awprot,
      axi_awaddr        => s_axi_awaddr,
      axi_wvalid        => s_axi_wvalid,
      axi_wready        => s_axi_wready,
      axi_wstrb         => s_axi_wstrb,
      axi_wdata         => s_axi_wdata,
      axi_bready        => s_axi_bready,
      axi_bvalid        => s_axi_bvalid,
      axi_bresp         => s_axi_bresp,
      axi_arvalid       => s_axi_arvalid,
      axi_arready       => s_axi_arready,
      axi_arprot        => s_axi_arprot,
      axi_araddr        => s_axi_araddr,
      axi_rready        => s_axi_rready,
      axi_rvalid        => s_axi_rvalid,
      axi_rdata         => s_axi_rdata,
      axi_rresp         => s_axi_rresp,
      reg_read          => reg_read,
      reg_write         => reg_write,
      reg_addr          => reg_addr,
      reg_beN           => reg_beN,
      reg_writedata     => reg_writedata,
      reg_readdataValid => reg_readdataValid,
      reg_readdata      => reg_readdata
      );


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_reg_readdataValid : process(axi_clk)
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0')then
        reg_readdataValid <= '0';
      else
        reg_readdataValid <= reg_read;
      end if;
    end if;
  end process;


  xregfile_dmawr2tlp : regfile_dmawr2tlp
    port map(
      resetN        => axi_reset_n,
      sysclk        => axi_clk,
      regfile       => regfile,
      reg_read      => reg_read,
      reg_write     => reg_write,
      reg_addr      => reg_addr(C_S_AXI_ADDR_WIDTH-1 downto 2),
      reg_beN       => reg_beN,
      reg_writedata => reg_writedata,
      reg_readdata  => reg_readdata
      );


  -----------------------------------------------------------------------------
  -- Registerfile remapping
  -----------------------------------------------------------------------------
  dma_context_mapping.frame_start(0) <= regfile.dma.frame_start(1).value & regfile.dma.frame_start(0).value;
  dma_context_mapping.frame_start(1) <= regfile.dma.frame_start_g(1).value & regfile.dma.frame_start_g(0).value;
  dma_context_mapping.frame_start(2) <= regfile.dma.frame_start_r(1).value & regfile.dma.frame_start_r(0).value;
  dma_context_mapping.line_pitch     <= regfile.dma.line_pitch.value;
  dma_context_mapping.line_size      <= regfile.dma.line_size.value;
  dma_context_mapping.reverse_y      <= regfile.dma.csc.reverse_y;
  dma_context_mapping.numb_plane     <= 1 when (regfile.dma.csc.COLOR_SPACE = "00") else
                                    3;


  -----------------------------------------------------------------------------
  -- Grab context pipeline
  -----------------------------------------------------------------------------
  P_dma_context : process(axi_clk)
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0')then
        dma_context_p0 <= INIT_DMA_CONTEXT_TYPE;
        dma_context_p1 <= INIT_DMA_CONTEXT_TYPE;
      else
        if (context_strb(0) = '1') then
          dma_context_p0 <= dma_context_mapping;
        end if;
        if (context_strb(1) = '1') then
          dma_context_p1 <= dma_context_p0;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Grab context selection MUX
  -----------------------------------------------------------------------------
  dma_context_mux <= dma_context_p1 when (regfile.dma.ctrl.grab_queue_enable = '1') else
                     dma_context_mapping;


  xaxi_stream_in : axi_stream_in
    generic map(
      AXIS_DATA_WIDTH   => AXIS_DATA_WIDTH,
      AXIS_USER_WIDTH   => AXIS_USER_WIDTH,
      BUFFER_ADDR_WIDTH => BUFFER_ADDR_WIDTH
      )
    port map(
      axi_clk                  => axi_clk,
      axi_reset_n              => axi_reset_n,
      s_axis_tready            => s_axis_tready,
      s_axis_tvalid            => s_axis_tvalid,
      s_axis_tdata             => s_axis_tdata,
      s_axis_tlast             => s_axis_tlast,
      s_axis_tuser             => s_axis_tuser,
      start_of_frame           => start_of_frame,
      line_ready               => line_ready,
      line_transfered          => line_transfered,
      end_of_dma               => end_of_dma,
      line_buffer_read_en      => line_buffer_read_en,
      line_buffer_read_address => line_buffer_read_address,
      line_buffer_read_data    => line_buffer_read_data
      );


  xdma_write : dma_write
    generic map(
      NUMBER_OF_PLANE       => MAX_NUMBER_OF_PLANE,
      READ_ADDRESS_MSB      => (BUFFER_ADDR_WIDTH-1),
      MAX_PCIE_PAYLOAD_SIZE => MAX_PCIE_PAYLOAD_SIZE
      )
    port map(
      sys_clk              => axi_clk,
      sys_reset_n          => axi_reset_n,
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

  intevent <= '0';                      -- TBD

end rtl;

