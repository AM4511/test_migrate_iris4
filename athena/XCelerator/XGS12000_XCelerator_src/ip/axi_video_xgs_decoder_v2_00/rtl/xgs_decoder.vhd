
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity decoder is
  generic (

        C_FAMILY                : string  := "kintexu";
        C_NROF_DATACONN         : integer := 12; --number of dataconnections per interface block
        C_INPUT_DATAWIDTH       : integer := 12;

        -- Parameters of Axi Streaming Interface
        C_AXIS_TDATA_WIDTH      : integer := 12*12; --C_NROF_DATACONN*C_INPUT_DATAWIDTH
        C_AXIS_TUSER_WIDTH      : integer := 1;
        C_AXIS_TDEST_WIDTH      : integer := 1;
        C_AXIS_TID_WIDTH        : integer := 1;

        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S00_AXI_DATA_WIDTH    : integer := 32;
        C_S00_AXI_ADDR_WIDTH    : integer := 12;

        C_USEEXT_EN             : integer := 1
  );
  port (
        -- Control signals
        EN_DECODER_IN           : in  std_logic;

        EN_DECODER_OUT_1        : out std_logic := '0';
        EN_DECODER_OUT_2        : out std_logic := '0';
        EN_DECODER_OUT_3        : out std_logic := '0';
        EN_DECODER_OUT_4        : out std_logic := '0';

        --AXI S MM interface
        S00_AXI_ACLK            : in  std_logic;
        S00_AXI_ARESETN         : in  std_logic;
        S00_AXI_AWADDR          : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        S00_AXI_AWPROT          : in  std_logic_vector(2 downto 0);
        S00_AXI_AWVALID         : in  std_logic;
        S00_AXI_AWREADY         : out std_logic := '0';
        S00_AXI_WDATA           : in  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        S00_AXI_WSTRB           : in  std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        S00_AXI_WVALID          : in  std_logic;
        S00_AXI_WREADY          : out std_logic := '0';
        S00_AXI_BRESP           : out std_logic_vector(1 downto 0) := (others => '0');
        S00_AXI_BVALID          : out std_logic := '0';
        S00_AXI_BREADY          : in  std_logic;
        S00_AXI_ARADDR          : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        S00_AXI_ARPROT          : in  std_logic_vector(2 downto 0);
        S00_AXI_ARVALID         : in  std_logic;
        S00_AXI_ARREADY         : out std_logic := '0';
        S00_AXI_RDATA           : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
        S00_AXI_RRESP           : out std_logic_vector(1 downto 0) := (others => '0');
        S00_AXI_RVALID          : out std_logic := '0';
        S00_AXI_RREADY          : in  std_logic;

        --axi stream port
        M_AXIS_VIDEO_ACLK       : in  std_logic;
        M_AXIS_VIDEO_ARESETN    : in  std_logic;

        M_AXIS_VIDEO_TVALID     : out std_logic := '0';
        M_AXIS_VIDEO_TDATA      : out std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TSTRB      : out std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TLAST      : out std_logic := '0';
        M_AXIS_VIDEO_TREADY     : in  std_logic;
        M_AXIS_VIDEO_TUSER      : out  std_logic_vector((C_AXIS_TUSER_WIDTH*C_AXIS_TDATA_WIDTH/8) -1 downto 0);
        M_AXIS_VIDEO_TKEEP      : out std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TDEST      : out std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');
        M_AXIS_VIDEO_TID        : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');

        -- Slave side
        S00_AXIS_TDATA          : in  std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);
        S00_AXIS_TVALID         : in  std_logic;
        S00_AXIS_TREADY         : out std_logic:= '0';
        S00_AXIS_TSTRB          : in  std_logic_vector(C_AXIS_TDATA_WIDTH/8-1 downto 0);
        S00_AXIS_TKEEP          : in  std_logic_vector(C_AXIS_TDATA_WIDTH/8-1 downto 0);
        S00_AXIS_TLAST          : in  std_logic;
        S00_AXIS_TUSER          : in  std_logic_vector((C_AXIS_TUSER_WIDTH*C_AXIS_TDATA_WIDTH/8) -1 downto 0)
  );

--optional debug insertion
attribute mark_debug : string;
attribute mark_debug of M_AXIS_video_TVALID   : signal is "true";
attribute mark_debug of M_AXIS_video_TDATA    : signal is "true";
attribute mark_debug of M_AXIS_video_TSTRB    : signal is "true";
attribute mark_debug of M_AXIS_video_TLAST    : signal is "true";
attribute mark_debug of M_AXIS_video_TREADY   : signal is "true";

end decoder;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of decoder is

component sync_decoder is
  generic (
        NROF_CONTR_CONN : integer:=1;
        MAX_DATAWIDTH   : integer:=1
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        -- config settings
        DATAWIDTH           : in    std_logic_vector(3 downto 0):="0000";
        FILL_ENABLE         : in    std_logic:='1';
        CRC_LANE_ENABLE     : in    std_logic:='1';
        LS_TRIGGERSELECT    : in    std_logic_vector(3 downto 0);

        sof_emb             : in    std_logic_vector(4 downto 0);
        sof_img             : in    std_logic_vector(4 downto 0);
        eof                 : in    std_logic_vector(4 downto 0);

        sol_emb             : in    std_logic_vector(4 downto 0);
        sol_img             : in    std_logic_vector(4 downto 0);
        eol                 : in    std_logic_vector(4 downto 0);

        --write controls for AXIS outputs
        write_img           : in    std_logic;
        write_emb           : in    std_logic;
        write_crc           : in    std_logic;

        -- Internal signaling
        EN_DECODER          : in    std_logic;

        PAR_DATA_RDEN       : out   std_logic := '0';
        PAR_DATAIN_VALID    : in    std_logic;
        PAR_DATAIN          : in    std_logic_vector((NROF_CONTR_CONN*MAX_DATAWIDTH)-1 downto 0);

        PAR_DATAOUT         : out   std_logic_vector((NROF_CONTR_CONN*MAX_DATAWIDTH)-1 downto 0) := (others => '0');
        PAR_DATA_VALID      : out   std_logic := '0';

        PAR_DATA_IMGVALID   : out   std_logic := '0';
        PAR_DATA_EMBVALID   : out   std_logic := '0';

        PAR_DATA_FRAME      : out   std_logic := '0';
        PAR_DATA_LINE       : out   std_logic := '0';

        PAR_DATA_SYNC_START : out   std_logic := '0';
        PAR_DATA_SYNC_END   : out   std_logic := '0';

        PAR_DATA_WINDOW     : out   std_logic := '0';

        PAR_DATA_FILL_VALID     : out   std_logic := '0';
        PAR_DATA_CRCLANE_VALID  : out   std_logic := '0';
        PAR_CALC_CRCLANE_VALID  : out   std_logic := '0';

        --axi streaming output
        AXIS_DATA_VALID     : out   std_logic := '0';
        AXIS_SOF            : out   std_logic := '0';
        AXIS_EOF            : out   std_logic := '0';
        AXIS_SOL            : out   std_logic := '0';
        AXIS_LAST           : out   std_logic := '0';

        -- synchro signals (pulse)
        FRAMESTART          : out   std_logic := '0';
        FRAMEEND            : out   std_logic := '0';
        LINESTART           : out   std_logic := '0';
        LINEEND             : out   std_logic := '0';
        IMAGELINESTART      : out   std_logic := '0';
        IMAGELINEEND        : out   std_logic := '0';

        -- counters
        FRAMESCNT           : out   std_logic_vector(31 downto 0) := (others => '0');
        IMGLINESCNT         : out   std_logic_vector(31 downto 0) := (others => '0');
        EMBLINESCNT         : out   std_logic_vector(31 downto 0) := (others => '0');
        IMGPIXELCNT         : out   std_logic_vector(31 downto 0) := (others => '0');
        WINDOWSCNT          : out   std_logic_vector(31 downto 0) := (others => '0');
        CLOCKSCNT           : out   std_logic_vector(31 downto 0) := (others => '0');
        STARTLINECNT        : out   std_logic_vector(31 downto 0) := (others => '0');
        ENDLINECNT          : out   std_logic_vector(31 downto 0) := (others => '0');

        TIMEOUTCNTRLOAD     : in    std_logic_vector(31 downto 0);
        TIMEOUT             : out   std_logic := '0';

        --LS trigger
        SEQ_FLASH_TRIGGER   : out   std_logic := '0';
        
        --X/Y triggering
        XSAMPLE             : in    std_logic_vector(31 downto 0);
        YSAMPLE             : in    std_logic_vector(31 downto 0);
        FRAMESAMPLE         : in    std_logic_vector(31 downto 0);

        --X/Y triggering
        PIXELTRIGGER        : out   std_logic := '0';
        LINETRIGGER         : out   std_logic := '0';
        FRAMETRIGGER        : out   std_logic := '0'
  );
end component;


component register_if_dec
    generic (
        -- Users to add parameters here
        gNrOf_DataConn   : integer   := 12;
        gMax_Datawidth   : integer   := 12;

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

        EN_DECODER                  : out std_logic;
        reset_fifo                  : out std_logic;

        sof_emb                     : out  std_logic_vector(4 downto 0);
        sof_img                     : out  std_logic_vector(4 downto 0);
        eof                         : out  std_logic_vector(4 downto 0);

        sol_emb                     : out  std_logic_vector(4 downto 0);
        sol_img                     : out  std_logic_vector(4 downto 0);
        eol                         : out  std_logic_vector(4 downto 0);

        --write controls for AXIS outputs
        write_img                   : out  std_logic;
        write_emb                   : out  std_logic;
        write_crc                   : out  std_logic;

        tid                         : out  std_logic_vector(3 downto 0);
        tdest                       : out  std_logic_vector(7 downto 0);

        DATAWIDTH                   : out std_logic_vector(3 downto 0);
        FILL_ENABLE                 : out std_logic;
        CRC_LANE_ENABLE             : out std_logic;
        CHANNELS_ENABLE             : out std_logic_vector(25 downto 0);

        FRAMESCNT                   : in  std_logic_vector(31 downto 0);
        IMGLINESCNT                 : in  std_logic_vector(31 downto 0);
        EMBLINESCNT                 : in  std_logic_vector(31 downto 0);
        IMGPIXELCNT                 : in  std_logic_vector(31 downto 0);
        CLOCKSCNT                   : in  std_logic_vector(31 downto 0);
        STARTLINECNT                : in  std_logic_vector(31 downto 0);
        ENDLINECNT                  : in  std_logic_vector(31 downto 0);
        STATUSBITS                  : in  std_logic_vector(31 downto 0);
        CRCSTATUS                   : in  std_logic_vector(31 downto 0);
        
        XSAMPLE                     : out std_logic_vector(31 downto 0);
        YSAMPLE                     : out std_logic_vector(31 downto 0);
        FRAMESAMPLE                 : out std_logic_vector(31 downto 0);

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

-- crc_check
component crc_checker
  generic (
        gMax_Datawidth     : integer := 12;
        gNrOf_DataConn     : integer := 12;
        POLYNOMIAL         : std_logic_vector := "10001000000100001"
  );
  port (
        -- Control signals
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        en_decoder                  : in    std_logic;
        DATAWIDTH                   : in    std_logic_vector(3 downto 0);

        CHANNELS_ENABLE             : in    std_logic_vector(gNrOf_DataConn-1 downto 0);
        CRC_LANE_ENABLE             : in    std_logic;
        CRC_FRAME_ENABLE            : in    std_logic;
        MSB_FIRST                   : in    std_logic;

        FRAME_START                 : in    std_logic;
        FRAME_END                   : in    std_logic;
        LINE_START                  : in    std_logic;
        LINE_END                    : in    std_logic;

        -- Data input
        PAR_DATA_IN                 : in    std_logic_vector((gNrOf_DataConn*gMax_Datawidth)-1 downto 0);
        PAR_DATA_VALID_IN           : in    std_logic;

        PAR_DATA_IMGVALID_IN        : in    std_logic;
        PAR_DATA_EMBVALID_IN        : in    std_logic;

        PAR_DATA_FRAME_IN           : in    std_logic;
        PAR_DATA_LINE_IN            : in    std_logic;

        PAR_DATA_SYNC_START_IN      : in    std_logic;
        PAR_DATA_SYNC_END_IN        : in    std_logic;

        PAR_DATA_WINDOW_IN          : in    std_logic;

        PAR_DATA_FILL_VALID_IN      : in    std_logic;
        PAR_DATA_CRCLANE_VALID_IN   : in    std_logic;
        PAR_CALC_CRCLANE_VALID_IN   : in    std_logic;

        -- Data out
        PAR_DATA_OUT                : out   std_logic_vector((gNrOf_DataConn*gMax_Datawidth)-1 downto 0);
        PAR_DATA_VALID_OUT          : out   std_logic;

        PAR_DATA_IMGVALID_OUT       : out   std_logic;
        PAR_DATA_EMBVALID_OUT       : out   std_logic;

        PAR_DATA_FRAME_OUT          : out   std_logic;
        PAR_DATA_LINE_OUT           : out   std_logic;

        PAR_DATA_SYNC_START_OUT     : out   std_logic;
        PAR_DATA_SYNC_END_OUT       : out   std_logic;

        PAR_DATA_WINDOW_OUT         : out   std_logic;

        PAR_DATA_FILL_VALID_OUT     : out   std_logic;
        PAR_DATA_CRCLANE_VALID_OUT  : out   std_logic;
        PAR_CALC_CRCLANE_VALID_OUT  : out   std_logic;

        FRAME_START_OUT             : out    std_logic;
        LINE_START_OUT              : out    std_logic;
        LINE_END_OUT                : out    std_logic;

        -- Frame crc checksum output:
        FRAME_CRC_CHECKSUM          : out   std_logic_vector((gNrOf_DataConn*16)-1 downto 0);

        --status
        CRC_STATUS                  : out   std_logic_vector(gNrOf_DataConn-1 downto 0)
        );
end component;

component decoder_fifo
  generic(
        MAX_DATAWIDTH       : integer :=12;
        C_FAMILY            : string  := "ULTRASCALE";
        NROF_CONTR_CONN     : integer :=12;
        DEPTH               : integer :=1024
       );
  port(
        CLOCK                   : in    std_logic;

        FIFO_EN                 : in    std_logic;

        FIFO_EMPTY              : out   std_logic;
        FIFO_AEMPTY             : out   std_logic;
        FIFO_FULL               : out   std_logic;
        FIFO_AFULL              : out   std_logic;
        FIFO_RDEN               : in    std_logic;
        FIFO_DOUT               : out   std_logic_vector(MAX_DATAWIDTH * NROF_CONTR_CONN -1 downto 0);
        FIFO_RESET              : in    std_logic;
        FIFO_WREN               : in    std_logic;
        FIFO_DIN                : in    std_logic_vector(MAX_DATAWIDTH * NROF_CONTR_CONN -1 downto 0);

        SOF_IN                  : in    std_logic;
        SOF_OUT                 : out   std_logic;
        EOF_IN                  : in    std_logic;
        EOF_OUT                 : out   std_logic;
        SOL_IN                  : in    std_logic;
        SOL_OUT                 : out   std_logic;
        EOL_IN                  : in    std_logic;
        EOL_OUT                 : out   std_logic;

        ERROR                   : out   std_logic
       );
end component;

constant zeros                  : std_logic_vector(31 downto 0) := (others => '0');

signal rst      : std_logic := '1';


--register signals
signal DATAWIDTH                        : std_logic_vector(3 downto 0) := (others => '0');
signal FILL_ENABLE                      : std_logic;
signal CRC_LANE_ENABLE                  : std_logic;
signal CHANNELS_ENABLE                  : std_logic_vector(25 downto 0) := (others => '0');

signal CHANNEL_SETTINGS                 : std_logic_vector(31 downto 0) := (others => '0');

signal sof_emb                          : std_logic_vector(4 downto 0) := (others => '0');
signal sof_img                          : std_logic_vector(4 downto 0) := (others => '0');
signal eof                              : std_logic_vector(4 downto 0) := (others => '0');
signal sol_emb                          : std_logic_vector(4 downto 0) := (others => '0');
signal sol_img                          : std_logic_vector(4 downto 0) := (others => '0');
signal eol                              : std_logic_vector(4 downto 0) := (others => '0');

--write controls for AXIS outputs
signal write_img                        : std_logic;
signal write_emb                        : std_logic;
signal write_crc                        : std_logic;

signal tid                              : std_logic_vector(3 downto 0);
signal tdest                            : std_logic_vector(7 downto 0);

signal data_out_dec                     : std_logic_vector((C_NROF_DATACONN*C_INPUT_DATAWIDTH)-1 downto 0) := (others => '0');
signal valid_out_dec                    : std_logic := '0';
signal par_data_imgvalid_dec            : std_logic := '0';
signal par_data_embvalid_dec            : std_logic := '0';
signal par_data_frame_dec               : std_logic := '0';
signal par_data_line_dec                : std_logic := '0';
signal par_data_sync_start_dec          : std_logic := '0';
signal par_data_sync_end_dec            : std_logic := '0';
signal par_data_window_dec              : std_logic := '0';
signal par_data_fill_valid_dec          : std_logic := '0';
signal par_data_crclane_valid_dec       : std_logic := '0';
signal par_calc_crclane_valid_dec       : std_logic := '0';
signal frame_start                      : std_logic := '0';
signal frame_end                        : std_logic := '0';
signal line_start                       : std_logic := '0';
signal line_end                         : std_logic := '0';
signal imageline_start                  : std_logic := '0';
signal imageline_end                    : std_logic := '0';
signal window_start                     : std_logic := '0';
signal window_end                       : std_logic := '0';

signal TIMEOUTCNTRLOAD                  : std_logic_vector(31 downto 0) := (others => '0');
signal TIMEOUT                          : std_logic := '0';

signal FRAMESCNT                        : std_logic_vector(31 downto 0) := (others => '0');
signal IMGLINESCNT                      : std_logic_vector(31 downto 0) := (others => '0');
signal EMBLINESCNT                      : std_logic_vector(31 downto 0) := (others => '0');
signal IMGPIXELCNT                      : std_logic_vector(31 downto 0) := (others => '0');
signal WINDOWSCNT                       : std_logic_vector(31 downto 0) := (others => '0');
signal CLOCKSCNT                        : std_logic_vector(31 downto 0) := (others => '0');
signal STARTLINECNT                     : std_logic_vector(31 downto 0) := (others => '0');
signal ENDLINECNT                       : std_logic_vector(31 downto 0) := (others => '0');
signal STATUSBITS                       : std_logic_vector(31 downto 0) := (others => '0');
signal CRCSTATUS                        : std_logic_vector(31 downto 0) := (others => '0');


signal XSAMPLE                          : std_logic_vector(31 downto 0) := (others => '0');
signal YSAMPLE                          : std_logic_vector(31 downto 0) := (others => '0');
signal FRAMESAMPLE                      : std_logic_vector(31 downto 0) := (others => '0');

signal timeout_dec                      : std_logic := '0';
signal SEQ_FLASH_TRIGGER                : std_logic := '0';
signal PIXELTRIGGER                     : std_logic := '0';
signal LINETRIGGER                      : std_logic := '0';
signal FRAMETRIGGER                     : std_logic := '0';

signal par_data_out_crc                 : std_logic_vector((C_NROF_DATACONN*C_INPUT_DATAWIDTH)-1 downto 0) := (others => '0');
signal par_data_valid_out_crc           : std_logic := '0';
signal par_data_imgvalid_out_crc        : std_logic := '0';
signal par_data_embvalid_out_crc        : std_logic := '0';
signal par_data_frame_out_crc           : std_logic := '0';
signal par_data_line_out_crc            : std_logic := '0';
signal par_data_sync_start_out_crc      : std_logic := '0';
signal par_data_sync_end_out_crc        : std_logic := '0';
signal par_data_window_out_crc          : std_logic := '0';
signal par_data_fill_valid_out_crc      : std_logic := '0';
signal par_data_crclane_valid_out_crc   : std_logic := '0';
signal par_calc_crclane_valid_out_crc   : std_logic := '0';
signal frame_start_out_crc              : std_logic := '0';
signal line_start_out_crc               : std_logic := '0';
signal FRAME_CRC_CHECKSUM               : std_logic_vector((C_NROF_DATACONN*16)-1 downto 0);
signal CRC_STATUS                       : std_logic_vector(C_NROF_DATACONN-1 downto 0) ;
signal FIFO_EMPTY                       : std_logic := '0';
signal FIFO_AEMPTY                      : std_logic := '0';
signal FIFO_FULL                        : std_logic := '0';
signal FIFO_AFULL                       : std_logic := '0';
signal FIFO_RDEN                        : std_logic := '0';

signal line_end_out_crc                 : std_logic := '0';

signal en_decoder                       : std_logic := '0';
signal en_decoder_reg                   : std_logic := '0';
signal fifo_reset                       : std_logic := '0';
signal fifo_error                       : std_logic := '0';

--axi streaming output
--pipeline signals
signal AXIS_DATA_VALID_dec              : std_logic := '0';
signal AXIS_SOF_dec                     : std_logic := '0';
signal AXIS_EOF_dec                     : std_logic := '0';
signal AXIS_SOL_dec                     : std_logic := '0';
signal AXIS_LAST_dec                    : std_logic := '0';

signal AXIS_DATA_VALID_int              : std_logic := '0';
signal AXIS_SOF_int                     : std_logic := '0';
signal AXIS_EOF_int                     : std_logic := '0';
signal AXIS_SOL_int                     : std_logic := '0';
signal AXIS_LAST_int                    : std_logic := '0';

signal AXIS_DATA_VALID_out              : std_logic := '0';
signal AXIS_SOF_out                     : std_logic := '0';
signal AXIS_EOF_out                     : std_logic := '0';
signal AXIS_SOL_out                     : std_logic := '0';
signal AXIS_LAST_out                    : std_logic := '0';


begin


resetpr : process(M_AXIS_VIDEO_ACLK)
begin
    if (M_AXIS_VIDEO_ACLK='1' and M_AXIS_VIDEO_ACLK'event) then
        rst <= not M_AXIS_VIDEO_ARESETN;

    end if;
end process;

M_AXIS_VIDEO_TUSER((C_AXIS_TUSER_WIDTH*C_AXIS_TDATA_WIDTH/8)-1 downto 3)<=(others=>'0');
FIFO_RDEN<= M_AXIS_VIDEO_TREADY and not FIFO_EMPTY;
M_AXIS_VIDEO_TVALID <= not FIFO_EMPTY;
M_AXIS_VIDEO_TSTRB  <= (others => '1');

STATUSBITS(0) <= EN_DECODER;
STATUSBITS(1) <= timeout_dec;
STATUSBITS(2) <= par_data_imgvalid_out_crc;
STATUSBITS(3) <= FIFO_RDEN;
STATUSBITS(4) <= fifo_error;
STATUSBITS(5) <= FIFO_EMPTY;
STATUSBITS(6) <= FIFO_AEMPTY;
STATUSBITS(7) <= FIFO_FULL;
STATUSBITS(8) <= FIFO_AFULL;

STATUSBITS(16)<= PIXELTRIGGER;
STATUSBITS(17)<= LINETRIGGER;
STATUSBITS(18)<= FRAMETRIGGER;


gen_ext_en: if C_USEEXT_EN > 0 generate
    en_decoder <= EN_DECODER_IN;
end generate;

gen_int_en: if C_USEEXT_EN = 0 generate
    en_decoder <= en_decoder_reg;
end generate;

EN_DECODER_OUT_1 <= en_decoder_reg;
EN_DECODER_OUT_2 <= en_decoder_reg;
EN_DECODER_OUT_3 <= en_decoder_reg;
EN_DECODER_OUT_4 <= en_decoder_reg;

ri: register_if_dec
    generic map (
     gNrOf_DataConn          => C_NROF_DATACONN      ,
     gMax_Datawidth          => C_INPUT_DATAWIDTH    ,

     C_S_AXI_DATA_WIDTH      => C_S00_AXI_DATA_WIDTH ,
     C_S_AXI_ADDR_WIDTH      => C_S00_AXI_ADDR_WIDTH
    )
    port map(
        -- Users to add ports here
        CLOCK               => M_AXIS_VIDEO_ACLK                ,
        RESET               => rst                              ,

        EN_DECODER          => en_decoder_reg                   ,
        reset_fifo          => fifo_reset                       ,

        sof_emb             => sof_emb                          ,
        sof_img             => sof_img                          ,
        eof                 => eof                              ,
        sol_emb             => sol_emb                          ,
        sol_img             => sol_img                          ,
        eol                 => eol                              ,

        --write controls for AXIS outputs
        write_img           => write_img                        ,
        write_emb           => write_emb                        ,
        write_crc           => write_crc                        ,

        tid                 => tid                              ,
        tdest               => tdest                            ,


        DATAWIDTH           => DATAWIDTH                        ,
        FILL_ENABLE         => FILL_ENABLE                      ,
        CRC_LANE_ENABLE     => CRC_LANE_ENABLE                  ,
        CHANNELS_ENABLE     => CHANNELS_ENABLE                  ,

        FRAMESCNT           => FRAMESCNT                        ,
        IMGLINESCNT         => IMGLINESCNT                      ,
        EMBLINESCNT         => EMBLINESCNT                      ,
        IMGPIXELCNT         => IMGPIXELCNT                      ,
        CLOCKSCNT           => CLOCKSCNT                        ,
        STARTLINECNT        => STARTLINECNT                     ,
        ENDLINECNT          => ENDLINECNT                       ,
        STATUSBITS          => STATUSBITS                       ,
        CRCSTATUS           => CRCSTATUS                        ,
        
        XSAMPLE             => XSAMPLE,
        YSAMPLE             => YSAMPLE,
        FRAMESAMPLE         => FRAMESAMPLE,

        S_AXI_ACLK          => s00_axi_aclk                     ,
        S_AXI_ARESETN       => s00_axi_aresetn                  ,
        S_AXI_AWADDR        => s00_axi_awaddr                   ,
        S_AXI_AWPROT        => s00_axi_awprot                   ,
        S_AXI_AWVALID       => s00_axi_awvalid                  ,
        S_AXI_AWREADY       => s00_axi_awready                  ,
        S_AXI_WDATA         => s00_axi_wdata                    ,
        S_AXI_WSTRB         => s00_axi_wstrb                    ,
        S_AXI_WVALID        => s00_axi_wvalid                   ,
        S_AXI_WREADY        => s00_axi_wready                   ,
        S_AXI_BRESP         => s00_axi_bresp                    ,
        S_AXI_BVALID        => s00_axi_bvalid                   ,
        S_AXI_BREADY        => s00_axi_bready                   ,
        S_AXI_ARADDR        => s00_axi_araddr                   ,
        S_AXI_ARPROT        => s00_axi_arprot                   ,
        S_AXI_ARVALID       => s00_axi_arvalid                  ,
        S_AXI_ARREADY       => s00_axi_arready                  ,
        S_AXI_RDATA         => s00_axi_rdata                    ,
        S_AXI_RRESP         => s00_axi_rresp                    ,
        S_AXI_RVALID        => s00_axi_rvalid                   ,
        S_AXI_RREADY        => s00_axi_rready
    );

CRCSTATUS(C_NROF_DATACONN-1 downto 0) <= CRC_STATUS;
CRCSTATUS(31 downto C_NROF_DATACONN)  <= zeros(31-C_NROF_DATACONN downto 0);

the_sync_decoder: sync_decoder
  generic map(
        NROF_CONTR_CONN => C_NROF_DATACONN,
        MAX_DATAWIDTH   => 12

  )
  port map(
        -- Control signals
        CLOCK               => M_AXIS_VIDEO_ACLK,
        RESET               => rst,

        -- config settings
        DATAWIDTH           => DATAWIDTH,
        FILL_ENABLE         => FILL_ENABLE,
        CRC_LANE_ENABLE     => CRC_LANE_ENABLE,
        LS_TRIGGERSELECT    => (others=>'0'),

        sof_emb             => sof_emb,
        sof_img             => sof_img,
        eof                 => eof,
        sol_emb             => sol_emb,
        sol_img             => sol_img,
        eol                 => eol,

        --write controls for AXIS outputs
        write_img           => write_img,
        write_emb           => write_emb,
        write_crc           => write_crc,

        -- Internal signaling
        EN_DECODER          => en_decoder,

        PAR_DATA_RDEN       => s00_axis_tready,
        PAR_DATAIN_VALID    => s00_axis_tvalid,
        PAR_DATAIN          => s00_axis_tdata,

        PAR_DATAOUT         => data_out_dec,
        PAR_DATA_VALID      => valid_out_dec,

        PAR_DATA_IMGVALID   => par_data_imgvalid_dec,
        PAR_DATA_EMBVALID   => par_data_embvalid_dec,

        PAR_DATA_FRAME      => par_data_frame_dec,
        PAR_DATA_LINE       => par_data_line_dec,

        PAR_DATA_SYNC_START => par_data_sync_start_dec,
        PAR_DATA_SYNC_END   => par_data_sync_end_dec,

        PAR_DATA_WINDOW     => par_data_window_dec,

        PAR_DATA_FILL_VALID     => par_data_fill_valid_dec,
        PAR_DATA_CRCLANE_VALID  => par_data_crclane_valid_dec,
        PAR_CALC_CRCLANE_VALID  => par_calc_crclane_valid_dec,

        --axi streaming output
        AXIS_DATA_VALID     => AXIS_DATA_VALID_dec,
        AXIS_SOF            => AXIS_SOF_dec,
        AXIS_EOF            => AXIS_EOF_dec,
        AXIS_SOL            => AXIS_SOL_dec,
        AXIS_LAST           => AXIS_LAST_dec,

        -- synchro signals (pulse)
        FRAMESTART          => frame_start,
        FRAMEEND            => frame_end,
        LINESTART           => line_start,
        LINEEND             => line_end,
        IMAGELINESTART      => imageline_start,
        IMAGELINEEND        => imageline_end,

        -- counters
        FRAMESCNT           => FRAMESCNT,
        IMGLINESCNT         => IMGLINESCNT,
        EMBLINESCNT         => EMBLINESCNT,
        IMGPIXELCNT         => IMGPIXELCNT,
        CLOCKSCNT           => CLOCKSCNT,
        STARTLINECNT        => STARTLINECNT,
        ENDLINECNT          => ENDLINECNT,

        TIMEOUTCNTRLOAD     => (others=>'1'),
        TIMEOUT             => timeout_dec,

        --LS trigger
        SEQ_FLASH_TRIGGER   => SEQ_FLASH_TRIGGER,

        --X/Y triggering
        XSAMPLE             => XSAMPLE,
        YSAMPLE             => YSAMPLE,
        FRAMESAMPLE         => FRAMESAMPLE,
        
        PIXELTRIGGER        => PIXELTRIGGER,
        LINETRIGGER         => LINETRIGGER,
        FRAMETRIGGER        => FRAMETRIGGER
  );


    the_crc_checker: crc_checker
      generic map(
            gMax_Datawidth     => C_INPUT_DATAWIDTH,
            gNrOf_DataConn     => C_NROF_DATACONN,
            POLYNOMIAL         => "10001000000100001"
      )
      port map(
            -- Control signals
            CLOCK                       => M_AXIS_VIDEO_ACLK,
            RESET                       => rst,

            en_decoder                  => en_decoder,
            DATAWIDTH                   => DATAWIDTH,

            CHANNELS_ENABLE             => CHANNELS_ENABLE(C_NROF_DATACONN-1 downto 0),
            CRC_LANE_ENABLE             => CRC_LANE_ENABLE,
            CRC_FRAME_ENABLE            => '0',
            MSB_FIRST                   => '1',

            FRAME_START                 => frame_start,
            FRAME_END                   => frame_end,
            LINE_START                  => line_start,
            LINE_END                    => line_end,

            -- Data input
            PAR_DATA_IN                 => data_out_dec,
            PAR_DATA_VALID_IN           => valid_out_dec,

            PAR_DATA_IMGVALID_IN        => par_data_imgvalid_dec,
            PAR_DATA_EMBVALID_IN        => par_data_embvalid_dec,

            PAR_DATA_FRAME_IN           => par_data_frame_dec,
            PAR_DATA_LINE_IN            => par_data_line_dec,

            PAR_DATA_SYNC_START_IN      => par_data_sync_start_dec,
            PAR_DATA_SYNC_END_IN        => par_data_sync_end_dec,

            PAR_DATA_WINDOW_IN          => par_data_window_dec,

            PAR_DATA_FILL_VALID_IN      => par_data_fill_valid_dec,
            PAR_DATA_CRCLANE_VALID_IN   => par_data_crclane_valid_dec,
            PAR_CALC_CRCLANE_VALID_IN   => par_calc_crclane_valid_dec,

            -- Data out
            PAR_DATA_OUT                => par_data_out_crc,
            PAR_DATA_VALID_OUT          => par_data_valid_out_crc,

            PAR_DATA_IMGVALID_OUT       => par_data_imgvalid_out_crc,
            PAR_DATA_EMBVALID_OUT       => par_data_embvalid_out_crc,

            PAR_DATA_FRAME_OUT          => par_data_frame_out_crc,
            PAR_DATA_LINE_OUT           => par_data_line_out_crc,

            PAR_DATA_SYNC_START_OUT     => par_data_sync_start_out_crc,
            PAR_DATA_SYNC_END_OUT       => par_data_sync_end_out_crc,

            PAR_DATA_WINDOW_OUT         => par_data_window_out_crc,

            PAR_DATA_FILL_VALID_OUT     => par_data_fill_valid_out_crc,
            PAR_DATA_CRCLANE_VALID_OUT  => par_data_crclane_valid_out_crc,
            PAR_CALC_CRCLANE_VALID_OUT  => par_calc_crclane_valid_out_crc,

            FRAME_START_OUT             => frame_start_out_crc,
            LINE_START_OUT              => line_start_out_crc,
            LINE_END_OUT                => line_end_out_crc,

            -- Frame crc checksum output:
            FRAME_CRC_CHECKSUM          => FRAME_CRC_CHECKSUM,

            --status
            CRC_STATUS                  => CRC_STATUS
    );


the_fifo: decoder_fifo
  generic map(
        MAX_DATAWIDTH       => C_INPUT_DATAWIDTH,
        C_FAMILY            => C_FAMILY,
        NROF_CONTR_CONN     => C_NROF_DATACONN,
        DEPTH               => 512
       )
  port map(
        CLOCK                   => M_AXIS_VIDEO_ACLK,

        FIFO_EN                 => en_decoder,

        FIFO_EMPTY              => FIFO_EMPTY,
        FIFO_AEMPTY             => FIFO_AEMPTY,
        FIFO_FULL               => FIFO_FULL,
        FIFO_AFULL              => FIFO_AFULL,
        FIFO_RDEN               => FIFO_RDEN,
        FIFO_DOUT               => M_AXIS_VIDEO_TDATA,
        FIFO_RESET              => fifo_reset,
        FIFO_WREN               => AXIS_DATA_VALID_out,
        FIFO_DIN                => par_data_out_crc,

        SOF_IN                  => AXIS_SOF_out,
        EOF_IN                  => AXIS_EOF_out,
        SOL_IN                  => AXIS_SOL_out,
        EOL_IN                  => AXIS_LAST_out,

        SOF_OUT                 => M_AXIS_VIDEO_TUSER(0),
        EOF_OUT                 => M_AXIS_VIDEO_TUSER(1),
        SOL_OUT                 => M_AXIS_VIDEO_TUSER(2),
        EOL_OUT                 => M_AXIS_VIDEO_TLAST,

        ERROR                   => fifo_error
       );

--pipeline axis_ctrl signals
PipelineProcess: process(M_AXIS_VIDEO_ACLK)
begin

    if (M_AXIS_VIDEO_ACLK'event and M_AXIS_VIDEO_ACLK = '1') then

        AXIS_DATA_VALID_int     <= AXIS_DATA_VALID_dec;
        AXIS_SOF_int            <= AXIS_SOF_dec;
        AXIS_EOF_int            <= AXIS_EOF_dec;
        AXIS_SOL_int            <= AXIS_SOL_dec;
        AXIS_LAST_int           <= AXIS_LAST_dec;

        AXIS_DATA_VALID_out     <= AXIS_DATA_VALID_int;
        AXIS_SOF_out            <= AXIS_SOF_int;
        AXIS_EOF_out            <= AXIS_EOF_int;
        AXIS_SOL_out            <= AXIS_SOL_int;
        AXIS_LAST_out           <= AXIS_LAST_int;

    end if;

end process;

M_AXIS_VIDEO_TDEST <= tdest(C_AXIS_TDEST_WIDTH-1 downto 0);
M_AXIS_VIDEO_TID <= tid(C_AXIS_TID_WIDTH-1 downto 0);

end rtl;
