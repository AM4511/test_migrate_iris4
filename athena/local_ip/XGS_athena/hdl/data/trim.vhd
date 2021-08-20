-----------------------------------------------------------------------
-- MODULE        : trim
-- 
-- DESCRIPTION   : Trimming module. This module can trim data directly
--                 from a streamed frame. It support the following
--                 trimming options:
--                          * Pixel cropping in the x direction
--                          * Pixel subsampling in the X direction
--                          * Line cropping in the Y direction
--                          * Support pixels of 1,2, 4 components (8bits)
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity trim is
  generic (
    NUMB_LINE_BUFFER : integer range 2 to 4 := 2
    );
  port (
    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    aclk_grab_queue_en : in std_logic;
    aclk_load_context  : in std_logic_vector(1 downto 0);
    aclk_pixel_width   : in std_logic_vector(2 downto 0);
    aclk_x_crop_en     : in std_logic;
    aclk_x_start       : in std_logic_vector(12 downto 0);
    aclk_x_size        : in std_logic_vector(12 downto 0);
    aclk_x_scale       : in std_logic_vector(3 downto 0);
    aclk_x_reverse     : in std_logic;
    aclk_y_start       : in std_logic_vector(12 downto 0);
    aclk_y_size        : in std_logic_vector(12 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    aclk         : in std_logic;
    aclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    aclk_tready : out std_logic;
    aclk_tvalid : in  std_logic;
    aclk_tuser  : in  std_logic_vector(3 downto 0);
    aclk_tlast  : in  std_logic;
    aclk_tdata  : in  std_logic_vector(63 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    bclk         : in std_logic;
    bclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI master stream output interface
    ---------------------------------------------------------------------------
    bclk_tready : in  std_logic;
    bclk_tvalid : out std_logic;
    bclk_tuser  : out std_logic_vector(3 downto 0);
    bclk_tlast  : out std_logic;
    bclk_tdata  : out std_logic_vector(63 downto 0)
    );
end trim;


architecture rtl of trim is


  attribute mark_debug : string;
  attribute keep       : string;


  component x_trim is
    generic (
      NUMB_LINE_BUFFER : integer range 2 to 4 := 2
      );
    port (
      ---------------------------------------------------------------------------
      -- Register file
      ---------------------------------------------------------------------------
      aclk_pixel_width : in std_logic_vector(2 downto 0);
      aclk_x_crop_en   : in std_logic;
      aclk_x_start     : in unsigned(12 downto 0);
      aclk_x_size      : in unsigned(12 downto 0);
      aclk_x_scale     : in std_logic_vector(3 downto 0);
      aclk_x_reverse   : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      aclk         : in std_logic;
      aclk_reset   : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI slave stream input interface
      ---------------------------------------------------------------------------
      aclk_tready : out std_logic;
      aclk_tvalid : in  std_logic;
      aclk_tuser  : in  std_logic_vector(3 downto 0);
      aclk_tlast  : in  std_logic;
      aclk_tdata  : in  std_logic_vector(63 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      bclk         : in std_logic;
      bclk_reset_n : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI master stream output interface
      ---------------------------------------------------------------------------
      bclk_tready : in  std_logic;
      bclk_tvalid : out std_logic;
      bclk_tuser  : out std_logic_vector(3 downto 0);
      bclk_tlast  : out std_logic;
      bclk_tdata  : out std_logic_vector(63 downto 0)
      );
  end component;


  component y_trim is
    port (
      ---------------------------------------------------------------------------
      -- Register file
      ---------------------------------------------------------------------------
      aclk_y_start : in unsigned(12 downto 0);
      aclk_y_size  : in unsigned(12 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      aclk       : in std_logic;
      aclk_reset : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI slave stream input interface
      ---------------------------------------------------------------------------
      aclk_tready : out std_logic;
      aclk_tvalid : in  std_logic;
      aclk_tuser  : in  std_logic_vector(3 downto 0);
      aclk_tlast  : in  std_logic;
      aclk_tdata  : in  std_logic_vector(63 downto 0);


      ---------------------------------------------------------------------------
      -- AXI master stream output interface
      ---------------------------------------------------------------------------
      aclk_tready_out : in  std_logic;
      aclk_tvalid_out : out std_logic;
      aclk_tuser_out  : out std_logic_vector(3 downto 0);
      aclk_tlast_out  : out std_logic;
      aclk_tdata_out  : out std_logic_vector(63 downto 0)
      );
  end component;


  type STRM_CONTEXT_TYPE is record
    pixel_width : std_logic_vector(2 downto 0);
    x_crop_en   : std_logic;
    x_start     : unsigned(12 downto 0);
    x_size      : unsigned(12 downto 0);
    x_scale     : std_logic_vector(3 downto 0);
    x_reverse   : std_logic;
    y_start     : unsigned(12 downto 0);
    y_size      : unsigned(12 downto 0);
  end record STRM_CONTEXT_TYPE;


  constant INIT_STRM_CONTEXT_TYPE : STRM_CONTEXT_TYPE := (
    pixel_width => (others => '0'),
    x_crop_en   => '0',
    x_start     => (others => '0'),
    x_size      => (others => '0'),
    x_scale     => (others => '0'),
    x_reverse   => '0',
    y_start     => (others => '0'),
    y_size      => (others => '0')
    );


  -----------------------------------------------------------------------------
  -- ACLK clock domain
  -----------------------------------------------------------------------------
  signal aclk_reset           : std_logic;
  signal aclk_strm_context_in : STRM_CONTEXT_TYPE;
  signal aclk_strm_context_P0 : STRM_CONTEXT_TYPE;
  signal aclk_strm_context_P1 : STRM_CONTEXT_TYPE;
  signal aclk_strm            : STRM_CONTEXT_TYPE;
  signal aclk_ld_strm_ctx     : std_logic_vector(1 downto 0);
  signal aclk_ld_strm_ctx_FF1 : std_logic_vector(1 downto 0);
  signal aclk_ld_strm_ctx_FF2 : std_logic_vector(1 downto 0);

  signal aclk_tready_int : std_logic;
  signal aclk_tvalid_int : std_logic;
  signal aclk_tuser_int  : std_logic_vector(3 downto 0);
  signal aclk_tlast_int  : std_logic;
  signal aclk_tdata_int  : std_logic_vector(63 downto 0);


  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of aclk_tready_int    : signal is "true";


begin

  aclk_reset <= not aclk_reset_n;


  -----------------------------------------------------------------------------
  -- Remap stream context from registerfile
  -----------------------------------------------------------------------------
  aclk_strm_context_in.pixel_width <= aclk_pixel_width;       -- Units in bytes
  aclk_strm_context_in.x_crop_en   <= aclk_x_crop_en;         -- Boolean
  aclk_strm_context_in.x_start     <= unsigned(aclk_x_start); -- Units in pixels
  aclk_strm_context_in.x_size      <= unsigned(aclk_x_size);  -- Units in pixels
  aclk_strm_context_in.x_scale     <= aclk_x_scale;           -- Units in pixels
  aclk_strm_context_in.x_reverse   <= aclk_x_reverse;         -- Boolean
  aclk_strm_context_in.y_start     <= unsigned(aclk_y_start); -- Units in lines
  aclk_strm_context_in.y_size      <= unsigned(aclk_y_size);  -- Units in lines


  -----------------------------------------------------------------------------
  -- Stream context management
  --
  -- Les contextes doivent etre loades sur le rising edge du signal. Il a été allongé 
  -- a 4 clk sysclk ds le controlleur pour l'envoyer dans le domaine pclk.
  -----------------------------------------------------------------------------
  P_aclk_strm : process(aclk)
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_ld_strm_ctx_FF1 <= (others => '0');
        aclk_ld_strm_ctx_FF2 <= (others => '0');
        aclk_strm_context_P0 <= INIT_STRM_CONTEXT_TYPE;
        aclk_strm_context_P1 <= INIT_STRM_CONTEXT_TYPE;

      else
        aclk_ld_strm_ctx_FF1 <= aclk_load_context;
        aclk_ld_strm_ctx_FF2 <= aclk_ld_strm_ctx_FF1;


        -----------------------------------------------------------------------
        -- On rising edge of aclk_load_context(0) store aclk_strm_context_in
        -- in the pipelined version 0
        -----------------------------------------------------------------------
        if (aclk_ld_strm_ctx_FF2(0) = '0' and aclk_ld_strm_ctx_FF1(0) = '1') then
          aclk_strm_context_P0 <= aclk_strm_context_in;
        end if;


        -----------------------------------------------------------------------
        -- On rising edge of aclk_load_context(1) we shift the stream context
        -- of pipeline 0 to pipeline 1.
        -----------------------------------------------------------------------
        if (aclk_ld_strm_ctx_FF2(1) = '0' and aclk_ld_strm_ctx_FF1(1) = '1') then
          aclk_strm_context_P1 <= aclk_strm_context_P0;
        end if;


      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Stream context selection MUX
  -----------------------------------------------------------------------------
  aclk_strm <= aclk_strm_context_P1 when (aclk_grab_queue_en = '1') else
               aclk_strm_context_in;


  -----------------------------------------------------------------------------
  -- Module      : y_trim
  -- Description : Input module used to crop lines at the beginning and the end
  --               of a frame.
  -----------------------------------------------------------------------------
  y_trim_inst : y_trim
    port map(
      aclk_y_start    => aclk_strm.y_start,
      aclk_y_size     => aclk_strm.y_size,
      aclk            => aclk,
      aclk_reset      => aclk_reset,
      aclk_tready     => aclk_tready,
      aclk_tvalid     => aclk_tvalid,
      aclk_tuser      => aclk_tuser,
      aclk_tlast      => aclk_tlast,
      aclk_tdata      => aclk_tdata,
      aclk_tready_out => aclk_tready_int,
      aclk_tvalid_out => aclk_tvalid_int,
      aclk_tuser_out  => aclk_tuser_int,
      aclk_tlast_out  => aclk_tlast_int,
      aclk_tdata_out  => aclk_tdata_int
      );


  -----------------------------------------------------------------------------
  -- Module      : x_trim
  -- Description : 
  -----------------------------------------------------------------------------
  x_trim_inst : x_trim
    generic map(
      NUMB_LINE_BUFFER => NUMB_LINE_BUFFER
      )
    port map(
      aclk_pixel_width => aclk_strm.pixel_width,
      aclk_x_crop_en   => aclk_strm.x_crop_en,
      aclk_x_start     => aclk_strm.x_start,
      aclk_x_size      => aclk_strm.x_size,
      aclk_x_scale     => aclk_strm.x_scale,
      aclk_x_reverse   => aclk_strm.x_reverse,
      aclk             => aclk,
      aclk_reset       => aclk_reset,
      aclk_tready      => aclk_tready_int,
      aclk_tvalid      => aclk_tvalid_int,
      aclk_tuser       => aclk_tuser_int,
      aclk_tlast       => aclk_tlast_int,
      aclk_tdata       => aclk_tdata_int,
      bclk             => bclk,
      bclk_reset_n     => bclk_reset_n,
      bclk_tready      => bclk_tready,
      bclk_tvalid      => bclk_tvalid,
      bclk_tuser       => bclk_tuser,
      bclk_tlast       => bclk_tlast,
      bclk_tdata       => bclk_tdata
      );

end architecture rtl;
