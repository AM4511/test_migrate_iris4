-----------------------------------------------------------------------
-- 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.dma_pack.all;

entity dmawr2tlp is
  generic (
    NUMBER_OF_PLANE       : integer range 1 to 3 := 1;
    READ_ADDRESS_MSB      : integer := 10;
    MAX_PCIE_PAYLOAD_SIZE : integer := 128;
    AXIS_DATA_WIDTH       : integer := 64
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    sys_clk     : in std_logic;
    sys_reset_n : in std_logic;

    ---------------------------------------------------------------------
    -- IRQ I/F
    ---------------------------------------------------------------------
    intevent : out std_logic;

    ---------------------------------------------------------------------
    -- RegisterFile I/F
    ---------------------------------------------------------------------
    -- write address channel
    s_axi_awaddr  : in  std_logic_vector(8 downto 0);
    s_axi_awvalid : in  std_logic;
    s_axi_awready : out std_logic;

    -- write data channel
    s_axi_wdata  : in  std_logic_vector(63 downto 0);
    s_axi_wstrb  : in  std_logic_vector((64/8)-1 downto 0);  --This signal indicates which byte lanes to update in memory.
    s_axi_wvalid : in  std_logic;
    s_axi_wready : out std_logic;

    -- write response channel
    s_axi_bresp  : out std_logic_vector(1 downto 0);
    s_axi_bvalid : out std_logic;
    s_axi_bready : in  std_logic;

    -- read address channel
    s_axi_araddr  : in  std_logic_vector(8 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;

    -- read data channel
    s_axi_rdata  : out std_logic_vector(63 downto 0);
    s_axi_rresp  : out std_logic_vector(1 downto 0);
    s_axi_rvalid : out std_logic;
    s_axi_rready : in  std_logic;


    ----------------------------------------------------
    -- AXI stream interface (Slave port)
    ----------------------------------------------------
    s_axis_tready : out std_logic;
    s_axis_tdest  : in  std_logic_vector(7 downto 0);
    s_axis_tdata  : in  std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
    s_axis_tkeep  : in  std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0);
    s_axis_tlast  : in  std_logic;
    s_axis_tuser  : in  std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0);
    s_axis_tvalid : in  std_logic;


    ---------------------------------------------------------------------
    -- Configuration space info (sys_clk)
    ---------------------------------------------------------------------
    cfg_bus_mast_en : in std_logic;
    cfg_setmaxpld   : in std_logic_vector(2 downto 0);

    ---------------------------------------------------------------------
    -- TLP Interface
    ---------------------------------------------------------------------
    tlp_out_req_to_send : out std_logic;
    tlp_out_grant       : in  std_logic;

    tlp_out_fmt_type     : out std_logic_vector(6 downto 0);
    tlp_out_length_in_dw : out std_logic_vector(9 downto 0);

    tlp_out_src_rdy_n : out std_logic;
    tlp_out_dst_rdy_n : in  std_logic;
    tlp_out_data      : out std_logic_vector(63 downto 0);

    -- for master request transmit
    tlp_out_address     : out std_logic_vector(63 downto 2);
    tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_out_attr           : out std_logic_vector(1 downto 0);
    tlp_out_transaction_id : out std_logic_vector(23 downto 0);
    tlp_out_byte_count     : out std_logic_vector(12 downto 0);
    tlp_out_lower_address  : out std_logic_vector(6 downto 0)

    );
end dmawr2tlp;


architecture rtl of dmawr2tlp is


  component dma_write is
    generic (
      NUMBER_OF_PLANE       : integer range 1 to 3 := 1;
      READ_ADDRESS_MSB      : integer := 10;  -- doit etre ajuste en fonction de la ligne maximale. 4095 pixel x BGR32 = 16kB = 2k * 8 bytes 
      MAX_PCIE_PAYLOAD_SIZE : integer := 128  -- ceci sert a limiter la dimension maximale que les agents master sur le pcie (le DMA) peuvent utiliser, en plus de la limitation

      );
    port (
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- Configuration space info (sys_clk)
      ---------------------------------------------------------------------
      cfg_bus_mast_en : in std_logic;
      cfg_setmaxpld   : in std_logic_vector(2 downto 0);

      ---------------------------------------------------------------------
      -- PCIe tx (sys_clk)
      ---------------------------------------------------------------------
      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send : out std_logic;
      tlp_out_grant       : in  std_logic;

      tlp_out_fmt_type     : out std_logic_vector(6 downto 0);  -- fmt and type field 
      tlp_out_length_in_dw : out std_logic_vector(9 downto 0);

      tlp_out_src_rdy_n : out std_logic;
      tlp_out_dst_rdy_n : in  std_logic;
      tlp_out_data      : out std_logic_vector(63 downto 0);

      -- for master request transmit
      tlp_out_address     : out std_logic_vector(63 downto 2);
      tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
      tlp_out_lower_address  : out std_logic_vector(6 downto 0);

      -- DMA transfer parameters
      host_number_of_plane : in integer;
      host_write_address   : in HOST_ADDRESS_ARRAY(NUMBER_OF_PLANE-1 downto 0);
      host_line_pitch      : in std_logic_vector(15 downto 0);
      host_line_size       : in std_logic_vector(13 downto 0);
      host_reverse_y       : in std_logic;  -- ecrire a l'envers.

      -- To Sensor interface, grab abort logic
      dma_idle       : out std_logic;
      dma_pcie_state : out std_logic_vector(2 downto 0);  -- pour debug seulement

      -- Interface to read data, on read_clk
      start_of_frame  : in  std_logic;  -- repart l'ecriture au host_write_address, repart la lecture a l'adresse 0 de la ram partagee
      line_ready      : in  std_logic;  -- indique qu'une ligne est disponible dans la RAM partagee
      line_transfered : out std_logic;  -- indique que la ligne signalée par line_ready est maintenant consumée (transférée au host)
      end_of_dma      : in  std_logic;

      read_enable_out : buffer std_logic;
      read_address    : buffer std_logic_vector(READ_ADDRESS_MSB downto 0);  -- buffers 2k x 8 bytes hardcode pour l'instant
      read_data       : in     std_logic_vector(63 downto 0)
      );
  end component;


  signal host_number_of_plane :  integer;
  signal host_write_address   :  HOST_ADDRESS_ARRAY(NUMBER_OF_PLANE-1 downto 0);
  signal host_line_pitch      :  std_logic_vector(15 downto 0);
  signal host_line_size       :  std_logic_vector(13 downto 0);
  signal host_reverse_y       :  std_logic;
  signal dma_idle             :  std_logic;
  signal dma_pcie_state       :  std_logic_vector(2 downto 0);
  signal start_of_frame       :  std_logic;
  signal line_ready           :  std_logic;
  signal line_transfered      :  std_logic;
  signal end_of_dma           :  std_logic;
  signal read_enable_out      :  std_logic;
  signal read_address         :  std_logic_vector(READ_ADDRESS_MSB downto 0);
  signal read_data            :  std_logic_vector(63 downto 0);



begin

  xdma_write : dma_write
    generic map(
      NUMBER_OF_PLANE       => NUMBER_OF_PLANE,
      READ_ADDRESS_MSB      => READ_ADDRESS_MSB,
      MAX_PCIE_PAYLOAD_SIZE => MAX_PCIE_PAYLOAD_SIZE
      )
    port map(
      sys_clk                => sys_clk,
      sys_reset_n            => sys_reset_n,
      cfg_bus_mast_en        => cfg_bus_mast_en,
      cfg_setmaxpld          => cfg_setmaxpld,
      tlp_out_req_to_send    => tlp_out_req_to_send,
      tlp_out_grant          => tlp_out_grant,
      tlp_out_fmt_type       => tlp_out_fmt_type,
      tlp_out_length_in_dw   => tlp_out_length_in_dw,
      tlp_out_src_rdy_n      => tlp_out_src_rdy_n,
      tlp_out_dst_rdy_n      => tlp_out_dst_rdy_n,
      tlp_out_data           => tlp_out_data,
      tlp_out_address        => tlp_out_address,
      tlp_out_ldwbe_fdwbe    => tlp_out_ldwbe_fdwbe,
      tlp_out_attr           => tlp_out_attr,
      tlp_out_transaction_id => tlp_out_transaction_id,
      tlp_out_byte_count     => tlp_out_byte_count,
      tlp_out_lower_address  => tlp_out_lower_address,
      host_number_of_plane   => host_number_of_plane,
      host_write_address     => host_write_address,
      host_line_pitch        => host_line_pitch,
      host_line_size         => host_line_size,
      host_reverse_y         => host_reverse_y,
      dma_idle               => dma_idle,
      dma_pcie_state         => dma_pcie_state,
      start_of_frame         => start_of_frame,
      line_ready             => line_ready,
      line_transfered        => line_transfered,
      end_of_dma             => end_of_dma,
      read_enable_out        => read_enable_out,
      read_address           => read_address,
      read_data              => read_data
      );

end rtl;

