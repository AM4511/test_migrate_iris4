-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/cores/ccd_if/design/ccd_common/design/cmos_serial.vhd $
-- $Author: jmansill $
-- $Revision: 6415 $
-- $Date: 2010-07-09 08:17:44 -0400 (Fri, 09 Jul 2010) $
--
-- DESCRIPTION: TOP DU SERIAL CMOS
-----------------------------------------------------------------------
-- File:        xgs_spi.vhd
-- Decription:  
--              
-- This module contains:
-- 
-- Serial interface of CMOS sensor  
--                                                                                                                       
-- Created by:  Javier Mansilla
-- Date:        
-- Project:     IRIS 4
------------------------------------------------------------------------------

library IEEE;                   
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Library xpm;
use xpm.vcomponents.all;

library  work;
use work.regfile_xgs_ctrl_pack.all;


entity xgs_spi is
   generic( G_SYS_CLK_PERIOD : integer  := 16
          );
   port (  
           sys_reset_n     : in  std_logic;      --SYSTEME
           sys_clk         : in  std_logic;

           cmos_spi_clk    : out std_logic;
           cmos_spi_en     : out std_logic;
           cmos_spi_mosi   : out std_logic;
           cmos_spi_miso   : in  std_logic;
           
           grab_mngr_sensor_reconf      : in  std_logic;
           sensor_reconf_busy           : out std_logic;

           abort_now             : in std_logic;
           abort_fifo_cmd        : in std_logic;
           abort_fifo_cmd_done   : out std_logic;

           --register file of this head
           acquisition_start_SFNC : in std_logic:='0';
           regfile                : inout REGFILE_XGS_CTRL_TYPE := INIT_REGFILE_XGS_CTRL_TYPE

        );
end xgs_spi;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of xgs_spi is




-- W_div_function
function W_div_function(G_SYS_CLK_PERIOD  : integer)  return integer is
  variable Divider : integer;
  begin
    
    --WRITE FREQ MAX is 25 MHZ
    
    if(G_SYS_CLK_PERIOD = 8) then       -- f=125  -> 15.624 Mhz
      Divider := 8;                    
    elsif(G_SYS_CLK_PERIOD = 10) then   -- f=100  -> 25 Mhz
      Divider := 4;      
    elsif(G_SYS_CLK_PERIOD = 16) then   -- f=62.5 -> 15.625 Mhz
      Divider := 4;      
    else
      Divider := 16 ;
    end if;
    return Divider;
  end function;

-- R_div_function
function R_div_function(G_SYS_CLK_PERIOD  : integer)  return integer is
  variable Divider : integer;
  begin
  
    --READ FREQ MAX is 6.1 MHZ
    if(G_SYS_CLK_PERIOD = 8) then       -- f=125   -> 3.90 Mhz
      Divider := 32;                    
    elsif(G_SYS_CLK_PERIOD = 10) then   -- f=100   -> 3.125 Mhz
      Divider := 32;      
    elsif(G_SYS_CLK_PERIOD = 16) then   -- f=62.5  -> 3.90 Mhz 
      Divider := 16;      
    else
      Divider := 64 ;
    end if;    
    return Divider;
  end function;
  
  
constant FREQ_DIV_R : integer := R_div_function(G_SYS_CLK_PERIOD) ;
constant FREQ_DIV_W : integer := W_div_function(G_SYS_CLK_PERIOD) ;   

--SIGNALS

signal sclk_div             : std_logic_vector(6 downto 0);
signal sclk_div_reset       : std_logic;

type Def_S_state is (  S_idle,
                       S_wait_reconf,
                       S_readfifo1,
                       S_capture,
                       S_wait_captureT,
                       S_captureT,
                       S_wait_cycle,
                       S_scanout,
                       S_wait,
                       S_wait_tsckss,
                       S_wait_tspi_1,
                       S_wait_tspi_2,
                       S_restart,
                       S_timer_start,
                       S_timer_wait,
                       S_reconf_done,
                       S_abort_fifo_cmd,
                       S_abort_fifo_done
                       
                    );



signal S_currentState        : Def_S_state ;
signal S_nextState           : Def_S_state ;

signal scanff                : std_logic_vector(31 downto 0);
signal s_count               : std_logic_vector(5 downto 0);

signal scanout               : std_logic;
--signal scanout_p1            : std_logic;

signal scan_in               : std_logic;
signal scan_in_p1            : std_logic;

signal capture1              : std_logic;
signal captureT              : std_logic;

signal next_scanout          : std_logic;
signal next_capture1         : std_logic;
signal next_captureT         : std_logic;

signal next_fifo_read        : std_logic;
signal next_sl_int           : std_logic;
signal sl_int                : std_logic; 
signal next_sl_out           : std_logic;
signal sl_out                : std_logic;

signal next_busy             : std_logic;
signal busy                  : std_logic;

signal reconf_done           : std_logic;
signal next_reconf_done      : std_logic;

signal next_timer_start      : std_logic;
signal timer_start           : std_logic;
signal timer_end             : std_logic;
signal timer_en              : std_logic;
signal timer_cntr            : std_logic_vector(25 downto 0);

signal fifo_rst              : std_logic;
signal fifo_read             : std_logic;
signal fifo_empty            : std_logic;
signal fifo_write            : std_logic;
signal fifo_data_in          : std_logic_vector(35 downto 0);
signal fifo_out36            : std_logic_vector(35 downto 0);
signal fifo_out36_dat        : std_logic_vector(15 downto 0);  -- pour l'interface serielle, on inverse l'ordre des bits
signal fifo_out36_add        : std_logic_vector(14 downto 0);  -- pour l'interface serielle, on inverse l'ordre des bits

signal sys_reset             : std_logic;

signal read_flag             : std_logic;
signal scan_in_vect          : std_logic_vector(15 downto 0);
signal ser_data_read         : std_logic_vector(15 downto 0);

--signal grab_mngr_sensor_reconf_pipe : std_logic_vector(5 downto 0);

--signal GRAB_CMD_P1           : std_logic;
--signal SER_WF_SS_P1          : std_logic;


signal sensor_reconf_add     : std_logic_vector(15 downto 0);
signal sensor_reconf_dat     : std_logic_vector(15 downto 0);
signal sensor_reconf_cmd     : std_logic_vector(1 downto 0);
signal sensor_reconf_WF_pipe : std_logic_vector(8 downto 0);
signal sensor_reconf_WF_ss   : std_logic;
signal sensor_reconf_roi_sel : std_logic_vector(3 downto 0) := "0101";


signal next_abort_cntr_en          : std_logic;
signal next_abort_fifo_cmd_done    : std_logic;
signal abort_cntr_en               : std_logic;
signal abort_fifo_cmd_cntr         : std_logic_vector(2 downto 0);

signal  read_temp_flag             : std_logic;
signal  ser_data_read_temp         : std_logic_vector(7 downto 0);
signal  ser_data_read_temp_valid   : std_logic;

signal grab_mngr_sensor_reconf_start       : std_logic;        
signal grab_mngr_sensor_reconf_start_buff  : std_logic;
signal read_temp_sensor_start              : std_logic;
signal read_temp_sensor_start_buff         : std_logic;

signal GRAB_ROI2_EN_DB                     : std_logic;
signal GRAB_CMD_DONE                       : std_logic;

signal GRAB_CMD                            : std_logic; 

signal cmos_spi_clk_div_R                  : integer range 1 to 6; 
signal cmos_spi_clk_div_W                  : integer range 1 to 6;

signal sclk_div_reset_R                    : std_logic_vector(6 downto 0);
signal sclk_div_reset_W                    : std_logic_vector(6 downto 0);

BEGIN


  ----------------------------------------------------------------
  --
  -- Frequency dividers for Read and Write 
  --
  ----------------------------------------------------------------
  -- sclk_div(1) : div par 4
  -- sclk_div(2) : div par 8
  -- sclk_div(3) : div par 16
  -- sclk_div(4) : div par 32
  -- sclk_div(5) : div par 64
  -- sclk_div(6) : div par 128
  cmos_spi_clk_div_R <= 1 when FREQ_DIV_R=4  else
                        2 when FREQ_DIV_R=8  else
                        3 when FREQ_DIV_R=16 else
                        4 when FREQ_DIV_R=32 else
                        5 when FREQ_DIV_R=64 else
                        6; 
    
  cmos_spi_clk_div_W <= 1 when FREQ_DIV_W=4  else
                        2 when FREQ_DIV_W=8  else
                        3 when FREQ_DIV_W=16 else
                        4 when FREQ_DIV_W=32 else
                        5 when FREQ_DIV_W=64 else
                        6;    
   
  -- sclk_div = "0000010" : div 4
  -- sclk_div = "0000110" : div 8
  -- sclk_div = "0001110" : div 16
  -- sclk_div = "0011110" : div 32
  -- sclk_div = "0111110" : div 64 
  -- sclk_div = "1111110" : div 128   
  sclk_div_reset_R <= "0000010" when FREQ_DIV_R=4  else
                      "0000110" when FREQ_DIV_R=8  else
                      "0001110" when FREQ_DIV_R=16 else
                      "0011110" when FREQ_DIV_R=32 else
                      "0111110" when FREQ_DIV_R=64 else  
                      "1111110";

  sclk_div_reset_W <= "0000010" when FREQ_DIV_W=4  else
                      "0000110" when FREQ_DIV_W=8  else
                      "0001110" when FREQ_DIV_W=16 else
                      "0011110" when FREQ_DIV_W=32 else
                      "0111110" when FREQ_DIV_W=64 else  
                      "1111110";                      
  

  ----------------------------------------------------------------
  --
  -- Grab command  
  --
  ----------------------------------------------------------------
  GRAB_CMD <= '1' when (regfile.ACQ.GRAB_CTRL.GRAB_CMD='1' and REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC/="100" ) else
              '0';                 

              
  ----------------------------------------------------------------
  --
  -- OUTPUT FIFO Write data 
  --
  ----------------------------------------------------------------

  fifo_data_in(14 downto 0)  <= regfile.ACQ.ACQ_SER_ADDATA.SER_ADD when (regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS='1') else sensor_reconf_add(14 downto 0);
  
  fifo_data_in(15)           <= '0';
  
  fifo_data_in(31 downto 16) <= regfile.ACQ.ACQ_SER_ADDATA.SER_DAT when (regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS='1') else sensor_reconf_dat;

  fifo_data_in(32)           <= regfile.ACQ.ACQ_SER_CTRL.SER_RWn   when (regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS='1') else '0';

  fifo_data_in(34 downto 33) <= regfile.ACQ.ACQ_SER_CTRL.SER_CMD   when (regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS='1') else sensor_reconf_cmd;

  fifo_data_in(35)           <= '0';


  fifo_write <= (regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS or sensor_reconf_WF_ss) and not(abort_now) ;  -- SS du regfile or grab commande

  ------------------------------------------------------------------------------------------------------
  -- La magie est faite ici:
  --
  -- Pour que le grab reprogramme les registres du senseur, ilfaut setter SENSOR_REG_UPTATE=1.
  --
  -- Lorsque le GRAB_CMD est recu, les registres(regfile) mirroirs du senseur sont envoyes dans le fifo.
  -- Un STOP separtor est insere a la fin des access. Si un deuxieme GRAB_CMD est recu sans que le premier
  -- n'ait ete evacue il va etre insere dans le fifo a la suite du STOP separator.
  --
  -- La re-programmation du senseur partie par le signal "grab_mngr_sensor_reconf"
  --
  ------------------------------------------------------------------------------------------------------
  

    process(sys_clk)
    begin
      if(sys_clk'event and sys_clk='1') then
        if(sys_reset_n='0') then
          sensor_reconf_WF_pipe  <= (others=>'0');
          GRAB_ROI2_EN_DB        <= '0'; 
        else
          sensor_reconf_WF_pipe(0)           <= (GRAB_CMD or acquisition_start_SFNC) and regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE;
          sensor_reconf_WF_pipe(8 downto 1) <= sensor_reconf_WF_pipe(7 downto 0);
          
          if(GRAB_CMD='1' or acquisition_start_SFNC='1') and regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1' then
            GRAB_ROI2_EN_DB        <= regfile.ACQ.GRAB_CTRL.GRAB_ROI2_EN;
          end if;
          
        end if;
    
        if(sys_reset_n='0') then
          sensor_reconf_roi_sel   <= "0101";
        else
          if( sensor_reconf_WF_pipe(7)='1' and regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1') then             -- now we have program all new parameters, change ROI for next grab image, "01"->"10"->"01"->"10" ... using only ROI 1 and 2
            sensor_reconf_roi_sel <= not(sensor_reconf_roi_sel(3)) & not(sensor_reconf_roi_sel(2)) & not(sensor_reconf_roi_sel(1)) & not(sensor_reconf_roi_sel(0));
          else
            sensor_reconf_roi_sel <= sensor_reconf_roi_sel;
          end if;
        end if;
    
        if(regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1') then
          
          if(sensor_reconf_WF_pipe(0)='1') then               -- Program register ROI[0-1]_START_REG (0x381a or 0x381e) : Ystart 
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd <= "00";
             if(sensor_reconf_roi_sel(1 downto 0)="01") then
               sensor_reconf_add <= X"381a";
             else  
               sensor_reconf_add <= X"381e";
             end if;
             sensor_reconf_dat   <=  regfile.ACQ.SENSOR_ROI_Y_START.reserved  &
                                     regfile.ACQ.SENSOR_ROI_Y_START.Y_START;
    
          elsif(sensor_reconf_WF_pipe(1)='1') then            -- Program register ROI[0-1]_SIZE_REG (0x381c or 0x3820) : Ysize
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd    <= "00";
            if(sensor_reconf_roi_sel(1 downto 0)="01") then
              sensor_reconf_add <= X"381c";
            else  
              sensor_reconf_add <= X"3820";
            end if;
            sensor_reconf_dat   <=  regfile.ACQ.SENSOR_ROI_Y_SIZE.reserved  &
                                    regfile.ACQ.SENSOR_ROI_Y_SIZE.Y_SIZE;


          elsif(sensor_reconf_WF_pipe(2)='1') then               -- Program register ROI[2-3]_START_REG (0x3822 or 0x3826) : Ystart 
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd <= "00";
             if(sensor_reconf_roi_sel(3 downto 2)="01") then
               sensor_reconf_add <= X"3822";
             else  
               sensor_reconf_add <= X"3826";
             end if;
             sensor_reconf_dat   <=  regfile.ACQ.SENSOR_ROI2_Y_START.reserved  &
                                     regfile.ACQ.SENSOR_ROI2_Y_START.Y_START;
    
          elsif(sensor_reconf_WF_pipe(3)='1') then            -- Program register ROI[2-3]_SIZE_REG (0x3824 or 0x3828) : Ysize
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd    <= "00";
            if(sensor_reconf_roi_sel(3 downto 2)="01") then
              sensor_reconf_add <= X"3824";
            else  
              sensor_reconf_add <= X"3828";
            end if;
            sensor_reconf_dat   <=  regfile.ACQ.SENSOR_ROI2_Y_SIZE.reserved  &
                                    regfile.ACQ.SENSOR_ROI2_Y_SIZE.Y_SIZE;

                                  
   
          elsif(sensor_reconf_WF_pipe(4)='1') then            -- Program reg ROI ACTIVE context 0 (0x383e) : ceci est automatiquement gere par le fpga
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd    <= "00";
            sensor_reconf_add    <= X"383e";
            sensor_reconf_dat(15 downto 4)    <= "000000000000";
            sensor_reconf_dat(1 downto 0)     <= sensor_reconf_roi_sel(1 downto 0);
            if(GRAB_ROI2_EN_DB='1') then
              sensor_reconf_dat(3 downto 2)   <= sensor_reconf_roi_sel(3 downto 2);
            else
              sensor_reconf_dat(3 downto 2)   <= "00";
            end if;
            
            
          elsif(sensor_reconf_WF_pipe(5)='1') then            -- Program reg SUBSAMPLING (0x383c) 
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd    <= "00";
            sensor_reconf_add    <= X"383c";
            sensor_reconf_dat    <= regfile.ACQ.SENSOR_SUBSAMPLING.reserved1             &
                                    regfile.ACQ.SENSOR_SUBSAMPLING.ACTIVE_SUBSAMPLING_Y  &
                                    regfile.ACQ.SENSOR_SUBSAMPLING.reserved0             &
                                    regfile.ACQ.SENSOR_SUBSAMPLING.M_SUBSAMPLING_Y       &
                                    regfile.ACQ.SENSOR_SUBSAMPLING.SUBSAMPLING_X;            
            
    
          elsif(sensor_reconf_WF_pipe(6)='1') then            -- Program reg ANALOG_GAIN_CODE (0x3844)
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd    <= "00";
            sensor_reconf_add    <= X"3844";
            sensor_reconf_dat    <= regfile.ACQ.SENSOR_GAIN_ANA.reserved1      &
                                    regfile.ACQ.SENSOR_GAIN_ANA.ANALOG_GAIN    &
                                    regfile.ACQ.SENSOR_GAIN_ANA.reserved0;
    
          --elsif(sensor_reconf_WF_pipe(7)='1') then            -- Program reg SENSOR_BLACK_CAL (128, 0x80)  XGS PEDESTAL is 4 registers!!!!
          --  sensor_reconf_WF_ss  <= '1';
          --  sensor_reconf_cmd    <= "00";
          --  sensor_reconf_add    <= "000000"&"010000000";
          --  sensor_reconf_dat    <=  regfile.ACQ.SENSOR_BLACK_CAL.CRC_SEED        &
          --                           regfile.ACQ.SENSOR_BLACK_CAL.reserved        &
          --                           regfile.ACQ.SENSOR_BLACK_CAL.black_samples   &
          --                           regfile.ACQ.SENSOR_BLACK_CAL.black_offset;
          --
          
          elsif(sensor_reconf_WF_pipe(7)='1') then            -- Program STOP SEPARATOR 
            sensor_reconf_WF_ss  <= '1';
            sensor_reconf_cmd    <= "10";
            sensor_reconf_add    <= (others => '-');
            sensor_reconf_dat    <= (others => '-');
          else
            sensor_reconf_WF_ss  <= '0';
            sensor_reconf_cmd    <= "--";
            sensor_reconf_add    <= (others => '-');
            sensor_reconf_dat    <= (others => '-');
          end if;
        else
          sensor_reconf_WF_ss  <= '0';
          sensor_reconf_cmd    <= "--";
          sensor_reconf_add    <= (others => '-');
          sensor_reconf_dat    <= (others => '-');
        end if;
      end if;
      
    end process;
    




  
  
  
  ------------------------------------------------------------------------------
  --  N3: because of register buffering in N3, we saw two GRAB_CMD back to back.
  --
  --                     _____      _____
  --  GRAB_CMD   _______/     \____/     \______
  --
  --  Lets put a register with GRAB_CMD_DONE to inform that the GRAB command 
  --  had susccefully reccorded.
  --
  -----------------------------------------------
  process(sys_clk)
  begin
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0') then
        GRAB_CMD_DONE                <= '1';
      else
        if (GRAB_CMD='1' or acquisition_start_SFNC='1') then
          GRAB_CMD_DONE                <= '0';
        elsif(sensor_reconf_WF_pipe(8)='1') then
          GRAB_CMD_DONE                <= '1';
        end if;
      end if;
    end if;
  end process;
  

  regfile.ACQ.GRAB_STAT.GRAB_CMD_DONE <= GRAB_CMD_DONE;

--  -------------------------------------------------------------
--  --  The grab CMD will insert a separator sync in the fifo.
--  --  lets the write fifo to be visible on the read side of 
--  --  the fifo.
--  -----------------------------------------------
--  process(sys_clk)
--  begin
--    if(sys_clk'event and sys_clk='1') then
--      if(sys_reset_n='0') then
--        GRAB_CMD_P1                  <= '0';
--        SER_WF_SS_P1                 <= '0';
--      else
--        GRAB_CMD_P1                  <= GRAB_CMD or acquisition_start_SFNC;
--        SER_WF_SS_P1                 <= regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS;
--        
--      end if;
--    end if;
--  end process;



  -------------------------------------------------------------------------------
  --  Petit arbitre pour gerer la question du read temperature et Acces du fifo
  -------------------------------------------------------------------------------
  process(sys_clk)
  begin
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0') then
        grab_mngr_sensor_reconf_start       <= '0';        
        grab_mngr_sensor_reconf_start_buff  <= '0';
        read_temp_sensor_start              <= '0';
        read_temp_sensor_start_buff         <= '0';
      else
        -- grab manager reconfiguration request
        if(grab_mngr_sensor_reconf='1' and regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1') then
          if(S_currentState= S_idle and read_temp_sensor_start='0') then                                           -- Cet access est prioritaire sur l'acces de temperature
            grab_mngr_sensor_reconf_start       <= '1';
            grab_mngr_sensor_reconf_start_buff  <= '0';
          else
            grab_mngr_sensor_reconf_start       <= '0';
            grab_mngr_sensor_reconf_start_buff  <= '1';
          end if;
        elsif(grab_mngr_sensor_reconf_start_buff='1' and regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1') then
          if(S_currentState= S_idle) then
            grab_mngr_sensor_reconf_start       <= '1';
            grab_mngr_sensor_reconf_start_buff  <= '0';
          else
            grab_mngr_sensor_reconf_start       <= '0';
            grab_mngr_sensor_reconf_start_buff  <= '1';
          end if;
        else
          grab_mngr_sensor_reconf_start       <= '0';
          grab_mngr_sensor_reconf_start_buff  <= '0';
        end if;

        -- temperature access request
        if(regfile.ACQ.SENSOR_CTRL.SENSOR_REFRESH_TEMP='1') then
          if(S_currentState= S_idle and grab_mngr_sensor_reconf='0' and grab_mngr_sensor_reconf_start='0') then      -- Cet access est moins prioritaire que l'acces du grab
            read_temp_sensor_start       <= '1';
            read_temp_sensor_start_buff  <= '0';
          else
            read_temp_sensor_start       <= '0';
            read_temp_sensor_start_buff  <= '1';
          end if;
        elsif(read_temp_sensor_start_buff='1') then
          if(S_currentState= S_idle and grab_mngr_sensor_reconf='0' and grab_mngr_sensor_reconf_start='0') then
            read_temp_sensor_start       <= '1';
            read_temp_sensor_start_buff  <= '0';
          else
            read_temp_sensor_start       <= '0';
            read_temp_sensor_start_buff  <= '1';
          end if;
        else
          read_temp_sensor_start         <= '0';
          read_temp_sensor_start_buff    <= '0';
        end if;

      end if;
    end if;
  end process;




  ----------------------------------------------------------------
  --
  -- This state machine defines the machine READING at the output fifo
  --
  ----------------------------------------------------------------
  State_machine_low : process(regfile, fifo_empty, s_count, S_currentState, sclk_div, sclk_div_reset, fifo_out36, timer_end, grab_mngr_sensor_reconf_start,read_temp_sensor_start, abort_fifo_cmd_cntr, abort_fifo_cmd, read_temp_flag)
  begin
     case S_currentState is

       when S_idle     => if(abort_fifo_cmd='1') then
                            S_nextstate <= S_abort_fifo_cmd;
                          elsif(grab_mngr_sensor_reconf_start='1') then                                          -- At this time the first instruction is see by the REad agent
                            S_nextstate <= S_wait_reconf;
                          elsif(read_temp_sensor_start='1') then                                                 -- Read temperature
                            S_nextstate <= S_wait_captureT;
                          elsif(fifo_empty = '0' and regfile.ACQ.ACQ_SER_CTRL.SER_RF_SS='1') then
                            S_nextstate <= S_readfifo1;
                          else
                            S_nextstate <= S_idle;
                          end if;

       when S_wait_reconf => if(fifo_empty = '0') then
                               S_nextstate <= S_readfifo1;
                             else
                               S_nextstate <= S_wait_reconf;         -- Attendre que les instruction arrivent sur un GRAB_START et idle!
                             end if;
                             
       when S_readfifo1=> S_nextstate <= S_capture;                         -- On lit ds le fifo - Adresse/Data/RWn

       when S_capture  => if(fifo_out36(34 downto 33) = "00") then          -- CMD 0x0 = On loade la lecture du fifo
                            S_nextstate <= S_wait_cycle;
                          elsif(fifo_out36(34 downto 33) = "01") then       -- CMD 0x1 = TIMER DELAI
                            S_nextstate <= S_timer_start;
                          elsif(fifo_out36(34 downto 33) = "10") then       -- CMD 0x2 = STOP REad from fifo (STOP SEPARATOR)
                            S_nextstate <= S_reconf_done;
                          else                                              -- CMD 0x3 = reserved for future cmds
                            S_nextstate <= S_idle;
                            -- synthesis translate_off
                            report "SENSOR COMMAND NOT SUPPORTED!" severity FAILURE;
                            -- synthesis translate_on
                          end if;

       when S_wait_captureT => S_nextstate <=S_captureT;

       when S_captureT => S_nextstate <= S_wait_cycle;
                          
       when S_wait_cycle => if(sclk_div_reset='1') then
                              S_nextstate <= S_wait;                      
                            else
                              S_nextstate <= S_wait_cycle;
                            end if;                                               

       when S_wait     => if(sclk_div= "0000000") then
                            S_nextstate <= S_scanout;                      
                          else
                            S_nextstate <= S_wait;
                          end if;                                               

       when S_scanout  => if(s_count="100000") then                      -->> 32shifts pour XGS
                            S_nextstate <= S_wait_tsckss;
                          else
                            S_nextstate <= S_wait;
                          end if;

       when S_wait_tsckss  =>    if(s_count="100001" and sclk_div_reset='1') then                          -->> wait for t_sckss timing
                                   S_nextstate <= S_wait_tspi_1;
                                 else
                                   S_nextstate <= S_wait_tsckss;
                                 end if;

       when S_wait_tspi_1     => if(s_count="100001" and sclk_div_reset='1') then                      -->> wait for tsck timing (first clk)
                                   S_nextstate <= S_wait_tspi_2;
                                 else
                                   S_nextstate <= S_wait_tspi_1;
                                 end if;

       when S_wait_tspi_2     => if(s_count="100001" and sclk_div_reset='1') then                      -->> wait for tsck timing (second clk)
                                   if(fifo_empty = '1' or read_temp_flag='1') then
                                     S_nextstate <= S_idle;
                                   else
                                     S_nextstate <= S_restart;
                                   end if;
                                 else
                                   S_nextstate <= S_wait_tspi_2;
                                 end if;

       when S_restart         => if(sclk_div= "0000000") then
                                   S_nextstate <= S_readfifo1;
                                 else
                                   S_nextstate <= S_restart;
                                 end if;
       
       when S_timer_start     => S_nextstate <= S_timer_wait;
       
       when S_timer_wait      => if(timer_end='1') then
                                   if(fifo_empty = '1') then
                                     S_nextstate <= S_idle;
                                   else
                                     S_nextstate <= S_restart;
                                   end if;
                                 else
                                   S_nextstate <= S_timer_wait;
                                 end if;

       when S_reconf_done     => S_nextstate <= S_idle;
       
       when S_abort_fifo_cmd  => if(abort_fifo_cmd_cntr = "111") then            --5 clk minimum treset for artix7, put 7
                                   S_nextstate <= S_abort_fifo_done;
                                 else
                                   S_nextstate <= S_abort_fifo_cmd;
                                 end if;
                                 
       when S_abort_fifo_done => S_nextstate <= S_idle;
                                 
     end case;
  end process;




  State_machine_assign : process(S_nextState)
  begin
     case S_nextState is
       when S_idle            => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '0';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_wait_reconf     => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_readfifo1       => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '1';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_capture         => next_scanout         <= '0';
                                 next_capture1        <= '1';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_wait_captureT   => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';


       when S_captureT        => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '1';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

                                 
       when S_wait_cycle      => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '0';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_scanout         => next_scanout         <= '1';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '0';
                                 next_sl_out          <= '0';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_wait            => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '0';
                                 next_sl_out          <= '0';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_wait_tsckss     => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '0';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_wait_tspi_1     => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_wait_tspi_2     => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_restart         => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_timer_start     => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '1';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_timer_wait      => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '1';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';

       when S_reconf_done     => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '0';
                                 next_reconf_done     <= '1';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '0';
                                 
       when S_abort_fifo_cmd  => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '0';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '1';
                                 next_abort_fifo_cmd_done      <= '0';
                                 
       when S_abort_fifo_done => next_scanout         <= '0';
                                 next_capture1        <= '0';
                                 next_captureT        <= '0';
                                 next_fifo_read       <= '0';
                                 next_sl_int          <= '1';
                                 next_sl_out          <= '1';
                                 next_timer_start     <= '0';
                                 next_busy            <= '0';
                                 next_reconf_done     <= '0';
                                 next_abort_cntr_en   <= '0';
                                 next_abort_fifo_cmd_done      <= '1';

     end case;
  end process;


  State_machine_clk : process(sys_clk)
  begin
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0') then
        S_currentState       <=  S_idle;
        scanout              <= '0';
        capture1             <= '0';
        captureT             <= '0';
        fifo_read            <= '0';
        sl_int               <= '1';
        sl_out               <= '1';
        timer_start          <= '0';
        busy                 <= '0';
        reconf_done          <= '0';
        abort_cntr_en        <= '0';
        abort_fifo_cmd_done  <= '0'; 
      else
        S_currentState       <= S_nextstate;
        scanout              <= next_scanout;
        capture1             <= next_capture1;
        captureT             <= next_captureT;
        fifo_read            <= next_fifo_read;
        sl_int               <= next_sl_int;
        sl_out               <= next_sl_out;
        timer_start          <= next_timer_start;
        busy                 <= next_busy;
        reconf_done          <= next_reconf_done;
        abort_cntr_en        <= next_abort_cntr_en;
        abort_fifo_cmd_done  <= next_abort_fifo_cmd_done;
      end if;
      
      if(sys_reset_n='0') then
        s_count <= "000000";
      elsif(fifo_read='1' or read_temp_sensor_start='1') then
        s_count <= "000000";
      elsif(scanout='1') then
        s_count <= std_logic_vector(s_count+'1');
      end if;

    end if;
  end process;


  sensor_reconf_busy           <= busy;


  -------------------------------------------------------------------------------
  --
  -- Process: SCANIN  (Single READ - IrisGTR)
  --
  -- IrisGTr   :  tx_clk    = sys_clk alors le data qui est floppe est sur le bon domaine d'horloge. 
  --
  -- NEXIS G2 :   tx_clk    = TBD (not supported for the moment)
  --
  -------------------------------------------------------------------------------
  SCANIN_proc : process (sys_clk)
  begin      
    if (sys_clk'event and sys_clk='1') then
      if (sys_reset_n = '0') then
        read_flag           <= '0';
        read_temp_flag      <= '0';
      elsif(capture1= '1') then
        read_flag           <= fifo_out36(32);  --R/Wn
        read_temp_flag      <= '0';
      elsif(captureT= '1') then
        read_flag           <= '1';  --Read!
        read_temp_flag      <= '1';
      else
        read_flag           <= read_flag;
        read_temp_flag      <= read_temp_flag;
      end if;
      

      if(sys_reset_n = '0') then
        scan_in  <= '0';
      elsif(s_count="010001" and read_flag='1') then  --python 11 xgs is 15+1+1=17
        scan_in  <= '1';
      elsif(s_count="100001") then                    --python 27 26+1  xgs is 32+1
        scan_in  <= '0';
      else
        scan_in  <= scan_in;
      end if;

      if(sys_reset_n = '0') then
        scan_in_p1  <= '0';
      else
        scan_in_p1  <= scan_in;
      end if;
      
      if (sys_reset_n = '0') then
        scan_in_vect  <= (others => '0');
      elsif(scan_in='1' and sclk_div="0000000") then
        scan_in_vect(0)           <= cmos_spi_miso;
        scan_in_vect(15 downto 1)  <= scan_in_vect(14 downto 0);
      end if;

      if (sys_reset_n = '0') then
        ser_data_read <= (others => '0');
      elsif(scan_in='0' and scan_in_p1='1' and read_temp_flag='0') then
        ser_data_read <= scan_in_vect;
      end if;

      if (sys_reset_n = '0') then
        ser_data_read_temp <= (others => '0');
      elsif(scan_in='0' and scan_in_p1='1' and read_temp_flag='1') then
        ser_data_read_temp <= scan_in_vect(7 downto 0);
      end if;

      if (sys_reset_n = '0') then
        ser_data_read_temp_valid <= '0';
      elsif(regfile.ACQ.SENSOR_CTRL.SENSOR_REFRESH_TEMP='1') then
        ser_data_read_temp_valid <= '0';
      elsif(scan_in='0' and scan_in_p1='1' and read_temp_flag='1') then
        ser_data_read_temp_valid <= '1';
      end if;


    end if;
  end process;

  regfile.ACQ.ACQ_SER_STAT.SER_DAT_R        <= ser_data_read;
  regfile.ACQ.SENSOR_STAT.SENSOR_TEMP       <= ser_data_read_temp;
  regfile.ACQ.SENSOR_STAT.SENSOR_TEMP_VALID <= ser_data_read_temp_valid;


  regfile.ACQ.ACQ_SER_STAT.SER_BUSY   <= busy;



  
  --------------------------------------------------------------------------------------
  --
  -- Process: OUTPUTS and sclk =0 when idle
  --
  --------------------------------------------------------------------------------------
  output_ff : process (sys_clk)      
  begin      
    if (sys_clk'event and sys_clk='1') then

      if (sys_reset_n = '0') then
        cmos_spi_clk <= '0';
      elsif(sl_int= '0') then

        --if ((G_SYS_CLK_FREQ = 100.0)) then
          -- sclk_div(1) : div par 4
          -- sclk_div(2) : div par 8
          -- sclk_div(3) : div par 16
          -- sclk_div(4) : div par 32
          -- sclk_div(5) : div par 64
          -- sclk_div(6) : div par 128
          if(read_flag='0') then
            cmos_spi_clk <= sclk_div(cmos_spi_clk_div_W);--sclk_div(1);
          else
            cmos_spi_clk <= sclk_div(cmos_spi_clk_div_R);--sclk_div(4);
          end if;          
        --else
        --  assert FALSE report "Frequence SYS_CLK not supported" severity FAILURE;        
        --end if;

        else
        cmos_spi_clk <= '0';
      end if;

      if (sys_reset_n = '0') then
        cmos_spi_en   <= '1';
      else
        cmos_spi_en   <= sl_out;
      end if;
      
      if (sys_reset_n = '0') then
        cmos_spi_mosi <= '0';
      elsif(sl_int='0' and sclk_div="0000000") then
        cmos_spi_mosi <= scanff(0);
      elsif(sl_int='1') then
        cmos_spi_mosi <= '0';
      end if;
      
    end if;
  end process;

  -------------------------------------------------------------------------------
  --
  -- Process: SCANOUT
  --
  -------------------------------------------------------------------------------
  Order_inversion_dat: for i in 15 downto 0 generate
    fifo_out36_dat(i)  <= fifo_out36(31-i);
  end generate;

  Order_inversion_add: for i in 0 to 14 generate
    fifo_out36_add(i)  <= fifo_out36(14-i);
  end generate;

  SCANOUT_proc : process (sys_clk)      
  begin      
    if (sys_clk'event and sys_clk='1') then
      if (sys_reset_n = '0') then
        scanff              <= (others => '0');
      elsif(capture1= '1') then
        scanff(31 downto 0) <= fifo_out36_dat & fifo_out36(32) & fifo_out36_add;
      elsif(captureT= '1') then                                               -- XGS temperature read 
        scanff(31 downto 0) <= "0000000000000000" & '1' & "000000000000000"; -- Data dontcare set to 0x0, read=0, add=????
      elsif(scanout='1') then
        scanff(31)          <= '0';
        scanff(30 downto 0) <= scanff(31 downto 1);
      end if;
    end if;
  end process;


  -------------------------------------------------------------------------------
  --
  -- Process: CTRL CLOCK DIVIDER BY 8/16/32/64
  --
  -------------------------------------------------------------------------------
  SYS_DIV : process (sys_clk)      
  begin      
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0' or S_currentState=S_wait_reconf or S_currentState=S_idle) then
        sclk_div <= "0000001";
      elsif(sclk_div_reset='1') then
        sclk_div <= "0000000";
      else
        sclk_div <= sclk_div + '1';
      end if;
    end if;
  end process;

  --sclk_div reset signal !
  process (sys_clk)      
  begin      
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0' or S_currentState=S_wait_reconf or S_currentState=S_idle) then
        sclk_div_reset <= '0';
      else

        --if (G_SYS_CLK_FREQ = 100.0) then
          -- sclk_div = "0000010" : div 4
          -- sclk_div = "0000110" : div 8
          -- sclk_div = "0001110" : div 16
          -- sclk_div = "0011110" : div 32
          -- sclk_div = "0111110" : div 64
          
          --Pour supporter div 4 dans les access on devance d'un clk ici la generation du "read_flag"
          if( (capture1='1' or captureT='1') and fifo_out36(32)='0' and sclk_div = sclk_div_reset_W) or  
            ( (capture1='1' or captureT='1') and fifo_out36(32)='1' and sclk_div = sclk_div_reset_R) then
            sclk_div_reset <= '1';
          elsif( read_flag='0' and sclk_div = sclk_div_reset_W) or    
               ( read_flag='1' and sclk_div = sclk_div_reset_R) then  
            sclk_div_reset <= '1';             
          else
            sclk_div_reset <= '0';
          end if;
        --else
        --  assert FALSE report "Frequence SYS_CLK not supported" severity FAILURE;        
        --end if;
        
      end if;
    end if;
  end process;



  
  
  

  -------------------------------------------------------------------------------
  --
  -- OUTPUT FIFO
  --
  -------------------------------------------------------------------------------
  sys_reset <= not(sys_reset_n);
  
  --Xxil_sensor_ser_fifo : xil_sensor_ser_fifo
  --port map (
  --           clk    => sys_clk,
  --           rst    => fifo_rst,
  --           wr_en  => fifo_write,
  --           din    => fifo_data_in,
  --           rd_en  => fifo_read,
  --           dout   => fifo_out36(35 downto 0),
  --           empty  => fifo_empty,
  --           full   => open
  --         );

  fifo_rst <= sys_reset or abort_cntr_en;    -- this will reset the pointers of the cmd fifos

  regfile.ACQ.ACQ_SER_STAT.SER_FIFO_EMPTY  <= fifo_empty;

  
   xpm_sensor_ser_fifo : xpm_fifo_sync
   generic map (
      DOUT_RESET_VALUE    => "0",       -- String
      ECC_MODE            => "no_ecc",  -- String
      FIFO_MEMORY_TYPE    => "auto",    -- String
      FIFO_READ_LATENCY   => 1,         -- DECIMAL
      FIFO_WRITE_DEPTH    => 1024,      -- DECIMAL
      FULL_RESET_VALUE    => 0,         -- DECIMAL
      PROG_EMPTY_THRESH   => 10,        -- DECIMAL
      PROG_FULL_THRESH    => 10,        -- DECIMAL
      RD_DATA_COUNT_WIDTH => 1,         -- DECIMAL
      READ_DATA_WIDTH     => 36,        -- DECIMAL
      READ_MODE           => "std",     -- String
      USE_ADV_FEATURES    => "0707",    -- String
      WAKEUP_TIME         => 0,         -- DECIMAL
      WRITE_DATA_WIDTH    => 36,        -- DECIMAL
      WR_DATA_COUNT_WIDTH => 1          -- DECIMAL
   )
   port map (
      almost_empty => open,
      almost_full  => open, 

      data_valid => open,       -- 1-bit output: Read Data Valid: When asserted, this signal indicates
                                      -- that valid data is available on the output bus (dout).

      dbiterr => open,      
      dout    => fifo_out36,                   -- READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                               -- when reading the FIFO.

      empty      => fifo_empty,                 -- 1-bit output: Empty Flag: When asserted, this signal indicates that
                                                -- the FIFO is empty. Read requests are ignored when the FIFO is empty,
                                                -- initiating a read while empty is not destructive to the FIFO.
      full       => open,                    

      overflow   => open,

      prog_empty => open,       

      prog_full  => open,       

      rd_data_count => open, -- RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates
                                      -- the number of words read from the FIFO.

      rd_rst_busy => open,     -- 1-bit output: Read Reset Busy: Active-High indicator that the FIFO
                                      -- read domain is currently in a reset state.

      sbiterr => open,             -- 1-bit output: Single Bit Error: Indicates that the ECC decoder
                                      -- detected and fixed a single-bit error.

      underflow => open,              -- 1-bit output: Underflow: Indicates that the read request (rd_en)
                                      -- during the previous clock cycle was rejected because the FIFO is
                                      -- empty. Under flowing the FIFO is not destructive to the FIFO.

      wr_ack => open,               -- 1-bit output: Write Acknowledge: This signal indicates that a write
                                      -- request (wr_en) during the prior clock cycle is succeeded.

      wr_data_count => open, -- WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                      -- the number of words written into the FIFO.

      wr_rst_busy => open,     -- 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                      -- write domain is currently in a reset state.

      din => fifo_data_in,            -- WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                      -- writing the FIFO.

      injectdbiterr => '0', -- 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                      -- the ECC feature is used on block RAMs or UltraRAM macros.

      injectsbiterr => '0', -- 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                      -- the ECC feature is used on block RAMs or UltraRAM macros.

      rd_en => fifo_read,             -- 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                      -- signal causes data (on dout) to be read from the FIFO. Must be held
                                      -- active-low when rd_rst_busy is active high.

      rst => fifo_rst,                -- 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                      -- unstable at the time of applying reset, but reset must be released
                                      -- only after the clock(s) is/are stable.

      sleep => '0',                   -- 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
                                      -- block is in power saving mode.

      wr_clk => sys_clk,               -- 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                      -- free running clock.

      wr_en => fifo_write             -- 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                      -- signal causes data (on din) to be written to the FIFO Must be held
                                      -- active-low when rst or wr_rst_busy or rd_rst_busy is active high

   );  
  
  
  
  
  -------------------------------------------------------------------------------
  --
  -- TIMER
  --
  -------------------------------------------------------------------------------
  
  process (sys_clk)
  begin      
    if(sys_clk'event and sys_clk='1') then
      if(timer_start='1') then
        timer_en     <= '1';
        timer_cntr   <= fifo_out36(31 downto 16) & "0000000000"; -- granularite : 1024 sysclk : 16.384us
        timer_end    <= '0';
      elsif(timer_en='1' and timer_cntr=X"0000000") then
        timer_en     <='0';
        timer_cntr   <= timer_cntr;
        timer_end    <= '1';
      elsif(timer_en='1') then
        timer_en     <= timer_en;
        timer_cntr   <= timer_cntr - '1';
        timer_end    <= '0';
      else
        timer_en     <= '0';
        timer_cntr   <= timer_cntr;
        timer_end    <= '0';
      end if;
    end if;
  end process;


  -------------------------------------------------------------------------------
  --
  -- ABORT
  --
  -------------------------------------------------------------------------------
  process (sys_clk)
  begin      
    if(sys_clk'event and sys_clk='1') then
      if(S_nextstate = S_idle) then
        abort_fifo_cmd_cntr  <= (others => '0');
      elsif(abort_cntr_en='1') then
        abort_fifo_cmd_cntr  <= abort_fifo_cmd_cntr + '1';
      end if;
    end if;
  end process;

end functional;



