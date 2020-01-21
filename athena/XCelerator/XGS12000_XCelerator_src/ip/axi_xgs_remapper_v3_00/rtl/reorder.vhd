-- Swap channel data based on odd/even information
-- Pix 0 will always end up in BRAM loc 0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity reorder is
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
        AXIS_VIDEO_ACLK                 : in  std_logic;
        AXIS_VIDEO_ARESETN              : in  std_logic;

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

--optional debug insertion
--  attribute mark_debug : string;
--  attribute mark_debug of REORDERED_VIDEO_TVALID   : signal is "true";


end reorder;

architecture rtl of reorder is


begin


gen_24ch: if (C_NROF_DATACONN = 24) generate

    reorder_pr : Process(AXIS_VIDEO_ACLK)
    begin

        if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then

            REORDERED_VIDEO_TVALID          <= AXIS_VIDEO_TVALID;
            REORDERED_VIDEO_TSTRB           <= AXIS_VIDEO_TSTRB;
            REORDERED_VIDEO_TLAST           <= AXIS_VIDEO_TLAST;
            REORDERED_VIDEO_TUSER           <= AXIS_VIDEO_TUSER;
            REORDERED_VIDEO_TKEEP           <= AXIS_VIDEO_TKEEP;
            REORDERED_VIDEO_TID             <= AXIS_VIDEO_TID;
            REORDERED_VIDEO_TDEST           <= AXIS_VIDEO_TDEST;
            
            if (DO_SWAP = '1' and REMAP_ENABLE = '1') then
  
                REORDERED_VIDEO_TDATA(( 0*12)+11 downto ( 0*12)) <= AXIS_VIDEO_TDATA(( 1*12)+11 downto ( 1*12));
                REORDERED_VIDEO_TDATA(( 1*12)+11 downto ( 1*12)) <= AXIS_VIDEO_TDATA(( 0*12)+11 downto ( 0*12));
                REORDERED_VIDEO_TDATA(( 2*12)+11 downto ( 2*12)) <= AXIS_VIDEO_TDATA(( 3*12)+11 downto ( 3*12));
                REORDERED_VIDEO_TDATA(( 3*12)+11 downto ( 3*12)) <= AXIS_VIDEO_TDATA(( 2*12)+11 downto ( 2*12));
                REORDERED_VIDEO_TDATA(( 4*12)+11 downto ( 4*12)) <= AXIS_VIDEO_TDATA(( 5*12)+11 downto ( 5*12));
                REORDERED_VIDEO_TDATA(( 5*12)+11 downto ( 5*12)) <= AXIS_VIDEO_TDATA(( 4*12)+11 downto ( 4*12));
                REORDERED_VIDEO_TDATA(( 6*12)+11 downto ( 6*12)) <= AXIS_VIDEO_TDATA(( 7*12)+11 downto ( 7*12));
                REORDERED_VIDEO_TDATA(( 7*12)+11 downto ( 7*12)) <= AXIS_VIDEO_TDATA(( 6*12)+11 downto ( 6*12));
                REORDERED_VIDEO_TDATA(( 8*12)+11 downto ( 8*12)) <= AXIS_VIDEO_TDATA(( 9*12)+11 downto ( 9*12));
                REORDERED_VIDEO_TDATA(( 9*12)+11 downto ( 9*12)) <= AXIS_VIDEO_TDATA(( 8*12)+11 downto ( 8*12));
                REORDERED_VIDEO_TDATA((10*12)+11 downto (10*12)) <= AXIS_VIDEO_TDATA((11*12)+11 downto (11*12));
                REORDERED_VIDEO_TDATA((11*12)+11 downto (11*12)) <= AXIS_VIDEO_TDATA((10*12)+11 downto (10*12));
                REORDERED_VIDEO_TDATA((12*12)+11 downto (12*12)) <= AXIS_VIDEO_TDATA((13*12)+11 downto (13*12));
                REORDERED_VIDEO_TDATA((13*12)+11 downto (13*12)) <= AXIS_VIDEO_TDATA((12*12)+11 downto (12*12));
                REORDERED_VIDEO_TDATA((14*12)+11 downto (14*12)) <= AXIS_VIDEO_TDATA((15*12)+11 downto (15*12));
                REORDERED_VIDEO_TDATA((15*12)+11 downto (15*12)) <= AXIS_VIDEO_TDATA((14*12)+11 downto (14*12));
                REORDERED_VIDEO_TDATA((16*12)+11 downto (16*12)) <= AXIS_VIDEO_TDATA((17*12)+11 downto (17*12));
                REORDERED_VIDEO_TDATA((17*12)+11 downto (17*12)) <= AXIS_VIDEO_TDATA((16*12)+11 downto (16*12));
                REORDERED_VIDEO_TDATA((18*12)+11 downto (18*12)) <= AXIS_VIDEO_TDATA((19*12)+11 downto (19*12));
                REORDERED_VIDEO_TDATA((19*12)+11 downto (19*12)) <= AXIS_VIDEO_TDATA((18*12)+11 downto (18*12));
                REORDERED_VIDEO_TDATA((20*12)+11 downto (20*12)) <= AXIS_VIDEO_TDATA((21*12)+11 downto (21*12));
                REORDERED_VIDEO_TDATA((21*12)+11 downto (21*12)) <= AXIS_VIDEO_TDATA((20*12)+11 downto (20*12));
                REORDERED_VIDEO_TDATA((22*12)+11 downto (22*12)) <= AXIS_VIDEO_TDATA((23*12)+11 downto (23*12));
                REORDERED_VIDEO_TDATA((23*12)+11 downto (23*12)) <= AXIS_VIDEO_TDATA((22*12)+11 downto (22*12));
            else
                REORDERED_VIDEO_TDATA <= AXIS_VIDEO_TDATA;
            end if;

        end if;

    end process;
end generate;


end rtl;