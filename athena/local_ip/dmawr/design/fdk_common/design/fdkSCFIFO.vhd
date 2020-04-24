----------------------------------------------------------------------------------------
-- Name:        fdkSCFIFO
-- Type:        Module
-- Project:     CameraLinkHS Frame grabber reference design
-- Description: Simple single clock domain FIFO with synchronous reset
-- Author(s):   Alain Marchand, Matrox Electronic Systems [AM]
----------------------------------------------------------------------------------------
-- History:     V0.01 [AM]
--               * initial release
----------------------------------------------------------------------------------------
-- SVN:         $Revision: 1452 $
--              $LastChangedDate: 2012-09-27 11:46:32 -0400 (Thu, 27 Sep 2012) $
--              $HeadURL: https://standards.svn.cvsdude.com/cameralinkhs/trunk/ipcore/refdesign/frameGrabber/fdkPixelExpander.vhd $
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- synthesis translate_off
library xpm;
  use xpm.vcomponents.all;
-- synthesis translate_on 

entity fdkSCFIFO is
  generic
    (
      FPGA_ARCH : string  := "ALTERA" ; -- ALTERA, XILINX_KU
      DATAWIDTH : integer := 32;
      ADDRWIDTH : integer := 8
      );
  port
    (
      clk   : in  std_logic;
      sclr  : in  std_logic;
      wren  : in  std_logic;
      data  : in  std_logic_vector (DATAWIDTH-1 downto 0);
      rden  : in  std_logic;
      q     : out std_logic_vector (DATAWIDTH-1 downto 0);
      usedw : out std_logic_vector (ADDRWIDTH-1 downto 0);
      empty : out std_logic;
      full  : out std_logic
      );
end fdkSCFIFO;

architecture rtl of fdkSCFIFO is
  
  component altera_fdkscfifo is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 8
        );
    port
      (
        clock : in  std_logic;
        data  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rdreq : in  std_logic;
        wrreq : in  std_logic;
        empty : out std_logic;
        full  : out std_logic;
        q     : out std_logic_vector (DATAWIDTH-1 downto 0);
        usedw : out std_logic_vector (ADDRWIDTH-1 downto 0)
        );
  end component;

  signal full_int  : std_logic;
  signal empty_int : std_logic;

begin


  gen_altera_scfifo : if FPGA_ARCH = "ALTERA" generate
     xaltera_scfifo : altera_fdkscfifo
       generic
       map (
         DATAWIDTH => DATAWIDTH,
         ADDRWIDTH => ADDRWIDTH
         )
       port
       map(
         clock => clk,
         data  => data,
         rdreq => rden,
         wrreq => wren,
         empty => empty_int,
         full  => full_int,
         q     => q,
         usedw => usedw
         );
  end generate;
  
  gen_xilinx_ku_scfifo : if FPGA_ARCH = "XILINX_KU" generate
  
  end generate;
  
  empty <= empty_int;
  full  <= full_int;

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
      if (full_int = '1' and (wren = '1')) then
        -- Error message used in simulation only
        assert false
          report "fdkSCFIFO, FIFO overrun"
          severity error;
      elsif (empty_int = '1' and (rden = '1')) then
        -- Error message used in simulation only
        assert false
          report "fdkSCFIFO, FIFO underrun"
          severity error;
      end if;
    end if;
  end process P_FiFoError;
  -- synthesis translate_on 

  
end rtl;
