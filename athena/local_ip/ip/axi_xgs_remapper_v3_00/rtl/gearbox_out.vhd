
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity gearbox_out is
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
        M_AXIS_VIDEO_TUSER              : out std_logic_vector(C_M_AXIS_TUSER_WIDTH -1 downto 0);
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

--optional debug insertion
attribute mark_debug : string;
attribute mark_debug of M_AXIS_VIDEO_TVALID   : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TDATA    : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TSTRB    : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TLAST    : signal is "true";
attribute mark_debug of M_AXIS_VIDEO_TREADY   : signal is "true";

end gearbox_out;

architecture rtl of gearbox_out is

component remapper_fifo
  generic(
        DATAWIDTH           : integer := 12;
        C_FAMILY            : string  := "kintexu";
        DEPTH               : integer := 1024;
        PROG_FULL_THRESH    : integer := 800
       );
  port(
        CLOCK                   : in    std_logic;

        FIFO_EMPTY              : out   std_logic;
        FIFO_FULL               : out   std_logic;
        FIFO_PROGFULL           : out   std_logic;
        FIFO_PROGEMPTY          : out   std_logic;
        FIFO_ERROR              : out   std_logic;
        FIFO_RDEN               : in    std_logic;
        FIFO_DOUT               : out   std_logic_vector(DATAWIDTH -1 downto 0);
        FIFO_RESET              : in    std_logic;
        FIFO_WREN               : in    std_logic;
        FIFO_DIN                : in    std_logic_vector(DATAWIDTH -1 downto 0)
       );
end component;



constant FIFO_DATA_WIDTH        : integer := (C_OUTPUT_DATAWIDTH*C_S_AXIS_TDATA_WIDTH)/C_INPUT_DATAWIDTH;
--constant FIFO_PIXELS_PER_WORD   : integer := (C_OUTPUT_DATAWIDTH*C_NROF_DATACONN)/C_INPUT_DATAWIDTH;
constant FIFO_PIXELS_PER_WORD   : integer := (C_M_AXIS_TDATA_WIDTH/C_OUTPUT_DATAWIDTH); --MTX_AM

constant FIFO_WORD_WIDTH        : integer := FIFO_DATA_WIDTH+C_AXIS_TID_WIDTH+C_AXIS_TDEST_WIDTH+C_S_AXIS_TUSER_WIDTH + 1;
constant MUXOFFSET              : integer := 96;

constant zero_padding       : std_logic_vector(C_OUTPUT_DATAWIDTH-C_INPUT_DATAWIDTH-1 downto 0) := (others => '0');

signal input_data_r         : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal input_data_r2        : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal input_data_concat    : std_logic_vector(2*C_S_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');

signal input_id_r           : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
signal input_id_r2          : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');

signal input_dest_r         : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');
signal input_dest_r2        : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');

signal input_user_r         : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');
signal input_user_r2        : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');

signal input_last_r         : std_logic := '0';
signal input_last_r2        : std_logic := '0';
signal input_last_concat    : std_logic_vector(1 downto 0) := (others => '0');

signal fifo_data            : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0) := (others => '0');
signal fifo_last            : std_logic := '0';
signal fifo_id              : std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0) := (others => '0');
signal fifo_dest            : std_logic_vector(C_AXIS_TDEST_WIDTH-1 downto 0) := (others => '0');
signal fifo_user            : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');

signal fifo_in_word         : std_logic_vector(FIFO_WORD_WIDTH-1 downto 0) := (others => '0');
signal fifo_out_word        : std_logic_vector(FIFO_WORD_WIDTH-1 downto 0) := (others => '0');
signal fifo_wren            : std_logic := '0';
signal fifo_rden            : std_logic := '0';
signal fifo_empty           : std_logic := '0';
signal fifo_full            : std_logic := '0';
signal fifo_prog_full       : std_logic := '0';
signal fifo_progempty       : std_logic := '0';
signal fifo_error           : std_logic := '0';

signal fifo_out_user        : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0');

signal ready                : std_logic := '0';

signal muxcntr              : integer range 0 to 3 := 0;
signal muxcntr_r            : integer range 0 to 3 := 0;

signal concat_valid         : std_logic := '0';

begin

ready <= not fifo_prog_full;

S_AXIS_VIDEO_TREADY <= ready;

--input control
input_pipepr: process(AXIS_VIDEO_ACLK)
begin
  if (AXIS_VIDEO_ACLK'event and AXIS_VIDEO_ACLK = '1') then
    concat_valid <= '0';
  
    if (S_AXIS_VIDEO_TVALID = '1' and ready = '1' and FIFO_ENABLE= '1') then
       input_data_r     <= S_AXIS_VIDEO_TDATA;
       input_data_r2    <= input_data_r;

       input_id_r       <= S_AXIS_VIDEO_TID;
       input_id_r2      <= input_id_r;

       input_dest_r     <= S_AXIS_VIDEO_TDEST;
       input_dest_r2    <= input_dest_r;

       input_user_r     <= S_AXIS_VIDEO_TUSER;
       input_user_r2    <= input_user_r;

       input_last_r     <= S_AXIS_VIDEO_TLAST;
       input_last_r2    <= input_last_r;

       if S_AXIS_VIDEO_TUSER(0) = '1' then --sync on tuser(0)/SOF
           muxcntr <= 1;
       elsif muxcntr = 3 then
           muxcntr <= 0;
       else
           muxcntr <= muxcntr + 1;
       end if;
       
       case muxcntr is
            when 0 =>
                concat_valid <= '0';
            when 1 =>
                concat_valid <= '1';
            when 2 =>
                concat_valid <= '1';
            when 3 =>
                concat_valid <= '1';
            when others =>
        end case;
    end if;

  end if;
end process;

input_data_concat <= input_data_r & input_data_r2;
input_last_concat <= input_last_r & input_last_r2;

input_muxpr: process(AXIS_VIDEO_ACLK)
begin
    if (AXIS_VIDEO_ACLK'event and AXIS_VIDEO_ACLK = '1') then

        fifo_wren <= concat_valid;
        muxcntr_r <= muxcntr;

        --data mux
        case muxcntr_r is
            when 0 =>
                --data/last is dont care  63-0
                fifo_data <= input_data_concat(FIFO_DATA_WIDTH-1 downto 0);
                fifo_last   <= input_last_concat(0);
            when 1 =>
                fifo_data <= input_data_concat(FIFO_DATA_WIDTH-1 downto 0);
                fifo_last   <= input_last_concat(0);
            when 2 =>
                fifo_data <= input_data_concat((1*MUXOFFSET)+FIFO_DATA_WIDTH-1 downto (1*MUXOFFSET));
                fifo_last   <= input_last_concat(0);
            when 3 =>
                fifo_data <= input_data_concat((2*MUXOFFSET)+FIFO_DATA_WIDTH-1 downto (2*MUXOFFSET));
                fifo_last   <= input_last_concat(0) or input_last_concat(1);
            when others =>
        end case;

        --some data content is lost when assigning these
        --delay tuser with one pipe more than data to make sure SOF is always written
        fifo_user   <= input_user_r2;
        fifo_id     <= input_id_r2;
        fifo_dest   <= input_dest_r2;

    end if;
end process;

fifo_in_word <=  fifo_user & fifo_id & fifo_dest & fifo_last & fifo_data;

--instantiate fwft fifo here
the_remapper_fifo: remapper_fifo
  generic map (
        DATAWIDTH               => FIFO_WORD_WIDTH      ,
        C_FAMILY                => C_FAMILY             ,
        DEPTH                   => 512                  ,
        PROG_FULL_THRESH        => 480
       )
  port map (
        CLOCK                   => AXIS_VIDEO_ACLK      ,

        FIFO_EMPTY              => fifo_empty           ,
        FIFO_FULL               => fifo_full            ,
        FIFO_PROGFULL           => fifo_prog_full       ,
        FIFO_PROGEMPTY          => fifo_progempty       ,
        FIFO_ERROR              => fifo_error           ,
        FIFO_RDEN               => fifo_rden            ,
        FIFO_DOUT               => fifo_out_word        ,
        FIFO_RESET              => FIFO_RESET           ,
        FIFO_WREN               => fifo_wren            ,
        FIFO_DIN                => fifo_in_word
       );

FIFO_STATUS <= fifo_prog_full & fifo_full & fifo_progempty & fifo_empty & fifo_error;

--output control
fifo_rden <= M_AXIS_VIDEO_TREADY and not fifo_empty;

M_AXIS_VIDEO_TVALID <= not fifo_empty;

--keep and strb are not used/fwded
M_AXIS_VIDEO_TKEEP <= (others => '1');
M_AXIS_VIDEO_TSTRB <= (others => '1');

--pad to 16 bit per pixel
--FIFO_DATA_WIDTH-1 downto 0
gen_padded_data: for i in 0 to FIFO_PIXELS_PER_WORD-1 generate
    M_AXIS_VIDEO_TDATA((i*C_OUTPUT_DATAWIDTH)+C_OUTPUT_DATAWIDTH-1 downto (i*C_OUTPUT_DATAWIDTH) ) <= fifo_out_word((i*C_INPUT_DATAWIDTH)+C_INPUT_DATAWIDTH-1 downto (i*C_INPUT_DATAWIDTH)) & zero_padding;
end generate;

M_AXIS_VIDEO_TLAST  <= fifo_out_word(FIFO_DATA_WIDTH);
M_AXIS_VIDEO_TDEST  <= fifo_out_word(FIFO_DATA_WIDTH+1+C_AXIS_TDEST_WIDTH-1 downto FIFO_DATA_WIDTH+1);
M_AXIS_VIDEO_TID    <= fifo_out_word(FIFO_DATA_WIDTH+1+C_AXIS_TDEST_WIDTH+C_AXIS_TID_WIDTH-1 downto FIFO_DATA_WIDTH+1+C_AXIS_TDEST_WIDTH);
fifo_out_user <= fifo_out_word(FIFO_DATA_WIDTH+1+C_AXIS_TDEST_WIDTH+C_AXIS_TID_WIDTH+C_S_AXIS_TUSER_WIDTH-1 downto FIFO_DATA_WIDTH+1+C_AXIS_TDEST_WIDTH+C_AXIS_TID_WIDTH);

gen_muser_larger: if (C_M_AXIS_TUSER_WIDTH > C_S_AXIS_TUSER_WIDTH) generate
    M_AXIS_VIDEO_TUSER(C_S_AXIS_TUSER_WIDTH-1 downto 0) <= fifo_out_user;
    M_AXIS_VIDEO_TUSER(C_M_AXIS_TUSER_WIDTH-1 downto C_S_AXIS_TUSER_WIDTH) <= (others => '0');
end generate;

gen_muser_equal: if (C_M_AXIS_TUSER_WIDTH = C_S_AXIS_TUSER_WIDTH) generate
    M_AXIS_VIDEO_TUSER <= fifo_out_user;
end generate;

gen_muser_smaller: if (C_M_AXIS_TUSER_WIDTH < C_S_AXIS_TUSER_WIDTH) generate
    M_AXIS_VIDEO_TUSER <= fifo_out_user(C_M_AXIS_TUSER_WIDTH-1 downto 0);
end generate;



end rtl;
