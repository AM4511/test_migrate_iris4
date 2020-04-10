------------------------------------------------------------------------------
-- File:        i2c_slave.vhd
-- Decription:  This is an emulation of a I2C slave. For simulation only.
--              
--              
-- 
-- Created by:  inconu, modifie par Jean-Francois Larin
-- Date:        7 Novembre 2002
-- Project:     Cronos2ppw
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use std.textio.all;
use work.ubus_decoder_model_pack.all;

entity i2c_slave is
  generic (
    BUS_NUMBER : integer;
    I2C_ADR    : std_logic_vector(6 downto 0) := "1000100";
    I2C_ADR_IO : std_logic_vector(6 downto 0) := "1000000";
    BASE_PATH  : string := "..\..\validation\simulation_files\";
    CLOCK_STRETCH : boolean := FALSE
  );
  port (
    i2c_ubus_par : in i2c_par_ubus_type;
    SCL          : inout STD_LOGIC;
    SDA          : inout STD_LOGIC
  );
end i2c_slave;

architecture i2c_slave_arch of i2c_slave is

  type    memory  is  array (127 downto 0) of std_logic_vector(7 downto 0);
  type    states  is  (idle, slave_ack, get_mem_adr, gma_ack, data, data_ack);
  signal  mem   : memory := (others => (others => '0'));
  signal  mem_adr : std_logic_vector(7 downto 0) := x"3A";
  signal  mem_do  : std_logic_vector(7 downto 0);
  signal  start   : std_logic := '0';
  signal  d_start : std_logic;
  signal  stop    : std_logic := '0';
  signal  sr      : std_logic_vector(7 downto 0) := (others => 'H');
  signal  rw      : std_logic;
  signal  my_adr  : std_logic;
  signal  i2c_reset : std_logic;
  signal  bit_cnt : std_logic_vector(2 downto 0) := (others => '0'); -- sert a compter les bits d'une sequence de 8 pour generer le signal acc_done
  signal  acc_done  : std_logic;
  signal  ld      : std_logic; -- reset le bit counter a 0 pour une sequence de 8 bits
  signal  sda_o   : std_logic := '1';

  signal  state   : states := idle;
  signal  NI_acc  : std_logic;
  signal  IOC_DAT_IO : std_logic_vector(7 downto 0) := "00000000";
  signal  devid_phase : std_logic;

  signal path_dump_mem    : string(1 to 32) := "test6969\simoutput\i2c_mem1.dump";
                                                        
  signal path_dump_io     : string(1 to 31) := "test6969\simoutput\i2c_io1.dump";
                                                         
  signal start_i2c_flush  : std_logic := '0'; 
  signal i2c_dump_done    : std_logic;
  signal start_i2c_dump   : std_logic;   



begin

my_adr <= '1' when (sr(7 downto 1) = I2C_ADR or sr(7 downto 1) = I2C_ADR_IO) else '0';   --***************** BUG BUG BUG  **********
acc_done <= '1' when bit_cnt = "000" else '0';
i2c_reset <= '1' when start = '1' or stop = '1' else '0';
sda <= 'Z' when sda_o = 'H' or sda_o = '1' else '0';

-- fonction classique, on ne fait pas de stretching
nostretchgen: if CLOCK_STRETCH = FALSE generate
  scl <= 'Z';
end generate;

withstretchgen: if CLOCK_STRETCH = TRUE generate
  driveclkprc: process
    variable cnt_avant_stretch : integer := 12; -- chiffre arbitraire
    variable dernier_edge : time := 0 ns;       -- pour compter la frequence
    variable derniere_periode : time := 0 ns;
  begin
    scl <= 'Z';
    wait until (scl = 'H' and scl'event);
    derniere_periode := now - dernier_edge;  -- enregister la periode de la clock
    dernier_edge := now;                     -- sauvegarder le temps pour la prochaine mesure
    cnt_avant_stretch := cnt_avant_stretch - 1;
    if cnt_avant_stretch = 0 then
      cnt_avant_stretch := 33;  -- autre nombre arbitraire pour faire du stretching plus tard.
      -- on attend que le signal redescende car on ne veux pas faire de glitch
      wait until (scl = '0' and scl'event);
      scl <= '0', 'Z' after derniere_periode * 3.5;
      wait until (scl = 'H' and scl'event);
    end if;
  end process;
end generate;    

-- Shift register
process (scl)
begin
  -- ici on latch sur le rising edge... messemble qu'on doit ramasser le data sur le falling edge!
  if(scl = 'H' and scl'event) then
    sr <= sr(6 downto 0) & sda after 1 ns;
  end if; 
end process;

-- bit counter
process (scl)
begin
  if(scl = 'H' and scl'event) then
    if (ld ='1') then
      bit_cnt <= "111";
    else
      bit_cnt <= bit_cnt - '1';
    end if;
  end if;
end process;

-- detect start condition
process (sda)
begin
  if(sda = '0' and sda'event) then
    if (scl = 'H') then
      start <= '1';
    else
      start <= '0';
    end if;
  end if; 
end process;

-- d_start
process (scl)
begin
  if(scl = 'H' and scl'event) then
    d_start <= start;
  end if; 
end process;

process (scl)
begin
  if(scl = '0' and scl'event) then
    if(d_start='1' and start='1') then
      devid_phase <='1';
	else
	  devid_phase <= devid_phase; 
	end if;
  elsif(scl = 'H' and scl'event and bit_cnt="000") then
    devid_phase <='0';
  else
	devid_phase <= devid_phase;
  end if; 
end process;


-- detect stop condition
process (sda)
begin
  if(sda'event) then -- and(sda = 'H' or sda = '1')  -- avant, on updatait le stop juste sur la monte de SDA. 
                                                     -- maintenant on le fait sur chaque changement de SDA, car au start condition
                                                     -- il faut debarque le stop
    if (scl = 'H') and (sda = 'H' or sda = '1') then                              
      stop <= '1';                                   
    else
      stop <= '0';
    end if;
  end if; 
end process;

-- state machine
process (scl, stop)
begin
  if((scl = '0' and scl'event) or (stop = '1' and stop'event)) then
    if (stop = '1' or (start = '1' and d_start = '0')) then
      state <= idle;
      sda_o <= '1';
      ld <= '1';
    else
      sda_o <= '1';
      ld <= '0';
      
      case state is
        when idle =>
          
          if (acc_done = '1' and my_adr = '1' and devid_phase='1') then
            
            state <= slave_ack after 1 ns;
            rw <= sr(0) after 1 ns;
            sda_o <= '0' after 1 ns;  --** generate i2c_ack

			if(sr(7 downto 1) = I2C_ADR_IO) then
              NI_acc<='1';
			else
			  NI_acc<='0';  
			end if;   
            

          end if;
          
      
          
        when slave_ack =>
          if (rw = 'H') then
            state <= data;
            sda_o <= mem_do (7);
          else
			if(NI_acc='1' and rw = '0') then
              state <= data;	   --<<--------???!??!?!?!?
			else
			  state <= get_mem_adr;	    --<<--------???!??!?!?!?
		    end if;
          end if;
          ld <= '1';
        
        when get_mem_adr =>
          if (acc_done = '1') then
            state <= gma_ack;
            mem_adr <= sr;
            sda_o <= '0';   -- **** Refer to example for more detail
          end if;
        
        when gma_ack =>
          state <= data;
          ld <= '1';
        
        when data =>
          if (rw = 'H') then
            sda_o <= mem_do(7);
          end if;
          if (acc_done = '1') then
            state <= data_ack;
            if (rw = 'H') then
              null;
            else
			  if(NI_acc='0') then					 --MEM ACCESS
                mem(conv_integer(mem_adr)) <= sr;
			  else									 --IO ACCESS
				IOC_DAT_IO <= sr(7 downto 0);
			  end if;
            end if;
            if (rw = 'H') then
              sda_o <= '1';
            else
              sda_o <= '0';
            end if;
          end if;
        
        when data_ack =>
          ld <= '1';
          if (rw = 'H') then
            if (sda = 'H') then
              state <= idle;
              sda_o <= '1';
            else
              state <= data;
              sda_o <= mem_do(7);
            end if;
          else
            state <= data;
            sda_o <= '1';
          end if;
        when others =>
          null;
      end case; 
    end if;
  end if; 
end process;

-- read data from memory
process (scl, state)
begin
  if (state = slave_ack) then
    if(NI_acc='0') then
       mem_do <= mem(conv_integer(mem_adr));
	else
	   mem_do <= IOC_DAT_IO;
    end	if;
  elsif (state = data_ack and acc_done = '1' and rw = 'H') then
    if(NI_acc='0') then
       mem_do <= mem(conv_integer(mem_adr));
	else
	   mem_do <= IOC_DAT_IO;
    end	if;
  else
    mem_do <= mem_do;
  end if;
 
  if(scl = 'H' and scl'event) then
    if (acc_done = '0' and rw = 'H') then
      mem_do(7 downto 0) <= mem_do(6 downto 0) & '1';
    end if;
  end if; 
end process;





  ------------------------------------------------------
  --  Paths de sortie des fichiers
  ------------------------------------------------------

  process(i2c_ubus_par.i2c_test_number)
  begin
 
   if(BUS_NUMBER=1) then
     if(i2c_ubus_par.i2c_test_number < 10 and i2c_ubus_par.i2c_test_number >= 0 ) then
        path_dump_mem <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem1.dump";
        path_dump_io  <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io1.dump";
     elsif(i2c_ubus_par.i2c_test_number < 100 and i2c_ubus_par.i2c_test_number >= 10) then
        path_dump_mem  <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem1.dump";
        path_dump_io   <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io1.dump";
     elsif(i2c_ubus_par.i2c_test_number < 1000 and i2c_ubus_par.i2c_test_number >= 100) then
        path_dump_mem  <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem1.dump";
        path_dump_io   <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io1.dump";
     elsif(i2c_ubus_par.i2c_test_number < 10000 and i2c_ubus_par.i2c_test_number >= 1000) then
        path_dump_mem  <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem1.dump";
        path_dump_io   <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io1.dump";
     elsif(i2c_ubus_par.i2c_test_number > 9999 ) then
        -- do nothing here
     end if;
   end if;
   
   if(BUS_NUMBER=2) then
     if(i2c_ubus_par.i2c_test_number < 10 and i2c_ubus_par.i2c_test_number >= 0 ) then
        path_dump_mem <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem2.dump";
        path_dump_io  <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io2.dump";
     elsif(i2c_ubus_par.i2c_test_number < 100 and i2c_ubus_par.i2c_test_number >= 10) then
        path_dump_mem  <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem2.dump";
        path_dump_io   <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io2.dump";
     elsif(i2c_ubus_par.i2c_test_number < 1000 and i2c_ubus_par.i2c_test_number >= 100) then
        path_dump_mem  <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem2.dump";
        path_dump_io   <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io2.dump";
     elsif(i2c_ubus_par.i2c_test_number < 10000 and i2c_ubus_par.i2c_test_number >= 1000) then
        path_dump_mem  <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem2.dump";
        path_dump_io   <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io2.dump";
     elsif(i2c_ubus_par.i2c_test_number > 9999 ) then
        -- do nothing here
     end if;
   end if;
   
   if(BUS_NUMBER=3) then
     if(i2c_ubus_par.i2c_test_number < 10 and i2c_ubus_par.i2c_test_number >= 0 ) then
        path_dump_mem <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem3.dump";
        path_dump_io  <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io3.dump";
     elsif(i2c_ubus_par.i2c_test_number < 100 and i2c_ubus_par.i2c_test_number >= 10) then
        path_dump_mem  <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem3.dump";
        path_dump_io   <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io3.dump";
     elsif(i2c_ubus_par.i2c_test_number < 1000 and i2c_ubus_par.i2c_test_number >= 100) then
        path_dump_mem  <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem3.dump";
        path_dump_io   <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io3.dump";
     elsif(i2c_ubus_par.i2c_test_number < 10000 and i2c_ubus_par.i2c_test_number >= 1000) then
        path_dump_mem  <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem3.dump";
        path_dump_io   <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io3.dump";
     elsif(i2c_ubus_par.i2c_test_number > 9999 ) then
        -- do nothing here
     end if;
   end if;

   if(BUS_NUMBER=4) then
     if(i2c_ubus_par.i2c_test_number < 10 and i2c_ubus_par.i2c_test_number >= 0 ) then
        path_dump_mem <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem4.dump";
        path_dump_io  <= "test000" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io4.dump";
     elsif(i2c_ubus_par.i2c_test_number < 100 and i2c_ubus_par.i2c_test_number >= 10) then
        path_dump_mem  <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem4.dump";
        path_dump_io   <= "test00" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io4.dump";
     elsif(i2c_ubus_par.i2c_test_number < 1000 and i2c_ubus_par.i2c_test_number >= 100) then
        path_dump_mem  <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem4.dump";
        path_dump_io   <= "test0" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io4.dump";
     elsif(i2c_ubus_par.i2c_test_number < 10000 and i2c_ubus_par.i2c_test_number >= 1000) then
        path_dump_mem  <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_mem4.dump";
        path_dump_io   <= "test" & integer'image(i2c_ubus_par.i2c_test_number) & "\simoutput\i2c_io4.dump";
     elsif(i2c_ubus_par.i2c_test_number > 9999 ) then
        -- do nothing here
     end if;
   end if;

  end process;


  ------------------------------------------------------
  --  MEMDUMP
  ------------------------------------------------------

  mem_dump_p: process
    
    FILE i2c_outfile_mem : text;
    FILE i2c_outfile_io  : text;
    
    variable wrline     : line;
    variable errFlag    : boolean;
    variable addr_incr  : std_logic_vector(31 downto 0);
    variable i          : integer; 
  begin

    wait until start_i2c_dump = '1';

      i2c_dump_done <= '0';
    
      file_open(i2c_outfile_mem, BASE_PATH & path_dump_mem, write_mode);          -- Fichier dump I2C MEMORY
      addr_incr := (others=> '0');
      for i in 0 to 127 loop
        --Write address and data to output file
        hwrite(wrline, addr_incr, LEFT, 8);
        write(wrline, string'(" "));
        hwrite(wrline,  mem(i), LEFT, 2);
        writeline(i2c_outfile_mem, wrline);
        addr_incr := addr_incr+'1';
      end loop;  --   read file
      file_close(i2c_outfile_mem);
    
      file_open(i2c_outfile_io,  BASE_PATH & path_dump_io,  write_mode);          -- Fichier dump I2C IO
      addr_incr := (others=> '0');
      --Write address and data to output file
      hwrite(wrline, addr_incr, LEFT, 8);
      write(wrline, string'(" "));
      hwrite(wrline,  IOC_DAT_IO, LEFT, 2);
      writeline(i2c_outfile_io, wrline);
      file_close(i2c_outfile_io);

      i2c_dump_done <= '1';

    wait;
  end process mem_dump_p;



  PROCESS(i2c_ubus_par.i2c_dump1, i2c_ubus_par.i2c_dump2, i2c_ubus_par.i2c_dump3, i2c_ubus_par.i2c_dump4, i2c_dump_done)
  BEGIN
    if(BUS_NUMBER=1) then
      IF (i2c_ubus_par.i2c_dump1 = '1') THEN
         start_i2c_dump <= '1';
      ELSIF (i2c_dump_done = '1') THEN
         start_i2c_dump <= '0';
      END IF;
    end if;

    if(BUS_NUMBER=2) then
      IF (i2c_ubus_par.i2c_dump2 = '1') THEN
         start_i2c_dump <= '1';
      ELSIF (i2c_dump_done = '1') THEN
         start_i2c_dump <= '0';
      END IF;
    end if;
    
    if(BUS_NUMBER=3) then
      IF (i2c_ubus_par.i2c_dump3 = '1') THEN
         start_i2c_dump <= '1';
      ELSIF (i2c_dump_done = '1') THEN
         start_i2c_dump <= '0';
      END IF;
    end if;
    
    if(BUS_NUMBER=4) then
      IF (i2c_ubus_par.i2c_dump4 = '1') THEN
         start_i2c_dump <= '1';
      ELSIF (i2c_dump_done = '1') THEN
         start_i2c_dump <= '0';
      END IF;
    end if;
    
    
  END PROCESS;





end i2c_slave_arch;
