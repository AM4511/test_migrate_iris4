-----------------------------------------------------------------------
-- MODULE        : dma_line_buffer
-- 
-- DESCRIPTION   : Line buffer of the DMA engine
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity dma_line_buffer is
  generic (
    DMA_ADDR_WIDTH        : integer := 11;  -- in bits
    BUFFER_LINE_PTR_WIDTH : integer := 2;
    BUFFER_ADDR_WIDTH     : integer := 13
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
    sclk_info_wlength  : in  std_logic_vector(DMA_ADDR_WIDTH-1 downto 0);
    sclk_info_weof     : in  std_logic;
    sclk_info_wbuff_id : in  std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);
    sclk_info_rden     : in  std_logic;
    sclk_info_rlength  : out std_logic_vector(DMA_ADDR_WIDTH-1 downto 0);
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

  constant BUFFER_WORD_PTR_WIDTH : integer := BUFFER_ADDR_WIDTH-2;
  constant INFO_WIDTH            : integer := BUFFER_LINE_PTR_WIDTH+DMA_ADDR_WIDTH+1;

  type QWORD_ARRAY is array (natural range <>) of std_logic_vector (63 downto 0);
  signal srst                      : std_logic;
  signal sclk_buffer_read_address  : std_logic_vector(BUFFER_WORD_PTR_WIDTH-1 downto 0);
  signal sclk_buffer_write_address : std_logic_vector(BUFFER_WORD_PTR_WIDTH-1 downto 0);
  signal sclk_buffer_read_en       : std_logic_vector(3 downto 0);
  signal sclk_buffer_write_en      : std_logic_vector(3 downto 0);
  signal sck_output_mux_sel        : std_logic_vector(1 downto 0);
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

  sclk_info_wrdata(DMA_ADDR_WIDTH-1 downto 0)                                    <= sclk_info_wlength;
  sclk_info_wrdata(DMA_ADDR_WIDTH)                                               <= sclk_info_weof;
  sclk_info_wrdata(DMA_ADDR_WIDTH+BUFFER_LINE_PTR_WIDTH downto DMA_ADDR_WIDTH+1) <= sclk_info_wbuff_id;

  sclk_info_rlength  <= sclk_info_rddata(DMA_ADDR_WIDTH-1 downto 0);
  sclk_info_reof     <= sclk_info_rddata(DMA_ADDR_WIDTH);
  sclk_info_rbuff_id <= sclk_info_rddata(DMA_ADDR_WIDTH+BUFFER_LINE_PTR_WIDTH downto DMA_ADDR_WIDTH+1);

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
  -- Change read buffer address scheme depending if we are in planar mode or
  -- in packed mode.
  --
  -- Planar mode:
  --
  -- sclk_buffer_read_address(10:9) : sclk_rdaddress(12:11)# Line buffer pointer (4 line buffers)
  -- sclk_buffer_read_address(8:0)  : sclk_rdaddress(8:0)  # DMA word address (1 Word = 4x64 bits)
  -- sck_output_mux_sel(1:0)        : sclk_rdaddress(10:9) # Plane selection
  --
  -- Packed mode:
  --
  -- sclk_buffer_read_address(10:9) : sclk_rdaddress(12:11) # Line buffer pointer (4 line buffers)
  -- sclk_buffer_read_address(8:0)  : sclk_rdaddress(12:2)  # DMA word address (1 Word = 4x64 bits)
  -- sck_output_mux_sel(1:0)        : sclk_rdaddress(1:0)   # Packed pixel QWORD selection
  -----------------------------------------------------------------------------
  sclk_buffer_read_address <= sclk_rdaddress(sclk_rdaddress'left downto sclk_rdaddress'left-1) & sclk_rdaddress(8 downto 0) when (sclk_unpack = '1') else
                              sclk_rdaddress(sclk_rdaddress'left downto 2);


  -----------------------------------------------------------------------------
  -- Process     : P_sck_output_mux_sel
  -- Description : Multiplexor selector for the P_sclk_rddata process
  -----------------------------------------------------------------------------
  P_sck_output_mux_sel : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0') then
        sck_output_mux_sel <= (others => '0');
      else
        if (sclk_rden = '1') then
          if (sclk_unpack = '1') then
            sck_output_mux_sel <= sclk_rdaddress(10 downto 9);
          else
            sck_output_mux_sel <= sclk_rdaddress(1 downto 0);
          end if;
        end if;
      end if;
    end if;
  end process P_sck_output_mux_sel;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_rddata
  -- Description : Extract data per component or per pixel according to the
  --               sclk_unpack input flag.
  -----------------------------------------------------------------------------
  P_sclk_rddata : process (sclk_unpack, sck_output_mux_sel, sclk_buffer_read_data_mux) is
  begin
    ---------------------------------------------------------------------------
    -- Unpacking BGR Data to planar
    ---------------------------------------------------------------------------
    if (sclk_unpack = '1') then

      -------------------------------------------------------------------------
      -- Use the base address of the plane to de-interlace (de-pack) data
      -------------------------------------------------------------------------
      case sck_output_mux_sel is
        -----------------------------------------------------------------------
        -- Extract QWORDs of Component 0
        -----------------------------------------------------------------------
        when "00" =>
          sclk_rddata(7 downto 0)   <= sclk_buffer_read_data_mux(0)(7 downto 0);    -- Byte 0
          sclk_rddata(15 downto 8)  <= sclk_buffer_read_data_mux(0)(39 downto 32);  -- Byte 4
          sclk_rddata(23 downto 16) <= sclk_buffer_read_data_mux(1)(7 downto 0);    -- Byte 8
          sclk_rddata(31 downto 24) <= sclk_buffer_read_data_mux(1)(39 downto 32);  -- Byte 12
          sclk_rddata(39 downto 32) <= sclk_buffer_read_data_mux(2)(7 downto 0);    -- Byte 16
          sclk_rddata(47 downto 40) <= sclk_buffer_read_data_mux(2)(39 downto 32);  -- Byte 20
          sclk_rddata(55 downto 48) <= sclk_buffer_read_data_mux(3)(7 downto 0);    -- Byte 24
          sclk_rddata(63 downto 56) <= sclk_buffer_read_data_mux(3)(39 downto 32);  -- Byte 28

        -----------------------------------------------------------------------
        -- Extract QWORDs of Component 1
        -----------------------------------------------------------------------
        when "01" =>
          sclk_rddata(7 downto 0)   <= sclk_buffer_read_data_mux(0)(15 downto 8);   -- Byte 1
          sclk_rddata(15 downto 8)  <= sclk_buffer_read_data_mux(0)(47 downto 40);  -- Byte 5
          sclk_rddata(23 downto 16) <= sclk_buffer_read_data_mux(1)(15 downto 8);   -- Byte 9
          sclk_rddata(31 downto 24) <= sclk_buffer_read_data_mux(1)(47 downto 40);  -- Byte 13
          sclk_rddata(39 downto 32) <= sclk_buffer_read_data_mux(2)(15 downto 8);   -- Byte 17
          sclk_rddata(47 downto 40) <= sclk_buffer_read_data_mux(2)(47 downto 40);  -- Byte 21
          sclk_rddata(55 downto 48) <= sclk_buffer_read_data_mux(3)(15 downto 8);   -- Byte 25
          sclk_rddata(63 downto 56) <= sclk_buffer_read_data_mux(3)(47 downto 40);  -- Byte 29

        -----------------------------------------------------------------------
        -- Extract QWORDs of Component 2
        -----------------------------------------------------------------------
        when "10" =>
          sclk_rddata(7 downto 0)   <= sclk_buffer_read_data_mux(0)(23 downto 16);  -- Byte 2
          sclk_rddata(15 downto 8)  <= sclk_buffer_read_data_mux(0)(55 downto 48);  -- Byte 6
          sclk_rddata(23 downto 16) <= sclk_buffer_read_data_mux(1)(23 downto 16);  -- Byte 10
          sclk_rddata(31 downto 24) <= sclk_buffer_read_data_mux(1)(55 downto 48);  -- Byte 14
          sclk_rddata(39 downto 32) <= sclk_buffer_read_data_mux(2)(23 downto 16);  -- Byte 18
          sclk_rddata(47 downto 40) <= sclk_buffer_read_data_mux(2)(55 downto 48);  -- Byte 22
          sclk_rddata(55 downto 48) <= sclk_buffer_read_data_mux(3)(23 downto 16);  -- Byte 26
          sclk_rddata(63 downto 56) <= sclk_buffer_read_data_mux(3)(55 downto 48);  -- Byte 30

        when others =>
          null;
      end case;

    ---------------------------------------------------------------------------
    -- Continuous data (Mono8 or Color packed). Linear memory configuration
    ---------------------------------------------------------------------------
    else


      case sck_output_mux_sel is
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

