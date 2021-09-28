-----------------------------------------------------------------------
-- MODULE        : dma_line_buffer
-- 
-- DESCRIPTION   : 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity dma_line_buffer is
  generic (
    BUFFER_ADDR_WIDTH     : integer := 11;  -- in bits
    BUFFER_LINE_PTR_WIDTH : integer := 3
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    sclk        : in std_logic;
    srst_n      : in std_logic;
    sclk_unpack : in std_logic;

    -- Info buffer
    sclk_info_wren     : in  std_logic;
    sclk_info_wlength  : in  std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
    sclk_info_weof     : in  std_logic;
    sclk_info_wbuff_id : in  std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);
    sclk_info_rden     : in  std_logic;
    sclk_info_rlength  : out std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
    sclk_info_reof     : out std_logic;
    sclk_info_rbuff_id : out std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);

    -- Data buffer
    sclk_wren      : in  std_logic;
    sclk_wraddress : in  std_logic_vector (BUFFER_ADDR_WIDTH-1 downto 0);
    sclk_wrdata    : in  std_logic_vector (63 downto 0);
    sclk_rden      : in  std_logic;
    sclk_rdaddress : in  std_logic_vector (BUFFER_ADDR_WIDTH-1 downto 0);
    sclk_rddata    : out std_logic_vector (63 downto 0)
    );
end dma_line_buffer;


architecture rtl of dma_line_buffer is

  attribute mark_debug : string;
  attribute keep       : string;



  component mtxSCFIFO is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        clk   : in  std_logic;
        sclr  : in  std_logic;
        wren  : in  std_logic;
        data  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rden  : in  std_logic;
        q     : out std_logic_vector (DATAWIDTH-1 downto 0);
        usedw : out std_logic_vector (ADDRWIDTH downto 0);
        empty : out std_logic;
        full  : out std_logic
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

  constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - 2);
  constant INFO_WIDTH            : integer := 16;

  type QWORD_ARRAY is array (natural range <>) of std_logic_vector (63 downto 0);
  signal srst                      : std_logic;
  signal sclk_buffer_read_address  : std_logic_vector(BUFFER_WORD_PTR_WIDTH-1 downto 0);
  signal sclk_buffer_write_address : std_logic_vector(BUFFER_WORD_PTR_WIDTH-1 downto 0);
  signal sclk_buffer_read_en       : std_logic_vector(3 downto 0);
  signal sclk_buffer_write_en      : std_logic_vector(3 downto 0);
  signal sclk_rdaddress_P1         : std_logic_vector(sclk_rdaddress'range);
  signal sclk_buffer_read_data_mux : QWORD_ARRAY(3 downto 0);
  signal sclk_info_wrdata          : std_logic_vector(INFO_WIDTH-1 downto 0);
  signal sclk_info_rddata          : std_logic_vector(INFO_WIDTH-1 downto 0);


  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  --attribute mark_debug of wr_state                 : signal is "true";


begin
  srst <= not srst_n;


  x_buff_info : mtxSCFIFO
    generic map(
      DATAWIDTH => INFO_WIDTH,
      ADDRWIDTH => 2
      )
    port map (
      clk   => sclk,
      sclr  => srst,
      wren  => sclk_info_wren,
      data  => sclk_info_wrdata,
      rden  => sclk_info_rden,
      q     => sclk_info_rddata,
      usedw => open,
      empty => open,
      full  => open
      );

  sclk_info_wrdata(BUFFER_ADDR_WIDTH-1 downto 0)                                       <= sclk_info_wlength;
  sclk_info_wrdata(BUFFER_ADDR_WIDTH)                                                  <= sclk_info_weof;
  sclk_info_wrdata(BUFFER_ADDR_WIDTH+BUFFER_LINE_PTR_WIDTH downto BUFFER_ADDR_WIDTH+1) <= sclk_info_wbuff_id;

  sclk_info_rlength  <= sclk_info_rddata(BUFFER_ADDR_WIDTH-1 downto 0);
  sclk_info_reof     <= sclk_info_rddata(BUFFER_ADDR_WIDTH);
  sclk_info_rbuff_id <= sclk_info_rddata(BUFFER_ADDR_WIDTH+BUFFER_LINE_PTR_WIDTH downto BUFFER_ADDR_WIDTH+1);

  -----------------------------------------------------------------------------
  -- Word address
  -----------------------------------------------------------------------------
  sclk_buffer_write_address <= sclk_wraddress(sclk_wraddress'left downto 2);


  -----------------------------------------------------------------------------
  -- 4 buffers in parallel
  -----------------------------------------------------------------------------
  G_line_buffer : for i in 0 to 3 generate

    sclk_buffer_write_en(i) <= sclk_wren when (unsigned(sclk_wraddress(1 downto 0)) = i) else
                               '0';

    xdual_port_ram : dualPortRamVar
      generic map(
        DATAWIDTH => 64,
        ADDRWIDTH => BUFFER_WORD_PTR_WIDTH
        )
      port map(
        data      => sclk_wrdata,
        rdaddress => sclk_buffer_read_address,
        rdclock   => sclk,
        rden      => sclk_buffer_read_en(i),
        wraddress => sclk_buffer_write_address,
        wrclock   => sclk,
        wren      => sclk_buffer_write_en(i),
        q         => sclk_buffer_read_data_mux(i)
        );

    sclk_buffer_read_en(i) <= sclk_rden;

  end generate G_line_buffer;


  -----------------------------------------------------------------------------
  -- Process     : sclk_rdaddress_P1
  -- Description : Pipeline version of sclk_rdaddress_P1
  -----------------------------------------------------------------------------
  P_sclk_rdaddress_P1 : process(sclk)
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        sclk_rdaddress_P1 <= (others => '0');
      else
        if (sclk_rden = '1') then
          sclk_rdaddress_P1 <= sclk_rdaddress;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_rddata
  -- Description : Pack data per component or per pixel according to the
  --               sclk_unpack input flag.
  -----------------------------------------------------------------------------
  P_sclk_rddata : process (sclk_unpack, sclk_rdaddress, sclk_buffer_read_data_mux) is
  begin
    ---------------------------------------------------------------------------
    -- Unpacking BGR Data
    ---------------------------------------------------------------------------
    if (sclk_unpack = '1') then
      sclk_buffer_read_address <= sclk_rdaddress(BUFFER_WORD_PTR_WIDTH-1 downto 0);

      case sclk_rdaddress_P1(11 downto 10) is
        -----------------------------------------------------------------------
        -- Extract QWORDs of Component 0
        -----------------------------------------------------------------------
        when "00" =>
          sclk_rddata(7 downto 0)   <= sclk_buffer_read_data_mux(0)(7 downto 0);
          sclk_rddata(15 downto 8)  <= sclk_buffer_read_data_mux(0)(39 downto 32);
          sclk_rddata(23 downto 16) <= sclk_buffer_read_data_mux(1)(7 downto 0);
          sclk_rddata(31 downto 24) <= sclk_buffer_read_data_mux(1)(39 downto 32);
          sclk_rddata(39 downto 32) <= sclk_buffer_read_data_mux(2)(7 downto 0);
          sclk_rddata(47 downto 40) <= sclk_buffer_read_data_mux(2)(39 downto 32);
          sclk_rddata(55 downto 48) <= sclk_buffer_read_data_mux(3)(7 downto 0);
          sclk_rddata(63 downto 56) <= sclk_buffer_read_data_mux(3)(39 downto 32);

        -----------------------------------------------------------------------
        -- Extract QWORDs of Component 1
        -----------------------------------------------------------------------
        when "01" =>
          sclk_rddata(7 downto 0)   <= sclk_buffer_read_data_mux(0)(7 downto 0);
          sclk_rddata(15 downto 8)  <= sclk_buffer_read_data_mux(0)(39 downto 32);
          sclk_rddata(23 downto 16) <= sclk_buffer_read_data_mux(1)(7 downto 0);
          sclk_rddata(31 downto 24) <= sclk_buffer_read_data_mux(1)(39 downto 32);
          sclk_rddata(39 downto 32) <= sclk_buffer_read_data_mux(2)(7 downto 0);
          sclk_rddata(47 downto 40) <= sclk_buffer_read_data_mux(2)(39 downto 32);
          sclk_rddata(55 downto 48) <= sclk_buffer_read_data_mux(3)(7 downto 0);
          sclk_rddata(63 downto 56) <= sclk_buffer_read_data_mux(3)(39 downto 32);

        -----------------------------------------------------------------------
        -- Extract QWORDs of Component 2
        -----------------------------------------------------------------------
        when "10" =>
          sclk_rddata(7 downto 0)   <= sclk_buffer_read_data_mux(0)(7 downto 0);
          sclk_rddata(15 downto 8)  <= sclk_buffer_read_data_mux(0)(39 downto 32);
          sclk_rddata(23 downto 16) <= sclk_buffer_read_data_mux(1)(7 downto 0);
          sclk_rddata(31 downto 24) <= sclk_buffer_read_data_mux(1)(39 downto 32);
          sclk_rddata(39 downto 32) <= sclk_buffer_read_data_mux(2)(7 downto 0);
          sclk_rddata(47 downto 40) <= sclk_buffer_read_data_mux(2)(39 downto 32);
          sclk_rddata(55 downto 48) <= sclk_buffer_read_data_mux(3)(7 downto 0);
          sclk_rddata(63 downto 56) <= sclk_buffer_read_data_mux(3)(39 downto 32);

        when others =>
          null;
      end case;

    ---------------------------------------------------------------------------
    -- Continuous data (Mono8 or Color packed). Linear memory configuration
    ---------------------------------------------------------------------------
    else

      sclk_buffer_read_address <= sclk_rdaddress(sclk_rdaddress'left downto 2);

      case sclk_rdaddress_P1(1 downto 0) is
        -----------------------------------------------------------------------
        -- QWORD 0
        -----------------------------------------------------------------------
        when "00" =>
          sclk_rddata <= sclk_buffer_read_data_mux(0);

        -----------------------------------------------------------------------
        -- QWORD 1
        -----------------------------------------------------------------------
        when "01" =>
          sclk_rddata <= sclk_buffer_read_data_mux(1);
        -----------------------------------------------------------------------
        -- QWORD 2
        -----------------------------------------------------------------------
        when "10" =>
          sclk_rddata <= sclk_buffer_read_data_mux(2);

        -----------------------------------------------------------------------
        -- QWORD 3
        -----------------------------------------------------------------------
        when "11" =>
          sclk_rddata <= sclk_buffer_read_data_mux(3);
        when others =>
          null;
      end case;

    end if;
  end process P_sclk_rddata;

end rtl;

