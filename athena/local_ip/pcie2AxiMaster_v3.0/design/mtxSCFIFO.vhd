----------------------------------------------------------------------------------------
-- Name:        mtxSCFIFO
-- Type:        Module
-- Project:     Matrox Generic component
-- Description: Simple single clock domain FIFO with synchronous reset
-- Author(s):   Alain Marchand, Matrox Electronic Systems [AM]
----------------------------------------------------------------------------------------
-- History:     V0.01 [AM]
--               * initial release
----------------------------------------------------------------------------------------
-- SVN:         $Revision: 14953 $
--              $LastChangedDate: 2015-06-03 13:03:26 -0400 (Wed, 03 Jun 2015) $
--              $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/vmecpugp/mvb/design/mtxSCFIFO.vhd $
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mtxSCFIFO is
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
end mtxSCFIFO;


architecture rtl of mtxSCFIFO is

  constant NUMOFMEMWORD : integer := 2**ADDRWIDTH;

  -- Inferred RAM bloc (We rely on the synthesis tool to infer the RAM bloc)
  type   mem_type is array ((NUMOFMEMWORD-1) downto 0) of std_logic_vector(data'range);
  signal mem : mem_type;

  signal wrAddrCntr   : unsigned(ADDRWIDTH-1 downto 0);
  signal rdAddrCntr   : unsigned(ADDRWIDTH-1 downto 0);
  signal distanceCntr : natural range 0 to NUMOFMEMWORD;
  
begin


---------------------------------------------------------------------------------------
-- Synchronous Process : P_wrAddrCntr
-- clock       : clk
-- Description : Write address counter.
---------------------------------------------------------------------------------------
  P_wrAddrCntr : process(clk)
  begin
    if(rising_edge(clk)) then
      if(sclr = '1') then
        wrAddrCntr <= (others => '0');
      else
        if(wren = '1') then
          wrAddrCntr <= wrAddrCntr +1;
        end if;
      end if;
    end if;
  end process P_wrAddrCntr;


---------------------------------------------------------------------------------------
-- Synchronous Process : P_WriteData
-- clock       : clk
-- Description : Write data port.
---------------------------------------------------------------------------------------
  P_WriteData : process(clk)
  begin
    if(rising_edge(clk)) then
      if(wren = '1') then
        mem(to_integer(wrAddrCntr)) <= data;
      end if;
    end if;
  end process P_WriteData;


---------------------------------------------------------------------------------------
-- Synchronous Process : P_rdAddrCntr
-- clock       : clk
-- Description : Read address counter.
---------------------------------------------------------------------------------------
  P_rdAddrCntr : process(clk)
  begin
    if(rising_edge(clk)) then
      if(sclr = '1') then
        rdAddrCntr <= (others => '0');
      else
        if(rden = '1') then
          rdAddrCntr <= rdAddrCntr + 1;
        end if;
      end if;
    end if;
  end process P_rdAddrCntr;


---------------------------------------------------------------------------------------
-- Synchronous Process : P_ReadData
-- clock       : clk
-- Description : Read Data port.
---------------------------------------------------------------------------------------
  P_ReadData : process(clk)
  begin
    if(rising_edge(clk)) then
      if(rden = '1') then
        q <= mem(to_integer(rdAddrCntr));
      end if;
    end if;
  end process P_ReadData;


---------------------------------------------------------------------------------------
-- Synchronous Process : P_distanceCntr
-- clock       : clk
-- Description : Distance counter. Calculate the distance between the read and
-- the write pointer. This counter needs to be one bit wider than the address
-- counter since we need to handle a count from 0 to ADDRWIDTH.
---------------------------------------------------------------------------------------
  P_distanceCntr : process(clk)
  begin
    if(rising_edge(clk)) then
      if(sclr = '1') then
        distanceCntr <= 0;
      else
        if(rden = '0' and wren = '1') then
          distanceCntr <= distanceCntr + 1;
        elsif(rden = '1' and wren = '0') then
          distanceCntr <= distanceCntr - 1;
        end if;
      end if;
    end if;
  end process P_distanceCntr;


---------------------------------------------------------------------------------------
-- Asynchronous signals : full, empty, usedw
-- Description :
--
-- full:  indicates that the FIFO is full and there is no room for another write access
-- empty: indicates that the FIFO is empty and there is nothing to read.
-- usedw: indicates the number of used word in the FIFO
---------------------------------------------------------------------------------------
  full  <= '1' when (distanceCntr = NUMOFMEMWORD) else '0';
  empty <= '1' when (distanceCntr = 0)            else '0';
  usedw <= std_logic_vector(to_unsigned(distanceCntr, ADDRWIDTH+1));


---------------------------------------------------------------------------------------
-- Synchronous Process : P_FiFoError
-- clock       : clk
-- Description : FiFo error assertions. Indicates when FIFO
-- oevrrun and underrun occur (in simulation only).
---------------------------------------------------------------------------------------
  -- synthesis translate_off
  P_FiFoError : process(clk)
  begin
    if (rising_edge(clk)) then
      if ((distanceCntr = NUMOFMEMWORD) and (wren = '1')) then
        -- Error message used in simulation only
        assert false
          report "mtxSCFIFO, FIFO overrun"
          severity error;
      elsif ((distanceCntr = 0) and (rden = '1')) then
        -- Error message used in simulation only
        assert false
          report "mtxSCFIFO, FIFO underrun"
          severity error;
      end if;
    end if;
  end process P_FiFoError;
  -- synthesis translate_on 

  
end rtl;
