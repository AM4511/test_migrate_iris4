
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity remapper is
  generic (

        C_FAMILY                        : string  := "kintexu";
        C_PLATFORM                      : integer := 2;
        C_NROF_DATACONN                 : integer := 24; --number of dataconnections per interface block
        C_INPUT_DATAWIDTH               : integer := 12;
        C_OUTPUT_DATAWIDTH              : integer := 16;

        -- Parameters of Axi Streaming Interface
        C_M_AXIS_TDATA_WIDTH            : integer := 512; --to align with axi video dma ( can be 32, 64, 128, 256,512 or 1024)
        C_M_AXIS_TUSER_WIDTH            : integer := 3;
        C_S_AXIS_TDATA_WIDTH            : integer := 24*12; --C_NROF_DATACONN*C_INPUT_DATAWIDTH
        C_S_AXIS_TUSER_WIDTH            : integer := 3;
        C_AXIS_TID_WIDTH                : integer := 1;
        C_AXIS_TDEST_WIDTH              : integer := 1;

        -- Parameters of Axi Slave MM Bus Interface
        C_S_AXI_DATA_WIDTH              : integer := 32;
        C_S_AXI_ADDR_WIDTH              : integer := 12

  );
  port (

        --AXI S MM interface
        S_AXI_ACLK                      : in std_logic;
        S_AXI_ARESETN                   : in std_logic;
        S_AXI_AWADDR                    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWPROT                    : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID                   : in std_logic;
        S_AXI_AWREADY                   : out std_logic;
        S_AXI_WDATA                     : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB                     : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID                    : in std_logic;
        S_AXI_WREADY                    : out std_logic;
        S_AXI_BRESP                     : out std_logic_vector(1 downto 0);
        S_AXI_BVALID                    : out std_logic;
        S_AXI_BREADY                    : in std_logic;
        S_AXI_ARADDR                    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARPROT                    : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID                   : in std_logic;
        S_AXI_ARREADY                   : out std_logic;
        S_AXI_RDATA                     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP                     : out std_logic_vector(1 downto 0);
        S_AXI_RVALID                    : out std_logic;
        S_AXI_RREADY                    : in std_logic;

        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 : in std_logic;
        AXIS_VIDEO_ARESETN              : in std_logic;

        -- Master side
        M_AXIS_VIDEO_TVALID             : out std_logic := '0';
        M_AXIS_VIDEO_TDATA              : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TSTRB              : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TLAST              : out std_logic := '0';
        M_AXIS_VIDEO_TREADY             : in std_logic;
        M_AXIS_VIDEO_TUSER              : out  std_logic_vector(C_M_AXIS_TUSER_WIDTH -1 downto 0);
        M_AXIS_VIDEO_TKEEP              : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TID                : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TDEST              : out std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');

        -- Slave side
        S_AXIS_VIDEO_TVALID             : in std_logic := '0';
        S_AXIS_VIDEO_TDATA              : in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TSTRB              : in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TLAST              : in std_logic := '0';
        S_AXIS_VIDEO_TREADY             : out std_logic;
        S_AXIS_VIDEO_TUSER              : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0);
        S_AXIS_VIDEO_TKEEP              : in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TID                : in std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TDEST              : in std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0')
  );

--optional debug insertion
attribute mark_debug : string;
attribute mark_debug of M_AXIS_VIDEO_TVALID   : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TDATA    : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TSTRB    : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TLAST    : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TREADY   : signal is "true";

end remapper;

architecture rtl of remapper is

component register_if
    generic (
        -- Users to add parameters here
        -- User parameters ends
        -- Do not modify the parameters beyond this line

        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH  : integer   := 32;
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH  : integer   := 32
    );
    port (
        -- Users to add ports here
        CLOCK                       : in  std_logic;
        RESET                       : in  std_logic;

        REMAP_ENABLE                : out std_logic;
        
        BRAM_RESET                  : out std_logic;
        BRAM_PIXEL_0_LANE           : out std_logic;
        BRAM_READOUT_MODE           : out std_logic_vector( 3 downto 0);
        BRAM_STATUS                 : in  std_logic_vector(31 downto 0);
        
        FIFO_RESET                  : out std_logic;
        FIFO_ENABLE                 : out std_logic;
        FIFO_STATUS                 : in  std_logic_vector( 4 downto 0);

        -- User ports ends
        -- Do not modify the ports beyond this line
        -- Global Clock Signal
        S_AXI_ACLK  : in std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN   : in std_logic;
        -- Write address (issued by master, acceped by Slave)
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Write channel Protection type. This signal indicates the
            -- privilege and security level of the transaction, and whether
            -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        -- Write address valid. This signal indicates that the master signaling
            -- valid write address and control information.
        S_AXI_AWVALID   : in std_logic;
        -- Write address ready. This signal indicates that the slave is ready
            -- to accept an address and associated control signals.
        S_AXI_AWREADY   : out std_logic;
        -- Write data (issued by master, acceped by Slave)
        S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte lanes hold
            -- valid data. There is one write strobe bit for each eight
            -- bits of the write data bus.
        S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write valid. This signal indicates that valid write
            -- data and strobes are available.
        S_AXI_WVALID    : in std_logic;
        -- Write ready. This signal indicates that the slave
            -- can accept the write data.
        S_AXI_WREADY    : out std_logic;
        -- Write response. This signal indicates the status
            -- of the write transaction.
        S_AXI_BRESP : out std_logic_vector(1 downto 0);
        -- Write response valid. This signal indicates that the channel
            -- is signaling a valid write response.
        S_AXI_BVALID    : out std_logic;
        -- Response ready. This signal indicates that the master
            -- can accept a write response.
        S_AXI_BREADY    : in std_logic;
        -- Read address (issued by master, acceped by Slave)
        S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Protection type. This signal indicates the privilege
            -- and security level of the transaction, and whether the
            -- transaction is a data access or an instruction access.
        S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
        -- Read address valid. This signal indicates that the channel
            -- is signaling valid read address and control information.
        S_AXI_ARVALID   : in std_logic;
        -- Read address ready. This signal indicates that the slave is
            -- ready to accept an address and associated control signals.
        S_AXI_ARREADY   : out std_logic;
        -- Read data (issued by slave)
        S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of the
            -- read transfer.
        S_AXI_RRESP : out std_logic_vector(1 downto 0);
        -- Read valid. This signal indicates that the channel is
            -- signaling the required read data.
        S_AXI_RVALID    : out std_logic;
        -- Read ready. This signal indicates that the master can
            -- accept the read data and response information.
        S_AXI_RREADY    : in std_logic
    );
end component;


component scrambler
  generic (

        C_PLATFORM                      : integer := 0;
        C_NROF_DATACONN                 : integer := 24; --number of dataconnections

        C_S_AXIS_TDATA_WIDTH            : integer := 24*12;
        C_S_AXIS_TUSER_WIDTH            : integer := 1;
        C_AXIS_TID_WIDTH                : integer := 1;
        C_AXIS_TDEST_WIDTH              : integer := 1
        
  );
  port (
        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 : in  std_logic;
        AXIS_VIDEO_ARESETN              : in  std_logic;

        -- Slave side
        S_AXIS_VIDEO_TVALID             : in  std_logic;
        S_AXIS_VIDEO_TDATA              : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        S_AXIS_VIDEO_TSTRB              : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        S_AXIS_VIDEO_TLAST              : in  std_logic;
        S_AXIS_VIDEO_TREADY             : out std_logic := '0';
        S_AXIS_VIDEO_TUSER              : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0);
        S_AXIS_VIDEO_TKEEP              : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        S_AXIS_VIDEO_TID                : in  std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0);
        S_AXIS_VIDEO_TDEST              : in  std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0);
        
        -- 
        SCRAMBLED_VIDEO_TVALID          : out std_logic := '0';
        SCRAMBLED_VIDEO_TDATA           : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        SCRAMBLED_VIDEO_TSTRB           : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        SCRAMBLED_VIDEO_TLAST           : out std_logic := '0';
        SCRAMBLED_VIDEO_TREADY          : in  std_logic;
        SCRAMBLED_VIDEO_TUSER           : out std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0) := (others => '0');
        SCRAMBLED_VIDEO_TKEEP           : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        SCRAMBLED_VIDEO_TID             : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        SCRAMBLED_VIDEO_TDEST           : out std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0')
        
  );
end component;


component reorder
  generic (

        C_FAMILY                        : string  := "kintexu";
        C_NROF_DATACONN                 : integer := 24; --number of dataconnections
        C_INPUT_DATAWIDTH               : integer := 12;

        C_S_AXIS_TDATA_WIDTH            : integer := 24*12; --C_NROF_DATACONN*C_INPUT_DATAWIDTH
        C_S_AXIS_TUSER_WIDTH            : integer := 1;
        C_AXIS_TID_WIDTH                : integer := 1;
        C_AXIS_TDEST_WIDTH              : integer := 1
        
  );
  port (
        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 : in std_logic;
        AXIS_VIDEO_ARESETN              : in std_logic;

        -- Slave side
        AXIS_VIDEO_TVALID               : in  std_logic;
        AXIS_VIDEO_TDATA                : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        AXIS_VIDEO_TSTRB                : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        AXIS_VIDEO_TLAST                : in  std_logic;
        AXIS_VIDEO_TUSER                : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0);
        AXIS_VIDEO_TKEEP                : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        AXIS_VIDEO_TID                  : in  std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0);
        AXIS_VIDEO_TDEST                : in  std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0);
        
        -- 
        REORDERED_VIDEO_TVALID          : out std_logic := '0';
        REORDERED_VIDEO_TDATA           : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        REORDERED_VIDEO_TSTRB           : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        REORDERED_VIDEO_TLAST           : out std_logic := '0';
        REORDERED_VIDEO_TUSER           : out std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0) := (others => '0');
        REORDERED_VIDEO_TKEEP           : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        REORDERED_VIDEO_TID             : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        REORDERED_VIDEO_TDEST           : out std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');
        
        REMAP_ENABLE                    : in  std_logic;
        DO_SWAP                         : in  std_logic
        
  );
end component;


component ctrl_bram
  generic (

        C_FAMILY                        : string  := "kintexu";
        C_NROF_DATACONN                 : integer := 24; --number of dataconnections
        C_INPUT_DATAWIDTH               : integer := 12; --max bits per pixel

        C_S_AXIS_TDATA_WIDTH            : integer := 24*12; --C_NROF_DATACONN*C_INPUT_DATAWIDTH
        C_S_AXIS_TUSER_WIDTH            : integer := 3;
        C_AXIS_TID_WIDTH                : integer := 1;
        C_AXIS_TDEST_WIDTH              : integer := 1
        
  );
  port (
        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 : in  std_logic;
        AXIS_VIDEO_ARESETN              : in  std_logic;

        -- Incoming axis interface
        REMAP_TVALID                    : in  std_logic;
        REMAP_TDATA                     : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        REMAP_TSTRB                     : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        REMAP_TLAST                     : in  std_logic;
        REMAP_TUSER                     : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0);
        REMAP_TKEEP                     : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        REMAP_TID                       : in  std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0);
        REMAP_TDEST                     : in  std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0);
        
        -- Outgoing axis interface
        BRAM_TVALID                     : out std_logic := '0';
        BRAM_TDATA                      : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        BRAM_TSTRB                      : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        BRAM_TLAST                      : out std_logic := '0';
        BRAM_TUSER                      : out std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0) := (others => '0');
        BRAM_TKEEP                      : out std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        BRAM_TID                        : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        BRAM_TDEST                      : out std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');
        
        RESET_BRAM                      : in  std_logic;
        PIXEL_0_LANE                    : in  std_logic;
        READOUT_MODE                    : in  std_logic_vector(3 downto 0);
        
        BRAM_READ_EN                    : in  std_logic;
        REMAP_ENABLE                    : in  std_logic;
        BRAM_TREADY                     : out std_logic := '1';
        DO_SWAP                         : out std_logic := '0';
        STATUS_REMAP_BRAM               : out std_logic_vector(31 downto 0) := (others => '0')
        
  );
end component;


component gearbox_out
  generic (

        C_FAMILY                        : string  := "kintexu";
        C_NROF_DATACONN                 : integer := 24; --number of dataconnections per interface block
        C_INPUT_DATAWIDTH               : integer := 12;
        C_OUTPUT_DATAWIDTH              : integer := 16;

        -- Parameters of Axi slave Streaming Interface
        C_S_AXIS_TDATA_WIDTH            : integer := 24*12;
        C_AXIS_TID_WIDTH                : integer := 1;
        C_AXIS_TDEST_WIDTH              : integer := 1;

        -- Parameters of Axi master Streaming Interface
        C_M_AXIS_TDATA_WIDTH            : integer := 512; --to align with axi video dma ( can be 32, 64, 128, 256,512 or 1024)

        C_S_AXIS_TUSER_WIDTH            : integer :=  1;
        C_M_AXIS_TUSER_WIDTH            : integer :=  1

  );
  port (

        --Register interface
        FIFO_RESET                      : in  std_logic;
        FIFO_ENABLE                     : in  std_logic;
        FIFO_STATUS                     : out std_logic_vector(4 downto 0);

        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 : in  std_logic;
        AXIS_VIDEO_ARESETN              : in  std_logic;

        -- Master side
        M_AXIS_VIDEO_TVALID             : out std_logic := '0';
        M_AXIS_VIDEO_TDATA              : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TSTRB              : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TLAST              : out std_logic := '0';
        M_AXIS_VIDEO_TREADY             : in  std_logic;
        M_AXIS_VIDEO_TUSER              : out  std_logic_vector(C_M_AXIS_TUSER_WIDTH -1 downto 0);
        M_AXIS_VIDEO_TKEEP              : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TID                : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TDEST              : out std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');

        -- Slave side
        S_AXIS_VIDEO_TVALID             : in  std_logic := '0';
        S_AXIS_VIDEO_TDATA              : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TSTRB              : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TLAST              : in  std_logic := '0';
        S_AXIS_VIDEO_TREADY             : out std_logic;
        S_AXIS_VIDEO_TUSER              : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0);
        S_AXIS_VIDEO_TKEEP              : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TID                : in  std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
        S_AXIS_VIDEO_TDEST              : in  std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0')
  );
end component;






-- signal declarations:

signal reset                : std_logic := '0';

signal reg_remap_enable     : std_logic := '0';

signal reg_bram_reset       : std_logic := '0';
signal reg_bram_pixel_0_lane: std_logic := '0';
signal reg_bram_readout_mode: std_logic_vector( 3 downto 0) := (others => '0');
signal reg_bram_status      : std_logic_vector(31 downto 0) := (others => '0');

signal reg_fifo_reset       : std_logic := '0';
signal reg_fifo_enable      : std_logic := '0';
signal reg_fifo_status      : std_logic_vector(4 downto 0) := (others => '0');


signal scrambler_tvalid     : std_logic := '0';
signal scrambler_tdata      : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal scrambler_tstrb      : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal scrambler_tlast      : std_logic := '0';
signal scrambler_tuser      : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');
signal scrambler_tkeep      : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal scrambler_tid        : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
signal scrambler_tdest      : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');

signal reorder_tvalid       : std_logic := '0';
signal reorder_tdata        : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal reorder_tstrb        : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal reorder_tlast        : std_logic := '0';
signal reorder_tuser        : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');
signal reorder_tkeep        : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal reorder_tid          : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
signal reorder_tdest        : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');

signal bram_tvalid          : std_logic := '0';
signal bram_tdata           : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal bram_tstrb           : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal bram_tlast           : std_logic := '0';
signal bram_tuser           : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');
signal bram_tkeep           : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal bram_tid             : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
signal bram_tdest           : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');
        
signal bram_tready          : std_logic := '0';
signal bram_doswap          : std_logic := '0';

signal gearbox_tready       : std_logic := '0';


begin




reset <= not AXIS_VIDEO_ARESETN;

--register interface
ri: register_if
    generic map (
        C_S_AXI_DATA_WIDTH          => C_S_AXI_DATA_WIDTH       ,
        C_S_AXI_ADDR_WIDTH          => C_S_AXI_ADDR_WIDTH
    )
    port map (
        -- Users to add ports here
        CLOCK                       => AXIS_VIDEO_ACLK          ,
        RESET                       => reset                    ,

        REMAP_ENABLE                => reg_remap_enable         ,
        
        BRAM_RESET                  => reg_bram_reset           ,
        BRAM_PIXEL_0_LANE           => reg_bram_pixel_0_lane    ,
        BRAM_READOUT_MODE           => reg_bram_readout_mode    ,
        BRAM_STATUS                 => reg_bram_status          ,
        
        FIFO_RESET                  => reg_fifo_reset           ,
        FIFO_ENABLE                 => reg_fifo_enable          ,
        FIFO_STATUS                 => reg_fifo_status          ,
        

        -- User ports ends
        -- Do not modify the ports beyond this line
        -- Global Clock Signal
        S_AXI_ACLK                  => S_AXI_ACLK               ,
        S_AXI_ARESETN               => S_AXI_ARESETN            ,
        S_AXI_AWADDR                => S_AXI_AWADDR             ,
        S_AXI_AWPROT                => S_AXI_AWPROT             ,
        S_AXI_AWVALID               => S_AXI_AWVALID            ,
        S_AXI_AWREADY               => S_AXI_AWREADY            ,
        S_AXI_WDATA                 => S_AXI_WDATA              ,
        S_AXI_WSTRB                 => S_AXI_WSTRB              ,
        S_AXI_WVALID                => S_AXI_WVALID             ,
        S_AXI_WREADY                => S_AXI_WREADY             ,
        S_AXI_BRESP                 => S_AXI_BRESP              ,
        S_AXI_BVALID                => S_AXI_BVALID             ,
        S_AXI_BREADY                => S_AXI_BREADY             ,
        S_AXI_ARADDR                => S_AXI_ARADDR             ,
        S_AXI_ARPROT                => S_AXI_ARPROT             ,
        S_AXI_ARVALID               => S_AXI_ARVALID            ,
        S_AXI_ARREADY               => S_AXI_ARREADY            ,
        S_AXI_RDATA                 => S_AXI_RDATA              ,
        S_AXI_RRESP                 => S_AXI_RRESP              ,
        S_AXI_RVALID                => S_AXI_RVALID             ,
        S_AXI_RREADY                => S_AXI_RREADY
    );

    
scra: scrambler
  generic map(

        C_PLATFORM                      => C_PLATFORM,
        C_NROF_DATACONN                 => C_NROF_DATACONN,

        C_S_AXIS_TDATA_WIDTH            => C_S_AXIS_TDATA_WIDTH,
        C_S_AXIS_TUSER_WIDTH            => C_S_AXIS_TUSER_WIDTH,
        C_AXIS_TID_WIDTH                => C_AXIS_TID_WIDTH,
        C_AXIS_TDEST_WIDTH              => C_AXIS_TDEST_WIDTH
        
  )
  port map(
        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 => AXIS_VIDEO_ACLK,
        AXIS_VIDEO_ARESETN              => AXIS_VIDEO_ARESETN,

        -- Slave side
        S_AXIS_VIDEO_TVALID             => S_AXIS_VIDEO_TVALID,
        S_AXIS_VIDEO_TDATA              => S_AXIS_VIDEO_TDATA,
        S_AXIS_VIDEO_TSTRB              => S_AXIS_VIDEO_TSTRB,
        S_AXIS_VIDEO_TLAST              => S_AXIS_VIDEO_TLAST,
        S_AXIS_VIDEO_TREADY             => S_AXIS_VIDEO_TREADY,
        S_AXIS_VIDEO_TUSER              => S_AXIS_VIDEO_TUSER,
        S_AXIS_VIDEO_TKEEP              => S_AXIS_VIDEO_TKEEP,
        S_AXIS_VIDEO_TID                => S_AXIS_VIDEO_TID,
        S_AXIS_VIDEO_TDEST              => S_AXIS_VIDEO_TDEST,
        
        -- 
        SCRAMBLED_VIDEO_TVALID          => scrambler_tvalid,
        SCRAMBLED_VIDEO_TDATA           => scrambler_tdata,
        SCRAMBLED_VIDEO_TSTRB           => scrambler_tstrb,
        SCRAMBLED_VIDEO_TLAST           => scrambler_tlast,
        SCRAMBLED_VIDEO_TREADY          => bram_tready,
        SCRAMBLED_VIDEO_TUSER           => scrambler_tuser,
        SCRAMBLED_VIDEO_TKEEP           => scrambler_tkeep,
        SCRAMBLED_VIDEO_TID             => scrambler_tid,
        SCRAMBLED_VIDEO_TDEST           => scrambler_tdest
        
  );


reord: reorder
  generic map(

        C_FAMILY                        => C_FAMILY,
        C_NROF_DATACONN                 => C_NROF_DATACONN,
        C_INPUT_DATAWIDTH               => C_INPUT_DATAWIDTH,

        C_S_AXIS_TDATA_WIDTH            => C_S_AXIS_TDATA_WIDTH,
        C_S_AXIS_TUSER_WIDTH            => C_S_AXIS_TUSER_WIDTH,
        C_AXIS_TID_WIDTH                => C_AXIS_TID_WIDTH,
        C_AXIS_TDEST_WIDTH              => C_AXIS_TDEST_WIDTH
        
  )
  port map(
        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 => AXIS_VIDEO_ACLK,
        AXIS_VIDEO_ARESETN              => AXIS_VIDEO_ARESETN,

        -- Slave side
        AXIS_VIDEO_TVALID               => scrambler_tvalid,
        AXIS_VIDEO_TDATA                => scrambler_tdata,
        AXIS_VIDEO_TSTRB                => scrambler_tstrb,
        AXIS_VIDEO_TLAST                => scrambler_tlast,
        AXIS_VIDEO_TUSER                => scrambler_tuser,
        AXIS_VIDEO_TKEEP                => scrambler_tkeep,
        AXIS_VIDEO_TID                  => scrambler_tid,
        AXIS_VIDEO_TDEST                => scrambler_tdest,
        
        -- 
        REORDERED_VIDEO_TVALID          => reorder_tvalid,
        REORDERED_VIDEO_TDATA           => reorder_tdata,
        REORDERED_VIDEO_TSTRB           => reorder_tstrb,
        REORDERED_VIDEO_TLAST           => reorder_tlast,
        REORDERED_VIDEO_TUSER           => reorder_tuser,
        REORDERED_VIDEO_TKEEP           => reorder_tkeep,
        REORDERED_VIDEO_TID             => reorder_tid,
        REORDERED_VIDEO_TDEST           => reorder_tdest,
        
        REMAP_ENABLE                    => reg_remap_enable,
        DO_SWAP                         => bram_doswap
        
  );


cbram: ctrl_bram
  generic map(

        C_FAMILY                        => C_FAMILY,
        C_NROF_DATACONN                 => C_NROF_DATACONN,
        C_INPUT_DATAWIDTH               => C_INPUT_DATAWIDTH,

        C_S_AXIS_TDATA_WIDTH            => C_S_AXIS_TDATA_WIDTH,
        C_S_AXIS_TUSER_WIDTH            => C_S_AXIS_TUSER_WIDTH,
        C_AXIS_TID_WIDTH                => C_AXIS_TID_WIDTH,
        C_AXIS_TDEST_WIDTH              => C_AXIS_TDEST_WIDTH
        
  )
  port map(
        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 => AXIS_VIDEO_ACLK,
        AXIS_VIDEO_ARESETN              => AXIS_VIDEO_ARESETN,

        -- Incoming axis interface
        REMAP_TVALID                    => reorder_tvalid,
        REMAP_TDATA                     => reorder_tdata,
        REMAP_TSTRB                     => reorder_tstrb,
        REMAP_TLAST                     => reorder_tlast,
        REMAP_TUSER                     => reorder_tuser,
        REMAP_TKEEP                     => reorder_tkeep,
        REMAP_TID                       => reorder_tid,
        REMAP_TDEST                     => reorder_tdest,
        
        -- Outgoing axis interface
        BRAM_TVALID                     => bram_tvalid,
        BRAM_TDATA                      => bram_tdata,
        BRAM_TSTRB                      => bram_tstrb,
        BRAM_TLAST                      => bram_tlast,
        BRAM_TUSER                      => bram_tuser,
        BRAM_TKEEP                      => bram_tkeep,
        BRAM_TID                        => bram_tid,
        BRAM_TDEST                      => bram_tdest,
        
        RESET_BRAM                      => reg_bram_reset,
        PIXEL_0_LANE                    => reg_bram_pixel_0_lane,
        READOUT_MODE                    => reg_bram_readout_mode,
        
        BRAM_READ_EN                    => gearbox_tready,
        REMAP_ENABLE                    => reg_remap_enable,
        BRAM_TREADY                     => bram_tready,
        DO_SWAP                         => bram_doswap,
        STATUS_REMAP_BRAM               => reg_bram_status
        
  );


gearout: gearbox_out
  generic map(

        C_FAMILY                        => C_FAMILY,
        C_NROF_DATACONN                 => C_NROF_DATACONN,
        C_INPUT_DATAWIDTH               => C_INPUT_DATAWIDTH,
        C_OUTPUT_DATAWIDTH              => C_OUTPUT_DATAWIDTH,

        -- Parameters of Axi slave Streaming Interface
        C_S_AXIS_TDATA_WIDTH            => C_S_AXIS_TDATA_WIDTH,
        C_AXIS_TID_WIDTH                => C_AXIS_TID_WIDTH,
        C_AXIS_TDEST_WIDTH              => C_AXIS_TDEST_WIDTH,

        -- Parameters of Axi master Streaming Interface
        C_M_AXIS_TDATA_WIDTH            => C_M_AXIS_TDATA_WIDTH,

        C_S_AXIS_TUSER_WIDTH            => C_S_AXIS_TUSER_WIDTH,
        C_M_AXIS_TUSER_WIDTH            => C_M_AXIS_TUSER_WIDTH

  )
  port map(

        --Register interface
        FIFO_RESET                      => reg_fifo_reset,
        FIFO_ENABLE                     => reg_fifo_enable,
        FIFO_STATUS                     => reg_fifo_status,

        --AXIS stream interfaces
        AXIS_VIDEO_ACLK                 => AXIS_VIDEO_ACLK,
        AXIS_VIDEO_ARESETN              => AXIS_VIDEO_ARESETN,

        -- Master side
        M_AXIS_VIDEO_TVALID             => M_AXIS_VIDEO_TVALID,
        M_AXIS_VIDEO_TDATA              => M_AXIS_VIDEO_TDATA,
        M_AXIS_VIDEO_TSTRB              => M_AXIS_VIDEO_TSTRB,
        M_AXIS_VIDEO_TLAST              => M_AXIS_VIDEO_TLAST,
        M_AXIS_VIDEO_TREADY             => M_AXIS_VIDEO_TREADY,
        M_AXIS_VIDEO_TUSER              => M_AXIS_VIDEO_TUSER,
        M_AXIS_VIDEO_TKEEP              => M_AXIS_VIDEO_TKEEP,
        M_AXIS_VIDEO_TID                => M_AXIS_VIDEO_TID,
        M_AXIS_VIDEO_TDEST              => M_AXIS_VIDEO_TDEST,

        -- Slave side
        S_AXIS_VIDEO_TVALID             => bram_tvalid,
        S_AXIS_VIDEO_TDATA              => bram_tdata,
        S_AXIS_VIDEO_TSTRB              => bram_tstrb,
        S_AXIS_VIDEO_TLAST              => bram_tlast,
        S_AXIS_VIDEO_TREADY             => gearbox_tready,
        S_AXIS_VIDEO_TUSER              => bram_tuser,
        S_AXIS_VIDEO_TKEEP              => bram_tkeep,
        S_AXIS_VIDEO_TID                => bram_tid,
        S_AXIS_VIDEO_TDEST              => bram_tdest
  );


end rtl;