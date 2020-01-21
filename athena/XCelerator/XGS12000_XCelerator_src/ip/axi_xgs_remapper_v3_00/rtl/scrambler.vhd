-- Bring the data in a uniform order to the next blocks, independant of the HW platform.
-- The lowest HiSpi lane number is located at the lower bits of the data word.
-- The highest HiSpi lane number is located at the upper bits of the data word.
-- For 12 bit pixel size:
-- CH_0 = Data(11 downto  0)
-- CH_1 = Data(23 downto 12)
-- CH_2 = Data(35 downto 24)
-- ...



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity scrambler is
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

--optional debug insertion
--  attribute mark_debug : string;
--  attribute mark_debug of SCRAMBLED_VIDEO_TVALID   : signal is "true";


end scrambler;

architecture rtl of scrambler is


begin

S_AXIS_VIDEO_TREADY <= SCRAMBLED_VIDEO_TREADY;


gen_bypass: if (C_PLATFORM = 0) generate

    no_scrambling : Process(AXIS_VIDEO_ACLK)
    begin

        if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
            
            SCRAMBLED_VIDEO_TVALID          <= S_AXIS_VIDEO_TVALID;
            SCRAMBLED_VIDEO_TSTRB           <= S_AXIS_VIDEO_TSTRB;
            SCRAMBLED_VIDEO_TLAST           <= S_AXIS_VIDEO_TLAST;
            SCRAMBLED_VIDEO_TUSER           <= S_AXIS_VIDEO_TUSER;
            SCRAMBLED_VIDEO_TKEEP           <= S_AXIS_VIDEO_TKEEP;
            SCRAMBLED_VIDEO_TID             <= S_AXIS_VIDEO_TID;
            SCRAMBLED_VIDEO_TDEST           <= S_AXIS_VIDEO_TDEST;
            
            SCRAMBLED_VIDEO_TDATA           <= S_AXIS_VIDEO_TDATA;

        end if;

    end process;
end generate;


gen_intelC10: if (C_PLATFORM = 1 and C_NROF_DATACONN = 24) generate
-- Intel C10 kit with 24 hispi lanes

    intelC10_scrambling : Process(AXIS_VIDEO_ACLK)
    begin

        if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then

            SCRAMBLED_VIDEO_TVALID          <= S_AXIS_VIDEO_TVALID;
            SCRAMBLED_VIDEO_TSTRB           <= S_AXIS_VIDEO_TSTRB;
            SCRAMBLED_VIDEO_TLAST           <= S_AXIS_VIDEO_TLAST;
            SCRAMBLED_VIDEO_TUSER           <= S_AXIS_VIDEO_TUSER;
            SCRAMBLED_VIDEO_TKEEP           <= S_AXIS_VIDEO_TKEEP;
            SCRAMBLED_VIDEO_TID             <= S_AXIS_VIDEO_TID;
            SCRAMBLED_VIDEO_TDEST           <= S_AXIS_VIDEO_TDEST;
            
            
            SCRAMBLED_VIDEO_TDATA(( 0*12)+11 downto ( 0*12)) <= S_AXIS_VIDEO_TDATA(( 0*12)+11 downto ( 0*12));
            SCRAMBLED_VIDEO_TDATA(( 1*12)+11 downto ( 1*12)) <= S_AXIS_VIDEO_TDATA(( 1*12)+11 downto ( 1*12));
            SCRAMBLED_VIDEO_TDATA(( 2*12)+11 downto ( 2*12)) <= S_AXIS_VIDEO_TDATA(( 2*12)+11 downto ( 2*12));
            SCRAMBLED_VIDEO_TDATA(( 3*12)+11 downto ( 3*12)) <= S_AXIS_VIDEO_TDATA(( 3*12)+11 downto ( 3*12));
            SCRAMBLED_VIDEO_TDATA(( 4*12)+11 downto ( 4*12)) <= S_AXIS_VIDEO_TDATA(( 4*12)+11 downto ( 4*12));
            SCRAMBLED_VIDEO_TDATA(( 5*12)+11 downto ( 5*12)) <= S_AXIS_VIDEO_TDATA((14*12)+11 downto (14*12));
            SCRAMBLED_VIDEO_TDATA(( 6*12)+11 downto ( 6*12)) <= S_AXIS_VIDEO_TDATA(( 5*12)+11 downto ( 5*12));
            SCRAMBLED_VIDEO_TDATA(( 7*12)+11 downto ( 7*12)) <= S_AXIS_VIDEO_TDATA((15*12)+11 downto (15*12));
            SCRAMBLED_VIDEO_TDATA(( 8*12)+11 downto ( 8*12)) <= S_AXIS_VIDEO_TDATA(( 6*12)+11 downto ( 6*12));
            SCRAMBLED_VIDEO_TDATA(( 9*12)+11 downto ( 9*12)) <= S_AXIS_VIDEO_TDATA(( 7*12)+11 downto ( 7*12));
            SCRAMBLED_VIDEO_TDATA((10*12)+11 downto (10*12)) <= S_AXIS_VIDEO_TDATA(( 8*12)+11 downto ( 8*12));
            SCRAMBLED_VIDEO_TDATA((11*12)+11 downto (11*12)) <= S_AXIS_VIDEO_TDATA((16*12)+11 downto (16*12));
            SCRAMBLED_VIDEO_TDATA((12*12)+11 downto (12*12)) <= S_AXIS_VIDEO_TDATA(( 9*12)+11 downto ( 9*12));
            SCRAMBLED_VIDEO_TDATA((13*12)+11 downto (13*12)) <= S_AXIS_VIDEO_TDATA((17*12)+11 downto (17*12));
            SCRAMBLED_VIDEO_TDATA((14*12)+11 downto (14*12)) <= S_AXIS_VIDEO_TDATA((10*12)+11 downto (10*12));
            SCRAMBLED_VIDEO_TDATA((15*12)+11 downto (15*12)) <= S_AXIS_VIDEO_TDATA((18*12)+11 downto (18*12));
            SCRAMBLED_VIDEO_TDATA((16*12)+11 downto (16*12)) <= S_AXIS_VIDEO_TDATA((11*12)+11 downto (11*12));
            SCRAMBLED_VIDEO_TDATA((17*12)+11 downto (17*12)) <= S_AXIS_VIDEO_TDATA((19*12)+11 downto (19*12));
            SCRAMBLED_VIDEO_TDATA((18*12)+11 downto (18*12)) <= S_AXIS_VIDEO_TDATA((12*12)+11 downto (12*12));
            SCRAMBLED_VIDEO_TDATA((19*12)+11 downto (19*12)) <= S_AXIS_VIDEO_TDATA((20*12)+11 downto (20*12));
            SCRAMBLED_VIDEO_TDATA((20*12)+11 downto (20*12)) <= S_AXIS_VIDEO_TDATA((21*12)+11 downto (21*12));
            SCRAMBLED_VIDEO_TDATA((21*12)+11 downto (21*12)) <= S_AXIS_VIDEO_TDATA((22*12)+11 downto (22*12));
            SCRAMBLED_VIDEO_TDATA((22*12)+11 downto (22*12)) <= S_AXIS_VIDEO_TDATA((13*12)+11 downto (13*12));
            SCRAMBLED_VIDEO_TDATA((23*12)+11 downto (23*12)) <= S_AXIS_VIDEO_TDATA((23*12)+11 downto (23*12));
    
        end if;

    end process;
end generate;


gen_Xil_kcu105: if (C_PLATFORM = 2 and C_NROF_DATACONN = 24) generate
-- Xilinx KCU105 kit with 24 hispi lanes

    xilKCU105_scrambling : Process(AXIS_VIDEO_ACLK)
    begin

        if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
        
            SCRAMBLED_VIDEO_TVALID          <= S_AXIS_VIDEO_TVALID;
            SCRAMBLED_VIDEO_TSTRB           <= S_AXIS_VIDEO_TSTRB;
            SCRAMBLED_VIDEO_TLAST           <= S_AXIS_VIDEO_TLAST;
            SCRAMBLED_VIDEO_TUSER           <= S_AXIS_VIDEO_TUSER;
            SCRAMBLED_VIDEO_TKEEP           <= S_AXIS_VIDEO_TKEEP;
            SCRAMBLED_VIDEO_TID             <= S_AXIS_VIDEO_TID;
            SCRAMBLED_VIDEO_TDEST           <= S_AXIS_VIDEO_TDEST;
            
            
            SCRAMBLED_VIDEO_TDATA(( 0*12)+11 downto ( 0*12)) <= S_AXIS_VIDEO_TDATA(( 0*12)+11 downto ( 0*12));
            SCRAMBLED_VIDEO_TDATA(( 1*12)+11 downto ( 1*12)) <= S_AXIS_VIDEO_TDATA((12*12)+11 downto (12*12));
            SCRAMBLED_VIDEO_TDATA(( 2*12)+11 downto ( 2*12)) <= S_AXIS_VIDEO_TDATA(( 1*12)+11 downto ( 1*12));
            SCRAMBLED_VIDEO_TDATA(( 3*12)+11 downto ( 3*12)) <= S_AXIS_VIDEO_TDATA((13*12)+11 downto (13*12));
            SCRAMBLED_VIDEO_TDATA(( 4*12)+11 downto ( 4*12)) <= S_AXIS_VIDEO_TDATA(( 2*12)+11 downto ( 2*12));
            SCRAMBLED_VIDEO_TDATA(( 5*12)+11 downto ( 5*12)) <= S_AXIS_VIDEO_TDATA((14*12)+11 downto (14*12));
            SCRAMBLED_VIDEO_TDATA(( 6*12)+11 downto ( 6*12)) <= S_AXIS_VIDEO_TDATA(( 3*12)+11 downto ( 3*12));
            SCRAMBLED_VIDEO_TDATA(( 7*12)+11 downto ( 7*12)) <= S_AXIS_VIDEO_TDATA((15*12)+11 downto (15*12));
            SCRAMBLED_VIDEO_TDATA(( 8*12)+11 downto ( 8*12)) <= S_AXIS_VIDEO_TDATA(( 4*12)+11 downto ( 4*12));
            SCRAMBLED_VIDEO_TDATA(( 9*12)+11 downto ( 9*12)) <= S_AXIS_VIDEO_TDATA((16*12)+11 downto (16*12));
            SCRAMBLED_VIDEO_TDATA((10*12)+11 downto (10*12)) <= S_AXIS_VIDEO_TDATA(( 5*12)+11 downto ( 5*12));
            SCRAMBLED_VIDEO_TDATA((11*12)+11 downto (11*12)) <= S_AXIS_VIDEO_TDATA((17*12)+11 downto (17*12));
            SCRAMBLED_VIDEO_TDATA((12*12)+11 downto (12*12)) <= S_AXIS_VIDEO_TDATA(( 6*12)+11 downto ( 6*12));
            SCRAMBLED_VIDEO_TDATA((13*12)+11 downto (13*12)) <= S_AXIS_VIDEO_TDATA((18*12)+11 downto (18*12));
            SCRAMBLED_VIDEO_TDATA((14*12)+11 downto (14*12)) <= S_AXIS_VIDEO_TDATA(( 7*12)+11 downto ( 7*12));
            SCRAMBLED_VIDEO_TDATA((15*12)+11 downto (15*12)) <= S_AXIS_VIDEO_TDATA((19*12)+11 downto (19*12));
            SCRAMBLED_VIDEO_TDATA((16*12)+11 downto (16*12)) <= S_AXIS_VIDEO_TDATA(( 8*12)+11 downto ( 8*12));
            SCRAMBLED_VIDEO_TDATA((17*12)+11 downto (17*12)) <= S_AXIS_VIDEO_TDATA((20*12)+11 downto (20*12));
            SCRAMBLED_VIDEO_TDATA((18*12)+11 downto (18*12)) <= S_AXIS_VIDEO_TDATA(( 9*12)+11 downto ( 9*12));
            SCRAMBLED_VIDEO_TDATA((19*12)+11 downto (19*12)) <= S_AXIS_VIDEO_TDATA((21*12)+11 downto (21*12));
            SCRAMBLED_VIDEO_TDATA((20*12)+11 downto (20*12)) <= S_AXIS_VIDEO_TDATA((10*12)+11 downto (10*12));
            SCRAMBLED_VIDEO_TDATA((21*12)+11 downto (21*12)) <= S_AXIS_VIDEO_TDATA((22*12)+11 downto (22*12));
            SCRAMBLED_VIDEO_TDATA((22*12)+11 downto (22*12)) <= S_AXIS_VIDEO_TDATA((11*12)+11 downto (11*12));
            SCRAMBLED_VIDEO_TDATA((23*12)+11 downto (23*12)) <= S_AXIS_VIDEO_TDATA((23*12)+11 downto (23*12));
    
        end if;

    end process;
end generate;

end rtl;