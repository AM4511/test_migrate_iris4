library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.numeric_std.all;
 use IEEE.std_logic_arith.all;
 use std.textio.all ; 


entity axis_width_conv is
   port (  

           ---------------------------------------------------------------------
           -- Axi domain reset and clock signals
           ---------------------------------------------------------------------
           axi_clk                                 : in    std_logic;
           axi_reset_n                             : in    std_logic;

           ---------------------------------------------------------------------
           -- AXI in
           ---------------------------------------------------------------------  
           s_axis_tvalid                           : in   std_logic;
           s_axis_tready                           : out  std_logic;
           s_axis_tuser                            : in   std_logic_vector(3 downto 0);
           s_axis_tlast                            : in   std_logic;
           s_axis_tdata                            : in   std_logic_vector(79 downto 0);	
           
           ---------------------------------------------------------------------
           -- AXI out
           ---------------------------------------------------------------------
           m_axis_tready                           : in  std_logic;
           m_axis_tvalid                           : out std_logic;
           m_axis_tuser                            : out std_logic_vector(3 downto 0);
           m_axis_tlast                            : out std_logic;
           m_axis_tdata                            : out std_logic_vector(19 downto 0)

        );
end axis_width_conv;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of axis_width_conv is



-----------------------------
-- Constant 
-----------------------------
constant axis_width_div    : integer := 4;--m_axis_tdata'length/s_axis_tdata'length;


type type_curr_axis_state is (  idle,
                                latched,
                                shift,
                                waite                                  
                              );
signal  curr_axis_state : type_curr_axis_state:= idle;

signal m_axis_tvalid_latched: std_logic := '0';
signal s_axis_tdata_latched : std_logic_vector(s_axis_tdata'range) := (others=>'0');
signal s_axis_tuser_latched : std_logic_vector(axis_width_div*(s_axis_tuser'high+1)-1 downto 0) := (others=>'0');
signal s_axis_tlast_latched : std_logic_vector(axis_width_div-1 downto 0):= (others=>'0');
signal axis_count           : integer range 0 to axis_width_div := 0;

--Pour SIM
signal s_axis_tdata_64 : std_logic_vector(63 downto 0); 
signal m_axis_tdata_16 : std_logic_vector(15 downto 0);

BEGIN

  
  s_axis_tdata_64 <= s_axis_tdata(79 downto 72) & s_axis_tdata(69 downto 62) & s_axis_tdata(59 downto 52) & s_axis_tdata(49 downto 42) & 
                     s_axis_tdata(39 downto 32) & s_axis_tdata(29 downto 22) & s_axis_tdata(19 downto 12) & s_axis_tdata(9 downto 2);   
  m_axis_tdata_16 <= s_axis_tdata_latched(19 downto 12) & s_axis_tdata_latched(9 downto 2);
  
  
  process(axi_clk, axi_reset_n)
  begin
    if(axi_reset_n='0') then
      curr_axis_state       <= idle;
      s_axis_tready         <= '0';
      m_axis_tvalid_latched <= '0';
      axis_count            <=  0;
      
    
    elsif (axi_clk'event and axi_clk='1') then

  
      case curr_axis_state is
        when  idle              =>  if(s_axis_tvalid='1' and (s_axis_tuser="0001" or s_axis_tuser="0100") ) then  
                                      curr_axis_state      <= latched;
                                      s_axis_tready        <= '1'; 
                                      s_axis_tdata_latched <= s_axis_tdata;
                                      s_axis_tuser_latched <= "0000" & "0000" & "0000" & s_axis_tuser;
                                      s_axis_tlast_latched <= "0000";
                                      axis_count           <= 1;                                    
                                      m_axis_tvalid_latched<= '1';
                                    else
                                      curr_axis_state  <= idle;
                                    end if;
      
        when  latched            => if(m_axis_tvalid_latched='1' and m_axis_tready='1') then  
                                      curr_axis_state                   <= shift;
                                      s_axis_tready                     <= '0'; 
                                      s_axis_tdata_latched(59 downto 0) <= s_axis_tdata_latched(79 downto 20);    -- SHIFT
                                      s_axis_tuser_latched(11 downto 0) <= s_axis_tuser_latched(15 downto 4);     -- SHIFT
                                      s_axis_tlast_latched(2 downto 0)  <= s_axis_tlast_latched(3 downto 1);      -- SHIFT  
                                      axis_count                        <= axis_count+1;
                                      m_axis_tvalid_latched             <='1';
                                    else
                                      curr_axis_state                   <= waite;     
                                      s_axis_tready                     <= '0';
                                      axis_count                        <= axis_count; 
                                      m_axis_tvalid_latched             <='1';                                       
                                    end if;
                                    
        when  shift              => if(m_axis_tvalid_latched='1' and m_axis_tready='1') then  
                                      if(axis_count = axis_width_div) then
                                        if(s_axis_tlast_latched(0)='0') then 
                                          curr_axis_state      <= latched;
                                          s_axis_tready        <= '1';
                                          s_axis_tdata_latched <= s_axis_tdata;                               -- LOAD DATA
                                          axis_count           <= 1;                                   
                                          m_axis_tvalid_latched<= '1';
                                          s_axis_tlast_latched <= s_axis_tlast & "000";
                                          if(s_axis_tuser="0001" or s_axis_tuser="0100") then                 -- LOAD SOF+SOL
                                            s_axis_tuser_latched <= "0000" & "0000" & "0000" & s_axis_tuser;
                                          elsif(s_axis_tuser="0010" or s_axis_tuser="1000") then              -- LOAD EOF+EOL
                                            s_axis_tuser_latched <=  s_axis_tuser & "0000" & "0000" & "0000";                                          
                                          else  
                                            s_axis_tuser_latched <= (others =>'0');                             
                                          end if;                                     
                                        else --EOL/EOF
                                          curr_axis_state      <= idle;
                                          s_axis_tready        <= '0';
                                          s_axis_tdata_latched <= (others => '0');                             -- LOAD DATA
                                          axis_count           <= 0;                                   
                                          m_axis_tvalid_latched<= '0';
                                          s_axis_tuser_latched <= (others => '0');
                                          s_axis_tlast_latched <= (others =>'0');
                                        end if;
                                      else
                                        curr_axis_state                   <= shift;
                                        s_axis_tready                     <= '0';
                                        s_axis_tdata_latched(59 downto 0) <= s_axis_tdata_latched(79 downto 20);  -- SHIFT
                                        m_axis_tvalid_latched             <= '1';
                                        axis_count                        <= axis_count+1;
                                        s_axis_tuser_latched(11 downto 0) <= s_axis_tuser_latched(15 downto 4);   -- SHIFT
                                        s_axis_tlast_latched(2 downto 0)  <= s_axis_tlast_latched(3 downto 1);    -- SHIFT
                                      end if;                                     
                                    else
                                      curr_axis_state                   <= waite;     
                                      s_axis_tready                     <= '0';
                                      axis_count                        <= axis_count; 
                                      m_axis_tvalid_latched             <='1';                                       
                                    end if;
      
        when  waite              => if(m_axis_tvalid_latched='1' and m_axis_tready='1') then  
                                      if(axis_count = axis_width_div) then
                                        if(s_axis_tlast_latched(0)='0') then 
                                          curr_axis_state      <= latched;
                                          s_axis_tready        <= '1';
                                          s_axis_tdata_latched <= s_axis_tdata;                               -- LOAD DATA
                                          axis_count           <= 1;                                   
                                          m_axis_tvalid_latched<= '1';
                                          s_axis_tlast_latched <= s_axis_tlast & "000";
                                          if(s_axis_tuser="0001" or s_axis_tuser="0100") then                 -- LOAD SOF+SOL
                                            s_axis_tuser_latched <= "0000" & "0000" & "0000" & s_axis_tuser;
                                          elsif(s_axis_tuser="0010" or s_axis_tuser="1000") then              -- LOAD EOF+EOL
                                            s_axis_tuser_latched <=  s_axis_tuser & "0000" & "0000" & "0000";                                          
                                          else  
                                            s_axis_tuser_latched <= (others =>'0');                             
                                          end if;                                     
                                        else --EOL/EOF
                                          curr_axis_state      <= idle;
                                          s_axis_tready        <= '0';
                                          s_axis_tdata_latched <= (others => '0');                             -- LOAD DATA
                                          axis_count           <= 0;                                   
                                          m_axis_tvalid_latched<= '0';
                                          s_axis_tuser_latched <= (others => '0');
                                          s_axis_tlast_latched <= (others => '0');
                                        end if;
                                      else
                                        curr_axis_state                   <= shift;
                                        s_axis_tready                     <= '0';
                                        s_axis_tdata_latched(59 downto 0) <= s_axis_tdata_latched(79 downto 20);  -- SHIFT
                                        m_axis_tvalid_latched             <= '1';
                                        axis_count                        <= axis_count+1;
                                        s_axis_tuser_latched(11 downto 0) <= s_axis_tuser_latched(15 downto 4);   -- SHIFT
                                        s_axis_tlast_latched(2 downto 0)  <= s_axis_tlast_latched(3 downto 1);    -- SHIFT
                                      end if;                                     
                                    else
                                      curr_axis_state                   <= waite;     
                                      s_axis_tready                     <= '0';
                                      axis_count                        <= axis_count; 
                                      m_axis_tvalid_latched             <='1'; 
                                    end if;
                                

     
      end case;
    end if;
  end process;
  
  
  m_axis_tvalid <= m_axis_tvalid_latched; 
  m_axis_tdata  <= s_axis_tdata_latched(19 downto 0);
  m_axis_tuser  <= s_axis_tuser_latched(3 downto 0);
  m_axis_tlast  <= s_axis_tlast_latched(0);
  
  
end functional;
  
