-------------------------------------------------------------------------------
-- MODULE      : line_buffer
--
-- DESCRIPTION : 
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Work library
library work;
use work.mtx_types_pkg.all;


entity line_buffer is
  generic (
    NUMB_LINE_BUFFER          : integer range 2 to 4 := 2;
    LINE_BUFFER_PTR_WIDTH     : integer              := 1;
    LINE_BUFFER_ADDRESS_WIDTH : integer              := 11;
    LINE_BUFFER_DATA_WIDTH    : integer              := 64;
    NUMB_LANE_PACKER          : integer              := 3;
    PIXELS_PER_LINE           : integer              := 4176;
    LINES_PER_FRAME           : integer              := 3102
    );
  port (
    sysclk : in std_logic;
    sysrst : in std_logic;

    ------------------------------------------------------------------------------------
    -- Interface name: System
    -- Description: 
    ------------------------------------------------------------------------------------
    row_id        : in std_logic_vector(11 downto 0);
--    row_last      : in std_logic;
    buffer_enable : in std_logic;
    init_frame    : in std_logic;

    ------------------------------------------------------------------------------------
    -- Interface name: Buffer control
    -- Description: 
    ------------------------------------------------------------------------------------
    nxtBuffer : in std_logic;
    clrBuffer : in std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);

    ------------------------------------------------------------------------------------
    -- Interface name: registerFileIF
    -- Description: 
    ------------------------------------------------------------------------------------
    lane_packer_req : in  std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
    lane_packer_ack : out std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
    -- buff_info_en    : in  std_logic;
    -- buff_info       : in  std_logic_vector(3 downto 0);
    buff_write      : in  std_logic;
    buff_addr       : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
    buff_data       : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

    ------------------------------------------------------------------------------------
    -- Interface name: registerFileIF
    -- Description: 
    ------------------------------------------------------------------------------------
    line_buffer_ready    : out std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
    line_buffer_read     : in  std_logic;
    line_buffer_ptr      : in  std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
    line_buffer_address  : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
    line_buffer_count    : out std_logic_vector(11 downto 0);
    line_buffer_row_id  : out std_logic_vector(11 downto 0);
    --line_buffer_row_info : out std_logic_vector(1 downto 0);
    line_buffer_data     : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
    );
end entity line_buffer;


architecture rtl of line_buffer is


  component round_robin is
    generic (NUM_REQUESTER : integer := 7);
    port (
      clk   : in  std_logic;
      rst_n : in  std_logic;
      req   : in  std_logic_vector(NUM_REQUESTER-1 downto 0);
      grant : out std_logic_vector(NUM_REQUESTER-1 downto 0)
      );
  end component;


  component dualPortRamVar is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        rdclock   : in  std_logic;
        rden      : in  std_logic := '1';
        wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        wrclock   : in  std_logic := '1';
        wren      : in  std_logic := '0';
        q         : out std_logic_vector (DATAWIDTH-1 downto 0)
        );
  end component;

  constant BUFFER_ADDRESS_WIDTH : integer := LINE_BUFFER_PTR_WIDTH+LINE_BUFFER_ADDRESS_WIDTH;

  type ROW_ID_ARRAY is array (0 to NUMB_LINE_BUFFER-1) of std_logic_vector(line_buffer_row_id'range);
  type ROW_INFO_ARRAY is array (0 to NUMB_LINE_BUFFER-1) of std_logic_vector(1 downto 0);

  signal sysrst_n         : std_logic;
  signal lane_grant       : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal write_buffer_ptr : unsigned(LINE_BUFFER_PTR_WIDTH-1 downto 0);
  signal word_cntr        : natural := 0;
  signal pixel_id         : natural := 0;
  signal buffer_row_id    : ROW_ID_ARRAY;
  signal buffer_row_info  : ROW_INFO_ARRAY;

  signal buffer_write_en      : std_logic;
  signal buffer_write_address : std_logic_vector(BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal buffer_write_data    : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

  signal buffer_read_address : std_logic_vector(BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal nxtBuffer_ff        : std_logic;

begin

  sysrst_n <= not sysrst;

  xround_robin : round_robin
    generic map(
      NUM_REQUESTER => NUMB_LANE_PACKER
      )
    port map(
      clk   => sysclk,
      rst_n => sysrst_n,
      req   => lane_packer_req,
      grant => lane_grant
      );

  lane_packer_ack <= lane_grant;


  buffer_write_en      <= buff_write;
  buffer_write_address <= std_logic_vector(write_buffer_ptr)& buff_addr;
  buffer_write_data    <= buff_data;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_write_buffer_ptr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        write_buffer_ptr <= (others => '0');
      else
        if (init_frame = '1') then
          write_buffer_ptr <= (others => '0');
        elsif (nxtBuffer = '1') then
          write_buffer_ptr <= write_buffer_ptr+1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_line_buffer_ready : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        line_buffer_ready <= (others => '0');
      else
        if (init_frame = '1') then
          line_buffer_ready <= (others => '0');
        elsif (nxtBuffer = '1') then
          for i in 0 to NUMB_LINE_BUFFER-1 loop
            if (i = to_integer(write_buffer_ptr)) then
              line_buffer_ready(i) <= '1';
            end if;
          end loop;
        else
          for i in 0 to NUMB_LINE_BUFFER-1 loop
            if (clrBuffer(i) = '1') then
              line_buffer_ready(i) <= '0';
            end if;
          end loop;
        end if;
      end if;
    end if;
  end process;




  P_nxtBuffer_ff : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        nxtBuffer_ff <= '0';
      else
        nxtBuffer_ff <= nxtBuffer;
      end if;
    end if;
  end process;




  P_word_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        word_cntr <= 0;
      else
        if (init_frame = '1') then
          word_cntr <= 0;
        elsif (buffer_write_en = '1' and line_buffer_read = '0') then
          word_cntr <= word_cntr+1;
        elsif (buffer_write_en = '0' and line_buffer_read = '1') then
          word_cntr <= word_cntr-1;
        end if;
      end if;
    end if;
  end process;




  P_buffer_row_id : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        buffer_row_id <= (others => (others => '0'));
      else
        if (nxtBuffer_ff = '1') then
          for i in 0 to NUMB_LINE_BUFFER-1 loop
            if (i = to_integer(write_buffer_ptr)) then
              buffer_row_id(i) <= row_id;
            end if;
          end loop;
        end if;
      end if;
    end if;
  end process;


  -- P_buffer_row_last : process (sysclk) is
  -- begin
  --   if (rising_edge(sysclk)) then
  --     if (sysrst = '1') then
  --       buffer_row_info <= (others => (others => '0'));
  --     else
  --       if (init_frame = '1') then
  --         -- Set the first_row flag
  --         buffer_row_info(0)(0) <= '1';
         
  --       elsif (nxtBuffer_ff = '1') then
  --         for i in 0 to NUMB_LINE_BUFFER-1 loop
           
  --           if (i = to_integer(write_buffer_ptr)) then
  --             -- Clear the last_row flag
  --             buffer_row_info(i)(0) <= '0';
              
  --             -- Set the last_row flag
  --             buffer_row_info(i)(1) <= row_last;
  --           end if;
  --         end loop;
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  xdual_port_ram : dualPortRamVar
    generic map(
      DATAWIDTH => LINE_BUFFER_DATA_WIDTH,
      ADDRWIDTH => BUFFER_ADDRESS_WIDTH
      )
    port map(
      data      => buffer_write_data,
      rdaddress => buffer_read_address,
      rdclock   => sysclk,
      rden      => line_buffer_read,
      wraddress => buffer_write_address,
      wrclock   => sysclk,
      wren      => buffer_write_en,
      q         => line_buffer_data
      );

  buffer_read_address <= line_buffer_ptr & line_buffer_address;
  line_buffer_count   <= std_logic_vector(unsigned(to_unsigned(word_cntr, line_buffer_count'length)));

  P_line_buffer_row_id : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        line_buffer_row_id <= (others => '0');
      else
        for i in 0 to NUMB_LINE_BUFFER-1 loop
          if (i = to_integer(unsigned(line_buffer_ptr))) then
            line_buffer_row_id <= buffer_row_id(i);
          end if;
        end loop;
      end if;
    end if;
  end process;




  -- P_line_buffer_row_info : process (sysclk) is
  -- begin
  --   if (rising_edge(sysclk)) then
  --     if (sysrst = '1')then
  --       line_buffer_row_info <= (others => '0');
  --     else
  --       for i in 0 to NUMB_LINE_BUFFER-1 loop
  --         if (i = to_integer(unsigned(line_buffer_ptr))) then
  --           line_buffer_row_info <= buffer_row_info(i);
  --         end if;
  --       end loop;

  --     end if;
  --   end if;
  -- end process;

end architecture rtl;
