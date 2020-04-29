
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xil_pcie_reg_fifo is
  port (
    clk        : in  std_logic;
    srst       : in  std_logic;
    din        : in  std_logic_vector(35 downto 0);
    wr_en      : in  std_logic;
    rd_en      : in  std_logic;
    dout       : out std_logic_vector(35 downto 0);
    full       : out std_logic;
    overflow   : out std_logic;
    empty      : out std_logic;
    underflow  : out std_logic;
    data_count : out std_logic_vector(9 downto 0);
    prog_full  : out std_logic
    );
end entity;

architecture mtx_ip_wrapper of xil_pcie_reg_fifo is


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



begin


  xmtxSCFIFO : mtxSCFIFO
    generic map
    (
      DATAWIDTH => 36,
      ADDRWIDTH => 9
      )
    port map
    (
      clk   => clk,
      sclr  => srst,
      wren  => wr_en,
      data  => din,
      rden  => rd_en,
      q     => dout,
      usedw => data_count,
      empty => empty,
      full  => prog_full
      );

  underflow <= '0';

end mtx_ip_wrapper;
