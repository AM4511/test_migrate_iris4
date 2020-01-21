library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_pattern_generator is
    generic (
        C_FAMILY                : string    := "kintexu";

        C_S00_AXI_DATA_WIDTH    : integer   := 32;
        C_S00_AXI_ADDR_WIDTH    : integer   := 12;

        C_M00_AXIS_TDATA_WIDTH  : integer   := 128;
        C_M00_AXIS_TUSER_WIDTH  : integer   := 16
    );
    port (
        s00_axi_aclk            : in std_logic;
        s00_axi_aresetn         : in std_logic;
        s00_axi_awaddr          : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot          : in std_logic_vector(2 downto 0);
        s00_axi_awvalid         : in std_logic;
        s00_axi_awready         : out std_logic;
        s00_axi_wdata           : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb           : in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid          : in std_logic;
        s00_axi_wready          : out std_logic;
        s00_axi_bresp           : out std_logic_vector(1 downto 0);
        s00_axi_bvalid          : out std_logic;
        s00_axi_bready          : in std_logic;
        s00_axi_araddr          : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot          : in std_logic_vector(2 downto 0);
        s00_axi_arvalid         : in std_logic;
        s00_axi_arready         : out std_logic;
        s00_axi_rdata           : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp           : out std_logic_vector(1 downto 0);
        s00_axi_rvalid          : out std_logic;
        s00_axi_rready          : in std_logic;

        m00_axis_aclk           : in std_logic;
        m00_axis_aresetn        : in std_logic;
        m00_axis_tvalid         : out std_logic;
        m00_axis_tdata          : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        m00_axis_tstrb          : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        m00_axis_tkeep          : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        m00_axis_tlast          : out std_logic;
        m00_axis_tready         : in std_logic;
        m00_axis_tuser          : out std_logic_vector(C_M00_AXIS_TUSER_WIDTH-1 downto 0)         -- TUSER signals, used as SOF
    );
end test_pattern_generator;

architecture structure of test_pattern_generator is

  -- component declaration
  component register_if is
     generic (
        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH  : integer   := 32;
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH  : integer   := 7
    );
    port (
        -- Users to add ports here
        CLOCK                       : in  std_logic;
        RESET                       : in  std_logic;

        linelength                  : out std_logic_vector(15 downto 0);
        nroflines                   : out std_logic_vector(15 downto 0);
        xinc                        : out std_logic_vector(15 downto 0);
        yinc                        : out std_logic_vector(15 downto 0);
        finc                        : out std_logic_vector(15 downto 0);

        enable                      : out std_logic;
        busy                        : in  std_logic := '0';

        read_count                  : in std_logic_vector(31 downto 0);
        write_count                 : in std_logic_vector(31 downto 0);
        read_error                  : in std_logic;
        write_error                 : in std_logic;
        
        fifo_status                 : in std_logic_vector(4 downto 0);

        -- User ports ends

        S_AXI_ACLK  : in std_logic;
        S_AXI_ARESETN   : in std_logic;
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID   : in std_logic;
        S_AXI_AWREADY   : out std_logic;
        S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID    : in std_logic;
        S_AXI_WREADY    : out std_logic;
        S_AXI_BRESP : out std_logic_vector(1 downto 0);
        S_AXI_BVALID    : out std_logic;
        S_AXI_BREADY    : in std_logic;
        S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID   : in std_logic;
        S_AXI_ARREADY   : out std_logic;
        S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP : out std_logic_vector(1 downto 0);
        S_AXI_RVALID    : out std_logic;
        S_AXI_RREADY    : in std_logic
    );
  end component register_if;

    component datapipeline is
        generic (
            C_FAMILY                : string := "Virtex7";
            C_M_AXIS_TDATA_WIDTH    : integer   := 128;
            C_M_AXIS_TUSER_WIDTH    : integer   := 1
        );
        port (
            -- Users to add ports here
            CLOCK                   : in  std_logic;
            RESET                   : in  std_logic;

            linelength              : in    std_logic_vector(15 downto 0);
            nroflines               : in    std_logic_vector(15 downto 0);
            xinc                    : in    std_logic_vector(15 downto 0);
            yinc                    : in    std_logic_vector(15 downto 0);
            finc                    : in    std_logic_vector(15 downto 0);

            enable                  : in    std_logic;
            busy                    : out   std_logic := '0';

            read_count              : out   std_logic_vector(31 downto 0);
            write_count             : out   std_logic_vector(31 downto 0);
            read_error              : out   std_logic;
            write_error             : out   std_logic;
            
            fifo_status             : out   std_logic_vector(4 downto 0);

            -- User ports ends
            -- Do not modify the ports beyond this line
            -- Global ports
            M_AXIS_ACLK             : in std_logic;
            M_AXIS_ARESETN          : in std_logic;
            M_AXIS_TVALID           : out std_logic;                                                -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
            M_AXIS_TDATA            : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);        -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
            M_AXIS_TSTRB            : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);    -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
            M_AXIS_TKEEP            : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
            M_AXIS_TLAST            : out std_logic;                                                -- TLAST indicates the boundary of a packet, used as EOL
            M_AXIS_TREADY           : in std_logic;                                                 -- TREADY indicates that the slave can accept a transfer in the current cycle.
            M_AXIS_TUSER            : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0)         -- TUSER signals, used as SOF
        );
    end component datapipeline;

constant RST_SYNC_NUM          : integer := 25;

signal clock                   : std_logic := '0'; --should be same as M_AXIS_ACLK in most cases
signal reset                   : std_logic := '0';

signal rst_sync_r              : std_logic_vector(RST_SYNC_NUM-1 downto 0) := (others => '1');
signal reset_sync              : std_logic := '1';

signal linelength              : std_logic_vector(15 downto 0) := (others => '0');
signal nroflines               : std_logic_vector(15 downto 0) := (others => '0');
signal xinc                    : std_logic_vector(15 downto 0) := (others => '0');
signal yinc                    : std_logic_vector(15 downto 0) := (others => '0');
signal finc                    : std_logic_vector(15 downto 0) := (others => '0');

signal enable                  : std_logic := '0';
signal busy                    : std_logic := '0';

signal read_count              : std_logic_vector(31 downto 0) := (others => '0');
signal write_count             : std_logic_vector(31 downto 0) := (others => '0');
signal read_error              : std_logic := '0';
signal write_error             : std_logic := '0';
signal fifo_status             : std_logic_vector( 4 downto 0) := (others => '0');

--optional debug insertion
attribute mark_debug : string;
attribute mark_debug of enable            : signal is "true";
attribute mark_debug of busy              : signal is "true";

begin

clock <= m00_axis_aclk;
reset <= not m00_axis_aresetn;

--reset synchronisation
--go async in reset but go sync out of reset
process (clock, reset)
  begin
    if (reset = '1') then
        rst_sync_r <= (others => '1');
    elsif (clock = '1' and clock'event) then
        rst_sync_r <= rst_sync_r(RST_SYNC_NUM-2 downto 0) & '0';
    end if;
end process;

reset_sync <= rst_sync_r(RST_SYNC_NUM-1);

-- Instantiation of Axi Bus Interface S00_AXI
the_register_if: register_if
     generic map (
        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH      => C_S00_AXI_DATA_WIDTH   ,
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH      => C_S00_AXI_ADDR_WIDTH
    )
    port map (
        -- Users to add ports here
        CLOCK                       => clock                    ,
        RESET                       => reset_sync               ,

        linelength                  => linelength               ,
        nroflines                   => nroflines                ,
        xinc                        => xinc                     ,
        yinc                        => yinc                     ,
        finc                        => finc                     ,

        enable                      => enable                   ,
        busy                        => busy                     ,

        read_count                  => read_count               ,
        write_count                 => write_count              ,
        read_error                  => read_error               ,
        write_error                 => write_error              ,
        
        fifo_status                 => fifo_status              ,

        -- User ports ends
        S_AXI_ACLK                  => s00_axi_aclk             ,
        S_AXI_ARESETN               => s00_axi_aresetn          ,
        S_AXI_AWADDR                => s00_axi_awaddr           ,
        S_AXI_AWPROT                => s00_axi_awprot           ,
        S_AXI_AWVALID               => s00_axi_awvalid          ,
        S_AXI_AWREADY               => s00_axi_awready          ,
        S_AXI_WDATA                 => s00_axi_wdata            ,
        S_AXI_WSTRB                 => s00_axi_wstrb            ,
        S_AXI_WVALID                => s00_axi_wvalid           ,
        S_AXI_WREADY                => s00_axi_wready           ,
        S_AXI_BRESP                 => s00_axi_bresp            ,
        S_AXI_BVALID                => s00_axi_bvalid           ,
        S_AXI_BREADY                => s00_axi_bready           ,
        S_AXI_ARADDR                => s00_axi_araddr           ,
        S_AXI_ARPROT                => s00_axi_arprot           ,
        S_AXI_ARVALID               => s00_axi_arvalid          ,
        S_AXI_ARREADY               => s00_axi_arready          ,
        S_AXI_RDATA                 => s00_axi_rdata            ,
        S_AXI_RRESP                 => s00_axi_rresp            ,
        S_AXI_RVALID                => s00_axi_rvalid           ,
        S_AXI_RREADY                => s00_axi_rready
    );

the_datapipeline: datapipeline
    generic map (
        C_FAMILY                    => C_FAMILY                 ,
        C_M_AXIS_TDATA_WIDTH        => C_M00_AXIS_TDATA_WIDTH   ,
        C_M_AXIS_TUSER_WIDTH        => C_M00_AXIS_TUSER_WIDTH
    )
    port map (
        -- Users to add ports here
        CLOCK                       => clock                    , --should be same as M_AXIS_ACLK in most cases
        RESET                       => reset_sync               ,

        linelength                  => linelength               ,
        nroflines                   => nroflines                ,
        xinc                        => xinc                     ,
        yinc                        => yinc                     ,
        finc                        => finc                     ,

        enable                      => enable                   ,
        busy                        => busy                     ,

        read_count                  => read_count               ,
        write_count                 => write_count              ,
        read_error                  => read_error               ,
        write_error                 => write_error              ,
        
        fifo_status                 => fifo_status              ,

        M_AXIS_ACLK                 => m00_axis_aclk            ,
        M_AXIS_ARESETN              => m00_axis_aresetn         ,
        M_AXIS_TVALID               => m00_axis_tvalid          ,
        M_AXIS_TDATA                => m00_axis_tdata           ,
        M_AXIS_TSTRB                => m00_axis_tstrb           ,
        M_AXIS_TKEEP                => m00_axis_tkeep           ,
        M_AXIS_TLAST                => m00_axis_tlast           ,
        M_AXIS_TREADY               => m00_axis_tready          ,
        M_AXIS_TUSER                => m00_axis_tuser
        );

end structure;
