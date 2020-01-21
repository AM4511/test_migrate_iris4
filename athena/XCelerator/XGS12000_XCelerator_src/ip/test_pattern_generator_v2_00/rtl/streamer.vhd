
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity streamer is
  generic (
        C_FAMILY                    : string := "Virtex7";
        gMax_Datawidth              : integer := 16;

        C_M_AXIS_TDATA_WIDTH        : integer   := 128;
        C_M_AXIS_TUSER_WIDTH        : integer   := 1
  );
  port (
        -- Control signals
        CLOCK                       : in std_logic; -- M_AXIS_ACLK
        RESET                       : in std_logic; -- M_AXIS_ARESETN

        -- Config settings
        read_count                  : out   std_logic_vector(31 downto 0) := (others => '0');
        write_count                 : out   std_logic_vector(31 downto 0) := (others => '0');
        read_error                  : out   std_logic := '0';
        write_error                 : out   std_logic := '0';

        -- Data input
        PAR_DATA                    : in    std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        PAR_DATA_VALID              : in    std_logic;
        PAR_DATA_SOF                : in    std_logic;
        PAR_DATA_EOL                : in    std_logic;

        streamer_full               : out   std_logic;
        streamer_almostfull         : out   std_logic;
        streamer_empty              : out   std_logic;
        streamer_almostempty        : out   std_logic;
        streamer_error              : out   std_logic;

        -- Data output
        -- Global ports
        M_AXIS_ACLK                 : in std_logic;
        M_AXIS_ARESETN              : in std_logic;
        M_AXIS_TVALID               : out std_logic := '0';                                                         -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
        M_AXIS_TDATA                : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');     -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
        M_AXIS_TSTRB                : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0'); -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
        M_AXIS_TKEEP                : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        M_AXIS_TLAST                : out std_logic := '0';                                                         -- TLAST indicates the boundary of a packet.
        M_AXIS_TREADY               : in std_logic;                                                                 -- TREADY indicates that the slave can accept a transfer in the current cycle.
        M_AXIS_TUSER                : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0) := (others => '0')
  );

--optional debug insertion
attribute mark_debug : string;
attribute mark_debug of M_AXIS_TVALID   : signal is "true";
attribute mark_debug of M_AXIS_TDATA    : signal is "true";
attribute mark_debug of M_AXIS_TSTRB    : signal is "true";
attribute mark_debug of M_AXIS_TLAST    : signal is "true";
attribute mark_debug of M_AXIS_TREADY   : signal is "true";
attribute mark_debug of M_AXIS_TUSER    : signal is "true";

attribute mark_debug of PAR_DATA          : signal is "true";
attribute mark_debug of PAR_DATA_VALID    : signal is "true";
attribute mark_debug of PAR_DATA_SOF      : signal is "true";
attribute mark_debug of PAR_DATA_EOL      : signal is "true";

end streamer;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of streamer is

component afifo_wrapper 
  generic (
    C_FAMILY            : string  := "ULTRASCALE";
    WIDTH               : integer := 128;
    DEPTH               : integer := 256;
    PROG_EMPTY_THRESH   : integer := 1;
    PROG_FULL_THRESH    : integer := 255
    );
  port (
    rst_wr      : in std_logic;
    rst_rd      : in std_logic;  
    wr_clk      : in std_logic;  
    rd_clk      : in std_logic;   
    din         : in std_logic_vector(WIDTH-1 downto 0);  
    wr_en       : in std_logic;
    rd_en       : in std_logic;
    dout        : out std_logic_vector(WIDTH-1 downto 0);
    --overflow    : out std_logic;
    --wr_rst_busy : out std_logic;
    --underflow   : out std_logic;
    --rd_rst_busy : out std_logic;
    full        : out std_logic;
    almost_full : out std_logic;
    empty       : out std_logic;
    almost_empty: out std_logic;
    fifo_error  : out std_logic
  );
end component;

--constant nroffifos : integer := (C_M_AXIS_TDATA_WIDTH/32)+1; --extra fifo for the additional signals; tstrb, tlast, tuser(sof)
constant zeros     : std_logic_vector(63 downto 0) := (others => '0');

--                              data                   last user
constant fifowidth : integer := C_M_AXIS_TDATA_WIDTH + 1 +  C_M_AXIS_TUSER_WIDTH;

signal dout     : std_logic_vector(fifowidth-1 downto 0) := (others => '0'); --width needed to map to fifo ports
signal din      : std_logic_vector(fifowidth-1 downto 0) := (others => '0'); --width needed to map to fifo ports

signal empty            : std_logic;
signal full             : std_logic;
signal almostempty      : std_logic;
signal almostfull       : std_logic;
signal rd_en            : std_logic;
signal fifo_error       : std_logic;

signal rderr            : std_logic;
signal wrerr            : std_logic;

signal rst              : std_logic := '1';

function family_to_integer (
  family : in string)
  return integer is
  variable returnvalue : integer := 0;
begin
  if ((C_FAMILY = "Virtex7") or (C_FAMILY = "Xilinx") or (C_FAMILY = "kintexu")) then
      returnvalue := 1;
  else
      returnvalue := 0;
  end if;

  return returnvalue;
end;

begin

--in theory to be compatible with video ip we need to generate a "continuous aligned stream"
resetpr : process(M_AXIS_ACLK)
begin
    if (M_AXIS_ACLK='1' and M_AXIS_ACLK'event) then
        rst <= not M_AXIS_ARESETN;
    end if;
end process;

M_AXIS_TVALID <= not empty;
M_AXIS_TDATA  <= dout(C_M_AXIS_TDATA_WIDTH-1 downto 0);
M_AXIS_TLAST  <= dout(C_M_AXIS_TDATA_WIDTH);
M_AXIS_TUSER  <= dout(C_M_AXIS_TDATA_WIDTH+C_M_AXIS_TUSER_WIDTH downto C_M_AXIS_TDATA_WIDTH+1);
M_AXIS_TSTRB  <= (others => '1');
M_AXIS_TKEEP  <= (others => '1');

gen_din: for i in 0 to (C_M_AXIS_TDATA_WIDTH/16)-1 generate
    din(16*i+15 downto 16*i) <= PAR_DATA(i*gMax_Datawidth+gMax_Datawidth-1 downto i*gMax_Datawidth) & zeros(15-gMax_Datawidth downto 0);
end generate;

--control signal fifo connections
din(C_M_AXIS_TDATA_WIDTH) <= PAR_DATA_EOL;              --M_AXIS_TLAST (EOL)
din(C_M_AXIS_TDATA_WIDTH+1) <= PAR_DATA_SOF;            --M_AXIS_TUSER (SOF)
gen_zero_tuser: if C_M_AXIS_TUSER_WIDTH > 1 generate
    din(C_M_AXIS_TDATA_WIDTH+C_M_AXIS_TUSER_WIDTH downto C_M_AXIS_TDATA_WIDTH+2) <= (others => '0'); --TUSER (not used)
end generate;

read_count      <= (others => '0');
write_count     <= (others => '0');
read_error      <= rderr;
write_error     <= wrerr;

streamer_full <= full;
streamer_almostfull <=  almostfull;
streamer_empty <= empty;
streamer_almostempty <= almostempty;
streamer_error <= fifo_error;

rd_en <= M_AXIS_TREADY and not empty;


wrerr <= '0';
rderr <= '0';

    the_fifo: afifo_wrapper 
        generic map (
            C_FAMILY            => C_FAMILY     ,
            WIDTH               => fifowidth    ,
            DEPTH               => 512          ,
            PROG_EMPTY_THRESH   => 5            ,
            PROG_FULL_THRESH    => 507
        )
        port map (
            rst_wr              => rst               ,
            rst_rd              => rst               ,
            wr_clk              => CLOCK             ,
            rd_clk              => M_AXIS_ACLK       ,
            din                 => din               ,
            wr_en               => PAR_DATA_VALID    ,
            rd_en               => rd_en             ,
            dout                => dout              ,
            --overflow            => wrerr             ,
            --wr_rst_busy         => open              ,
            --underflow           => rderr             ,
            --rd_rst_busy         => open              ,
            full                => full              ,
            almost_full         => almostfull        ,
            empty               => empty             ,
            almost_empty        => almostempty,
            fifo_error          => fifo_error
        );


end rtl;