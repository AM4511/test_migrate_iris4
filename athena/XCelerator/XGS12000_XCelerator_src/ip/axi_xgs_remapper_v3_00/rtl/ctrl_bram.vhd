-- 
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity ctrl_bram is
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

--optional debug insertion
--  attribute mark_debug : string;
--  attribute mark_debug of REMAP_TVALID   : signal is "true";
end ctrl_bram;


-- TUSER(0) = SOF
-- TUSER(1) = EOF
-- TUSER(2) = SOL
-- TLAST    = EOL


-- READOUT_MODE
-- [0] : 0 = incremental readout; 1 = nested readout;
-- [3:1] = RFU


architecture rtl of ctrl_bram is


component sdp_bram
  generic (

        C_FAMILY                        : string  := "kintexu";
        C_DATAWIDTH                     : integer := 32;
        C_ADDRWIDTH                     : integer := 10
  );
  port (
        CLOCK                           : in  std_logic;
        RESET_PORTB                     : in  std_logic;

        -- WRITE PORT
        ENABLE_PORTA                    : in  std_logic;
        ADDR_PORTA                      : in  std_logic_vector(C_ADDRWIDTH-1 downto 0);
        DATA_PORTA                      : in  std_logic_vector(C_DATAWIDTH-1 downto 0);
        
        -- READ PORT
        ENABLE_PORTB                    : in  std_logic;
        ADDR_PORTB                      : in  std_logic_vector(C_ADDRWIDTH-1 downto 0);
        DATA_PORTB                      : out std_logic_vector(C_DATAWIDTH-1 downto 0) := (others => '0');
        DATA_PORTB_VALID                : out std_logic := '0'
        
  );


end component;

-- signal declarations:
constant cNbrOfRamPages         : integer := 4;
constant cBramDatawidth         : integer := 32;
constant cBramAddrwidth         : integer := 10;

constant zero_padding           : std_logic_vector(cBramDatawidth-(2*C_INPUT_DATAWIDTH)-1 downto 0) := (others => '0');

constant valid_zero             : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '0');
constant valid_one              : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '1');

signal tvalid                   : std_logic := '0';
signal tdata                    : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal tstrb                    : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal tlast                    : std_logic := '0';
signal tuser                    : std_logic_vector(C_S_AXIS_TUSER_WIDTH -1 downto 0) := (others => '0');
signal tkeep                    : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
signal tid                      : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
signal tdest                    : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');


-- (9:8) block selection (page)
-- (7:0) address selection inside the block
signal bram_addr_wr             : std_logic_vector(cBramAddrwidth-1 downto 0) := (others => '0');
signal bram_addr_wr_fsm         : std_logic_vector(cBramAddrwidth-1 downto 0) := (others => '0');
alias  page_wr                  : std_logic_vector(1 downto 0) IS bram_addr_wr_fsm(9 downto 8);
alias  addr_wr                  : std_logic_vector(7 downto 0) IS bram_addr_wr_fsm(7 downto 0);
signal bram_addr_rd             : std_logic_vector(cBramAddrwidth-1 downto 0) := (others => '0');
alias  page_rd                  : std_logic_vector(1 downto 0) IS bram_addr_rd(9 downto 8);
alias  addr_rd                  : std_logic_vector(7 downto 0) IS bram_addr_rd(7 downto 0);

signal bram_data_wr             : std_logic_vector((cBramDatawidth*C_NROF_DATACONN/2)-1 downto 0) := (others => '0');
signal bram_data_rd             : std_logic_vector((cBramDatawidth*C_NROF_DATACONN/2)-1 downto 0) := (others => '0');
signal bram_en_wr               : std_logic := '0';
signal bram_en_wr_fsm           : std_logic := '0';
signal bram_en_rd               : std_logic := '0';
signal reset_portb              : std_logic := '1';

signal valid                    : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '0');
signal set_valid                : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '0');
signal clear_valid              : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '0');
signal set_valid_error          : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '0');
signal clear_valid_error        : std_logic_vector(cNbrOfRamPages-1 downto 0) := (others => '0');

signal slicer                   : integer range 1 to C_NROF_DATACONN/2 := 1;
signal line_swap                : std_logic := '0';

type pixstate_tp is (InitFrame, SwapLine);
signal pixstate : pixstate_tp := InitFrame;

type wr_ram_tp is (Init, InitAddr, IncrAddr, Updatevalid);
signal wr_ramstate : wr_ram_tp := Init;

type rd_ram_tp is (Idle, InitAddr, CheckValid, FirstRead, IncrAddr, Updatevalid);
signal rd_ramstate : rd_ram_tp := Idle;

type read_concat_tp is (full_word, half_word);
signal read_concat : read_concat_tp := full_word;

signal bram_full_int            : std_logic := '0';
signal sol_int                  : std_logic := '0';
signal eol_int                  : std_logic := '0';
signal read_cycle               : integer range 1 to 15 := 1;
signal read_shift               : integer range 0 to 11 := 0;
signal read_shift_d             : integer range 0 to 11 := 0;

signal data_cycle               : integer range 1 to 15 := 1;
signal data_shift               : integer range 0 to 11 := 0;

constant addr_rd_incr           : integer := 12;

signal bram_addr_rd_all         : std_logic_vector((cBramAddrwidth*C_NROF_DATACONN/2)-1 downto 0) := (others => '0');
signal bram_addr_rd_cat         : std_logic_vector((cBramAddrwidth*C_NROF_DATACONN)-1 downto 0) := (others => '0');
signal bram_addr_rd_slice       : std_logic_vector((cBramAddrwidth*C_NROF_DATACONN/2)-1 downto 0) := (others => '0');

signal bram_data_rd_cat         : std_logic_vector((cBramDatawidth*C_NROF_DATACONN)-1 downto 0) := (others => '0');
signal bram_data_rd_slice       : std_logic_vector((cBramDatawidth*C_NROF_DATACONN/2)-1 downto 0) := (others => '0');
signal bram_data_rd_gear        : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal bram_data_rd_valid       : std_logic := '0';
signal bram_data_rd_cat_valid   : std_logic := '0';
signal bram_data_rd_gear_valid  : std_logic := '0';


signal bram_en_rd_d1            : std_logic := '0';
signal bram_en_rd_d2            : std_logic := '0';

signal gearbox_valid            : std_logic := '0';
signal gearbox_data             : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal gearbox_store            : std_logic_vector((C_S_AXIS_TDATA_WIDTH/2)-1 downto 0) := (others => '0');
signal gearbox_count            : integer range 1 to 15 := 1;
signal gearbox_tuser            : std_logic_vector(2 downto 0) := (others => '0');
signal gearbox_pix              : integer range 1 to 174 := 1;
signal gearbox_tlast            : std_logic := '0';

signal set_sof_nested           : std_logic := '0';
signal sof_nested               : std_logic := '0';

--------------------------------------------------------
begin

-- status reporting bits:
STATUS_REMAP_BRAM( 3 downto  0) <= set_valid_error;
STATUS_REMAP_BRAM( 7 downto  4) <= clear_valid_error;
STATUS_REMAP_BRAM(11 downto  8) <= valid;
STATUS_REMAP_BRAM(13 downto 12) <= (others => '0');
STATUS_REMAP_BRAM(14) <= bram_full_int;
STATUS_REMAP_BRAM(31 downto 15) <= (others => '0');

-- output selection
select_out : process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
        if (REMAP_ENABLE = '1') then
            BRAM_TREADY <= not bram_full_int;

            BRAM_TVALID <= gearbox_valid;
            BRAM_TDATA  <= gearbox_data;
            BRAM_TSTRB  <= (others => '1');
            BRAM_TLAST  <= gearbox_tlast;
            BRAM_TUSER  <= gearbox_tuser;
            BRAM_TKEEP  <= (others => '1');
            BRAM_TID    <= (others => '0');
            BRAM_TDEST  <= (others => '0');
        else
            BRAM_TREADY <= BRAM_READ_EN;

            BRAM_TVALID <= REMAP_TVALID;
            BRAM_TDATA  <= REMAP_TDATA;
            BRAM_TSTRB  <= REMAP_TSTRB;
            BRAM_TLAST  <= REMAP_TLAST;
            BRAM_TUSER  <= REMAP_TUSER;
            BRAM_TKEEP  <= REMAP_TKEEP;
            BRAM_TID    <= REMAP_TID;
            BRAM_TDEST  <= REMAP_TDEST;
        end if;
    end if;
end process;


-- 
data_pipe_pr : Process(AXIS_VIDEO_ACLK)
begin

    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then

        if (REMAP_TVALID = '1') then
        
            tvalid          <= REMAP_TVALID;
            tstrb           <= REMAP_TSTRB;
            tuser           <= REMAP_TUSER;
            tlast           <= REMAP_TLAST;
            tkeep           <= REMAP_TKEEP;
            tid             <= REMAP_TID;
            tdest           <= REMAP_TDEST;
            
            -- BRAM data assignment:
            if slicer = 1 then
                tdata <= REMAP_TDATA;
            
            -- vivado synthesis doesn't like the 'else'
            --else
            --    tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-((slicer-1)*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-((slicer-1)*2*C_INPUT_DATAWIDTH));
            
            elsif slicer = 2 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(1*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(1*2*C_INPUT_DATAWIDTH));
            elsif slicer = 3 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(2*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(2*2*C_INPUT_DATAWIDTH));
            elsif slicer = 4 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(3*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(3*2*C_INPUT_DATAWIDTH));
            elsif slicer = 5 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(4*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(4*2*C_INPUT_DATAWIDTH));
            elsif slicer = 6 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(5*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(5*2*C_INPUT_DATAWIDTH));
            elsif slicer = 7 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(6*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(6*2*C_INPUT_DATAWIDTH));
            elsif slicer = 8 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(7*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(7*2*C_INPUT_DATAWIDTH));
            elsif slicer = 9 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(8*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(8*2*C_INPUT_DATAWIDTH));
            elsif slicer = 10 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(9*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(9*2*C_INPUT_DATAWIDTH));
            elsif slicer = 11 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(10*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(10*2*C_INPUT_DATAWIDTH));
            elsif slicer = 12 then
                tdata <= REMAP_TDATA( (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(11*2*C_INPUT_DATAWIDTH)-1 downto 0) & REMAP_TDATA(C_S_AXIS_TDATA_WIDTH-1 downto (C_NROF_DATACONN*C_INPUT_DATAWIDTH)-(11*2*C_INPUT_DATAWIDTH));
            end if;
            
        end if;
    end if;

end process;


err_valid_pr : Process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
        for i in 0 to (cNbrOfRamPages-1) loop
            if ( RESET_BRAM = '1') then
                set_valid_error(i) <= '0';
            elsif ( set_valid(i) = '1' and valid(i) = '1')  then
                set_valid_error(i) <= '1';
            end if;
            if ( RESET_BRAM = '1') then
                clear_valid_error(i) <= '0';
            elsif ( clear_valid(i) = '1' and valid(i) = '0') then
                clear_valid_error(i) <= '1';
            end if;
            
            if ( RESET_BRAM = '1' or clear_valid(i) = '1') then
                valid(i) <= '0';
            elsif ( set_valid(i) = '1' and REMAP_ENABLE = '1') then
                valid(i) <= '1';
            end if;
        end loop;
    end if;
end process;


-- DO_SWAP depends on location of pixel_0 on HiSpi lane (XGS sensor config dependent, even/odd row)
-- pixel_0 @ DATA_0 => DO_SWAP = 0
-- pixel_0 @ DATA_1 => DO_SWAP = 1
-- after initial setting, DO_SWAP alternates for each next line
pix0_pr : Process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
        
        case pixstate is
                when InitFrame =>
                    line_swap <= PIXEL_0_LANE;
                    if (RESET_BRAM = '0' and REMAP_ENABLE = '1') then
                        pixstate  <= SwapLine;
                    end if;
                    
                when SwapLine =>
                    if ( RESET_BRAM = '1' or REMAP_TUSER(1) = '1') then -- EOF signal
                        pixstate <= InitFrame;
                    elsif ( REMAP_TVALID = '1' and REMAP_TLAST = '1' ) then  -- EOL
                        line_swap <= not line_swap;
                    end if;
                    
        end case;
    end if;
end process;

DO_SWAP <= line_swap;


write_ram : process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
    
        set_valid  <= (others => '0');
        sof_nested <= '0';
        bram_en_wr_fsm <= '0';
        
        case wr_ramstate is
            when Init =>
                slicer      <= 1;
                wr_ramstate <= InitAddr;
                
            when InitAddr =>
                if (REMAP_TVALID = '1' and REMAP_ENABLE = '1') then
                    bram_en_wr_fsm <= '1';
                    
                    if ( REMAP_TUSER(0) = '1' ) then  -- SOF, restart sequence
                        if ( READOUT_MODE(0) = '0' ) then
                            page_wr <= "00";
                        else
                            page_wr <= "11";
                            set_sof_nested <= '1';
                        end if;
                        addr_wr     <= (others => '0');
                        slicer      <= slicer + 1;
                        wr_ramstate <= IncrAddr;
                    elsif ( REMAP_TUSER(2) = '1' ) then  -- SOL
                        addr_wr <= (others => '0');
                        if ( READOUT_MODE(0) = '0' ) then
                            page_wr <= page_wr + '1';
                        else
                            page_wr <= page_wr - '1';
                        end if;
                        if (set_sof_nested = '1') then
                            set_sof_nested <= '0';
                            sof_nested     <= '1';
                        end if;
                        slicer      <= slicer + 1;
                        wr_ramstate <= IncrAddr;
                    end if;
                end if;
            
            when IncrAddr =>
                if (REMAP_TVALID = '1') then
                    bram_en_wr_fsm <= '1';
                    addr_wr <= addr_wr + '1';
                    
                    if ( REMAP_TLAST = '1' ) then  -- EOL
                        wr_ramstate <= Updatevalid;
                    end if;
                    
                    if (slicer = C_NROF_DATACONN/2) then
                        slicer <= 1;
                    else
                        slicer <= slicer + 1;
                    end if;
                end if;
            
            when Updatevalid =>
                set_valid(to_integer(unsigned(page_wr))) <= '1';
                wr_ramstate <= Init;
            
            when others =>
                wr_ramstate <= Init;
                
        end case;

        
        if ( valid = valid_one) then
            bram_full_int <= '1';
        else
            bram_full_int <= '0';
        end if;
    end if;
end process;

write_pipe: process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
    
        -- bram_0 contains frame/line information:
        if (READOUT_MODE(0) = '0') then
            bram_data_wr(cBramDatawidth-1 downto 0) <= zero_padding(3 downto 0) & tlast & tuser(2 downto 0) & tdata(2*C_INPUT_DATAWIDTH-1 downto 0);
        else
            bram_data_wr(cBramDatawidth-1 downto 0) <= zero_padding(3 downto 0) & tlast & tuser(2 downto 1)& sof_nested & tdata(2*C_INPUT_DATAWIDTH-1 downto 0);
        end if;

        -- pad write data to 32 bit per 2 pixels for all other bram's:
        for i in 1 to (C_NROF_DATACONN/2)-1 loop
            bram_data_wr((i*cBramDatawidth)+cBramDatawidth-1 downto (i*cBramDatawidth)) <= zero_padding & tdata((2*i*C_INPUT_DATAWIDTH)+(2*C_INPUT_DATAWIDTH)-1 downto (2*i*C_INPUT_DATAWIDTH));
        end loop;
        
        bram_en_wr   <= bram_en_wr_fsm;
        bram_addr_wr <= bram_addr_wr_fsm;

    end if;
end process;



-- BRAM instantiation
gen_bram_sdp: for i in 0 to (C_NROF_DATACONN/2)-1 generate
    sdp_bram_inst : sdp_bram
      generic map(
            C_FAMILY                        => C_FAMILY,
            C_DATAWIDTH                     => cBramDatawidth,
            C_ADDRWIDTH                     => cBramAddrwidth
      )
      port map(
            CLOCK                           => AXIS_VIDEO_ACLK,
            RESET_PORTB                     => reset_portb,

            -- WRITE PORT
            ENABLE_PORTA                    => bram_en_wr,
            ADDR_PORTA                      => bram_addr_wr,
            DATA_PORTA                      => bram_data_wr((i*cBramDatawidth)+cBramDatawidth-1 downto (i*cBramDatawidth)),
            
            -- READ PORT
            ENABLE_PORTB                    => bram_en_rd_d2,
            ADDR_PORTB                      => bram_addr_rd_slice((i*cBramAddrwidth)+cBramAddrwidth-1 downto (i*cBramAddrwidth)),
            DATA_PORTB                      => bram_data_rd((i*cBramDatawidth)+cBramDatawidth-1 downto (i*cBramDatawidth)),
            DATA_PORTB_VALID                => bram_data_rd_valid
            
      );
end generate;






read_ram : Process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
    
        clear_valid  <= (others => '0');
        bram_en_rd   <= '0';
        sol_int      <= '0';
        eol_int      <= '0';
        
        if ( BRAM_READ_EN = '1' or RESET_BRAM = '1') then
        
            case rd_ramstate is
                when Idle =>
                    reset_portb <= '1';
                    if (valid /= valid_zero) then
                        reset_portb <= '0';
                        rd_ramstate <= InitAddr;
                    end if;
                    
                when InitAddr =>
                    addr_rd <= (others => '0');
                    if ( READOUT_MODE(0) = '0' ) then
                        page_rd <= "00";
                    else
                        page_rd <= "10";
                    end if;
                    rd_ramstate <= CheckValid;

                when CheckValid =>
                    if (RESET_BRAM = '1') then
                        rd_ramstate <= Idle;
                    elsif ( valid(to_integer(unsigned(page_rd))) = '1') then
                        rd_ramstate <= FirstRead;
                    end if;
                    
                when FirstRead =>
                    sol_int <= '1';
                    addr_rd <= (others => '0');
                    bram_en_rd  <= '1';
                    rd_ramstate <= IncrAddr;
                    read_cycle  <= 1;
                    read_shift  <= 0;
                    
                when IncrAddr =>
                    if (read_cycle < 15) then
                        read_cycle <= read_cycle + 1;
                        addr_rd    <= addr_rd + addr_rd_incr;
                        bram_en_rd <= '1';
                    else
                        read_cycle <= 1;
                        addr_rd    <= (others => '0');
                        if (read_shift < 11) then
                            read_shift <= read_shift + 1;
                            bram_en_rd <= '1';
                         else
                            read_shift <= 0;
                            eol_int    <= '1';
                            rd_ramstate <= Updatevalid;
                         end if;
                    end if;
                    
                when Updatevalid =>
                    clear_valid(to_integer(unsigned(page_rd))) <= '1';
                    page_rd <= page_rd + '1';
                    rd_ramstate <= CheckValid;
                    
                when others =>
                    rd_ramstate <= Idle;
                    
            end case;
            
            read_shift_d <= read_shift;
            
        end if;

    end if;
end process;




-- create read address for all bram's:
gen_addr_rd: for i in 0 to (C_NROF_DATACONN/2)-1 generate
    bram_addr_rd_all((i*cBramAddrwidth)+cBramAddrwidth-1 downto (i*cBramAddrwidth)) <=  bram_addr_rd + i;
end generate;

read_addr_pipe: process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
        bram_addr_rd_cat   <= bram_addr_rd_all & bram_addr_rd_all;
        bram_addr_rd_slice <= bram_addr_rd_cat((cBramAddrwidth*C_NROF_DATACONN)-1-(read_shift_d*cBramAddrwidth) downto (cBramAddrwidth*C_NROF_DATACONN/2)-(read_shift_d*cBramAddrwidth));
        bram_en_rd_d1 <= bram_en_rd;
        bram_en_rd_d2 <= bram_en_rd_d1;
    end if;
end process;

-- reorder data to get correct pixel order
read_data_pipe: process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
        if (RESET_BRAM = '1') then
            data_cycle <= 1;
            data_shift <= 0;
        elsif (bram_data_rd_cat_valid = '1') then
            if (data_cycle < 15) then
                data_cycle <= data_cycle + 1;
            else
                data_cycle <= 1;
                if (data_shift < 11) then
                    data_shift <= data_shift + 1;
                else
                    data_shift <= 0;
                end if;
            end if;
            bram_data_rd_slice <= bram_data_rd_cat((cBramDatawidth*C_NROF_DATACONN/2)-1+(data_shift*cBramDatawidth) downto (data_shift*cBramDatawidth));
        end if;
        if (bram_data_rd_valid = '1') then
            bram_data_rd_cat   <= bram_data_rd & bram_data_rd;
        end if;
        bram_data_rd_cat_valid  <= bram_data_rd_valid;
        bram_data_rd_gear_valid <= bram_data_rd_cat_valid;
    end if;
end process;

-- take only the pixel data (remove user/padding bits)
gen_data_gear: for i in 0 to (C_NROF_DATACONN/2)-1 generate
    bram_data_rd_gear((i+1)*(cBramDatawidth-8)-1 downto (i*(cBramDatawidth-8))) <= bram_data_rd_slice((i+1)*(cBramDatawidth-8)+(i*8)-1 downto (i*(cBramDatawidth-8)+(i*8)));
end generate;



-- gearbox datastream to get continuous output of C_NROF_DATACONN*C_INPUT_DATAWIDTH bits
-- 14 cycles : C_NROF_DATACONN*C_INPUT_DATAWIDTH
--  1 cycle  : (C_NROF_DATACONN*C_INPUT_DATAWIDTH)/2
read_data_gearbox: process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
    
        gearbox_valid <= '0';
        gearbox_tuser <= (others => '0');
        
        
        if (RESET_BRAM = '1') then
            gearbox_count <= 1;
            read_concat   <= full_word;
            
        elsif (bram_data_rd_gear_valid = '1') then
        
            gearbox_tuser <= bram_data_rd_slice(26 downto 24);
        
            case read_concat is
                when full_word =>
                    if (gearbox_count < 15) then
                        gearbox_count <= gearbox_count + 1;
                        gearbox_data  <= bram_data_rd_gear;
                        gearbox_valid <= '1';
                    else
                        gearbox_count <= 1;
                        gearbox_store <= bram_data_rd_gear((C_S_AXIS_TDATA_WIDTH/2)-1 downto 0);
                        gearbox_valid <= '0';
                        read_concat   <= half_word;
                    end if;
                    

                when half_word =>
                    if (gearbox_count < 15) then
                        gearbox_count <= gearbox_count + 1;
                        gearbox_store <= bram_data_rd_gear(C_S_AXIS_TDATA_WIDTH-1 downto (C_S_AXIS_TDATA_WIDTH/2));
                        gearbox_data  <= bram_data_rd_gear((C_S_AXIS_TDATA_WIDTH/2)-1 downto 0) & gearbox_store;
                        gearbox_valid <= '1';
                    else
                        gearbox_count <= 1;
                        gearbox_store <= bram_data_rd_gear(C_S_AXIS_TDATA_WIDTH-1 downto (C_S_AXIS_TDATA_WIDTH/2));
                        gearbox_data  <= bram_data_rd_gear((C_S_AXIS_TDATA_WIDTH/2)-1 downto 0) & gearbox_store;
                        gearbox_valid <= '1';
                        read_concat   <= full_word;
                    end if;

                when others =>
                    gearbox_count <= 1;
                    read_concat   <= full_word;
            end case;
            
        end if;
        
    end if;
end process;


gen_tlast: process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and (AXIS_VIDEO_ACLK = '1')) then
    
        gearbox_tlast <= '0';
    
        if (RESET_BRAM = '1') then
            gearbox_pix   <= 1;
            
        elsif (gearbox_valid = '1') then
        
            if (gearbox_pix < 174) then
                gearbox_pix <= gearbox_pix + 1;
                if (gearbox_pix = 173)then
                    gearbox_tlast <= '1';
                end if;
            else
                gearbox_pix   <= 1;
            end if;
            
        end if;
    
    end if;
end process;

end rtl;