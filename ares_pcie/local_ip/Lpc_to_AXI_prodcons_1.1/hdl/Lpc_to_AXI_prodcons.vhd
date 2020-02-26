library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lpc_to_AXI_prodcons is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 13
	);
	port (
		-- Users to add ports here
        sysclk                     : in    std_logic;                                               -- System clock
        sysrst                     : in    std_logic;                                               -- reset synchrone au sysclk
        ------------------------------------------------------------------------------------
        -- Interface name: External interface
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_writeBeN               : in   std_logic_vector(3 downto 0);                            -- Write Byte Enable Bus for all external sections
        ext_writeData              : in   std_logic_vector(31 downto 0);                           -- Write Data Bus for all external sections
        ------------------------------------------------------------------------------------
        -- Interface name: ProdCons
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_ProdCons_addr          : in   std_logic_vector(10 downto 0);                           -- Address Bus for ProdCons external section
        ext_ProdCons_writeEn       : in   std_logic;                                               -- Write enable for ProdCons external section
        ext_ProdCons_readEn        : in   std_logic;                                               -- Read enable for ProdCons external section
        ext_ProdCons_readDataValid : out   std_logic;                                               -- Read Data Valid for ProdCons external section
        ext_ProdCons_readData      : out   std_logic_vector(31 downto 0);         
        host_irq                   : out  std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end Lpc_to_AXI_prodcons;

architecture arch_imp of Lpc_to_AXI_prodcons is

	-- component declaration
	component Lpc_to_AXI_prodcons_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        sysclk                     : in    std_logic;                                               -- System clock
        sysrst                     : in    std_logic;                                               -- reset synchrone au sysclk
        ------------------------------------------------------------------------------------
        -- Interface name: External interface
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_writeBeN               : in   std_logic_vector(3 downto 0);                            -- Write Byte Enable Bus for all external sections
        ext_writeData              : in   std_logic_vector(31 downto 0);                           -- Write Data Bus for all external sections
        ------------------------------------------------------------------------------------
        -- Interface name: ProdCons
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_ProdCons_addr          : in   std_logic_vector(10 downto 0);                           -- Address Bus for ProdCons external section
        ext_ProdCons_writeEn       : in   std_logic;                                               -- Write enable for ProdCons external section
        ext_ProdCons_readEn        : in   std_logic;                                               -- Read enable for ProdCons external section
        ext_ProdCons_readDataValid : out   std_logic;                                               -- Read Data Valid for ProdCons external section
        ext_ProdCons_readData      : out   std_logic_vector(31 downto 0);         
        host_irq                   : out  std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component Lpc_to_AXI_prodcons_S00_AXI;

begin

-- Instantiation of Axi Bus Interface S00_AXI
Lpc_to_AXI_prodcons_S00_AXI_inst : Lpc_to_AXI_prodcons_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,
        sysclk                     => sysclk,                                             -- System clock
        sysrst                     => sysrst,                                               -- reset synchrone au sysclk
        ------------------------------------------------------------------------------------
        -- Interface name: External interface
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_writeBeN               => ext_writeBeN,                            -- Write Byte Enable Bus for all external sections
        ext_writeData              => ext_writeData,                           -- Write Data Bus for all external sections
        ------------------------------------------------------------------------------------
        -- Interface name: ProdCons
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_ProdCons_addr          => ext_ProdCons_addr,                           -- Address Bus for ProdCons external section
        ext_ProdCons_writeEn       => ext_ProdCons_writeEn,                                              -- Write enable for ProdCons external section
        ext_ProdCons_readEn        => ext_ProdCons_readEn,                                               -- Read enable for ProdCons external section
        ext_ProdCons_readDataValid => ext_ProdCons_readDataValid,                                               -- Read Data Valid for ProdCons external section
        ext_ProdCons_readData      => ext_ProdCons_readData,
        host_irq                   =>         host_irq
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
