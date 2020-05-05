-----------------------------------------------------------------------
-- File:        xgs_ctrl.vhd
-- Decription:  
--              
-- This module contains:
-- 
-- Control interface of CMOS sensor
--                                                                                                                       
-- Created by:  Javier Mansilla 
-- Date:        
-- Project:     IRIS 4
------------------------------------------------------------------------------
  
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.std_logic_arith.all;

library work;
use work.regfile_xgs_ctrl_pack.all;

library UNISIM;
  use UNISIM.VCOMPONENTS.all;

entity xgs_ctrl is
   generic(  G_KU706               : integer := 0; -- Nous n'avons pas de monitor sur le board Xcelerator+KU706 , generation interne!
             G_SIMULATION          : integer := 0;
             G_SYS_CLK_PERIOD      : integer := 16;
             G_SENSOR_FREQ         : integer := 32400
             
          );
   port (  
           sys_reset_n                     : in  std_logic;      --Reset pour le controleur au complet
           sys_reset_n_power               : in  std_logic;      --Reset pour le module de power
           
           sys_clk                         : in  std_logic;

           ---------------------------------------------------------------------------
           --  XGS CMOS IF signals
           ---------------------------------------------------------------------------
           xgs_power_good                  : in  std_logic;      -- power good
           xgs_osc_en                      : out std_logic;
           xgs_reset_n                     : out std_logic;
         
           xgs_sclk                        : out std_logic;
           xgs_ssn                         : out std_logic;
           xgs_mosi                        : out std_logic;
           xgs_miso                        : in  std_logic;

           xgs_trig_int                    : out std_logic;
           xgs_trig_rd                     : out std_logic;

           xgs_monitor0                    : in std_logic;  --EXP
           xgs_monitor1                    : in std_logic;  --EFOT 
           xgs_monitor2                    : in std_logic;  --NEW_LINE
           
           ---------------------------------------------------------------------------
           --  OUTPUTS TO other fpga
           ---------------------------------------------------------------------------
           strobe_out                      : out   std_logic;
           strobe_A_out                    : out   std_logic;
           strobe_B_out                    : out   std_logic;
           exposure_out                    : out   std_logic;
           trig_rdy_out                    : out   std_logic;
           
           xgs_monitor0_sysclk             : out   std_logic;
           xgs_monitor1_sysclk             : out   std_logic;
           
           ---------------------------------------------------------------------------
           --  INPUTS FROM other fpga
           ---------------------------------------------------------------------------
           ext_trig                        : in    std_logic;
           acquisition_start               : in    std_logic :='0';
           exposure_select                 : in    std_logic_vector(1 downto 0) := "00";   
           
           ---------------------------------------------------------------------------
           -- Debug out
           ---------------------------------------------------------------------------
           debug_out                       : out std_logic_vector(3 downto 0);

           ---------------------------------------------------------------------------
           -- IRQ
           ---------------------------------------------------------------------------
           irq_eos                         : out   std_logic;  --Strobe
           irq_sos                         : out   std_logic;  --Strobe
           irq_eoe                         : out   std_logic;  --Exposure
           irq_soe                         : out   std_logic;  --Exposure
           irq_abort                       : out   std_logic;
           
           ---------------------------------------------------------------------------
           --   signals
           ---------------------------------------------------------------------------          
           start_calibration               : out std_logic;
           DEC_EOF_sys                     : in  std_logic;
           
           abort_readout_datapath          : out std_logic;
           dma_idle                        : in  std_logic;

           strobe_DMA_P1                   : out std_logic;            -- Load DMA 1st stage registers (5 sys_clk length) 
           strobe_DMA_P2                   : out std_logic;            -- Load DMA 2nd stage registers (5 sys_clk length)  
           
           curr_db_GRAB_ROI2_EN            : out std_logic;
                      
           curr_db_y_start_ROI1            : out std_logic_vector;     -- 1-base
           curr_db_nblines_ROI1            : out std_logic_vector;     -- 1-base  

           curr_db_y_start_ROI2            : out std_logic_vector;     -- 1-base  
           curr_db_nblines_ROI2            : out std_logic_vector;     -- 1-base
             
           curr_db_subsampling_X           : out std_logic;
           curr_db_subsampling_Y           : out std_logic;
                           
           curr_db_BUFFER_ID               : out std_logic;

           ---------------------------------------------------------------------------
           --  RegFile
           ---------------------------------------------------------------------------         
           regfile                         : inout REGFILE_XGS_CTRL_TYPE-- := INIT_REGFILE_TYPE

        );
end xgs_ctrl;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of xgs_ctrl is



  ------------------------------------------
  --  MODULE XGS SPI
  ------------------------------------------
  component xgs_spi
   generic( G_SYS_CLK_PERIOD : integer :=16
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
    
    acquisition_start_SFNC   : in std_logic:='0';
    regfile                  : inout REGFILE_XGS_CTRL_TYPE := INIT_REGFILE_XGS_CTRL_TYPE
  );
  end component;

  ------------------------------------------
  --  MODULE XGS SPI
  ------------------------------------------
  component xgs_power
    generic(  G_SIMULATION     : integer       := 0;
              G_SYS_CLK_PERIOD : integer       := 16
           );
    port (  
            sys_reset_n                     : in  std_logic;      --SYSTEME
            sys_clk                         : in  std_logic;

            ---------------------------------------------------------------------------
            --  XGS CMOS IF signals
            ---------------------------------------------------------------------------
            xgs_power_good                  : in  std_logic;      -- power good
            xgs_osc_en                      : out std_logic;
            xgs_reset_n                     : out std_logic;

            regfile                         : inout REGFILE_XGS_CTRL_TYPE := INIT_REGFILE_XGS_CTRL_TYPE
         );
  end component;


  ------------------------------------------
  --  SIGNALS DECLARATION
  ------------------------------------------

  -----------------------------------------------------------------------------
  -- Function making a OR of a group of signals
  -----------------------------------------------------------------------------
  function OrN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '0';

    for i in arg'range loop
      result := result or arg(i);
    end loop;

    return result;
  end OrN;





  attribute ASYNC_REG       : string;
  attribute mark_debug      : string;
  attribute keep            : string;
  attribute dont_touch      : string;
  
  
  -- constants
  --constant keep_out_zone_100ns : std_logic_vector(REGFILE.ACQ.READOUT_CFG3.LINE_TIME'range) := std_logic_vector(conv_unsigned(integer( (100/G_SYS_CLK_PERIOD)+1 ), REGFILE.ACQ.READOUT_CFG3.LINE_TIME'length));
  
  signal keep_out_zone_cntr : std_logic_vector(REGFILE.ACQ.READOUT_CFG3.LINE_TIME'range) := (others =>'0');
  signal keep_out_zone      : std_logic := '0';
  
  -- synthesis translate_off
  -- SIM Debug
  type type_curr_acq_mode is (  NOT_DEFINED_YET,
                                CONTINUOUS,
                                TRIGGERED_HW_EDGE_RISE,
                                TRIGGERED_HW_EDGE_FALL,
                                TRIGGERED_HW_LEVEL_LO_EXP_TRIGWIDTH,
                                TRIGGERED_HW_LEVEL_HI_EXP_TRIGWIDTH,
                                TRIGGERED_HW_LEVEL_LO_EXP_TIMED,
                                TRIGGERED_HW_LEVEL_HI_EXP_TIMED,
                                TRIGGERED_SW,
                                SFNC
                              );
  signal  curr_acq_mode : type_curr_acq_mode;
  -- synthesis translate_on


  -- Status
  signal  grab_active            : std_logic;
  signal  grab_pending           : std_logic;
  
  signal  grab_idle_stat         : std_logic;

  signal  next_grab_mngr_stat    : std_logic_vector(REGFILE.ACQ.GRAB_STAT.GRAB_MNGR_STAT'range);
  signal  grab_mngr_stat         : std_logic_vector(REGFILE.ACQ.GRAB_STAT.GRAB_MNGR_STAT'range);

  signal  next_timer_mngr_stat   : std_logic_vector(REGFILE.ACQ.GRAB_STAT.TIMER_MNGR_STAT'range);
  signal  timer_mngr_stat        : std_logic_vector(REGFILE.ACQ.GRAB_STAT.TIMER_MNGR_STAT'range);

  signal  next_trig_mngr_stat    : std_logic_vector(REGFILE.ACQ.GRAB_STAT.TRIG_MNGR_STAT'range);
  signal  trig_mngr_stat         : std_logic_vector(REGFILE.ACQ.GRAB_STAT.TRIG_MNGR_STAT'range);


  -- EXPOSURE DB registers 
  signal  curr_trigger_src       : std_logic_vector(REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC'range);
  signal  curr_trigger_act       : std_logic_vector(REGFILE.ACQ.GRAB_CTRL.TRIGGER_ACT'range);
  signal  curr_readout_length    : std_logic_vector(REGFILE.ACQ.READOUT_CFG2.READOUT_LENGTH'range);
  --signal  curr_readout_en        : std_logic;
  signal  curr_exposure_lev_mode : std_logic;
  signal  curr_exposure_ss       : std_logic_vector(REGFILE.ACQ.EXP_CTRL1.EXPOSURE_SS'range);
  signal  curr_exposure_ds       : std_logic_vector(REGFILE.ACQ.EXP_CTRL2.EXPOSURE_DS'range);
  signal  curr_exposure_ts       : std_logic_vector(REGFILE.ACQ.EXP_CTRL3.EXPOSURE_TS'range);
  signal  curr_trigger_delay     : std_logic_vector(REGFILE.ACQ.TRIGGER_DELAY.TRIGGER_DELAY'range);
  signal  curr_strobe_e          : std_logic;
  signal  curr_strobe_mode       : std_logic;
  signal  curr_strobe_start      : std_logic_vector(REGFILE.ACQ.STROBE_CTRL1.STROBE_START'range);
  signal  curr_strobe_end        : std_logic_vector(REGFILE.ACQ.STROBE_CTRL2.STROBE_END'range);
  signal  curr_strobe_A_en       : std_logic;
  signal  curr_strobe_B_en       : std_logic;
  signal  curr_level_mode_exp    : std_logic;
  signal  curr_level_mode_cont   : std_logic;
  signal  curr_trigger_overlap   : std_logic;
  signal  curr_trigger_overlap_buffn   : std_logic;

  -- READOUT DB registers
  signal  curr_GRAB_ROI2_EN      : std_logic; 

  signal  curr_CSC_32            : std_logic_vector(31 downto 0):= (others=>'0');
  signal  curr_BUFFER_ID         : std_logic; -- hardcode a un seul bit a cause du register file. Si jamais le register file est etendu, ca ne va pas compiler
  --signal  curr_db_BUFFER_ID_int  : std_logic;
  --signal  curr_DMA_PARAMETER     : ALIAS_DMA_TYPE;
  
  signal  curr_y_start           : std_logic_vector(REGFILE.ACQ.SENSOR_ROI_Y_START.Y_START'high+2 downto 0 );  --XGS in kernel of 4 lignes
  signal  curr_y_size            : std_logic_vector(REGFILE.ACQ.SENSOR_ROI_Y_SIZE.Y_SIZE'high+2 downto 0 );    --XGS in kernel of 4 lignes
  signal  curr_y_start_ROI2      : std_logic_vector(REGFILE.ACQ.SENSOR_ROI2_Y_START.Y_START'high+2 downto 0 );  --XGS in kernel of 4 lignes
  signal  curr_y_size_ROI2       : std_logic_vector(REGFILE.ACQ.SENSOR_ROI2_Y_SIZE.Y_SIZE'high+2 downto 0 );    --XGS in kernel of 4 lignes

  --signal  curr_reverse_y         : std_logic;
  signal  curr_subsampling_X       : std_logic;
  signal  curr_subsampling_Y       : std_logic;

  
  type type_grab_mngr_state is (  idle,
                                  sensor_reprog,
                                  wait_end_rdo,
                                  wait_end_deadwindow,
                                  arm,
                                  trig,
                                  wait_level,
                                  wait_end_rdout,
                                  wait_so_fot,
                                  wait_eo_fot
                               );
  signal  curr_grab_mngr_state   :  type_grab_mngr_state;
  signal  next_grab_mngr_state   :  type_grab_mngr_state;

  signal  hw_trig                : std_logic;
  
  signal  next_grab_mngr_trig          : std_logic;
  signal  grab_mngr_trig               : std_logic;
  signal  grab_mngr_trig_p1            : std_logic;
  signal  next_grab_mngr_trig_rdy      : std_logic;
  signal  grab_mngr_trig_rdy           : std_logic;
  signal  next_grab_mngr_trig_ack      : std_logic;
  signal  grab_mngr_trig_ack           : std_logic;


  signal  next_grab_mngr_sensor_reconf : std_logic;
  signal  grab_mngr_sensor_reconf      : std_logic;
  --signal  grab_mngr_sensor_reconf_done : std_logic;
  signal  sensor_reconf_busy           : std_logic;
  
  type type_trig_mngr_state is (  idle,
                                  trigger,
                                  wait_exp_start,
                                  single_slope,
                                  exp_level,
                                  monitoring,
                                  SO_FOT_STATE,
                                  FOT_STATE,
                                  EO_FOT_STATE,
                                  readout_state,
                                  wait_pet
                               );
  signal  curr_trig_mngr_state   :  type_trig_mngr_state;
  signal  next_trig_mngr_state   :  type_trig_mngr_state;


  type type_timer_mngr_state is(  idle,
                                  verify_reconf_busy,
                                  delaying,
                                  trig,
                                  exposure_monitor,
                                  exposure,
                                  --exposure_fot,
                                  exposure_end,
                                  level
                               );
  signal  curr_timer_mngr_state  :  type_timer_mngr_state;
  signal  next_timer_mngr_state  :  type_timer_mngr_state;

  signal  next_timer_exposure_end: std_logic;
  signal  timer_exposure_end     : std_logic;
  --signal  exp_fot_cntr           : std_logic_vector(REGFILE.ACQ.EXP_FOT.EXP_FOT_TIME'range);

  signal  exposure_cntr          : std_logic_vector(REGFILE.ACQ.EXP_CTRL1.EXPOSURE_SS'range);
  signal  readout_cnt            : std_logic;
  signal  readout_cntr           : std_logic_vector(REGFILE.ACQ.READOUT_CFG2.READOUT_LENGTH'range); 
  signal  readout_cntr_FOT       : std_logic:= '0'; -- generation du EO_FOT a l'interne
  signal  readout_cntr_EO_FOT    : std_logic:= '0'; -- generation du EO_FOT a l'interne
  
  
  signal  readout_cntr2          : std_logic_vector(REGFILE.ACQ.READOUT_CFG2.READOUT_LENGTH'range);
  signal  readout_cntr2_armed    : std_logic;
  signal  readout_cntr2_end      : std_logic;
  
  
  signal  next_readout_stateD    : std_logic;
  signal  readout_stateD         : std_logic;
  
  signal  readout                : std_logic;       -- range may be corercted

  signal  next_trig0             : std_logic;
  signal  next_readout_cnt       : std_logic;

  signal  next_SO_FOT            : std_logic;
  signal  next_FOT               : std_logic;
  signal  next_EO_FOT            : std_logic;
  signal  SO_FOT                 : std_logic;
  signal  FOT                    : std_logic;
  signal  EO_FOT                 : std_logic;
  
  signal  curr_trig0             : std_logic;
  signal  curr_trig0_P1          : std_logic; 
  signal  xgs_trig_int_delayed   : std_logic; 

  signal  xgs_monitor0_p1        : std_logic;
  signal  xgs_exposure           : std_logic;
  signal  xgs_exposure_p1        : std_logic;
  signal  exposure_outpin        : std_logic:='0';
  signal  exposure_reg           : std_logic;
  signal  trig_rdy_outpin        : std_logic:='0';

  attribute KEEP       of trig_rdy_outpin     : signal is "TRUE";
  attribute dont_touch of trig_rdy_outpin     : signal is "TRUE";
  attribute KEEP       of exposure_outpin     : signal is "TRUE";
  attribute dont_touch of exposure_outpin     : signal is "TRUE";
  attribute KEEP       of xgs_exposure_p1     : signal is "TRUE";
  attribute dont_touch of xgs_exposure_p1     : signal is "TRUE";
  
  attribute ASYNC_REG of xgs_monitor0_p1  : signal is "TRUE";
  attribute ASYNC_REG of xgs_exposure     : signal is "TRUE";


  signal  xgs_monitor1_p1  : std_logic;
  signal  xgs_FOT          : std_logic;
  signal  xgs_FOT_p1       : std_logic;
  signal  xgs_EO_FOT       : std_logic;
  attribute ASYNC_REG of xgs_monitor1_p1  : signal is "TRUE";
  attribute ASYNC_REG of xgs_FOT          : signal is "TRUE";

  signal  xgs_monitor2_p1  : std_logic;
  signal  XGS_NEW_LINE     : std_logic;
  signal  XGS_NEW_LINE_p1  : std_logic;
 
  attribute ASYNC_REG of xgs_monitor2_p1  : signal is "TRUE";
  attribute ASYNC_REG of XGS_NEW_LINE     : signal is "TRUE";
  
  


  signal  ext_trig_p1            : std_logic;
  signal  ext_trig_p2            : std_logic;
  signal  ext_trig_p3            : std_logic;

  attribute ASYNC_REG of ext_trig_p1  : signal is "TRUE";
  attribute ASYNC_REG of ext_trig_p2  : signal is "TRUE";
  
  signal  next_trig_delayed      : std_logic;
  signal  next_timer_cnt         : std_logic;
  signal  next_timer_exposure    : std_logic;

  signal  trig_delayed           : std_logic;
  signal  trig_delayed_p1        : std_logic;
  signal  timer_cnt              : std_logic;
  signal  timer_exposure         : std_logic;

  signal  timer_cntr             : std_logic_vector(REGFILE.ACQ.TRIGGER_DELAY.TRIGGER_DELAY'range);

  signal  strobe                 : std_logic;

  signal  strobe_outpin                 : std_logic:='0';
  attribute KEEP       of strobe_outpin : signal is "TRUE";
  attribute dont_touch of strobe_outpin : signal is "TRUE";

  signal  strobe_p1                     : std_logic;
  attribute KEEP       of strobe_p1     : signal is "TRUE";
  attribute dont_touch of strobe_p1     : signal is "TRUE";

  signal hw_trig_miss             : std_logic;
  signal sw_trig_miss            : std_logic;
  signal trigger_missed_cntr     : std_logic_vector(REGFILE.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_CNTR'high+1 downto 0); -- Bit 16 is used to stop the counter at 0xffff

  signal  OneSec_cntr            : std_logic_vector(27 downto 0);
  signal  fps_cntr_ld            : std_logic;
  signal  fps_cntr               : std_logic_vector(REGFILE.ACQ.SENSOR_FPS.SENSOR_FPS'range);
  signal  fps_cntr_db            : std_logic_vector(REGFILE.ACQ.SENSOR_FPS.SENSOR_FPS'range);

  signal fast_fps_est     : std_logic_vector(REGFILE.ACQ.DEBUG_CNTR1.SENSOR_FRAME_DURATION'range);
  signal fast_fps_est_DB  : std_logic_vector(REGFILE.ACQ.DEBUG_CNTR1.SENSOR_FRAME_DURATION'range); 
  
  -------------------------------------
  --  Signaux Chipscopables
  -------------------------------------
  --attribute mark_debug : string;
  --attribute keep       : string;
  --attribute mark_debug of grab_mngr_trig_rdy    : signal is "true";
  
  --attribute mark_debug of curr_trig0            : signal is "true";
  --attribute mark_debug of strobe                : signal is "true";
  
  --attribute mark_debug of python_exposure       : signal is "true";
  --attribute mark_debug of FOT                   : signal is "true";
  --attribute mark_debug of readout               : signal is "true";
  
  --attribute mark_debug of readout_stateD        : signal is "true";
  --attribute mark_debug of grab_mngr_trig        : signal is "true";
  --attribute mark_debug of grab_pending          : signal is "true";
  --attribute mark_debug of grab_active           : signal is "true";
  --attribute mark_debug of TRIG_MNGR_STAT        : signal is "true";
  --attribute mark_debug of TIMER_MNGR_STAT       : signal is "true";
  --attribute mark_debug of GRAB_MNGR_STAT        : signal is "true";

--signal python_monitor0_p1_pix     : std_logic;
--signal python_monitor0_p2_pix     : std_logic;
--
--signal python_monitor1_p1_pix     : std_logic;
--signal python_monitor1_p2_pix     : std_logic;
--
--signal grab_mngr_trig_rdy_p1_pix  : std_logic;
--signal grab_mngr_trig_rdy_p2_pix  : std_logic;
--
--signal FOT_p1_pix                 : std_logic;
--signal FOT_p2_pix                 : std_logic;
--
--signal readout_p1_pix             : std_logic;
--signal readout_p2_pix             : std_logic;
--
--signal readout_stateD_p1_pix      : std_logic;
--signal readout_stateD_p2_pix      : std_logic;


type type_grab_abort_state is(  idle,
                                abort_states,
                                abort_cmd_flags,
                                abort_ser_fifo,
                                abort_dma,
                                abort_irq
                             );
signal  curr_grab_abort_state  :  type_grab_abort_state;
signal  next_grab_abort_state  :  type_grab_abort_state;

signal  abort_mngr_stat        :  std_logic_vector(2 downto 0);
signal  next_abort_mngr_stat   :  std_logic_vector(2 downto 0);

signal abort_now                :  std_logic;
signal abort_grab_cmd           :  std_logic;
signal abort_fifo_cmd           :  std_logic;
signal abort_fifo_cmd_done      :  std_logic;
signal abort_done               :  std_logic;

signal abort_seq                :  std_logic;  -- trig mngr qui trouve un abort et signale aux autres states machines d'arreter
signal abort_delai              :  std_logic;  -- Abort during delai,       abort delai ->  dont start new exposure
signal abort_pet                :  std_logic;  -- Abort during pet waiting, abort pet   ->  dont start new exposure

signal next_abort_now                :  std_logic;
signal next_abort_grab_cmd           :  std_logic;
signal next_abort_fifo_cmd           :  std_logic;
signal next_irq_abort                :  std_logic;
signal next_abort_fifo_cmd_done      :  std_logic;
signal next_abort_done               :  std_logic;

--
-- signaux pour sous-module DMA params
--
--signal  COLOR_SPACE                     :  std_logic_vector(2 downto 0);
--signal  MONO10                          :  std_logic;
--signal  REVERSE_Y                       :  std_logic;
--signal  GRAB_REVX                       :  std_logic;
--signal  regfile_dma_parameters          : ALIAS_DMA_TYPE; -- indirection sur le register file de DMA au complet

signal  acquisition_start_SFNC          :  std_logic := '0';

signal TOTAL_NB_LINES                : std_logic_vector(12 downto 0);
signal INTERNAL_READOUT_LENGTH_FLOAT : std_logic_vector(47 downto 0);
signal INTERNAL_READOUT_LENGTH       : std_logic_vector(REGFILE.ACQ.READOUT_CFG2.READOUT_LENGTH'range);
  
constant SENSOR_PERIOD_32p4          : std_logic_vector(18 downto 0):= "1111011011101001111"; --X"7B74F";  --[4].[15] : 15.4320985 ns = 1/(2x32.4Mhz)
constant SENSOR_PERIOD_32p0          : std_logic_vector(18 downto 0):= "1111101000000000000"; --X"7d000";  --[4].[15] :     15.625 ns = 1/(2x32Mhz)

signal   SENSOR_PERIOD               : std_logic_vector(18 downto 0); 

-- Pour le board de developpement, on n'a aps les signaux monitor
signal Synthetic_EXPOSURE : std_logic :='0';
signal Synthetic_DELAI_EXP: std_logic :='0'; 
signal Synthetic_cntr     : std_logic_vector(15 downto 0) :=(others=>'0');

signal strobe_DMA_P1_vector :  std_logic_vector(3 downto 0) :=(others=>'0');
signal strobe_DMA_P2_vector :  std_logic_vector(3 downto 0) :=(others=>'0');


signal debug_ctrl16_int : std_logic_vector(debug_ctrl16'range);

BEGIN

 

  SENSOR_PERIOD <=  SENSOR_PERIOD_32p4 when G_SENSOR_FREQ=32400 else SENSOR_PERIOD_32p0 ;
 
  ------------------------------------------------------------------------------------------------------------------------------ 
  -- For the 3D profiler, we want to be able to reload the parameters (Python sensor parameters and fpga parameters) with the 
  -- companIOn acquisition_start.
  -- First step is to issue a grab_cmd with trigger source = "100" SFNC, to set the Python controller in SFNC mode
  -- Then each acquisition_start of the companIOn module will reload FPGA and SENSOR parameters.
  acquisition_start_SFNC <= '1' when (acquisition_start='1' and curr_grab_mngr_state=arm) else 
                            '0';

  ------------------------------------------
  --
  --  STATUS REGISTERS
  --
  ------------------------------------------

  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then

      if(sys_reset_n='0') then
        grab_idle_stat    <= '1';
      else
        if(curr_grab_mngr_state=idle and curr_timer_mngr_state=idle and curr_trig_mngr_state=idle) then
          grab_idle_stat    <= '1';
        else
          grab_idle_stat    <= '0';
        end if;
      end if;
    end if;
  end process;

  REGFILE.ACQ.GRAB_STAT.TRIG_MNGR_STAT  <= TRIG_MNGR_STAT;
  REGFILE.ACQ.GRAB_STAT.TIMER_MNGR_STAT <= TIMER_MNGR_STAT;
  REGFILE.ACQ.GRAB_STAT.GRAB_MNGR_STAT  <= GRAB_MNGR_STAT;

  REGFILE.ACQ.GRAB_STAT.GRAB_FOT        <= FOT;
  REGFILE.ACQ.GRAB_STAT.GRAB_READOUT    <= readout;
  REGFILE.ACQ.GRAB_STAT.GRAB_EXPOSURE   <= exposure_reg;

  REGFILE.ACQ.GRAB_STAT.GRAB_PENDING    <= grab_pending;
  REGFILE.ACQ.GRAB_STAT.GRAB_ACTIVE     <= grab_active;
  REGFILE.ACQ.GRAB_STAT.GRAB_IDLE       <= grab_idle_stat;

  ------------------------------------------
  --
  --  HW TRIGGER ACTIVATION
  --
  ------------------------------------------

  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then

      if(sys_reset_n='0') then
        ext_trig_p1  <= '0';
        ext_trig_p2  <= '0';
        ext_trig_p3  <= '0';
      else
        ext_trig_p1  <= ext_trig;
        ext_trig_p2  <= ext_trig_p1;
        ext_trig_p3  <= ext_trig_p2;
      end if;


      if(sys_reset_n='0') then
        sw_trig_miss      <= '0';
      elsif(curr_trigger_src/="011") then       -- If not SW trig, then not generate signal
        sw_trig_miss      <= '0';
      else
        if(REGFILE.ACQ.GRAB_CTRL.GRAB_SS='1') then
          if(grab_mngr_trig_rdy='0') then
            sw_trig_miss  <= '1';
          else
            sw_trig_miss  <= '0';
          end if;
        else
          sw_trig_miss    <= '0';
        end if;
      end if;

      if(sys_reset_n='0') then
        hw_trig          <= '0';
        hw_trig_miss     <= '0';
      elsif(curr_trigger_src/="010" and curr_trigger_src/="100") then       -- If not HW trig, then not generate signal
        hw_trig          <= '0';
        hw_trig_miss     <= '0';
      else
        if(curr_trigger_act="000") then                                           -- RISING edge
          if(ext_trig_p2='1' and ext_trig_p3='0') then
            if(grab_mngr_trig_rdy='1') then
              hw_trig          <= '1';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= '0';
              hw_trig_miss     <= '1';
            end if;
          else
            hw_trig          <= '0';
            hw_trig_miss     <= '0';
          end if;
            
        elsif(curr_trigger_act="001") then                                        -- FALLING edge
          if(ext_trig_p2='0' and ext_trig_p3='1') then
            if(grab_mngr_trig_rdy='1') then
              hw_trig          <= '1';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= '0';
              hw_trig_miss     <= '1';
            end if;
          else
            hw_trig          <= '0';
            hw_trig_miss     <= '0';
          end if;

        elsif(curr_trigger_act="010") then                                        -- RISING OR FALLING
          if(ext_trig_p2='1' and ext_trig_p3='0') or (ext_trig_p2='0' and ext_trig_p3='1')  then
            if(grab_mngr_trig_rdy='1') then
              hw_trig          <= '1';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= '0';
              hw_trig_miss     <= '1';
            end if;
          else
            hw_trig          <= '0';
            hw_trig_miss     <= '0';
          end if;

        elsif(curr_trigger_act="011") then                                        -- LEVEL HI with exposure TIMED   OR  LEVEL HI with exposure TRIGGER WIDTH
          if(ext_trig_p2='1' and ext_trig_p3='0') then       --rising ext trig
            if(grab_mngr_trig_rdy='1') then
              hw_trig          <= '1';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= '0';
              hw_trig_miss     <= '1';
            end if;
          elsif(hw_trig='1') then
            if(ext_trig_p2='0' and ext_trig_p3='1') then     --falling ext trig
              hw_trig          <= '0';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= hw_trig;
              hw_trig_miss     <= '0';
            end if;
          else
            hw_trig          <= hw_trig;
            hw_trig_miss     <= '0';
          end if;

        elsif(curr_trigger_act="100") then                                        -- LEVEL LO with exposure TIMED   OR LEVEL LO with exposure TRIGGER WIDTH
          if(ext_trig_p2='0' and ext_trig_p3='1') then
            if(grab_mngr_trig_rdy='1') then
              hw_trig          <= '1';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= '0';
              hw_trig_miss     <= '1';
            end if;
          elsif(hw_trig='1') then
            if(ext_trig_p2='1' and ext_trig_p3='0') then
              hw_trig          <= '0';
              hw_trig_miss     <= '0';
            else
              hw_trig          <= hw_trig;
              hw_trig_miss     <= '0';
            end if;
          else
            hw_trig          <= hw_trig;
            hw_trig_miss     <= '0';
          end if;
        
        else
          hw_trig          <= '0';
          hw_trig_miss     <= '0';
        end if;

      end if;
      
    end if;
  end process;




  -----------------------------------------------------------------------------
  -- FIRST STEP OF GRAB COMMAND
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- grab_active
  -----------------------------------------------------------------------------
  process (sys_clk)
  begin  
    if (sys_clk'event  and sys_clk = '1') then
      if (sys_reset_n = '0' or abort_grab_cmd='1') then
        grab_active <= '0';
      
      elsif(REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC="100" and REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active = '0') or (curr_trigger_src="100") then
        grab_active <= '1';
        
      elsif(EO_FOT='1') then
        if(REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active = '1') then         -- bug sur bench : FOT et grabCMD en meme temps
          grab_active <= '1';
        elsif(grab_pending= '1') then  -- Pending=1
          grab_active <= '1';
        else
          grab_active <= '0';          -- Pending=0, active=1
        end if;
      elsif(REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active = '0') then
        grab_active <= '1';
      end if;
    end if;
  end process; 

  -----------------------------------------------------------------------------
  -- grab_pending
  -----------------------------------------------------------------------------
  process (sys_clk)
  begin  
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0' or abort_grab_cmd='1') then
        grab_pending <= '0'; 
      
      elsif(REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC="100" and REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active = '0') or (curr_trigger_src="100") then
        grab_pending <= '1';

      elsif(EO_FOT='1') then
        if(REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active = '1') then         -- bug sur bench : FOT et grabCMD en meme temps
          grab_pending <= '0';
        elsif(grab_pending= '1') then   -- Pending=1
          grab_pending <= '0';
        else                            -- Pending=0
          grab_pending <= '0';
        end if;
      elsif(REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active = '1' and grab_pending='0') then
        grab_pending <= '1';
      end if;
      
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Double buffer current GRAB registers (GTR+N3)
  -----------------------------------------------------------------------------
  process (sys_clk)
  begin  
    if (sys_clk'event and sys_clk = '1') then
      ------------------------------------------------------------------------
      --  Those are Exposure parameters
      ------------------------------------------------------------------------
      -- dont cahnge current on EOFOT when in SFNC mode
      if(abort_now='1') then
        curr_trigger_src        <= (others=>'0');      
      elsif(REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active= '0') or (EO_FOT='1' and (grab_pending= '1' or REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1') ) then   --bug bench EO_FOT+GRABCMD        
        curr_trigger_src        <= REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC;
      end if;  

      if(acquisition_start_SFNC='1') or (REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active= '0') or (EO_FOT='1' and REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC/="100" and (grab_pending= '1' or REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1') ) then   --bug bench EO_FOT+GRABCMD        

        --curr_readout_length     <= REGFILE.ACQ.READOUT_CFG2.READOUT_LENGTH;
        curr_readout_length     <= INTERNAL_READOUT_LENGTH;
        
        curr_trigger_src        <= REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC;
        curr_trigger_act        <= REGFILE.ACQ.GRAB_CTRL.TRIGGER_ACT;
        --curr_readout_en         <= REGFILE.ACQ.READOUT_CFG2.READOUT_EN;
        curr_exposure_lev_mode  <= REGFILE.ACQ.EXP_CTRL1.EXPOSURE_LEV_MODE;
        
        ------------------------------------------------------------------
        -- This is a new 3d profiler feature
        -- We will be able to program upto 3 diferent exposure times (using unused multiSlope registers)
        -- Then we will be able to sequence those exposure times 
        --
        if(exposure_select="00") then
          if(REGFILE.ACQ.EXP_FOT.EXP_FOT='0') then 
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL1.EXPOSURE_SS;
          else
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL1.EXPOSURE_SS - REGFILE.ACQ.EXP_FOT.EXP_FOT_TIME;
          end if;          
        elsif(exposure_select="01") then 
          if(REGFILE.ACQ.EXP_FOT.EXP_FOT='0') then 
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL2.EXPOSURE_DS;
          else
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL2.EXPOSURE_DS - REGFILE.ACQ.EXP_FOT.EXP_FOT_TIME;
          end if;          
        elsif(exposure_select="10") then 
          if(REGFILE.ACQ.EXP_FOT.EXP_FOT='0') then 
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL3.EXPOSURE_TS;
          else
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL3.EXPOSURE_TS - REGFILE.ACQ.EXP_FOT.EXP_FOT_TIME;
          end if;                      
        else
          if(REGFILE.ACQ.EXP_FOT.EXP_FOT='0') then 
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL1.EXPOSURE_SS;
          else
            curr_exposure_ss        <= REGFILE.ACQ.EXP_CTRL1.EXPOSURE_SS - REGFILE.ACQ.EXP_FOT.EXP_FOT_TIME;
          end if;          
        end if;
        
        curr_exposure_ds        <= REGFILE.ACQ.EXP_CTRL2.EXPOSURE_DS;
        curr_exposure_ts        <= REGFILE.ACQ.EXP_CTRL3.EXPOSURE_TS;
        curr_trigger_delay      <= REGFILE.ACQ.TRIGGER_DELAY.TRIGGER_DELAY;
        curr_strobe_e           <= REGFILE.ACQ.STROBE_CTRL1.STROBE_E;
        curr_strobe_mode        <= REGFILE.ACQ.STROBE_CTRL2.STROBE_MODE;
        curr_strobe_start       <= REGFILE.ACQ.STROBE_CTRL1.STROBE_START;
        curr_strobe_end         <= REGFILE.ACQ.STROBE_CTRL2.STROBE_END;
        curr_trigger_overlap    <= REGFILE.ACQ.GRAB_CTRL.TRIGGER_OVERLAP;
        curr_trigger_overlap_buffn <= REGFILE.ACQ.GRAB_CTRL.TRIGGER_OVERLAP_BUFFn;
        curr_strobe_A_en        <= REGFILE.ACQ.STROBE_CTRL2.STROBE_A_EN;
        curr_strobe_B_en        <= REGFILE.ACQ.STROBE_CTRL2.STROBE_B_EN;
        
        if(REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC="010" and REGFILE.ACQ.EXP_CTRL1.EXPOSURE_LEV_MODE='1' and (REGFILE.ACQ.GRAB_CTRL.TRIGGER_ACT="011" or REGFILE.ACQ.GRAB_CTRL.TRIGGER_ACT="100")) then       -- Level mode with TriggerWidth exposure mode
          curr_level_mode_exp       <= '1';
        else
          curr_level_mode_exp       <= '0';
        end if;

        if(REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC="010" and REGFILE.ACQ.EXP_CTRL1.EXPOSURE_LEV_MODE='0' and (REGFILE.ACQ.GRAB_CTRL.TRIGGER_ACT="011" or REGFILE.ACQ.GRAB_CTRL.TRIGGER_ACT="100")) then       -- Level mode with Timed exposure mode
          curr_level_mode_cont       <= '1';
        else
          curr_level_mode_cont       <= '0';
        end if;
      end if;
      
      ------------------------------------------------------------------------
      --  Those are Readout parameters GRAB
      ------------------------------------------------------------------------
      if (acquisition_start_SFNC='1') or (REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active= '0') or (EO_FOT='1' and REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC/="100" ) then
        strobe_DMA_P1_vector(0) <= '1';
      else
        strobe_DMA_P1_vector(0) <= '0';
      end if;  
      
      if(EO_FOT='1') then
        strobe_DMA_P2_vector(0) <= '1';
      else
        strobe_DMA_P2_vector(0) <= '0';
      end if; 
      
      strobe_DMA_P1_vector(strobe_DMA_P1_vector'high downto 1) <= strobe_DMA_P1_vector(strobe_DMA_P1_vector'high -1 downto 0);
      strobe_DMA_P1                                            <= orN(strobe_DMA_P1_vector);
      strobe_DMA_P2_vector(strobe_DMA_P2_vector'high downto 1) <= strobe_DMA_P2_vector(strobe_DMA_P2_vector'high -1 downto 0);
      strobe_DMA_P2                                            <= orN(strobe_DMA_P2_vector);
      
      
      if (acquisition_start_SFNC='1') or (REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active= '0') or (EO_FOT='1' and REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC/="100" ) then
              
        curr_y_start               <= REGFILE.ACQ.SENSOR_ROI_Y_START.Y_START & "00";
        curr_y_size                <= REGFILE.ACQ.SENSOR_ROI_Y_SIZE.Y_SIZE   & "00";
        
        curr_y_start_ROI2          <= REGFILE.ACQ.SENSOR_ROI2_Y_START.Y_START & "00";
        curr_y_size_ROI2           <= REGFILE.ACQ.SENSOR_ROI2_Y_SIZE.Y_SIZE   & "00";

        curr_GRAB_ROI2_EN          <= REGFILE.ACQ.GRAB_CTRL.GRAB_ROI2_EN;

        curr_subsampling_X         <= REGFILE.ACQ.SENSOR_SUBSAMPLING.SUBSAMPLING_X;
        curr_subsampling_Y         <= REGFILE.ACQ.SENSOR_SUBSAMPLING.ACTIVE_SUBSAMPLING_Y;
      end if;
     
      
      if(EO_FOT='1') then
        curr_db_y_start_ROI1       <= curr_y_start;                 --Only used in Bayer
        curr_db_nblines_ROI1       <= curr_y_size;

        curr_db_y_start_ROI2       <= curr_y_start_ROI2;
        curr_db_nblines_ROI2       <= curr_y_size_ROI2;
        
        curr_db_GRAB_ROI2_EN       <= curr_GRAB_ROI2_EN;
        
        curr_db_subsampling_X      <= curr_subsampling_X;
        curr_db_subsampling_Y      <= curr_subsampling_Y;
      end if;
      
      
    end if;
  end process;


--  -----------------------------------------------------------------------------
--  -- Double buffer current DMA registers (GTR: python_ctrl_DMA_params_GTR & N3:python_ctrl_DMA_params_N3)
--  -----------------------------------------------------------------------------
  process (sys_clk)
--    --variable reg : ALIAS_DMA_GRAB_CSC_TYPE;
  begin  
    if (sys_clk'event and sys_clk = '1') then
      ------------------------------------------------------------------------
      --  Those are Readout parameters DMA
      ------------------------------------------------------------------------
      if(acquisition_start_SFNC='1') or (REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and grab_active= '0') or (EO_FOT='1' and REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC/="100" ) then     
        -- a ce moment-ci nous sauvons les parametres du DMA. Dans Nexis3, nous sauvons le buffer ID pour le renvoyer a l'autre FPGA
        curr_BUFFER_ID  <= REGFILE.ACQ.GRAB_CTRL.BUFFER_ID;
      end if;

      if(EO_FOT='1') then
        curr_db_BUFFER_ID          <= curr_BUFFER_ID;
      end if;
      
    end if;
  end process;


  -- synthesis translate_off
  -- POUR AIDER LES SIMs
  curr_acq_mode <= CONTINUOUS                           when (curr_trigger_src="001")                                                            else
                   TRIGGERED_HW_EDGE_RISE               when (curr_trigger_src="010" and curr_trigger_act="000")                                 else
                   TRIGGERED_HW_EDGE_FALL               when (curr_trigger_src="010" and curr_trigger_act="010")                                 else
                   TRIGGERED_HW_LEVEL_HI_EXP_TRIGWIDTH  when (curr_trigger_src="010" and curr_trigger_act="011" and curr_exposure_lev_mode='1')  else
                   TRIGGERED_HW_LEVEL_LO_EXP_TRIGWIDTH  when (curr_trigger_src="010" and curr_trigger_act="100" and curr_exposure_lev_mode='1')  else
                   TRIGGERED_HW_LEVEL_HI_EXP_TIMED      when (curr_trigger_src="010" and curr_trigger_act="011" and curr_exposure_lev_mode='0')  else
                   TRIGGERED_HW_LEVEL_LO_EXP_TIMED      when (curr_trigger_src="010" and curr_trigger_act="100" and curr_exposure_lev_mode='0')  else
                   TRIGGERED_SW                         when (curr_trigger_src="011")                                                            else
                   SFNC                                 when (curr_trigger_src="100")                                                            else
                   NOT_DEFINED_YET;
  -- synthesis translate_on


  -----------------------------------------------------------------------------
  -- SECOND STEP : GRAB MANAGER
  -----------------------------------------------------------------------------

  process(curr_grab_mngr_state, REGFILE, curr_trigger_src, curr_level_mode_exp, hw_trig, SO_FOT, EO_FOT, grab_pending,  readout, abort_now, abort_seq, curr_trigger_overlap, curr_trigger_overlap_buffn, readout_cnt, curr_exposure_ss, readout_cntr, curr_exposure_ds, acquisition_start_SFNC)
  begin
    case curr_grab_mngr_state is
      when  idle              =>  if(REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1' and abort_now='0' and REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='0') then
                                    if(regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1' and REGFILE.ACQ.GRAB_CTRL.TRIGGER_SRC/="100") then
                                      next_grab_mngr_state  <= sensor_reprog;
                                    else
                                      next_grab_mngr_state  <= arm;
                                    end if;
                                  else
                                    next_grab_mngr_state  <= idle;
                                  end if;

      when  sensor_reprog     =>  -- The sensor reprogrammation wait is now done in the DELAI FSM
                                  if(curr_trigger_overlap='1') then
                                    if(curr_trigger_overlap_buffn='1' and curr_level_mode_exp='0') then
                                      next_grab_mngr_state  <= wait_end_deadwindow;
                                    else
                                      next_grab_mngr_state  <= arm;
                                    end if;  
                                  else
                                    next_grab_mngr_state  <= wait_end_rdo;
                                  end if;

      when  wait_end_rdo      =>  -- PET ENGIN DISABLE
                                  if (abort_now='1') then
                                    next_grab_mngr_state  <= idle;
                                  elsif(readout = '0') then
                                    next_grab_mngr_state  <= arm;
                                  else
                                    next_grab_mngr_state  <= wait_end_rdo;
                                  end if;

      when  wait_end_deadwindow =>  -- PET ENGIN ENABLE, BUT DON'T BUFFER TRIGGERS
                                    if (abort_now='1') then
                                      next_grab_mngr_state  <= idle;
                                    elsif(readout_cnt='1') then
                                      if( ('0'& curr_exposure_ss) > readout_cntr ) then      --Single slope
                                        next_grab_mngr_state  <= arm;
                                      else
                                        next_grab_mngr_state  <= wait_end_deadwindow;
                                      end if;
                                    else
                                      next_grab_mngr_state  <= arm;
                                    end if;
      
      when  arm               =>  if(abort_now='1') then
                                    next_grab_mngr_state  <= idle;
                                  elsif(acquisition_start_SFNC='1') then
                                    next_grab_mngr_state  <= sensor_reprog;                                 
                                  elsif (curr_trigger_src="011" and REGFILE.ACQ.GRAB_CTRL.GRAB_SS='1')        or    -- SOfT MODE
                                        ((curr_trigger_src="010" or curr_trigger_src="100") and hw_trig='1')  or    -- HARD MODE
                                        (curr_trigger_src="001"  or curr_trigger_src="000")                   then    -- CONTINUOUS 
                                    next_grab_mngr_state  <= trig;
                                  else
                                    next_grab_mngr_state  <= arm;
                                  end if;
      
      when  trig              =>  if(curr_level_mode_exp='1') then                                        -- Level mode with TriggerWidth exposure mode
                                    next_grab_mngr_state  <= wait_level;
                                  else
                                    next_grab_mngr_state  <= wait_EO_FOT;                                 -- others
                                  end if;
      
      when  wait_level        =>  if(hw_trig='0') then
                                    if(readout='1' and curr_level_mode_exp='1')  then           --deassert trig during readout looks to be bugged in the sensor!!!! so do the job here...( only with level with trigger width exposure)
                                      next_grab_mngr_state  <= wait_end_rdout; 
                                    else
                                      next_grab_mngr_state  <= wait_SO_FOT;
                                    end if;
                                  else
                                    next_grab_mngr_state  <= wait_level;
                                  end if;

      when  wait_end_rdout    =>  if(readout='0') then                                          --deassert trig during readout looks to be bugged in the sensor!!!! so do the job here...
                                    next_grab_mngr_state  <= wait_SO_FOT;
                                  else
                                    next_grab_mngr_state  <= wait_end_rdout;
                                  end if;
      
      when  wait_so_fot       =>  if(SO_FOT='1') then
                                    next_grab_mngr_state  <= wait_EO_FOT;
                                  else
                                    next_grab_mngr_state  <= wait_SO_FOT;
                                  end if;
                                                                                              
      when  wait_eo_fot       =>  if(abort_seq='1') then
                                    next_grab_mngr_state  <= idle;
                                  elsif(EO_FOT='1') then
                                    if(abort_now='0' and REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='0') then
                                      if(grab_pending='1' or REGFILE.ACQ.GRAB_CTRL.GRAB_CMD='1') then          -- --bug bench EO_FOT+GRABCMD
                                        if(regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE='1' and curr_trigger_src/="100") then  -- in 3D scanner do not reprogram at end of FOT
                                          next_grab_mngr_state  <= sensor_reprog;
                                        else
                                          if(curr_trigger_overlap='1') then
                                            if(curr_trigger_overlap_buffn='1' and curr_level_mode_exp='0') then     -- PET + NO BUFFERING
                                              next_grab_mngr_state  <= wait_end_deadwindow;
                                            else
                                              next_grab_mngr_state  <= arm;                   -- PET + BUFFERING    -- in 3D scanner path
                                            end if;  
                                          else
                                            next_grab_mngr_state    <= wait_end_rdo;          -- NO PET
                                          end if;
                                        end if;
                                      else
                                        next_grab_mngr_state  <= idle;
                                      end if;
                                    else
                                      next_grab_mngr_state  <= idle;
                                    end if;
                                  else
                                    next_grab_mngr_state  <= wait_EO_FOT;
                                  end if;
    end case;
  end process;



  process(next_grab_mngr_state)
  begin
    case next_grab_mngr_state is
      when  idle               =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "0000";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';
                                   
      when  sensor_reprog      =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "0001";
                                    next_grab_mngr_sensor_reconf <= '1';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';

      --when  sensor_wait_reprog =>   next_grab_mngr_trig          <= '0';
      --                              next_grab_mngr_stat          <= "0010";
      --                              next_grab_mngr_sensor_reconf <= '0';
      --                              next_grab_mngr_trig_rdy      <= '0';
      --                              next_grab_mngr_trig_ack      <= '0';

      when  wait_end_rdo       =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "1001";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';

      when wait_end_deadwindow =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "1010";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';

      when  arm                =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "0011";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '1';
                                    next_grab_mngr_trig_ack      <= '0';
                                   
      when  trig               =>   next_grab_mngr_trig          <= '1';
                                    next_grab_mngr_stat          <= "0100";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '1';
                                   
      when  wait_level         =>   next_grab_mngr_trig          <= '1';
                                    next_grab_mngr_stat          <= "0101";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';
                                    
      when  wait_end_rdout     =>   next_grab_mngr_trig          <= '1';
                                    next_grab_mngr_stat          <= "1000";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';

      when  wait_so_fot        =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "0110";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';
                                   
      when  wait_eo_fot        =>   next_grab_mngr_trig          <= '0';
                                    next_grab_mngr_stat          <= "0111";
                                    next_grab_mngr_sensor_reconf <= '0';
                                    next_grab_mngr_trig_rdy      <= '0';
                                    next_grab_mngr_trig_ack      <= '0';
    end case;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_grab_mngr_state    <=  idle;
        grab_mngr_trig          <=  '0';
        grab_mngr_trig_p1       <=  '0';
        grab_mngr_stat          <=  "0000";
        grab_mngr_sensor_reconf <=  '0';
        grab_mngr_trig_rdy      <=  '0';
        grab_mngr_trig_ack      <=  '0';
      else
        curr_grab_mngr_state    <=  next_grab_mngr_state;
        grab_mngr_trig          <=  next_grab_mngr_trig;
        grab_mngr_trig_p1       <=  grab_mngr_trig;
        grab_mngr_stat          <=  next_grab_mngr_stat;
        grab_mngr_sensor_reconf <=  next_grab_mngr_sensor_reconf;
        grab_mngr_trig_rdy      <=  next_grab_mngr_trig_rdy;
        grab_mngr_trig_ack      <=  next_grab_mngr_trig_ack;
        
      end if;
    end if;
  end process;

  REGFILE.ACQ.GRAB_STAT.TRIGGER_RDY  <= grab_mngr_trig_rdy;

  ----------------------------------------
  --  Trigger Missed
  ----------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        trigger_missed_cntr  <=  (others=>'0');
      else
        if(REGFILE.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_RST='1') then 
          trigger_missed_cntr  <=  (others=>'0');
        elsif(trigger_missed_cntr(REGFILE.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_CNTR'high+1) = '1') then
          trigger_missed_cntr  <=  (others=>'1');
        elsif(sw_trig_miss = '1' or hw_trig_miss = '1') then    -- SW OR HW MODEs
          trigger_missed_cntr  <= trigger_missed_cntr + '1';
        else
          trigger_missed_cntr  <= trigger_missed_cntr;
        end if;  
      end if;
    end if;
  end process;

  REGFILE.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_CNTR  <=  trigger_missed_cntr(REGFILE.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_CNTR'range);


  ----------------------------------------
  --  FPS
  ----------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
   
        OneSec_cntr  <= std_logic_vector(conv_unsigned(1000000000/G_SYS_CLK_PERIOD, 28)); -- 1 SEC
        
        fps_cntr_ld  <= '0';
        fps_cntr     <= (others=> '0');
        fps_cntr_db  <= (others=> '0');
      else

        if(OneSec_cntr=X"0000000") then 
          OneSec_cntr  <= std_logic_vector(conv_unsigned(1000000000/G_SYS_CLK_PERIOD, 28)); -- 1 SEC
          fps_cntr_ld  <= '1';
        else
          OneSec_cntr  <= OneSec_cntr-'1';        
          fps_cntr_ld  <= '0';
        end if;
        
        if(fps_cntr_ld='1') then
          fps_cntr <= (others=>'0');
        elsif(SO_FOT='1') then
          fps_cntr <= fps_cntr+'1';
        end if;
        
        if(fps_cntr_ld='1') then
          fps_cntr_db <= fps_cntr;
        end if;
        
      end if;
    end if;
  end process;

  REGFILE.ACQ.SENSOR_FPS.SENSOR_FPS  <= fps_cntr_db;


  ------------------------------------------
  -- Fast FPS estimate, frame length
  ------------------------------------------ 
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.ACQ.DEBUG.DEBUG_RST_CNTR='1') then
        fast_fps_est  <= (others=>'0');
      elsif(DEC_EOF_sys='1' ) then
        fast_fps_est  <= (others=>'0');
      elsif(fast_fps_est=X"FFFFFFF") then
        fast_fps_est  <= fast_fps_est;
      else
        fast_fps_est  <= fast_fps_est+'1';      
      end if;
    
      if(sys_reset_n='0' or regfile.ACQ.DEBUG.DEBUG_RST_CNTR='1') then
        fast_fps_est_DB  <= (others=>'0');
      elsif(DEC_EOF_sys='1' ) then
        fast_fps_est_DB  <= fast_fps_est;
      end if;
    end if;    
  end process;
    
  REGFILE.ACQ.DEBUG_CNTR1.SENSOR_FRAME_DURATION <= fast_fps_est_DB;
  
  
  ------------------------------------------
  --
  --  THIRD STEP :TIMER : EXPOSURE DELAY AND STROBE GENERATION  
  --
  ------------------------------------------


  process(curr_timer_mngr_state, REGFILE, grab_mngr_trig, grab_mngr_trig_p1, sensor_reconf_busy, curr_level_mode_exp, timer_cntr, curr_trigger_delay, xgs_exposure_p1, xgs_exposure,  abort_seq, abort_now, EO_FOT)
  begin
    case curr_timer_mngr_state is
      when  idle              =>  if(grab_mngr_trig='1' and grab_mngr_trig_p1='0') then       -- trig start, verify sensor programmation end before delai.
                                    next_timer_mngr_state  <= verify_reconf_busy;
                                  else
                                    next_timer_mngr_state  <= idle;
                                  end if;


      -- Wait for sensor reprogrammation end
      when  verify_reconf_busy=>  if(sensor_reconf_busy='1') then
                                    next_timer_mngr_state  <= verify_reconf_busy;
                                  else
                                    if(curr_level_mode_exp='1') then                          -- Level mode with TriggerWidth exposure mode, no delay added
                                      next_timer_mngr_state  <= trig;
                                    else
                                      next_timer_mngr_state  <= delaying;
                                    end if;
                                  end if;


      when  delaying          =>  if(abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') then
                                    next_timer_mngr_state  <= trig;
                                  elsif(timer_cntr=(curr_trigger_delay) ) then
                                    next_timer_mngr_state  <= trig;
                                  else
                                    next_timer_mngr_state  <= delaying;
                                  end if;
                                  
      when  trig              =>  next_timer_mngr_state  <= exposure_monitor;


      when  exposure_monitor  =>  if(abort_seq='1') then -- abort detected by trig_mngr
                                    next_timer_mngr_state  <= exposure_end;
                                  elsif(xgs_exposure='1' and xgs_exposure_p1='0') then --when we see rising on exposure then
                                    if(curr_level_mode_exp='1') then
                                      next_timer_mngr_state  <= level;
                                    else
                                      next_timer_mngr_state  <= exposure;
                                    end if;  
                                  else
                                    next_timer_mngr_state  <= exposure_monitor;
                                  end if;

      when  exposure          =>  if(abort_seq='1') then -- abort detected by trig_mngr
                                    next_timer_mngr_state  <= exposure_end;
                                  --elsif(python_exposure='0' and python_exposure_p1='1' ) then
                                  --  if(REGFILE.ACQ.EXP_FOT.EXP_FOT='0') then                     -- Exp end signaled by sensor (Falling edge of monitor 0)
                                  --    next_timer_mngr_state   <= exposure_end;
                                  --  else                                                         -- Exp end signaled by sensor + EXP_FOT
                                  --    next_timer_mngr_state   <= exposure_fot;
                                  --  end if;
                                  elsif(xgs_exposure='0' and xgs_exposure_p1='1' ) then    -- XGS using real integration! un bon bug de corrige ds le DIe du XGS, a valider! 
                                    next_timer_mngr_state   <= exposure_end;
                                  else
                                    next_timer_mngr_state  <= exposure;
                                  end if;

      --when  exposure_fot      =>  if(abort_seq='1') then                                         -- abort detected by trig_mngr
      --                              next_timer_mngr_state  <= exposure_end;
      --                            elsif(EO_FOT='1') then                                         -- protection
      --                              next_timer_mngr_state   <= exposure_end;
      --                            elsif(exp_fot_cntr = (REGFILE.ACQ.EXP_FOT.EXP_FOT_TIME)) then
      --                              next_timer_mngr_state   <= exposure_end;
      --                            else
      --                              next_timer_mngr_state   <= exposure_fot;
      --                            end if;

      when  exposure_end      =>  next_timer_mngr_state   <= idle;


      when  level             =>  if((grab_mngr_trig='0')  or (abort_seq='1'))  then    -- Level fall(remove) , or abort detected by trig_mngr
                                    next_timer_mngr_state  <= exposure;
                                  else
                                    next_timer_mngr_state  <= level;
                                  end if;
    end case;
  end process;



  process(next_timer_mngr_state, curr_level_mode_exp)
  begin
    case next_timer_mngr_state is
      when  idle              =>  next_trig_delayed      <='0';
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='0';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "000";

      when verify_reconf_busy=>   next_trig_delayed      <='0';
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='0';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "101";
                                      
      when  delaying          =>  next_trig_delayed      <='0';
                                  next_timer_cnt         <='1';
                                  next_timer_exposure    <='0';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "001";
                                  
      when  trig              =>  next_trig_delayed      <='1';
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='0';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "010";

      when  exposure_monitor  =>  if(curr_level_mode_exp='1') then
                                    next_trig_delayed    <='1';
                                  else
                                    next_trig_delayed    <='0';
                                  end if;
                                  
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='0';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "101";

      when  exposure          =>  next_trig_delayed      <='0';
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='1';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "011";

      --when  exposure_fot      =>  next_trig_delayed      <='0';
      --                            next_timer_cnt         <='0';
      --                            next_timer_exposure    <='1';
      --                            next_timer_exposure_end<='0';
      --                            next_timer_mngr_stat   <= "110";

      when  exposure_end      =>  next_trig_delayed      <='0';
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='0';
                                  next_timer_exposure_end<='1';
                                  next_timer_mngr_stat   <= "111";

                                  
      when  level             =>  next_trig_delayed      <='1';
                                  next_timer_cnt         <='0';
                                  next_timer_exposure    <='1';
                                  next_timer_exposure_end<='0';
                                  next_timer_mngr_stat   <= "100";
    end case;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_timer_mngr_state <= idle;
        timer_mngr_stat       <="000";
        timer_cnt             <= '0';
        timer_exposure        <= '0';
        timer_exposure_end    <= '0';
        trig_delayed          <= '0';
        trig_delayed_p1       <= '0';
        --exp_fot_cntr          <= (others =>'0');
      else
        curr_timer_mngr_state <=  next_timer_mngr_state;
        timer_mngr_stat       <=  next_timer_mngr_stat;
        timer_cnt             <=  next_timer_cnt;
        timer_exposure        <=  next_timer_exposure;
        timer_exposure_end    <=  next_timer_exposure_end;
        trig_delayed          <=  next_trig_delayed;
        trig_delayed_p1       <=  trig_delayed;
        --if(curr_timer_mngr_state=exposure_fot) then
        --  exp_fot_cntr        <= exp_fot_cntr+'1';          
        --else
        --  exp_fot_cntr        <= (others =>'0');
        --end if;
      end if;
    end if;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if (timer_cnt='1') then
        timer_cntr <= timer_cntr + '1';
      else
        timer_cntr <= (others=>'0');
      end if;
    end if;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        strobe           <= '0';
      elsif(curr_strobe_e='0') then                                                                 -- strobe not enabled in this sequence
        strobe           <= '0';
      elsif(abort_now ='1' or abort_pet='1' or abort_delai='1') then                                -- abort detected in Delai or pet!
        strobe           <= '0';
      elsif(timer_exposure_end= '1') then                                                           -- exposure endend, reset strobe (falling of exposure or falling of exp +exp_FOT)
        strobe           <= '0';
      elsif(timer_exposure= '1' and exposure_cntr=(curr_strobe_end) ) then                    -- strobe end register during exposure
        strobe           <= '0';
      elsif((curr_strobe_mode='0' or curr_level_mode_exp='1') and exposure_cntr=(curr_strobe_start) and timer_exposure='1') then    -- Strobe START during EXP, mode0 or level with exposure embedded
        strobe           <= '1';
      elsif(curr_strobe_mode='1' and timer_cntr=(curr_strobe_start) and timer_cnt='1') then                                         -- Strobe START during delay( before exposure      
        strobe           <= '1';
      end if;
      
      if(sys_reset_n='0') then
       strobe_p1           <= '0';
      else
       strobe_p1           <=  strobe;
      end if;
       
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- FOURTH STEP : TRIG MANAGER
  -----------------------------------------------------------------------------
  process(curr_trig_mngr_state, REGFILE, trig_delayed, trig_delayed_p1, xgs_exposure, timer_exposure, curr_level_mode_exp, 
          exposure_cntr, curr_exposure_ts, curr_exposure_ds, curr_exposure_ss, EO_FOT, readout_cntr, xgs_FOT, xgs_EO_FOT, abort_now) 
  begin
    case curr_trig_mngr_state is
      when  idle              =>  if(trig_delayed='1' and abort_now='0' and REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='0') then
                                    next_trig_mngr_state  <= trigger;
                                  else
                                    next_trig_mngr_state  <= idle;
                                  end if;

      when  trigger           =>  next_trig_mngr_state  <= wait_exp_start;

      when  wait_exp_start    =>  if(curr_level_mode_exp='1') then                              -- Level mode with TriggerWidth exposure mode
                                    if(xgs_exposure='1') then
                                      next_trig_mngr_state  <= exp_level;
                                    else
                                      next_trig_mngr_state  <= wait_exp_start;
                                    end if;
                                  else
                                    if(timer_exposure='1') then
                                      next_trig_mngr_state  <= single_slope;                                      
                                    else
                                      next_trig_mngr_state  <= wait_exp_start;
                                    end if;  
                                  end if;

      when  single_slope      =>  if(exposure_cntr=curr_exposure_ss) then
                                    next_trig_mngr_state  <= monitoring;
                                  else
                                    next_trig_mngr_state  <= single_slope;
                                  end if;

      when  exp_level         =>  if(trig_delayed='0' and trig_delayed_p1='1') then
                                    next_trig_mngr_state  <= monitoring;
                                  else
                                    next_trig_mngr_state  <= exp_level;
                                  end if;

      when  monitoring        =>  if(xgs_FOT='1') then                      --In XGS we dont look at exposure, look at FOT instead!!!
                                    next_trig_mngr_state  <= SO_FOT_STATE;
                                  else
                                    next_trig_mngr_state  <= monitoring;
                                  end if;

      when  SO_FOT_STATE      =>  next_trig_mngr_state  <= FOT_STATE;

      when  FOT_STATE         =>  if(xgs_EO_FOT='1') then
                                    next_trig_mngr_state  <= EO_FOT_STATE;
                                  else
                                    next_trig_mngr_state  <= FOT_STATE;
                                  end if;

      when  EO_FOT_STATE      =>  next_trig_mngr_state  <= readout_state;

      when  readout_state     =>  if (trig_delayed='1' and abort_now='0' and REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='0') then
                                    if(curr_level_mode_exp='1') then                           -- Level mode with TriggerWidth exposure mode
                                      next_trig_mngr_state  <= trigger;
                                    else                                                       -- all other modes
                                      next_trig_mngr_state  <= wait_pet;
                                    end if;  
                                  elsif(readout_cntr= ('0' & X"0000000") ) then --29 bits @ 0
                                    next_trig_mngr_state  <= idle;
                                  else
                                    next_trig_mngr_state  <= readout_state;
                                  end if; 

      when  wait_pet          =>  if(abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') then                                             -- on cancelle le exposure qui n'a pas encore commence
                                    next_trig_mngr_state  <= readout_state;
                                  elsif( ('0' & curr_exposure_ss) > readout_cntr ) then   --Single slope
                                    next_trig_mngr_state  <= trigger;
                                  else
                                    next_trig_mngr_state  <= wait_pet;
                                  end if;
    end case;
  end process;

  --Si on detecte un abort avant d'envoyer le trigger au senseur, on aborte les autres state machines et on ignore!
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        abort_seq   <= '0';
      elsif( (curr_trig_mngr_state = idle          and trig_delayed='1' and (abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') ) or
             (curr_trig_mngr_state = readout_state and trig_delayed='1' and (abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') ) or
             (curr_trig_mngr_state = wait_pet      and                      (abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') )
           ) then
        abort_seq   <= '1';
      else
        abort_seq   <= '0';
      end if;
    end if;
  end process;

  --Abort during Delay, stop delai+exposure and let readout finish!
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        abort_delai   <= '0';
      elsif( curr_timer_mngr_state = delaying and  (abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') 
           ) then
        abort_delai   <= '1';
      elsif(abort_done='1') then
        abort_delai   <= '0';
      end if;
    end if;
  end process;

  REGFILE.ACQ.GRAB_STAT.ABORT_DELAI <= abort_delai;


  --Abort during pet waiting, don't start the exposure!
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        abort_pet   <= '0';
      elsif(  (curr_trig_mngr_state = wait_pet  and  (abort_now='1' or REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') ) 
           ) then
        abort_pet   <= '1';
      elsif(abort_done='1') then
        abort_pet   <= '0';
      end if;
    end if;
  end process;

  REGFILE.ACQ.GRAB_STAT.ABORT_PET <= abort_pet;



  process(next_trig_mngr_state, REGFILE, curr_trig0)
  begin
    case next_trig_mngr_state is
      when  idle              =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "0000";
                                  next_readout_stateD <= '0';
                                  
      when  trigger           =>  next_trig0          <= '1';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "0001";
                                  next_readout_stateD <= '0';
                                  
      when  wait_exp_start    =>  next_trig0          <= curr_trig0;
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "0010";
                                  next_readout_stateD <= '0';
                                                                   
      when  single_slope      =>  next_trig0          <= '1';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "0101";
                                  next_readout_stateD <= '0';
                                  
      when  exp_level         =>  next_trig0          <=  curr_trig0;
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "0110";
                                  next_readout_stateD  <= '0';
                                  
      when  monitoring        =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "0111";
                                  next_readout_stateD <= '0';

      when  SO_FOT_STATE      =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '1';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "1000";
                                  next_readout_stateD  <= '0';

      when  FOT_STATE         =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '1';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "1001";
                                  next_readout_stateD <= '0';
                                  
      when  EO_FOT_STATE      =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '0';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '1';
                                  next_trig_mngr_stat <= "1010";
                                  next_readout_stateD  <= '0';
                                  
      when  readout_state     =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '1';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "1011";
                                  next_readout_stateD <= '1';
                                  
      when  wait_pet          =>  next_trig0          <= '0';
                                  next_readout_cnt    <= '1';
                                  next_SO_FOT         <= '0';
                                  next_FOT            <= '0';
                                  next_EO_FOT         <= '0';
                                  next_trig_mngr_stat <= "1100";
                                  next_readout_stateD <= '0';
    end case;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_trig_mngr_state  <=  idle;
        trig_mngr_stat        <= "0000";
        curr_trig0            <= '0';
        curr_trig0_P1         <= '0';
        readout_cnt           <= '0';
        SO_FOT                <= '0';
        FOT                   <= '0';
        EO_FOT                <= '0';
        readout_stateD        <= '0';
      else
        curr_trig_mngr_state  <=  next_trig_mngr_state;
        trig_mngr_stat        <=  next_trig_mngr_stat;
        curr_trig0            <=  next_trig0;
        curr_trig0_P1         <=  curr_trig0;
        readout_cnt           <=  next_readout_cnt;
        SO_FOT                <=  next_SO_FOT;
        FOT                   <=  next_FOT;
        EO_FOT                <=  next_EO_FOT;
        readout_stateD        <=  next_readout_stateD;
      end if;
    end if;
  end process;



  ------------------------------------------
  --
  --  Exposure and ROT et Readout counters
  --
  ------------------------------------------

  -- Exposure
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        xgs_monitor0_p1  <= '0';
        xgs_exposure     <= '0';
        xgs_exposure_p1  <= '0';
      else
        xgs_monitor0_p1  <= xgs_monitor0; 
        
        if(G_KU706=0) then
          xgs_exposure   <= xgs_monitor0_p1;
        else
          xgs_exposure   <= Synthetic_EXPOSURE;
        end if;
        
        xgs_exposure_p1  <= xgs_exposure;
      end if;
      
      if(sys_reset_n='0') then
        xgs_monitor1_p1  <= '0';
        xgs_FOT          <= '0';
        xgs_FOT_p1       <= '0';
        xgs_EO_FOT       <= '0';
      else
        xgs_monitor1_p1  <= xgs_monitor1;       
        xgs_FOT          <= xgs_monitor1_p1;
        
        xgs_FOT_p1       <= xgs_FOT;
        xgs_EO_FOT       <= xgs_FOT_p1 and not(xgs_FOT);
        
        if(REGFILE.ACQ.READOUT_CFG1.EO_FOT_SEL='0')then 
          xgs_EO_FOT       <= xgs_FOT_p1 and not(xgs_FOT);
        else  
          xgs_EO_FOT       <= readout_cntr_EO_FOT;
        end if;  
        
      end if;
   
      if(sys_reset_n='0') then
        xgs_monitor2_p1  <= '0';
        XGS_NEW_LINE     <= '0';
        XGS_NEW_LINE_p1  <= '0';
      else
        xgs_monitor2_p1  <= xgs_monitor2;
        XGS_NEW_LINE     <= xgs_monitor2_p1;
        XGS_NEW_LINE_p1  <= XGS_NEW_LINE;
      end if;
   
      if(sys_reset_n='0') then
        exposure_cntr <= (others=> '0');      
      elsif(timer_exposure = '1') then
        exposure_cntr <= exposure_cntr + '1';
      else
        exposure_cntr <= (others=> '0');
      end if;

      -- This is the exposure register status. It will go to 0 when readout goes to 1 !  --look at sensor exposure
      if(sys_reset_n='0') then
        exposure_reg <= '0';
      else
        exposure_reg <= timer_exposure;
      end if; 
      
    end if;
  end process;

  xgs_monitor0_sysclk <=  xgs_exposure;
  xgs_monitor1_sysclk <=  xgs_FOT;

  -- Readout_cntr : ce compteur arrete de compter lorsqu'un exposure durant le readout commence (compteur actif seulement ds states: readout et wait_pet)
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        readout_cntr <= (others=> '0');
      elsif(REGFILE.ACQ.READOUT_CFG1.EO_FOT_SEL='0') then
        readout_cntr_FOT    <= '0'; 
        readout_cntr_EO_FOT <= '0'; 
        if(EO_FOT = '1') then
          readout_cntr <= curr_readout_length;
        elsif(readout_cnt = '1') then
          readout_cntr <= readout_cntr - '1';
        end if;
      else
        --ce code test permet de s'isoler de l'incertitude sur FOT 
        if(xgs_FOT='1' and xgs_FOT_p1 <='0') then                           --SO_FOT
          readout_cntr        <= '0' & X"000" & REGFILE.ACQ.READOUT_CFG1.FOT_LENGTH;
          readout_cntr_FOT    <= '1';
          readout_cntr_EO_FOT <= '0';
        elsif(readout_cntr_FOT='1' and readout_cntr= ('0' & X"0000000") ) then    -- signal internal EO_FOT
          readout_cntr        <= curr_readout_length;
          readout_cntr_FOT    <= '0';
          readout_cntr_EO_FOT <= '1';
        elsif(readout_cntr_EO_FOT='1') then                                       -- unsignal internal EO_FOT 
          readout_cntr        <= curr_readout_length;  
          readout_cntr_FOT    <= '0';    
          readout_cntr_EO_FOT <= '0';              
        elsif(readout_cnt = '1' or readout_cntr_FOT='1') then                     -- Count  
          readout_cntr        <= readout_cntr - '1';  
          readout_cntr_FOT    <= readout_cntr_FOT; 
          readout_cntr_EO_FOT <= '0';    
        end if;  
      end if;
 

      --Pour pallier au manque du signal EOF du datapath
      if(sys_reset_n='0') then
        readout_cntr2        <= (others=> '0');
        readout_cntr2_armed  <= '0';
        readout_cntr2_end    <= '0'; 
      elsif(readout_cntr2_armed = '1' and readout_cntr2 = ('0' & X"0000000") ) then
        readout_cntr2        <= (others=> '0');
        readout_cntr2_armed  <= '0';  
        readout_cntr2_end    <= '1';
      elsif(EO_FOT = '1') then
        readout_cntr2        <= curr_readout_length;
        readout_cntr2_armed  <= '1';
        readout_cntr2_end    <= '0';        
      elsif(readout_cntr2_armed = '1') then
        readout_cntr2        <= readout_cntr2 - '1';
        readout_cntr2_armed  <= '1';
        readout_cntr2_end    <= '0';   
      else
        readout_cntr2        <= (others=> '0');
        readout_cntr2_armed  <= '0';
        readout_cntr2_end    <= '0';       
      end if;
      
      if(sys_reset_n='0') then
        readout  <= '0';
      --elsif(DEC_EOF_sys='1') then   --<<<< a changer ici!!!
      elsif(readout_cntr2_end='1' ) then       
        readout  <= '0';
      elsif(SO_FOT='1') then
        readout <= '1';
      end if;
    end if;
  end process;



  ------------------------------------------
  --  MODULE XGS SPI
  --
  ------------------------------------------
  Xxgs_spi : xgs_spi
             
  generic map( G_SYS_CLK_PERIOD    => G_SYS_CLK_PERIOD  
              )
             
  port map(
    sys_reset_n                =>  sys_reset_n,
    sys_clk                    =>  sys_clk,
                               
    cmos_spi_clk               =>  xgs_sclk,
    cmos_spi_en                =>  xgs_ssn,
    cmos_spi_mosi              =>  xgs_mosi,
    cmos_spi_miso              =>  xgs_miso,

    grab_mngr_sensor_reconf    =>  grab_mngr_sensor_reconf,
    sensor_reconf_busy         =>  sensor_reconf_busy,

    abort_now                  => abort_now,
    abort_fifo_cmd             => abort_fifo_cmd,
    abort_fifo_cmd_done        => abort_fifo_cmd_done,

    --register file of this ACQ
    acquisition_start_SFNC     =>  acquisition_start_SFNC,
    regfile                    =>  regfile
  );


  --------------------------------------------
  ----
  ----  SIGNALS TO OTHER MODULES
  ----
  --------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        start_calibration <= '0';
      else
        start_calibration <= curr_readout_en and SO_FOT;
      end if;
    end if;
  end process;

  abort_readout_datapath <= abort_now;

  ------------------------------------------
  --
  --  OUTPUT FLIPFLOPS
  --
  ------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        --xgs_trig_int     <= '0';

        strobe_outpin    <= '0';
        exposure_outpin  <= '0';
        trig_rdy_outpin  <= '0';
        
        strobe_A_out     <= '0';
        strobe_B_out     <= '0';
        
      else
        --xgs_trig_int     <= curr_trig0;
        exposure_outpin  <= timer_exposure;
        trig_rdy_outpin  <= grab_mngr_trig_rdy;
        
        if(REGFILE.ACQ.STROBE_CTRL1.STROBE_POL='0') then        --FOR GTR
          strobe_outpin    <= strobe;
        else
          strobe_outpin    <= not(strobe);
        end if;
        
        strobe_A_out     <= strobe and curr_strobe_A_en;        --FOR NEXIS
        strobe_B_out     <= strobe and curr_strobe_B_en;        --FOR NEXIS
        
      end if;
    end if;
  end process;

  
  xgs_trig_rd       <= '0'; --XGS pour le moment on ne fait rien avec le readout sequencer! 
  
  exposure_out      <= exposure_outpin;
  strobe_out        <= strobe_outpin;
  trig_rdy_out      <= trig_rdy_outpin;
  
  -------------------------------------------------------------------------------
  --
  -- DEBUG PINS
  --
  -------------------------------------------------------------------------------
  debug_ctrl16_int(0)  <=  xgs_exposure; --python_monitor0;  --resync to sysclk
  debug_ctrl16_int(1)  <=  xgs_FOT;      --python_monitor1;  --resync to sysclk
  debug_ctrl16_int(2)  <=  grab_mngr_trig_rdy;
  debug_ctrl16_int(3)  <=  readout_cntr_FOT;         
  debug_ctrl16_int(4)  <=  readout_cntr_EO_FOT;
  debug_ctrl16_int(5)  <=  curr_trig0;
  debug_ctrl16_int(6)  <=  strobe;
  debug_ctrl16_int(7)  <=  FOT;
  debug_ctrl16_int(8)  <=  readout;
  debug_ctrl16_int(9)  <=  readout_stateD;
  debug_ctrl16_int(10) <=  readout_cntr2_armed;
  debug_ctrl16_int(11) <=  REGFILE.ACQ.GRAB_STAT.GRAB_IDLE;
  debug_ctrl16_int(12) <=  REGFILE.ACQ.GRAB_CTRL.GRAB_CMD;
  debug_ctrl16_int(13) <=  REGFILE.ACQ.GRAB_CTRL.GRAB_SS;
  debug_ctrl16_int(14) <=  grab_pending;
  debug_ctrl16_int(15) <=  grab_active;

  debug_out(0) <= debug_ctrl16_int(conv_integer(REGFILE.ACQ.DEBUG_PINS.Debug0_sel(3 downto 0) ));
  debug_out(1) <= debug_ctrl16_int(conv_integer(REGFILE.ACQ.DEBUG_PINS.Debug1_sel(3 downto 0) ));
  debug_out(2) <= debug_ctrl16_int(conv_integer(REGFILE.ACQ.DEBUG_PINS.Debug2_sel(3 downto 0) ));
  debug_out(3) <= debug_ctrl16_int(conv_integer(REGFILE.ACQ.DEBUG_PINS.Debug3_sel(3 downto 0) ));

  
  -------------------------------------------------------------------------------
  --
  -- POWER UP OF SENSOR
  --
  -------------------------------------------------------------------------------
  xxgs_power : xgs_power
  generic map (  G_SIMULATION     => G_SIMULATION,
                 G_SYS_CLK_PERIOD => G_SYS_CLK_PERIOD
              )
  port map (  
          sys_reset_n       =>  sys_reset_n_power,
          sys_clk           =>  sys_clk,

          ---------------------------------------------------------------------------
          --  XGS CMOS IF signals
          ---------------------------------------------------------------------------
          xgs_power_good    =>  xgs_power_good,

          xgs_osc_en        =>  xgs_osc_en,
          xgs_reset_n       =>  xgs_reset_n,

          regfile           =>  regfile
       );



  






  ---------------------------------------------------------------------------
  -- IRQ
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        irq_sos  <= '0';
      elsif(strobe='1' and strobe_p1='0') then                     -- strobe start
        irq_sos  <= '1';
      else
        irq_sos  <= '0';
      end if;

      if(sys_reset_n='0') then
        irq_eos  <= '0';
      elsif(strobe='0' and strobe_p1='1') then                     -- strobe end
        irq_eos  <= '1';
      else
        irq_eos  <= '0';
      end if;

      if(sys_reset_n='0') then
        irq_soe  <= '0';
      elsif(xgs_exposure='1' and xgs_exposure_p1='0') then   -- exposure start
        irq_soe  <= '1';
      else
        irq_soe  <= '0';
      end if;
      
        
      if(sys_reset_n='0') then
        irq_eoe  <= '0';
      elsif(timer_exposure_end='1') then   -- exposure end
        irq_eoe  <= '1';
      else
        irq_eoe  <= '0';
      end if;
    end if;
  end process;





  -----------------------------------------------------------------------------
  -- GRAB ABORT 
  -----------------------------------------------------------------------------

  process(curr_grab_abort_state, REGFILE, curr_grab_mngr_state, curr_timer_mngr_state, curr_trig_mngr_state, abort_fifo_cmd_done, dma_idle)
  begin
    case curr_grab_abort_state is
      when  idle              =>  if(REGFILE.ACQ.GRAB_CTRL.ABORT_GRAB='1') then
                                    next_grab_abort_state  <= abort_states;
                                  else
                                    next_grab_abort_state  <= idle;
                                  end if;

                                  --Wait for all readout to be done
      when  abort_states      =>  if(curr_grab_mngr_state  = idle and curr_timer_mngr_state = idle and curr_trig_mngr_state  = idle ) then
                                    next_grab_abort_state  <= abort_cmd_flags;
                                  else
                                    next_grab_abort_state  <= abort_states;
                                  end if;

                                  --Reset active and pending flags, if any (active+pending)
      when  abort_cmd_flags   =>  next_grab_abort_state  <= abort_ser_fifo;

                                  --Reset serial fifo
      when  abort_ser_fifo    =>  if(abort_fifo_cmd_done='1') then
                                    next_grab_abort_state  <= abort_dma;
                                  else
                                    next_grab_abort_state  <= abort_ser_fifo;
                                  end if;
                                  
      when  abort_dma         =>  if(dma_idle='1') then
                                    next_grab_abort_state  <= abort_irq;
                                  else
                                    next_grab_abort_state  <= abort_dma;
                                  end if;
                                  
                                  
      when  abort_irq         =>  next_grab_abort_state <= idle;
      
    end case;
  end process;



  process(next_grab_abort_state)
  begin
    case next_grab_abort_state is
      when  idle               =>   next_abort_now              <= '0';
                                    next_abort_grab_cmd         <= '0';
                                    next_abort_fifo_cmd         <= '0';
                                    next_irq_abort              <= '0';
                                    next_abort_done             <= '1';
                                    next_abort_mngr_stat        <= "000";
                                    
      when  abort_states       =>   next_abort_now              <= '1';
                                    next_abort_grab_cmd         <= '0';
                                    next_abort_fifo_cmd         <= '0';
                                    next_irq_abort              <= '0';
                                    next_abort_done             <= '0';
                                    next_abort_mngr_stat        <= "001";
                                    
                                    
      when  abort_cmd_flags    =>   next_abort_now              <= '1';
                                    next_abort_grab_cmd         <= '1';
                                    next_abort_fifo_cmd         <= '0';
                                    next_irq_abort              <= '0';
                                    next_abort_done             <= '0';
                                    next_abort_mngr_stat        <= "010";
                                    
      when  abort_ser_fifo     =>   next_abort_now              <= '1';
                                    next_abort_grab_cmd         <= '0';
                                    next_abort_fifo_cmd         <= '1';
                                    next_irq_abort              <= '0';
                                    next_abort_done             <= '0';
                                    next_abort_mngr_stat        <= "011";

      when  abort_dma          =>   next_abort_now              <= '1';
                                    next_abort_grab_cmd         <= '0';
                                    next_abort_fifo_cmd         <= '0';
                                    next_irq_abort              <= '0';
                                    next_abort_done             <= '0';
                                    next_abort_mngr_stat        <= "100";
                                    
      when  abort_irq          =>   next_abort_now              <= '1';
                                    next_abort_grab_cmd         <= '0';
                                    next_abort_fifo_cmd         <= '0';
                                    next_irq_abort              <= '1';
                                    next_abort_done             <= '0';
                                    next_abort_mngr_stat        <= "101";
    end case;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_grab_abort_state    <=  idle;
        abort_now                <=  '0';
        abort_grab_cmd           <=  '0';
        abort_fifo_cmd           <=  '0';
        irq_abort                <=  '0';
        abort_done               <=  '1';
        abort_mngr_stat          <=  "000";
      else
        curr_grab_abort_state    <=  next_grab_abort_state;
        abort_now                <=  next_abort_now;
        abort_grab_cmd           <=  next_abort_grab_cmd;
        abort_fifo_cmd           <=  next_abort_fifo_cmd;
        irq_abort                <=  next_irq_abort;
        abort_done               <=  next_abort_done;
        abort_mngr_stat          <=  next_abort_mngr_stat;
      end if;
    end if;
  end process;

  REGFILE.ACQ.GRAB_STAT.ABORT_DONE      <= abort_done;
  REGFILE.ACQ.GRAB_STAT.ABORT_MNGR_STAT <= abort_mngr_stat;



  --Xpython_ctrl_DMA_params  : python_ctrl_DMA_params
  --port map(  
  --        regfile           => regfile,
  --        
  --        regfile_dma       => regfile_dma_parameters,
  --
  --        COLOR_SPACE       => COLOR_SPACE,
  --        MONO10            => MONO10,
  --        REVERSE_Y         => REVERSE_Y,
  --        GRAB_REVX         => GRAB_REVX
  --
  --     );
  --

  
  
  ----------------------------------------------
  -- Exposure Time Jitter in Triggered Mode
  -- See dev. guide
  -- Need to synchronize triger_int with new_line
  -- in a 100ns window
  ----------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        keep_out_zone_cntr <= (others=>'0');
        keep_out_zone      <=  '0';     
      elsif(XGS_NEW_LINE='0' and XGS_NEW_LINE_p1='1') then --On falling edge start the counter for trigger keep-out zone
        keep_out_zone_cntr <= (others=>'0');
        keep_out_zone      <=  '0';
      elsif(keep_out_zone='0' and keep_out_zone_cntr = REGFILE.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_START) then 
        keep_out_zone_cntr <= (others=>'0');        
        keep_out_zone      <=  '1';
      elsif(keep_out_zone_cntr = REGFILE.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_END) then   --j'enleve ici le keep_out_zone=1, ce registre va donc reseter la zone lorsque le compteur va atteindre le compteur
        keep_out_zone_cntr <= (others=>'0');
        keep_out_zone      <=  '0';     
      else  
        keep_out_zone_cntr <= keep_out_zone_cntr+'1';
        keep_out_zone      <= keep_out_zone;        
      end if;
    end if;
  end process;

  
       
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        xgs_trig_int         <= '0';
        xgs_trig_int_delayed <= '0';   
      elsif(REGFILE.ACQ.READOUT_CFG3.KEEP_OUT_TRIG_ENA='1') then 
        if(curr_trig0='1' and curr_trig0_P1='0') then  --RISING / START OF TRIG
          if(keep_out_zone='0') then  
            xgs_trig_int         <= '1';
            xgs_trig_int_delayed <= '0';
          else 
            xgs_trig_int         <= '0'; 
            xgs_trig_int_delayed <= '1';
          end if;       
        elsif(curr_trig0='0' and curr_trig0_P1='1') then  --FALLING / END OF TRIG
          if(keep_out_zone='0') then  
            xgs_trig_int         <= '0';
            xgs_trig_int_delayed <= '0';          
          else
            xgs_trig_int         <= '1';
            xgs_trig_int_delayed <= '1';        
          end if;
        elsif(xgs_trig_int_delayed='1') then           -- Stay in same level as long keep-out zone is active
          if(keep_out_zone='1') then
            xgs_trig_int         <= not(curr_trig0);
            xgs_trig_int_delayed <= '1';        
          else
            xgs_trig_int         <= curr_trig0;
            xgs_trig_int_delayed <= '0';             
          end if;           
        end if;
      else -- do not synchronize
        xgs_trig_int         <= curr_trig0;
        xgs_trig_int_delayed <= '0';                    
      end if;      
    end if;
  end process; 
   
  
  ------------------------------------------------------------
  -- For XGS we will calculate the readout length internally
  ------------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      
      --4 dummy lines after M_lines are skipped, confirmed by Onsemi      
      TOTAL_NB_LINES <= "11"                                                  -- 3 is first dummy lines after FOT
                        + REGFILE.ACQ.SENSOR_M_LINES.M_LINES_SENSOR           -- Black lines for calibration 
                        + '1'                                                 -- Embedded
                        + ('0' & REGFILE.ACQ.SENSOR_ROI_Y_SIZE.Y_SIZE & "00") -- Y_size is a 4 line multiplier              
                        + "111"                                               -- Dummy 3
                        + "111"                                               -- Start of Exposure in readout: when Exposure Coarse offset = 0,1,2 measured with line_valid
                        + REGFILE.ACQ.READOUT_CFG_FRAME_LINE.DUMMY_LINES;     -- Pour allonger readout (Debug)
     
      INTERNAL_READOUT_LENGTH_FLOAT <=   (TOTAL_NB_LINES * REGFILE.ACQ.READOUT_CFG3.LINE_TIME) * SENSOR_PERIOD;   
    end if;
  end process;  
  
  
  
  
  -- First  LSR of 15 bits because of decimal [4].[15] of the sensor period
  -- Second LSR of 4 bits with 62.5 Mhz sys clk (/16)   -> total is LSR 19
  -- Second LSR of 3 bits with  125 Mhz sys clk (/8)    -> total is LSR 18
  INTERNAL_READOUT_LENGTH <= INTERNAL_READOUT_LENGTH_FLOAT(47 downto 19) when G_SYS_CLK_PERIOD=16 else          -- 62.5 Mhz
                             '0' & INTERNAL_READOUT_LENGTH_FLOAT(47 downto 18);                                 --125.0 Mhz
                             
    
  REGFILE.ACQ.READOUT_CFG2.READOUT_LENGTH <= curr_readout_length; -- INTERNAL_READOUT_LENGTH;
      
  REGFILE.ACQ.READOUT_CFG_FRAME_LINE.CURR_FRAME_LINES <= TOTAL_NB_LINES;          
      
  ----------------------------------------------------------------------
  --
  -- For XGS DEV BOARD WE ONLY HAVE ONE MONITOR
  --
  -- So Let's generate the monitor FOT and REAL INTEGRATION internally
  --
  -- A enlever lorsqu'on aura le sensor board et qu'on pourra utiliser les MONITOR
  -----------------------------------------------------------------------    

  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        Synthetic_EXPOSURE <='0';
        Synthetic_DELAI_EXP<='0';
        Synthetic_cntr     <=(others=>'0');
      elsif(curr_trig0='1' and curr_trig0_P1='0') then                             --RISING / START OF TRIG  : GENERATE EXPOSURE
        Synthetic_EXPOSURE <='0';
        Synthetic_DELAI_EXP<='1';    
        Synthetic_cntr     <=(others=>'0');    
      elsif(Synthetic_EXPOSURE='1' and curr_trig0='0' and curr_trig0_P1='1') then  --FALLING / END OF TRIG   : START OF FOT + EXPOSURE
        Synthetic_EXPOSURE <='1';
        Synthetic_DELAI_EXP<='0'; 
        Synthetic_cntr     <=(others=>'0');
      elsif(G_SYS_CLK_PERIOD=16 and Synthetic_DELAI_EXP='1' and Synthetic_cntr=X"02c2" ) or   -- 11.3 us :  Start of exposure Delay one line Start Of Exposure  12M @ 6 LANES  
           (G_SYS_CLK_PERIOD=8  and Synthetic_DELAI_EXP='1' and Synthetic_cntr=X"0584" ) then
        Synthetic_EXPOSURE <='1';
        Synthetic_DELAI_EXP<='0'; 
        Synthetic_cntr     <= (others=>'0');                     
      elsif(G_SYS_CLK_PERIOD=16 and XGS_FOT='1' and Synthetic_cntr=X"014f" ) or   -- 5.36 us :  Simulating END of EXP during FOT 12M @ 6 LANES  
           (G_SYS_CLK_PERIOD=8  and XGS_FOT='1' and Synthetic_cntr=X"029e" ) then
        Synthetic_EXPOSURE <='0';
        Synthetic_DELAI_EXP<='0';         
        Synthetic_cntr     <= Synthetic_cntr+'1';              
      elsif(XGS_FOT='0' and XGS_FOT_p1='1') then -- END OF FOT
        Synthetic_EXPOSURE <='0';
        Synthetic_DELAI_EXP<='0';         
        Synthetic_cntr     <= (others=>'0');
      elsif(XGS_FOT='1' or Synthetic_DELAI_EXP='1') then 
        Synthetic_EXPOSURE <= Synthetic_EXPOSURE;
        Synthetic_DELAI_EXP<= Synthetic_DELAI_EXP;
        Synthetic_cntr     <= Synthetic_cntr+'1';
      else
        Synthetic_EXPOSURE <= Synthetic_EXPOSURE;
        Synthetic_DELAI_EXP<= Synthetic_DELAI_EXP;          
        Synthetic_cntr     <= Synthetic_cntr;      
      end if;                 
    end if;
  end process;     
      
      
end functional;





