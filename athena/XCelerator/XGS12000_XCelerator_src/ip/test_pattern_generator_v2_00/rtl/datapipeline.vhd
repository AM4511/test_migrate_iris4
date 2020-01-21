library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapipeline is
    generic (
        C_FAMILY                : string    := "Virtex7";
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
end datapipeline;

architecture structure of datapipeline is

component generator
  generic (
        DATAWIDTH   : integer := 16
        );
  port (
        CLOCK                   : in    std_logic;
                                
        linelength              : in    std_logic_vector(15 downto 0);
        nroflines               : in    std_logic_vector(15 downto 0);
        xinc                    : in    std_logic_vector(15 downto 0);
        yinc                    : in    std_logic_vector(15 downto 0);
        finc                    : in    std_logic_vector(15 downto 0);

        enable                  : in    std_logic;
        busy                    : out   std_logic := '0';

        streamer_full           : in   std_logic;
        streamer_almostfull     : in   std_logic;
        streamer_empty          : in   std_logic;
        streamer_almostempty    : in   std_logic;

        PAR_DATA                : out   std_logic_vector(DATAWIDTH-1 downto 0) := (others => '0');
        PAR_DATA_VALID          : out   std_logic;
        PAR_DATA_SOF            : out   std_logic;
        PAR_DATA_EOL            : out   std_logic
       );
end component;

component streamer
  generic (
        C_FAMILY                : string    := "Virtex7";
  
        gMax_Datawidth          : integer   := 16;
  
        C_M_AXIS_TDATA_WIDTH    : integer   := 128;
        C_M_AXIS_TUSER_WIDTH    : integer   := 1
  );
  port (
        -- Control signals
        CLOCK                   : in std_logic; -- M_AXIS_ACLK
        RESET                   : in std_logic; -- M_AXIS_ARESETN

        -- Config settings
        read_count              : out   std_logic_vector(31 downto 0);
        write_count             : out   std_logic_vector(31 downto 0);
        read_error              : out   std_logic;
        write_error             : out   std_logic;

        -- Data input
        PAR_DATA                : in    std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        PAR_DATA_VALID          : in    std_logic;
        PAR_DATA_SOF            : in    std_logic;
        PAR_DATA_EOL            : in    std_logic;

        streamer_full           : out   std_logic;
        streamer_almostfull     : out   std_logic;
        streamer_empty          : out   std_logic;
        streamer_almostempty    : out   std_logic;
        streamer_error          : out   std_logic;

        -- Data output
        -- Global ports
        M_AXIS_ACLK             : in std_logic;
        M_AXIS_ARESETN          : in std_logic;
        M_AXIS_TVALID           : out std_logic;                                                -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
        M_AXIS_TDATA            : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);        -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
        M_AXIS_TSTRB            : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);    -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
        M_AXIS_TKEEP            : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        M_AXIS_TLAST            : out std_logic;                                                -- TLAST indicates the boundary of a packet.
        M_AXIS_TREADY           : in std_logic;                                                 -- TREADY indicates that the slave can accept a transfer in the current cycle.
        M_AXIS_TUSER            : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0)
  );
end component;

signal par_data                 : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
signal par_data_valid           : std_logic := '0';
signal par_data_sof             : std_logic := '0';
signal par_data_eol             : std_logic := '0';

signal streamer_full            : std_logic;
signal streamer_almostfull      : std_logic;
signal streamer_empty           : std_logic;
signal streamer_almostempty     : std_logic;
signal streamer_error           : std_logic;

begin

the_generator: generator
  generic map (
        DATAWIDTH           => C_M_AXIS_TDATA_WIDTH
        )
  port map (
        CLOCK               => CLOCK                ,

        linelength          => linelength           ,
        nroflines           => nroflines            ,
        xinc                => xinc                 ,
        yinc                => yinc                 ,
        finc                => finc                 ,

        enable              => enable               ,
        busy                => busy                 ,

        streamer_full        => streamer_full       ,
        streamer_almostfull  => streamer_almostfull ,
        streamer_empty       => streamer_empty      ,
        streamer_almostempty => streamer_almostempty,

        PAR_DATA            => par_data             ,
        PAR_DATA_VALID      => par_data_valid       ,
        PAR_DATA_SOF        => par_data_sof         ,
        PAR_DATA_EOL        => par_data_eol
       );



the_streamer: streamer
  generic map (
        C_FAMILY                => C_FAMILY                 ,
  
        gMax_Datawidth          => 16                       ,
  
        C_M_AXIS_TDATA_WIDTH    => C_M_AXIS_TDATA_WIDTH     ,
        C_M_AXIS_TUSER_WIDTH    => C_M_AXIS_TUSER_WIDTH
  )
  port map (
        -- Control signals
        CLOCK                   => CLOCK                    ,
        RESET                   => RESET                    ,

        -- Config settings
        read_count              => read_count               ,
        write_count             => write_count              ,
        read_error              => read_error               ,
        write_error             => write_error              ,

        -- Data input
        PAR_DATA                => par_data                 ,
        PAR_DATA_VALID          => par_data_valid           ,
        PAR_DATA_SOF            => par_data_sof             ,
        PAR_DATA_EOL            => par_data_eol             ,

        streamer_full           => streamer_full            ,
        streamer_almostfull     => streamer_almostfull      ,
        streamer_empty          => streamer_empty           ,
        streamer_almostempty    => streamer_almostempty     ,
        streamer_error          => streamer_error           ,

        -- Data output
        -- Global ports
        M_AXIS_ACLK             => M_AXIS_ACLK              ,
        M_AXIS_ARESETN          => M_AXIS_ARESETN           ,
        M_AXIS_TVALID           => M_AXIS_TVALID            , -- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
        M_AXIS_TDATA            => M_AXIS_TDATA             , -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
        M_AXIS_TSTRB            => M_AXIS_TSTRB             , -- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
        M_AXIS_TKEEP            => M_AXIS_TKEEP             ,
        M_AXIS_TLAST            => M_AXIS_TLAST             , -- TLAST indicates the boundary of a packet.
        M_AXIS_TREADY           => M_AXIS_TREADY            , -- TREADY indicates that the slave can accept a transfer in the current cycle.
        M_AXIS_TUSER            => M_AXIS_TUSER
  );

fifo_status <= streamer_almostfull & streamer_full & streamer_almostempty & streamer_empty & streamer_error;

end structure;
