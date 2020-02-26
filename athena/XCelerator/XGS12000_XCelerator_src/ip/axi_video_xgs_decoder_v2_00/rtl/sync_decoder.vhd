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



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity sync_decoder is
  generic (
        NROF_CONTR_CONN : integer;
        MAX_DATAWIDTH   : integer
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        -- config settings
        DATAWIDTH           : in    std_logic_vector(3 downto 0);
        FILL_ENABLE         : in    std_logic;
        CRC_LANE_ENABLE     : in    std_logic;
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


        TIMEOUTCNTRLOAD     : in    std_logic_vector(31 downto 0):= (others => '0');
        TIMEOUT             : out   std_logic := '0';

        --LS trigger
        SEQ_FLASH_TRIGGER   : out   std_logic := '0';

        --X/Y triggering
        XSAMPLE             : in    std_logic_vector(31 downto 0);
        YSAMPLE             : in    std_logic_vector(31 downto 0);
        FRAMESAMPLE         : in    std_logic_vector(31 downto 0);

        PIXELTRIGGER        : out   std_logic := '0';
        LINETRIGGER         : out   std_logic := '0';
        FRAMETRIGGER        : out   std_logic := '0'
  );
end sync_decoder;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of sync_decoder is

------------------------------
--TYPE & SIGNAL DEFINITIONS --
------------------------------
constant    c_pipe_depth    : integer := 6;

constant    sync_word1      : std_logic_vector((MAX_DATAWIDTH-1) downto 0):= (others => '1');
constant    sync_word2      : std_logic_vector((MAX_DATAWIDTH-1) downto 0):= (others => '0');
constant    sync_word3      : std_logic_vector((MAX_DATAWIDTH-1) downto 0):= (others => '0');


signal sof_img_value        : std_logic_vector(4 downto 0):= "11000";
signal sof_emb_value        : std_logic_vector(4 downto 0):= "11001";
signal sol_img_value        : std_logic_vector(4 downto 0):= "10000";
signal sol_emb_value        : std_logic_vector(4 downto 0):= "10001";
signal eof_value            : std_logic_vector(4 downto 0):= "11100";
signal eol_value            : std_logic_vector(4 downto 0):= "10100";

signal sync_word1_value     : std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');
signal sync_word23_value    : std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');


signal sync_word1_detect    : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal sync_word23_detect   : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');

signal sync_start_detect    : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0'); -- word4 start
signal sync_end_detect      : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0'); -- word4 end

signal sof_img_detect       : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal sof_emb_detect       : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal sol_img_detect       : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal sol_emb_detect       : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal eof_detect           : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal eol_detect           : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');


--
type DataDelayPipetp is array (0 to c_pipe_depth) of std_logic_vector((NROF_CONTR_CONN*MAX_DATAWIDTH-1) downto 0);
signal DataPipe    : DataDelayPipetp := (others => (others => '0'));
signal DataValidPipe    : std_logic_vector(0 to c_pipe_depth) := (others => '0');

signal data_valid       : std_logic := '0';
signal frame_valid      : std_logic := '0';
signal sync_start_valid : std_logic := '0';
signal fill_valid       : std_logic := '0';
signal line_valid       : std_logic := '0';
signal img_data_valid   : std_logic := '0';
signal emb_data_valid   : std_logic := '0';
signal sync_end_valid   : std_logic := '0';
signal crc_lane_valid   : std_logic := '0';
signal crc_lane_calc_valid : std_logic := '0';

signal sync_start       : std_logic := '0';
signal sync_end         : std_logic := '0';

signal sync_start_cnt   : std_logic_vector(2 downto 0) := (others => '0');
signal sync_end_cnt     : std_logic_vector(2 downto 0) := (others => '0');

signal frame_start      : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal frame_end        : std_logic_vector(c_pipe_depth   downto 0) := (others => '0');
signal line_start       : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal line_end         : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal img_data_start   : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal img_data_end     : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal emb_data_start   : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal fill_start       : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal crc_lane_start   : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal axis_frame_start : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');
signal axis_line_end    : std_logic_vector(c_pipe_depth-1 downto 0) := (others => '0');

signal img_embb_line    : std_logic := '0';
signal gensofatimg      : std_logic := '0';

signal decode           : std_logic := '0';

type SyncWordStateTp is (Idle, DetectSyncStart, FillDecode, DetectSyncEnd, CrcDecode);
signal SyncWordState    : SyncWordStateTp := Idle;

type ValidStatetp is ( Idle, Valid);
signal FrameValidState     : ValidStatetp := Idle;
signal LineValidState      : ValidStatetp := Idle;
signal SyncStartValidState : ValidStatetp := Idle;
signal SyncEndValidState   : ValidStatetp := Idle;
signal EmbDataValidState   : ValidStatetp := Idle;
signal ImgDataValidState   : ValidStatetp := Idle;

signal DataChannels : std_logic_vector((NROF_CONTR_CONN*MAX_DATAWIDTH-1) downto 0) := (others => '0');

signal en_dec_pipe  : std_logic_vector(15 downto 0) := (others => '0');


signal rst_cntrs    : std_logic := '1';
signal FramesCntr   : std_logic_vector(31 downto 0) := (others => '0');
signal ImgLinesCntr : std_logic_vector(31 downto 0) := (others => '0');
signal EmbLinesCntr : std_logic_vector(31 downto 0) := (others => '0');
signal ImgPixelCntr : std_logic_vector(31 downto 0) := (others => '0');
signal ClocksCntr   : std_logic_vector(31 downto 0) := (others => '0');
signal StartLineCntr: std_logic_vector(31 downto 0) := (others => '0');
signal EndLineCntr  : std_logic_vector(31 downto 0) := (others => '0');

signal timeout_cntr : std_logic_vector(32 downto 0) := (others => '0');


signal startwindow      : std_logic := '0'; -- window logic to add
signal endwindow        : std_logic := '0'; -- window logic to add

signal Monitor0HighCntr : std_logic_vector(31 downto 0):= (others => '0');
signal Monitor0LowCntr  : std_logic_vector(31 downto 0):= (others => '0');
signal Monitor1HighCntr : std_logic_vector(31 downto 0):= (others => '0');
signal Monitor1LowCntr  : std_logic_vector(31 downto 0):= (others => '0');
signal Monitor2HighCntr : std_logic_vector(31 downto 0):= (others => '0');
signal Monitor2LowCntr  : std_logic_vector(31 downto 0):= (others => '0');

signal monitor_rising   : std_logic_vector(2 downto 0):= (others => '0');
signal monitor_falling  : std_logic_vector(2 downto 0):= (others => '0');

type Monitor_synctp is array (2 downto 0) of std_logic_vector(2 downto 0);
signal Monitor_sync : Monitor_synctp := (others => (others => '0'));


signal framestart_p     : std_logic := '0';
signal frameend_p       : std_logic := '0';
signal linestart_p      : std_logic := '0';
signal lineend_p        : std_logic := '0';
signal imagelinestart_p : std_logic := '0';
signal imagelineend_p   : std_logic := '0';

------------------
--MAIN BEHAVIOUR--
------------------

begin

gen_datachannels: for i in 0 to (NROF_CONTR_CONN-1) generate
    DataChannels(( (i+1)*MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH)) <= PAR_DATAIN(((i+1)*MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH));
end generate;


sof_emb_value           <= sof_emb;
sof_img_value           <= sof_img;
eof_value               <= eof;

sol_emb_value           <= sol_emb;
sol_img_value           <= sol_img;
eol_value               <= eol;

PAR_DATA_RDEN           <= en_dec_pipe(10);
PAR_DATAOUT             <= DataPipe(6);
PAR_DATA_VALID          <= data_valid and DataValidPipe(0);

PAR_DATA_IMGVALID       <= img_data_valid and DataValidPipe(0);
PAR_DATA_EMBVALID       <= emb_data_valid and DataValidPipe(0);

PAR_DATA_FRAME          <= frame_valid;
PAR_DATA_LINE           <= line_valid and DataValidPipe(0);

PAR_DATA_SYNC_START     <= sync_start_valid and DataValidPipe(0);
PAR_DATA_SYNC_END       <= sync_end_valid and DataValidPipe(0);

PAR_DATA_WINDOW         <= '0'; -- not used so far

PAR_DATA_FILL_VALID     <= fill_valid and DataValidPipe(0);
PAR_DATA_CRCLANE_VALID  <= crc_lane_valid and DataValidPipe(0);
PAR_CALC_CRCLANE_VALID  <= crc_lane_calc_valid and DataValidPipe(0);

AXIS_DATA_VALID         <= ((img_data_valid and write_img) or (emb_data_valid and write_emb) or (crc_lane_valid and write_crc)) and DataValidPipe(0);
AXIS_SOF                <= axis_frame_start(5);
AXIS_EOF                <= frame_end(0);
AXIS_SOL                <= line_start(5);

AXIS_LAST               <= axis_line_end(0);

FRAMESTART      <= framestart_p;
FRAMEEND        <= frameend_p;
LINESTART       <= linestart_p;
LINEEND         <= lineend_p;
IMAGELINESTART  <= imagelinestart_p;
IMAGELINEEND    <= imagelineend_p;


-- Pipeline
pr_DataPipe: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then

        for i in 0 to (DataValidPipe'high-1) loop
            DataValidPipe(i+1) <= DataValidPipe(i);
        end loop;
        DataValidPipe(0) <= PAR_DATAIN_VALID;

        if (PAR_DATAIN_VALID = '1') then
            for i in 0 to (DataPipe'high-1) loop
                DataPipe(i+1) <= DataPipe(i);
            end loop;
            DataPipe(0) <= PAR_DATAIN;
        end if;

    end if;
end process;

pr_EnPipe: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then
        en_dec_pipe(0) <= en_decoder;

        for i in 0 to en_dec_pipe'high-1 loop
            en_dec_pipe(i+1) <= en_dec_pipe(i);
        end loop;
    end if;
end process;



-- find the start/end sync words (12 or 10 bit possible)
-- indicate the other optional fill/crc position
pr_Decoder: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then

        if ( EN_DECODER = '0') then

            SyncWordState       <= Idle;
            sync_start          <= '0';
            sync_end            <= '0';
            frame_start         <= (others => '0');
            line_end            <= (others => '0');
            fill_start          <= (others => '0');
            crc_lane_start      <= (others => '0');
            line_start          <= (others => '0');
            frame_end           <= (others => '0');
            img_data_start      <= (others => '0');
            emb_data_start      <= (others => '0');
            axis_frame_start    <= (others => '0');
            axis_line_end       <= (others => '0');
            img_embb_line       <= '0';

        elsif (PAR_DATAIN_VALID = '1') then
            -- defaults:
            sync_start          <= '0';
            sync_end            <= '0';
            fill_start(0)       <= '0';
            crc_lane_start(0)   <= '0';
            frame_start(0)      <= '0';
            frame_end(0)        <= '0';
            line_start(0)       <= '0';
            line_end(0)         <= '0';
            img_data_start(0)   <= '0';
            emb_data_start(0)   <= '0';
            axis_frame_start(0) <= '0';
            axis_line_end(0)    <= '0';

            case SyncWordState is
                when Idle =>
                    if (EN_DECODER = '1') then
                        SyncWordState <= DetectSyncStart;
                        timeout_cntr  <= '0' & TIMEOUTCNTRLOAD;
                        TIMEOUT        <= '0';
                    end if;
                    decode      <= '0';

                when DetectSyncStart =>
                    if (EN_DECODER = '0') then
                        SyncWordState   <= Idle;
                    elsif (sync_word1_detect(3) = '1' and sync_word23_detect(2) = '1' and sync_word23_detect(1) = '1' and sync_start_detect(0) = '1') then
                        sync_start     <= '1';
                        
                        if (sof_img_detect(0) = '1') then
                            decode          <= '1';
                            frame_start(0)  <= '1';
                            gensofatimg     <= '0';
                        elsif (sof_emb_detect(0) = '1') then
                            decode          <= '1';
                            frame_start(0)  <= '1';
                            if write_emb = '0' then
                                gensofatimg <= '1';
                            else
                                gensofatimg <= '0';
                            end if;
                        end if;
                        
                        if (FILL_ENABLE = '1') then
                            SyncWordState   <= FillDecode;
                        else
                            line_start(0)   <= '1';
                            timeout_cntr    <= '0' & TIMEOUTCNTRLOAD;
                            SyncWordState   <= DetectSyncEnd;
                        
                            if (sof_img_detect(0) = '1') then
                                img_data_start(0)   <= '1';
                                img_embb_line       <= '1';
                                axis_frame_start(0) <= write_img;
                            elsif (sol_img_detect(0) = '1') then
                                if (gensofatimg = '1') then
                                    gensofatimg <= '0';
                                    axis_frame_start(0) <= write_img;
                                end if;
                                img_data_start(0)   <= '1';
                                img_embb_line       <= '1';
                            elsif (sof_emb_detect(0) = '1') then
                                axis_frame_start(0) <= write_emb;
                                emb_data_start(0)   <= '1';
                                img_embb_line       <= '0';
                            elsif (sol_emb_detect(0) = '1') then
                                emb_data_start(0)   <= '1';
                                img_embb_line       <= '0';
                            end if;
                        end if;
                    elsif (timeout_cntr(timeout_cntr'high) = '1') then
                        TIMEOUT        <= '1';
                        timeout_cntr   <= '0' & TIMEOUTCNTRLOAD;
                    else
                        timeout_cntr <= timeout_cntr - '1';
                    end if;

                when FillDecode =>
                    if (EN_DECODER = '0') then
                        SyncWordState   <= Idle;
                    else
                        fill_start(0)   <= '1';
                        line_start(0)   <= '1';
                        timeout_cntr    <= '0' & TIMEOUTCNTRLOAD;
                        SyncWordState   <= DetectSyncEnd;

                        if (sof_img_detect(1) = '1') then
                            axis_frame_start(0) <= write_img;
                            img_data_start(0)   <= '1';
                            img_embb_line       <= '1';
                        elsif (sol_img_detect(1) = '1') then
                            if (gensofatimg = '1') then
                                gensofatimg <= '0';
                                axis_frame_start(0) <= write_img;
                            end if;
                            img_data_start(0)   <= '1';
                            img_embb_line       <= '1';
                        elsif (sof_emb_detect(1) = '1') then
                            emb_data_start(0)   <= '1';
                            img_embb_line       <= '0';
                            axis_frame_start(0) <= write_emb;
                        elsif (sol_emb_detect(1) = '1') then
                            emb_data_start(0)   <= '1';
                            img_embb_line       <= '0';
                        end if;
                    end if;

                when DetectSyncEnd =>
                    if (EN_DECODER = '0') then
                        SyncWordState   <= Idle;
                    elsif (sync_word1_detect(3) = '1' and sync_word23_detect(2) = '1' and sync_word23_detect(1) = '1' and sync_end_detect(0) = '1') then
                        sync_end     <= '1';
                        if (eof_detect(0) = '1' ) then
                            frame_end(0)    <= '1';
                        end if;

                        if (eof_detect(0) = '1' or eol_detect(0) = '1' ) then
                            line_end(0)     <= '1';
                            if img_embb_line = '1' then --was img line
                                axis_line_end(0) <= write_img and not write_crc;
                            else --was emb line
                                axis_line_end(0) <= write_emb and not write_crc;
                            end if;
                        end if;

                        if (CRC_LANE_ENABLE = '1') then
                            SyncWordState <= CrcDecode;
                        else
                            timeout_cntr  <= '0' & TIMEOUTCNTRLOAD;
                            SyncWordState <= DetectSyncStart;
                        end if;
                    elsif (timeout_cntr(timeout_cntr'high) = '1') then
                        TIMEOUT        <= '1';
                        timeout_cntr   <= '0' & TIMEOUTCNTRLOAD;
                    else
                        timeout_cntr <= timeout_cntr - '1';
                    end if;

                when CrcDecode =>
                    if (EN_DECODER = '0') then
                        SyncWordState   <= Idle;
                    else
                        crc_lane_start(0) <= '1';
                        --sof generation only for CRC
                        axis_frame_start(0)  <= (not write_emb) and (not write_img) and write_crc;
                        axis_line_end(0) <= write_crc;
                        timeout_cntr  <= '0' & TIMEOUTCNTRLOAD;
                        SyncWordState <= DetectSyncStart;
                    end if;

                when others =>
                    SyncWordState   <= Idle;

            end case;

            for i in c_pipe_depth-2 downto 0 loop
                frame_start(i+1)     <= frame_start(i);
                line_start(i+1)      <= line_start(i);
                line_end(i+1)        <= line_end(i);
                fill_start(i+1)      <= fill_start(i);
                crc_lane_start(i+1)  <= crc_lane_start(i);
                frame_end(i+1)       <= frame_end(i);
                emb_data_start(i+1)  <= emb_data_start(i);
                img_data_start(i+1)  <= img_data_start(i);
                axis_frame_start(i+1)<= axis_frame_start(i);
                axis_line_end(i+1)   <= axis_line_end(i);

            end loop;
            frame_end(6)       <= frame_end(5);
        end if;

    end if;
end process;



-- Generate all framing valid signal
pr_Valid: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then

        if ( EN_DECODER = '0' or decode = '0') then

            FrameValidState     <= Idle;
            LineValidState      <= Idle;
            SyncStartValidState <= Idle;
            SyncEndValidState   <= Idle;
            EmbDataValidState   <= Idle;
            ImgDataValidState   <= Idle;

            frame_valid      <= '0';
            line_valid       <= '0';
            sync_start_valid <= '0';
            sync_end_valid   <= '0';
            emb_data_valid   <= '0';
            img_data_valid   <= '0';
            fill_valid       <= '0';
            crc_lane_valid   <= '0';
            img_data_end     <= (others => '0');

        elsif (PAR_DATAIN_VALID = '1') then


            -- frame valid
            case FrameValidState is
                when Idle =>
                    if (frame_start(0) = '1') then
                        frame_valid     <= '1';
                        FrameValidState <= Valid;
                    end if;

                when Valid =>
                    if ((CRC_LANE_ENABLE = '0' and frame_end(4) = '1' ) or (CRC_LANE_ENABLE = '1' and frame_end(6) = '1')) then
                        frame_valid     <= '0';
                        FrameValidState <= Idle;
                    end if;
            end case;

            -- line_valid
            case LineValidState is
                when Idle =>
                    if (line_start(4) = '1') then
                        line_valid      <= '1';
                        LineValidState  <= Valid;
                    end if;

                when Valid =>
                    if (line_end(0) = '1') then
                        line_valid      <= '0';
                        LineValidState  <= Idle;
                    end if;
            end case;

            -- emb_data_valid
            case EmbDataValidState is
                when Idle =>
                    if ( emb_data_start(4) = '1' ) then
                        emb_data_valid     <= '1';
                        EmbDataValidState  <= Valid;
                    end if;

                when Valid =>
                    if (line_end(0) = '1') then
                        emb_data_valid     <= '0';
                        EmbDataValidState  <= Idle;
                    end if;
            end case;

            -- img_data_valid
            case ImgDataValidState is
                when Idle =>
                    if (img_data_start(4) = '1') then
                        img_data_valid     <= '1';
                        ImgDataValidState  <= Valid;
                    end if;
                    img_data_end(0) <= '0';

                when Valid =>
                    if (line_end(0) = '1') then
                        img_data_valid     <= '0';
                        ImgDataValidState  <= Idle;
                        img_data_end(0) <= '1';
                    else
                        img_data_end(0) <= '0';
                    end if;
            end case;

            -- sync start valid
            case SyncStartValidState is
                when Idle =>
                    if (sync_start = '1') then
                        sync_start_cnt <= "010";
                        sync_start_valid <= '1';
                        SyncStartValidState <= Valid;
                    else
                        sync_start_valid <= '0';
                    end if;

                when Valid =>
                    if (sync_start_cnt(sync_start_cnt'high) = '1') then
                        sync_start_valid <= '0';
                        SyncStartValidState <= Idle;
                    else
                        sync_start_valid <= '1';
                        sync_start_cnt <= sync_start_cnt - '1';
                    end if;
            end case;

            -- sync end valid
            case SyncEndValidState is
                when Idle =>

                    if (sync_end = '1') then
                        sync_end_cnt <= "010";
                        sync_end_valid <= '1';
                        SyncEndValidState <= Valid;
                    else
                        sync_end_valid <= '0';
                    end if;

                when Valid =>
                    if (sync_end_cnt(sync_end_cnt'high) = '1') then
                        sync_end_valid <= '0';
                        SyncEndValidState <= Idle;
                    else
                        sync_end_valid <= '1';
                        sync_end_cnt <= sync_end_cnt - '1';
                    end if;
            end case;

            for i in c_pipe_depth-2 downto 0 loop
                img_data_end(i+1)    <= img_data_end(i);
            end loop;


            fill_valid      <= fill_start(3);
            crc_lane_valid  <= crc_lane_start(3) or crc_lane_start(4);

        end if;

    end if;
end process;

data_valid           <= sync_start_valid or fill_valid or line_valid or sync_end_valid or crc_lane_valid;
crc_lane_calc_valid  <= fill_valid or line_valid or sync_end_valid;


-- Detection of sync words
pr_SyncWordDetect: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then

        if DATAWIDTH = "1010" then -- 10-bit
            sync_word1_value   <= sync_word1(MAX_DATAWIDTH-1 downto 2) & "00";
            sync_word23_value  <= sync_word2(MAX_DATAWIDTH-1 downto 2) & "00";

        else -- 12-bit
            sync_word1_value   <= sync_word1(MAX_DATAWIDTH-1 downto 0);
            sync_word23_value  <= sync_word2(MAX_DATAWIDTH-1 downto 0);

        end if;

        if ( EN_DECODER = '0') then
            sync_word1_detect     <= (others => '0');
            sync_word23_detect    <= (others => '0');
            sync_start_detect     <= (others => '0');
            sync_end_detect       <= (others => '0');

            sof_img_detect        <= (others => '0');
            sof_emb_detect        <= (others => '0');
            sol_img_detect        <= (others => '0');
            sol_emb_detect        <= (others => '0');
            eof_detect            <= (others => '0');
            eol_detect            <= (others => '0');

        elsif (PAR_DATAIN_VALID = '1') then

            sync_word1_detect(0)  <= '0';
            sync_word23_detect(0) <= '0';
            sync_start_detect(0)  <= '0';
            sync_end_detect(0)    <= '0';

            sof_img_detect(0)     <= '0';
            sof_emb_detect(0)     <= '0';
            sol_img_detect(0)     <= '0';
            sol_emb_detect(0)     <= '0';
            eof_detect(0)         <= '0';
            eol_detect(0)         <= '0';

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto 0) = sync_word1_value) then
                sync_word1_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto 0) = sync_word23_value) then
                sync_word23_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto (MAX_DATAWIDTH-5))= sof_img_value) then
                sof_img_detect(0) <= '1';
                sync_start_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto (MAX_DATAWIDTH-5))= sof_emb_value) then
                sof_emb_detect(0) <= '1';
                sync_start_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto (MAX_DATAWIDTH-5))= sol_img_value) then
                sol_img_detect(0) <= '1';
                sync_start_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto (MAX_DATAWIDTH-5))= sol_emb_value) then
                sol_emb_detect(0) <= '1';
                sync_start_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto (MAX_DATAWIDTH-5))= eof_value) then
                eof_detect(0) <= '1';
                sync_end_detect(0) <= '1';
            end if;

            if (DataPipe(0)((MAX_DATAWIDTH-1) downto (MAX_DATAWIDTH-5))= eol_value) then
                eol_detect(0) <= '1';
                sync_end_detect(0) <= '1';
            end if;


            --pipeline
            for i in c_pipe_depth-2 downto 0 loop
              sync_word1_detect(i+1)  <= sync_word1_detect(i);
              sync_word23_detect(i+1) <= sync_word23_detect(i);
              sync_start_detect(i+1)  <= sync_start_detect(i);
              sync_end_detect(i+1)    <= sync_end_detect(i);

              sof_img_detect(i+1)     <= sof_img_detect(i);
              sof_emb_detect(i+1)     <= sof_emb_detect(i);
              sol_img_detect(i+1)     <= sol_img_detect(i);
              sol_emb_detect(i+1)     <= sol_emb_detect(i);
              eof_detect(i+1)         <= eof_detect(i);
              eol_detect(i+1)         <= eol_detect(i);
            end loop;

        end if;
    end if;
end process;


pr_Counters: process(CLOCK)
begin
  if (CLOCK'event and CLOCK = '1') then

      -- counter reset logic
      if (en_dec_pipe(0) = '1' and en_dec_pipe(1) = '0') then --rising edge en_decoder
          rst_cntrs       <= '1';
          FRAMESCNT       <= (others => '0');
          IMGLINESCNT     <= (others => '0');
          EMBLINESCNT     <= (others => '0');
          IMGPIXELCNT     <= (others => '0');
          CLOCKSCNT       <= (others => '0');
          STARTLINECNT    <= (others => '0');
          ENDLINECNT      <= (others => '0');
      else
          rst_cntrs <= '0';
          -- transfer counter values at frame pace
          if (frameend_p = '1') then
            FRAMESCNT       <= FramesCntr;
            IMGLINESCNT     <= ImgLinesCntr;
            EMBLINESCNT     <= EmbLinesCntr;
            IMGPIXELCNT     <= ImgPixelCntr;
            CLOCKSCNT       <= ClocksCntr;
            STARTLINECNT    <= StartLineCntr;
            ENDLINECNT      <= EndLineCntr;
          end if;
      end if;
   
      
      -- framescounter
      if (rst_cntrs = '1') then
          FramesCntr <= (others => '0');
      else
          if (EN_DECODER = '1') then
              if (frame_start(0) = '1' and PAR_DATAIN_VALID = '1') then
                  FramesCntr <= FramesCntr + '1';
              end if;
          end if;
      end if;
      
      -- counts total amount of imagelines/frame
      if (rst_cntrs = '1' or frame_start(0) = '1') then
        ImgLinesCntr <= (others => '0');
      else
          if (EN_DECODER = '1' ) then
              if (img_data_start(1) = '1' and PAR_DATAIN_VALID = '1') then
                  ImgLinesCntr <= ImgLinesCntr + '1';
              end if;
          end if;
      end if;
      
      -- counts total amount of embeddedlines/frame
      if (rst_cntrs = '1' or frame_start(0) = '1') then
        EmbLinesCntr <= (others => '0');
      else
          if (EN_DECODER = '1' ) then
              if (emb_data_start(1) = '1' and PAR_DATAIN_VALID = '1') then
                  EmbLinesCntr <= EmbLinesCntr + '1';
              end if;
          end if;
      end if;

      -- image pixels per frame counter
      if (rst_cntrs = '1' or img_data_start(0) = '1') then
          ImgPixelCntr <= (others => '0');
      else
          if (EN_DECODER = '1') then
              if (img_data_valid = '1' and DataValidPipe(0) = '1') then
                      ImgPixelCntr <= ImgPixelCntr + '1';
              end if;
          end if;
      end if;

      -- clocks/frame counter
      if (rst_cntrs = '1' or frame_start(0) = '1') then
        ClocksCntr <= (others => '0');
      else
          if (EN_DECODER = '1' ) then
              if (frame_valid = '1') then
                  ClocksCntr <= ClocksCntr + '1';
              end if;
          end if;
      end if;

      -- startlinecounter (/readout) (including black lines)
      if (rst_cntrs = '1' ) then
          StartLineCntr <= (others => '0');
          EndLineCntr   <= (others => '0');
      else
          if (EN_DECODER = '1') then
              if (line_start(0) = '1'and PAR_DATAIN_VALID = '1') then
                  StartLineCntr <= StartLineCntr + '1';
              end if;
              if (line_end(0) = '1' and PAR_DATAIN_VALID = '1') then
                  EndLineCntr <= EndLineCntr + '1';
              end if;
          end if;
      end if;

  end if;
end process;


-- X/Y triggering
x_y_trigger: process(CLOCK)
  begin
    if(CLOCK = '1' and CLOCK'event) then
        -- defaults
        PIXELTRIGGER        <= '0';
        LINETRIGGER         <= '0';
        FRAMETRIGGER        <= '0';
           
        if (ImgPixelCntr(15 downto 0) = XSAMPLE(15 downto 0)) then
            PIXELTRIGGER        <= '1';
        end if;
        
        if (ImgLinesCntr(15 downto 0) = YSAMPLE(15 downto 0)) then
            LINETRIGGER        <= '1';
        end if;
        
        if (FramesCntr(15 downto 0) = FRAMESAMPLE(15 downto 0)) then
            FRAMETRIGGER        <= '1';
        end if;

    end if;
end process;


-- monitor parser
-- also used for lightsource triggering
monitor_parser: process(CLOCK)
begin
  if(CLOCK = '1' and CLOCK'event) then

      --defaults
      Monitor_sync(0)(0)  <= '0';--removed monitor
      Monitor_sync(0)(1)  <= '0';--removed monitor
      Monitor_sync(0)(2)  <= '0';--removed monitor

      for i in 0 to (Monitor_sync'high - 1) loop
          Monitor_sync(i+1) <= Monitor_sync(i);
      end loop;

      -- monitor counters
      for i in 0 to 2 loop
      --defaults
          monitor_rising(i)   <= '0';
          monitor_falling(i)  <= '0';
          if (decode = '1') then
              if (Monitor_sync(2)(i) = '0' and Monitor_sync(1)(i) = '1') then --rising edge
                  monitor_rising(i) <= '1';
              elsif (Monitor_sync(2)(0) = '1' and Monitor_sync(1)(i) = '0') then --falling edge
                  monitor_falling(i) <= '1';
              end if;
          end if;
      end loop;

      if (decode = '1') then
          if (monitor_rising(0) = '1') then
            --  MONITOR0HIGHCNT <= Monitor0HighCntr;
              Monitor0HighCntr <= (others => '0');
          elsif (Monitor_sync(2)(0) = '1') then
              Monitor0HighCntr <= Monitor0HighCntr + '1';
          end if;

          if (monitor_falling(0) = '1') then
           --   MONITOR0LOWCNT <= Monitor0LowCntr;
              Monitor0LowCntr <= (others => '0');
          elsif (Monitor_sync(2)(0) = '0') then
              Monitor0LowCntr <= Monitor0LowCntr + '1';
          end if;

          if (monitor_rising(1) = '1') then
            --  MONITOR1HIGHCNT <= Monitor1HighCntr;
              Monitor1HighCntr <= (others => '0');
          elsif (Monitor_sync(2)(1) = '1') then
              Monitor1HighCntr <= Monitor1HighCntr + '1';
          end if;

          if (monitor_falling(1) = '1') then
           --   MONITOR1LOWCNT <= Monitor1LowCntr;
              Monitor1LowCntr <= (others => '0');
          elsif (Monitor_sync(2)(1) = '0') then
              Monitor1LowCntr <= Monitor1LowCntr + '1';
          end if;

          if (monitor_rising(2) = '1') then
           --   MONITOR2HIGHCNT <= Monitor2HighCntr;
              Monitor2HighCntr <= (others => '0');
          elsif (Monitor_sync(2)(2) = '1') then
              Monitor2HighCntr <= Monitor2HighCntr + '1';
          end if;

          if (monitor_falling(2) = '1') then
            --  MONITOR2LOWCNT <= Monitor2LowCntr;
              Monitor2LowCntr <= (others => '0');
          elsif (Monitor_sync(2)(2) = '0') then
              Monitor2LowCntr <= Monitor2LowCntr + '1';
          end if;
      end if;

      -- monitor in
      SEQ_FLASH_TRIGGER   <= '0';

      case LS_TRIGGERSELECT is
          when X"0" => -- once, after start sequencer, not aligned with readout, when/before frames are grabbed
              SEQ_FLASH_TRIGGER <= EN_DECODER;
          when X"1" => -- every frame start, aligned with readout, when/before frames are grabbed
              SEQ_FLASH_TRIGGER <= frame_start(0);
          when X"2" => -- every frame end, aligned with readout, when/before frames are grabbed
              SEQ_FLASH_TRIGGER <= frame_end(6);
          when X"3" => -- every windowstart when/before frames are grabbed
              SEQ_FLASH_TRIGGER <= startwindow;
          when X"4" => -- every windowend when/before frames are grabbed
              SEQ_FLASH_TRIGGER <= endwindow;
          when X"5" => -- rising edge of monitor pin 0
              SEQ_FLASH_TRIGGER <= monitor_rising(0);
          when X"6" => -- falling edge of monitor pin 0
              SEQ_FLASH_TRIGGER <=  monitor_falling(0);
          when X"7" => -- rising edge of monitor pin 1
              SEQ_FLASH_TRIGGER <= monitor_rising(1);
          when X"8" => -- falling edge of monitor pin 1
              SEQ_FLASH_TRIGGER <=  monitor_falling(1);
          when X"9" => -- rising edge of monitor pin 2
              SEQ_FLASH_TRIGGER <= monitor_rising(2);
          when X"A" => -- falling edge of monitor pin 2
              SEQ_FLASH_TRIGGER <=  monitor_falling(2);
          when others =>
              SEQ_FLASH_TRIGGER <= '0';
      end case;

  end if;
end process;

single_pulse: process(CLOCK)
begin
    if(CLOCK = '1' and CLOCK'event) then

        --rising edge detection to make single pulse for output signals
        if (frame_start(0) = '1' and frame_start(1) = '0' and PAR_DATAIN_VALID = '1') then
          framestart_p <= '1';
        else
          framestart_p <= '0';
        end if;

        if (frame_end(5) = '1' and frame_end(6) = '0' and PAR_DATAIN_VALID = '1') then
          frameend_p <= '1';
        else
          frameend_p <= '0';
        end if;

        if (line_start(0) = '1' and line_start(1) = '0' and PAR_DATAIN_VALID = '1') then
          linestart_p <= '1';
        else
          linestart_p <= '0';
        end if;

        if (line_end(0) = '1' and line_end(1) = '0' and PAR_DATAIN_VALID = '1') then
          lineend_p <= '1';
        else
          lineend_p <= '0';
        end if;

        if (img_data_start(0) = '1' and img_data_start(1) = '0' and PAR_DATAIN_VALID = '1') then
          imagelinestart_p <= '1';
        else
          imagelinestart_p <= '0';
        end if;

        if (img_data_end(0) = '1' and img_data_end(1) = '0' and PAR_DATAIN_VALID = '1') then
          imagelineend_p <= '1';
        else
          imagelineend_p <= '0';
        end if;


    end if;
end process;

end rtl;
