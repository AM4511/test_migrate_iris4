library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.regfile_xgs_athena_pack.all;


entity XGS_athena is
  generic (
    ENABLE_IDELAYCTRL     : integer range 0 to 1 := 1;
    NUMBER_OF_LANE        : integer              := 6;
    MUX_RATIO             : integer              := 4;
    PIXELS_PER_LINE       : integer              := 4176;
    LINES_PER_FRAME       : integer              := 3102;
    PIXEL_SIZE            : integer              := 12;
    MAX_PCIE_PAYLOAD_SIZE : integer              := 128
    );
  port (
    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    axi_clk     : in std_logic;
    axi_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- Interrupts
    ---------------------------------------------------------------------------
    irq : out std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Slave interface (Registerfile)
    ---------------------------------------------------------------------------
    s_axi_awaddr  : in  std_logic_vector(10 downto 0);
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
    s_axi_araddr  : in  std_logic_vector(10 downto 0);
    s_axi_arprot  : in  std_logic_vector(2 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata   : out std_logic_vector(31 downto 0);
    s_axi_rresp   : out std_logic_vector(1 downto 0);
    s_axi_rvalid  : out std_logic;
    s_axi_rready  : in  std_logic;


    ---------------------------------------------------------------------------
    -- Top HiSPI I/F
    ---------------------------------------------------------------------------
    idelay_clk      : in std_logic;
    hispi_io_clk_p  : in std_logic_vector(1 downto 0);  -- hispi clock
    hispi_io_clk_n  : in std_logic_vector(1 downto 0);  -- hispi clock
    hispi_io_data_p : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);
    hispi_io_data_n : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);

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
end entity XGS_athena;


architecture struct of XGS_athena is


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
  end component;


  component regfile_xgs_athena is
    port (
      resetN        : in    std_logic;  -- System reset
      sysclk        : in    std_logic;  -- System clock
      regfile       : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;  -- Read
      reg_write     : in    std_logic;  -- Write
      reg_addr      : in    std_logic_vector(10 downto 2);  -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);   -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);  -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)   -- Read data
      );
  end component;


  component xgs_hispi_top is
    generic (
      NUMBER_OF_LANE  : integer := 6;
      MUX_RATIO       : integer := 4;
      PIXELS_PER_LINE : integer := 4176;
      LINES_PER_FRAME : integer := 3102;
      PIXEL_SIZE      : integer := 12
      );
    port (
      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;


      ---------------------------------------------------------------------------
      -- Register file interface 
      ---------------------------------------------------------------------------
      regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file


      ---------------------------------------------------------------------------
      -- Top HiSPI I/F
      ---------------------------------------------------------------------------
      idelay_clk      : in std_logic;
      hispi_io_clk_p  : in std_logic_vector(1 downto 0);  -- hispi clock
      hispi_io_clk_n  : in std_logic_vector(1 downto 0);  -- hispi clock
      hispi_io_data_p : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);
      hispi_io_data_n : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);


      ---------------------------------------------------------------------------
      -- AXI Master stream interface
      ---------------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tuser  : out std_logic_vector(3 downto 0);
      m_axis_tlast  : out std_logic;
      m_axis_tdata  : out std_logic_vector(63 downto 0)
      );
  end component;


  component dmawr2tlp is
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
      regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file



      ----------------------------------------------------
      -- AXI stream interface (Slave port)
      ----------------------------------------------------
      tready : out std_logic;
      tvalid : in  std_logic;
      tdata  : in  std_logic_vector(63 downto 0);
      tuser  : in  std_logic_vector(3 downto 0);
      tlast  : in  std_logic;


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
  end component;

  constant C_S_AXI_DATA_WIDTH : integer := 32;
  constant C_S_AXI_ADDR_WIDTH : integer := 11;

  signal regfile           : REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file
  signal reg_read          : std_logic;
  signal reg_write         : std_logic;
  signal reg_addr          : std_logic_vector(10 downto 0);
  signal reg_beN           : std_logic_vector(3 downto 0);
  signal reg_writedata     : std_logic_vector(31 downto 0);
  signal reg_readdata      : std_logic_vector(31 downto 0);
  signal reg_readdatavalid : std_logic;

  signal tready : std_logic;
  signal tvalid : std_logic;
  signal tdata  : std_logic_vector(63 downto 0);
  signal tuser  : std_logic_vector(3 downto 0);
  signal tlast  : std_logic;

  signal context_strb : std_logic_vector(1 downto 0);  -- TBD from controller

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
  -- Module      : regfile_xgs_athena
  -- Description : IP-Core main registerfile. This file is generated by the
  --               Matrox FDK-IDE tool
  -----------------------------------------------------------------------------
  xregfile_xgs_athena : regfile_xgs_athena
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

  x_xgs_hispi_top : xgs_hispi_top
    generic map(
      NUMBER_OF_LANE  => NUMBER_OF_LANE,
      MUX_RATIO       => MUX_RATIO,
      PIXELS_PER_LINE => PIXELS_PER_LINE,
      LINES_PER_FRAME => LINES_PER_FRAME,
      PIXEL_SIZE      => PIXEL_SIZE
      )
    port map(
      axi_clk         => axi_clk,
      axi_reset_n     => axi_reset_n,
      regfile         => regfile,
      idelay_clk      => idelay_clk,
      hispi_io_clk_p  => hispi_io_clk_p,
      hispi_io_clk_n  => hispi_io_clk_n,
      hispi_io_data_p => hispi_io_data_p,
      hispi_io_data_n => hispi_io_data_n,
      m_axis_tready   => tready,
      m_axis_tvalid   => tvalid,
      m_axis_tuser    => tuser,
      m_axis_tlast    => tlast,
      m_axis_tdata    => tdata
      );




  xdmawr2tlp : dmawr2tlp
    generic map(
      MAX_PCIE_PAYLOAD_SIZE => MAX_PCIE_PAYLOAD_SIZE
      )
    port map(
      axi_clk            => axi_clk,
      axi_reset_n        => axi_reset_n,
      intevent           => irq(0),
      context_strb       => context_strb,
      regfile            => regfile,
      tready             => tready,
      tvalid             => tvalid,
      tdata              => tdata,
      tuser              => tuser,
      tlast              => tlast,
      cfg_bus_mast_en    => cfg_bus_mast_en,
      cfg_setmaxpld      => cfg_setmaxpld,
      tlp_req_to_send    => tlp_req_to_send,
      tlp_grant          => tlp_grant,
      tlp_fmt_type       => tlp_fmt_type,
      tlp_length_in_dw   => tlp_length_in_dw,
      tlp_src_rdy_n      => tlp_src_rdy_n,
      tlp_dst_rdy_n      => tlp_dst_rdy_n,
      tlp_data           => tlp_data,
      tlp_address        => tlp_address,
      tlp_ldwbe_fdwbe    => tlp_ldwbe_fdwbe,
      tlp_attr           => tlp_attr,
      tlp_transaction_id => tlp_transaction_id,
      tlp_byte_count     => tlp_byte_count,
      tlp_lower_address  => tlp_lower_address
      );



  -----------------------------------------------------------------------------
  -- Process     : P_reg_readdatavalid
  -- Description : register file read data valid. Indicates when the data is
  --               return from the registerfile. By default the Matrox FDKIde
  --               does not generates by default a read data valid flag. Only
  --               when an External section is declared. In case of regular
  --               FF register, the read latency is 1 clock cycle.
  -----------------------------------------------------------------------------
  P_reg_readdatavalid : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        reg_readdatavalid <= '0';
      else
        reg_readdatavalid <= reg_read;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- IDELAYCTRL is needed for SERDES calibration. 
  -----------------------------------------------------------------------------
  G_ENABLE_IDELAYCTRL : if (ENABLE_IDELAYCTRL > 0) generate
    xIDELAYCTRL : IDELAYCTRL
      port map (
        RDY    => regfile.HISPI.IDELAYCTRL_STATUS.PLL_LOCKED,
        REFCLK => idelay_clk,
        RST    => regfile.HISPI.CTRL.RESET_IDELAYCTRL
        );
  end generate G_ENABLE_IDELAYCTRL;


end struct;
