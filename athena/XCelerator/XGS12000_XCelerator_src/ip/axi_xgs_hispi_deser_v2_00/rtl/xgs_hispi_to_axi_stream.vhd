-- *********************************************************************
-- Copyright 2014, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.


-------------------
-- LIBRARY USAGE --
-------------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

Library UNISIM;
use UNISIM.vcomponents.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity hispi_2_stream is
  generic (
        C_SIM                       : integer := 0;
        C_NROF_DATACONN             : integer := 12;    --number of dataconnections per serdes block
        C_INPUT_DATAWIDTH           : integer := 12;

        -- Parameters of Axi Streaming Interface
        C_M_AXIS_TDATA_WIDTH        : integer := 12*12;
        C_M_AXIS_TUSER_WIDTH        : integer := 1;

        -- Parameters of Axi Slave MM Bus Interface
        C_S00_AXI_DATA_WIDTH        : integer := 32;
        C_S00_AXI_ADDR_WIDTH        : integer := 12;
        
        --iserdes generics
        C_SERDES_FAMILY             : string  := "ULTRASCALE";
        C_REFCLK_F                  : integer := 200;
        C_SERDES_DATAWIDTH          : integer := 8      -- dependent on FPGA family used

  );
  port (
        -- Control signals

        REFCLK                  : in std_logic; -- 200 MHz ref clock
        FIFO_EN                 : in std_logic;
        
        FIFO_EN_OUT             : out std_logic;
        EN_DECODER              : out std_logic;

        -- Data input
        --SENSOR
        --LVDS IO
        DATA_P                  : in std_logic_vector(C_NROF_DATACONN-1 downto 0);
        DATA_N                  : in std_logic_vector(C_NROF_DATACONN-1 downto 0);
    
        D_CLK_P                 : in std_logic;
        D_CLK_N                 : in std_logic;

        --AXI S MM interface

        S00_AXI_ACLK            : in std_logic;
        S00_AXI_ARESETN         : in std_logic;
        S00_AXI_AWADDR          : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        S00_AXI_AWPROT          : in std_logic_vector(2 downto 0);
        S00_AXI_AWVALID         : in std_logic;
        S00_AXI_AWREADY         : out std_logic;
        S00_AXI_WDATA           : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        S00_AXI_WSTRB           : in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        S00_AXI_WVALID          : in std_logic;
        S00_AXI_WREADY          : out std_logic;
        S00_AXI_BRESP           : out std_logic_vector(1 downto 0);
        S00_AXI_BVALID          : out std_logic;
        S00_AXI_BREADY          : in std_logic;
        S00_AXI_ARADDR          : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        S00_AXI_ARPROT          : in std_logic_vector(2 downto 0);
        S00_AXI_ARVALID         : in std_logic;
        S00_AXI_ARREADY         : out std_logic;
        S00_AXI_RDATA           : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        S00_AXI_RRESP           : out std_logic_vector(1 downto 0);
        S00_AXI_RVALID          : out std_logic;
        S00_AXI_RREADY          : in std_logic;


        --axi stream port
        -- Data output
        -- Global ports
        M_AXIS_ACLK             : in std_logic;
        M_AXIS_ARESETN          : in std_logic;
        M_AXIS_TVALID           : out std_logic := '0';                                                         -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
        M_AXIS_TDATA            : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');     -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
        M_AXIS_TSTRB            : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0'); -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
        M_AXIS_TLAST            : out std_logic := '0';                                                         -- TLAST indicates the boundary of a packet.
        M_AXIS_TREADY           : in std_logic;                                                                 -- TREADY indicates that the slave can accept a transfer in the current cycle.
        M_AXIS_TUSER            : out std_logic_vector(((C_M_AXIS_TUSER_WIDTH*C_M_AXIS_TDATA_WIDTH / 8) - 1) downto 0)
  );

--optional debug insertion
attribute mark_debug : string;
attribute mark_debug of M_AXIS_TVALID   : signal is "true";
attribute mark_debug of M_AXIS_TDATA    : signal is "true";
attribute mark_debug of M_AXIS_TSTRB    : signal is "true";
attribute mark_debug of M_AXIS_TLAST    : signal is "true";
attribute mark_debug of M_AXIS_TREADY   : signal is "true";




end hispi_2_stream;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of hispi_2_stream is


component iserdes_interface
  generic (
        SIMULATION                  : integer := 0;
        NROF_CONN                   : integer := 12;
        MAX_DATAWIDTH               : integer := 12;
        SERDES_DATAWIDTH            : integer := 8;
        RETRY_MAX                   : integer := 32767; --16 bits, global
        STABLE_COUNT                : integer := 16;
        TAP_COUNT_MAX               : integer := 32;
        TAP_COUNT_BITS              : integer := 8;
        DATA_RATE                   : string  := "DDR"; -- DDR/SDR
        DIFF_TERM                   : boolean := TRUE;
        USE_BLOCKRAMFIFO            : boolean := TRUE;
        INVERT_OUTPUT               : boolean := FALSE;
        INVERSE_BITORDER            : boolean := FALSE;
        CHANNEL_COUNT               : integer := 2;
        SERDES_COUNT                : integer := 2;
        SAMPLE_COUNT                : integer := 128;
        IDELAY_COUNT                : integer := 1;

        LOW_PWR                     : boolean := FALSE;
        REFCLK_F                    : real    := 200.0;
        C_CALWIDTH                  : integer := 5;

        CLKSPEED                    : integer := 40;

        C_FAMILY                    : string  := "VIRTEX6";


        NROF_DELAYCTRLS             : integer := 1;
        IDELAYCLK_MULT              : integer := 3;
        IDELAYCLK_DIV               : integer := 1;
        GENIDELAYCLK                : boolean := FALSE;

        USE_DIFF_HS_CLK_IN          : boolean := FALSE;
        USE_DIFF_LS_CLK_IN          : boolean := FALSE;
        USE_HS_REGIONAL_CLK         : boolean := FALSE;
        USE_LS_CLK                  : boolean := FALSE;
        CLOCK_COUNT                 : integer := 1;
        USE_ONE_CLOCK               : boolean := TRUE;
        USE_HSCLK_BUFIO             : boolean := TRUE
  );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        CLK_STATUS                  : out   std_logic_vector((16*CLOCK_COUNT)-1 downto 0);

        CLKREF                      : in    std_logic; -- optional 200MHz/300MHz refclk

        -- from sensor (only used when USED_EXT_CLK = YES)
        LS_IN_CLK                   : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        LS_IN_CLKb                  : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        HS_IN_CLK                   : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        HS_IN_CLKb                  : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        HS_CLK_MON                  : out   std_logic_vector(CLOCK_COUNT-1 downto 0);

        --serdes data, directly connected to bondpads
        SDATAP                      : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        SDATAN                      : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);

        SDATA_MON                   : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);

        --calibration input
        IODELAY_CAL_CLK             : in    std_logic_vector((2*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0); --values for both hs (0) (fixme) & ls clks (1)
        IODELAY_CAL                 : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0);

        -- status info datachannel
        EDGE_DETECT                 : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT               : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND            : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND           : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES                : out   std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING                 : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH                : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT                   : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN                  : out   std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                  : out   std_logic_vector((NROF_CONN*8)-1 downto 0);
        SHIFT_STATUS                : out   std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        --status info ls clk channel (if any)
        EDGE_DETECT_CLK             : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT_CLK           : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND_CLK        : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND_CLK       : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES_CLK            : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING_CLK             : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_CLK            : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_CLK               : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_CLK              : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT_CLK              : out   std_logic_vector((CLOCK_COUNT*8)-1 downto 0);

        -- control
        START_TRAINING              : in    std_logic;
        BUSY_TRAINING               : out   std_logic;

        FIFO_EN                     : in    std_logic;

        DATAWIDTH                   : in    integer;
        SINGLECHANNEL               : in    std_logic_vector(7 downto 0);
        ALIGNMODE                   : in    std_logic_vector(15 downto 0);
  

        AUTOALIGNCHANNEL            : in    std_logic_vector(1 downto 0);
        MANUAL_TAP                  : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TRAINING                    : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);

        --data
        FIFO_EMPTY                  : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_AEMPTY                 : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_RDEN                   : in    std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_DOUT                   : out   std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0);
        FIFO_RESET                  : in    std_logic;
        ERROR                       : out   std_logic_vector(NROF_CONN-1 downto 0);
        ERROR_CLK                   : out   std_logic
       );
end component;


component register_if
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

        START_TRAINING              : out std_logic;
        BUSY_TRAINING               : in  std_logic;

        FIFO_EN                     : out std_logic;
        FIFO_RESET                  : out std_logic;
        EN_DECODER                  : out std_logic;
        FILTER_MODE                 : out std_logic;


        MANUAL_TAP                  : out std_logic_vector(15 downto 0);
        TRAINING                    : out std_logic_vector(gMax_Datawidth-1 downto 0);
        ENABLE_TRAINING             : out std_logic_vector(gNrOf_DataConn-1 downto 0);


        -- Training pattern on data channels
        TR_DATA                     : out  std_logic_vector(gMax_Datawidth-1 downto 0);

 
        --status pins
        SERDES_CLK_STATUS           : in std_logic_vector(31 downto 0);
        SERDES_WORD_ALIGN           : in std_logic_vector(gNrOf_DataConn-1 downto 0);
        SERDES_SLIP_COUNT           : in std_logic_vector((gNrOf_DataConn*8)-1 downto 0);
        SERDES_SHIFT_STATUS         : in std_logic_vector((6*gNrOf_DataConn)-1 downto 0);
        SERDES_ERROR                : in std_logic_vector(gNrOf_DataConn-1 downto 0);



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


constant zeros                  : std_logic_vector(C_NROF_DATACONN-1 downto 0) := (others => '0');

signal rst                      : std_logic := '1';

signal fifo_empty_all           : std_logic_vector(C_NROF_DATACONN-1 downto 0);
signal fifo_read_rdy_all        : std_logic;
signal fifo_read_rdy_all_r      : std_logic;
signal serdes_DATAOUT           : std_logic_vector((C_NROF_DATACONN*C_INPUT_DATAWIDTH)-1 downto 0);
signal serdes_DATAOUT_r         : std_logic_vector((C_NROF_DATACONN*C_INPUT_DATAWIDTH)-1 downto 0);

signal START_TRAINING           : std_logic;
signal BUSY_TRAINING            : std_logic;
signal FIFO_RESET               : std_logic;
signal FILTER_MODE              : std_logic;

signal MANUAL_TAP               : std_logic_vector(15 downto 0);
signal TRAINING                 : std_logic_vector(C_INPUT_DATAWIDTH-1 downto 0);
signal ENABLE_TRAINING          : std_logic_vector(C_NROF_DATACONN-1 downto 0);
signal TR_DATA                  : std_logic_vector(C_INPUT_DATAWIDTH-1 downto 0);
signal SERDES_CLK_STATUS        : std_logic_vector(31 downto 0);
signal SERDES_WORD_ALIGN        : std_logic_vector(C_NROF_DATACONN-1 downto 0);
signal SERDES_SLIP_COUNT        : std_logic_vector(((C_NROF_DATACONN)*8)-1 downto 0);
signal SERDES_SHIFT_STATUS      : std_logic_vector((6*(C_NROF_DATACONN))-1 downto 0);
signal SERDES_ERROR             : std_logic_vector(C_NROF_DATACONN-1 downto 0);

signal FIFO_RDEN_s              : std_logic_vector(C_NROF_DATACONN-1 downto 0);
signal alignmode_s              : std_logic_vector(15 downto 0);

begin


fifo_read_rdy_all  <= '1' when (fifo_empty_all = zeros((C_NROF_DATACONN-1) downto 0)) else '0';

resetpr : process(M_AXIS_ACLK)
begin
    if (M_AXIS_ACLK='1' and M_AXIS_ACLK'event) then
        rst                     <= not M_AXIS_ARESETN;
        serdes_DATAOUT_r        <= serdes_DATAOUT;
        fifo_read_rdy_all_r     <= fifo_read_rdy_all;
        
    end if;
end process;

gen_rden: for i in 0 to C_NROF_DATACONN-1 generate
    FIFO_RDEN_s(i) <= M_AXIS_TREADY and fifo_read_rdy_all;
end generate;

M_AXIS_TUSER   <= (others=>'0');
M_AXIS_TVALID  <= fifo_read_rdy_all_r;
M_AXIS_TDATA   <= serdes_DATAOUT_r;
M_AXIS_TSTRB   <= (others => '1');  -- not used
M_AXIS_TLAST   <= '0';              -- not used since frame concept is not known here
SERDES_CLK_STATUS(31 downto 16)<= (others=>'0');


alignmode_s <= "000000000" & FILTER_MODE & "000010";


--control signal fifo connections

ri: register_if
    generic map (

        gNrOf_DataConn          => C_NROF_DATACONN      ,
        gMax_Datawidth          => C_INPUT_DATAWIDTH    ,

        C_S_AXI_DATA_WIDTH      => C_S00_AXI_DATA_WIDTH ,
        C_S_AXI_ADDR_WIDTH      => C_S00_AXI_ADDR_WIDTH
    )
    port map(
        -- Users to add ports here
        CLOCK                => M_AXIS_ACLK        ,
        RESET                => rst                ,
        START_TRAINING       => START_TRAINING     ,
        BUSY_TRAINING        => BUSY_TRAINING      ,
        FIFO_EN              => FIFO_EN_OUT        ,
        FIFO_RESET           => FIFO_RESET         ,
        EN_DECODER           => EN_DECODER         ,
        FILTER_MODE          => FILTER_MODE        ,
        
        MANUAL_TAP           => MANUAL_TAP         ,
        TRAINING             => TRAINING           ,
        ENABLE_TRAINING      => ENABLE_TRAINING    ,
        TR_DATA              => TR_DATA            ,
        SERDES_CLK_STATUS    => SERDES_CLK_STATUS  ,
        SERDES_WORD_ALIGN    => SERDES_WORD_ALIGN  ,
        SERDES_SLIP_COUNT    => SERDES_SLIP_COUNT  ,
        SERDES_SHIFT_STATUS  => SERDES_SHIFT_STATUS,
        SERDES_ERROR         => SERDES_ERROR       ,

        S_AXI_ACLK      => s00_axi_aclk,
        S_AXI_ARESETN   => s00_axi_aresetn,
        S_AXI_AWADDR    => s00_axi_awaddr,
        S_AXI_AWPROT    => s00_axi_awprot,
        S_AXI_AWVALID   => s00_axi_awvalid,
        S_AXI_AWREADY   => s00_axi_awready,
        S_AXI_WDATA     => s00_axi_wdata,
        S_AXI_WSTRB     => s00_axi_wstrb,
        S_AXI_WVALID    => s00_axi_wvalid,
        S_AXI_WREADY    => s00_axi_wready,
        S_AXI_BRESP     => s00_axi_bresp,
        S_AXI_BVALID    => s00_axi_bvalid,
        S_AXI_BREADY    => s00_axi_bready,
        S_AXI_ARADDR    => s00_axi_araddr,
        S_AXI_ARPROT    => s00_axi_arprot,
        S_AXI_ARVALID   => s00_axi_arvalid,
        S_AXI_ARREADY   => s00_axi_arready,
        S_AXI_RDATA     => s00_axi_rdata,
        S_AXI_RRESP     => s00_axi_rresp,
        S_AXI_RVALID    => s00_axi_rvalid,
        S_AXI_RREADY    => s00_axi_rready
    );

ii: iserdes_interface
  generic map (
        SIMULATION              => C_SIM                ,
        NROF_CONN               => C_NROF_DATACONN      ,
        MAX_DATAWIDTH           => C_INPUT_DATAWIDTH    ,
        SERDES_DATAWIDTH        => C_SERDES_DATAWIDTH   ,
        RETRY_MAX               => 32767                ,
        STABLE_COUNT            => 16                   ,
        TAP_COUNT_MAX           => 512                  ,
        TAP_COUNT_BITS          => 16                   ,
        DATA_RATE               => "DDR"                ,
        DIFF_TERM               => TRUE                 ,
        USE_BLOCKRAMFIFO        => TRUE                 ,
        INVERT_OUTPUT           => FALSE                ,
        INVERSE_BITORDER        => FALSE                ,
        CHANNEL_COUNT           => 1                    ,
        SERDES_COUNT            => 2       ,
        SAMPLE_COUNT            => 128                  ,
        IDELAY_COUNT            => 1                    ,
        LOW_PWR                 => FALSE                ,
        REFCLK_F                => Real(C_REFCLK_F)     ,
        C_CALWIDTH              => 5                    ,
        CLKSPEED                => 125                  ,
        C_FAMILY                => C_SERDES_FAMILY      ,            
        NROF_DELAYCTRLS         => 1                    ,
        IDELAYCLK_MULT          => 3                    ,
        IDELAYCLK_DIV           => 1                    ,
        GENIDELAYCLK            => FALSE                ,
        USE_DIFF_HS_CLK_IN      => TRUE                 ,
        USE_DIFF_LS_CLK_IN      => FALSE                ,
        USE_HS_REGIONAL_CLK     => TRUE                 ,
        USE_LS_CLK              => FALSE                ,
        CLOCK_COUNT             => 1                    ,
        USE_ONE_CLOCK           => TRUE                 ,
        USE_HSCLK_BUFIO         => TRUE
  )
  port map(
        CLOCK                       => M_AXIS_ACLK                      ,
        RESET                       => rst                              ,

        CLK_STATUS                  => SERDES_CLK_STATUS(15 downto 0)   ,

        CLKREF                      => REFCLK                           ,

        -- from sensor (only used when USED_EXT_CLK = YES)
        LS_IN_CLK                   => "0"                              ,
        LS_IN_CLKb                  => "0"                              ,

        HS_IN_CLK(0)                => D_CLK_P                          ,
        HS_IN_CLKb(0)               => D_CLK_N                          ,

        HS_CLK_MON                  => open                             ,

        --serdes data, directly connected to bondpads
        SDATAP                      => DATA_P                           ,
        SDATAN                      => DATA_N                           ,

        SDATA_MON                   => open                             ,

        --calibration input
        IODELAY_CAL_CLK             => (others => '0')                  ,
        IODELAY_CAL                 => (others => '0')                  ,

        -- status info datachannel
        EDGE_DETECT                 => open                             ,
        STABLE_DETECT               => open                             ,
        FIRST_EDGE_FOUND            => open                             ,
        SECOND_EDGE_FOUND           => open                             ,
        NROF_RETRIES                => open                             ,
        TAP_SETTING                 => open                             ,
        WINDOW_WIDTH                => open                             ,
        TAP_DRIFT                   => open                             ,
        WORD_ALIGN                  => SERDES_WORD_ALIGN                ,
        SLIP_COUNT                  => SERDES_SLIP_COUNT                ,
        SHIFT_STATUS                => SERDES_SHIFT_STATUS              ,

        --status info ls clk channel (if any)
        EDGE_DETECT_CLK             => open                             ,
        STABLE_DETECT_CLK           => open                             ,
        FIRST_EDGE_FOUND_CLK        => open                             ,
        SECOND_EDGE_FOUND_CLK       => open                             ,
        NROF_RETRIES_CLK            => open                             ,
        TAP_SETTING_CLK             => open                             ,
        WINDOW_WIDTH_CLK            => open                             ,
        TAP_DRIFT_CLK               => open                             ,
        WORD_ALIGN_CLK              => open                             ,
        SLIP_COUNT_CLK              => open                             ,

        -- control
        START_TRAINING              => START_TRAINING                   ,
        BUSY_TRAINING               => BUSY_TRAINING                    ,

        FIFO_EN                     => FIFO_EN                          ,

        DATAWIDTH                   => 12                               ,
        SINGLECHANNEL               => (others => '0')                  ,
        ALIGNMODE                   => alignmode_s                      ,
        AUTOALIGNCHANNEL            => "00"                             ,
        MANUAL_TAP                  => MANUAL_TAP                       ,
        TRAINING                    => TRAINING                         ,
        ENABLE_TRAINING             => ENABLE_TRAINING                  ,

        --data
        FIFO_EMPTY                  => fifo_empty_all                   ,
        FIFO_AEMPTY                 => open                             ,
        FIFO_RDEN                   => FIFO_RDEN_s                      ,
        FIFO_DOUT                   => serdes_DATAOUT                   ,
        FIFO_RESET                  => FIFO_RESET                       ,
        ERROR                       => SERDES_ERROR                     ,
        ERROR_CLK                   => open
       );

end rtl;

