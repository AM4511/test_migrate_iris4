library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Work library
library work;
use work.mtx_types_pkg.all;


entity multi_line_buffer is
  generic (
    NUMB_LINE_BUFFER          : integer := 3;
    LINE_BUFFER_ADDRESS_WIDTH : integer := 11;
    LINE_BUFFER_DATA_WIDTH    : integer := 64;
    NUMB_LANE_PACKER          : integer := 3;
    PIXELS_PER_LINE           : integer := 4176;
    LINES_PER_FRAME           : integer := 3102
    );
  port (
    sysclk : in std_logic;
    sysrst : in std_logic;

    ------------------------------------------------------------------------------------
    -- Interface name: System
    -- Description: 
    ------------------------------------------------------------------------------------
    row_id        : in std_logic_vector(11 downto 0);
    buffer_enable : in std_logic;

    ------------------------------------------------------------------------------------
    -- Interface name: 
    -- Description: 
    ------------------------------------------------------------------------------------
    buffer_init : in std_logic;
    w_buffer_incr : in std_logic;
    -- r_buffer_init : in std_logic;
    -- r_buffer_incr : in std_logic;

    ------------------------------------------------------------------------------------
    -- Interface name: Line buffer write interface
    -- Description: 
    ------------------------------------------------------------------------------------
    lane_packer_req : in  std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
    lane_packer_ack : out std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
    buff_write      : in  std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
    buff_addr       : in  std11_logic_vector(NUMB_LANE_PACKER-1 downto 0);
    buff_data       : in  std64_logic_vector(NUMB_LANE_PACKER-1 downto 0);

    ------------------------------------------------------------------------------------
    -- Interface name:  Line buffer read interface
    -- Description: 
    ------------------------------------------------------------------------------------
    line_buffer_id      : in  std_logic_vector(1 downto 0);
    line_buffer_read    : in  std_logic;
    line_buffer_address : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
    line_buffer_count   : out std_logic_vector(11 downto 0);
    line_buffer_line_id : out std_logic_vector(11 downto 0);
    line_buffer_data    : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
    );
end entity multi_line_buffer;


architecture rtl of multi_line_buffer is


  component line_buffer is
    generic (
      LINE_BUFFER_ID            : integer := 0;
      LINE_BUFFER_ADDRESS_WIDTH : integer := 11;
      LINE_BUFFER_DATA_WIDTH    : integer := 64;
      NUMB_LANE_PACKER          : integer := 3;
      PIXELS_PER_LINE           : integer := 4176;
      LINES_PER_FRAME           : integer := 3102
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      ------------------------------------------------------------------------------------
      -- Interface name: System
      -- Description: 
      ------------------------------------------------------------------------------------
      row_id        : in std_logic_vector(11 downto 0);
      buffer_enable : in std_logic;
      init          : in std_logic;

      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      lane_packer_req : in  std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
      lane_packer_ack : out std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
      buff_write      : in  std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
      buff_addr       : in  std11_logic_vector(NUMB_LANE_PACKER-1 downto 0);
      buff_data       : in  std64_logic_vector(NUMB_LANE_PACKER-1 downto 0);


      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      line_buffer_read    : in  std_logic;
      line_buffer_address : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      line_buffer_count   : out std_logic_vector(11 downto 0);
      line_buffer_line_id : out std_logic_vector(11 downto 0);
      line_buffer_data    : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
      );
  end component;


  signal wbuffer_init   : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal wbuffer_enable : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);

  signal wlane_packer_req     : std3_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal wlane_packer_ack     : std3_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal wbuff_write          : std3_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal rline_buffer_count   : std12_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal rline_buffer_line_id : std12_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal rline_buffer_read    : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal rline_buffer_address : std_logic_vector(10 downto 0);
  signal rline_buffer_data    : std64_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal w_buffer_iptr        : integer range 0 to NUMB_LINE_BUFFER-1 := 0;
  signal r_buffer_iptr        : integer range 0 to NUMB_LINE_BUFFER-1 := 0;


begin


  P_w_buffer_iptr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        w_buffer_iptr <= 0;
      else
        if (buffer_init = '1') then
          w_buffer_iptr <= 0;
        elsif (w_buffer_incr = '1') then
          -- wrap around
          if (w_buffer_iptr = NUMB_LINE_BUFFER-1) then
            w_buffer_iptr <= 0;
          else
            w_buffer_iptr <= w_buffer_iptr+1;
          end if;
        end if;
      end if;
    end if;
  end process;




  G_linebuffer : for i in 0 to NUMB_LINE_BUFFER-1 generate

    -- wbuffer_init(i) <= init when (i = w_buffer_iptr) else
    --                    '0';

    wlane_packer_req(i) <= lane_packer_req when (i = w_buffer_iptr) else
                           (others => '0');

    wbuff_write(i) <= buff_write when (i = w_buffer_iptr) else
                      (others => '0');

    lane_packer_ack <= wlane_packer_ack(w_buffer_iptr);



    

    xline_buffer : line_buffer
      generic map(
        LINE_BUFFER_ID            => i,
        LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH,
        LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
        NUMB_LANE_PACKER          => NUMB_LANE_PACKER,
        PIXELS_PER_LINE           => PIXELS_PER_LINE,
        LINES_PER_FRAME           => LINES_PER_FRAME
        )
      port map(
        sysclk              => sysclk,
        sysrst              => sysrst,
        row_id              => row_id,
        buffer_enable       => buffer_enable,
        init                => wbuffer_init(i),
        lane_packer_req     => wlane_packer_req(i),
        lane_packer_ack     => wlane_packer_ack(i),
        buff_write          => wbuff_write(i),
        buff_addr           => buff_addr,
        buff_data           => buff_data,
        line_buffer_count   => rline_buffer_count(i),
        line_buffer_line_id => rline_buffer_line_id(i),
        line_buffer_read    => rline_buffer_read(i),
        line_buffer_address => rline_buffer_address,
        line_buffer_data    => rline_buffer_data(i)
        );



    rline_buffer_read(i) <= line_buffer_read when (i = r_buffer_iptr) else
                            '0';

    rline_buffer_address <= line_buffer_address;


    line_buffer_count <= rline_buffer_count(r_buffer_iptr);

    line_buffer_line_id <= rline_buffer_line_id(r_buffer_iptr);

    line_buffer_data <= rline_buffer_data(r_buffer_iptr);

  end generate G_linebuffer;

  r_buffer_iptr <= to_integer(unsigned(line_buffer_id));


end architecture rtl;
