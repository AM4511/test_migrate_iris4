-- BRAM wrapper

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.all;
Library xpm;
use xpm.vcomponents.all;


entity sdp_bram is
  generic (

        C_FAMILY                        : string  := "kintexu";
        C_DATAWIDTH                     : integer := 32;
        C_ADDRWIDTH                     : integer := 10
  );
  port (
        CLOCK                           : in  std_logic;
        RESET_PORTB                     : in  std_logic;

        -- WRITE PORT
        ENABLE_PORTA                    : in  std_logic;
        ADDR_PORTA                      : in  std_logic_vector(C_ADDRWIDTH-1 downto 0);
        DATA_PORTA                      : in  std_logic_vector(C_DATAWIDTH-1 downto 0);
        
        -- READ PORT
        ENABLE_PORTB                    : in  std_logic;
        ADDR_PORTB                      : in  std_logic_vector(C_ADDRWIDTH-1 downto 0);
        DATA_PORTB                      : out std_logic_vector(C_DATAWIDTH-1 downto 0) := (others => '0');
        DATA_PORTB_VALID                : out std_logic := '0'
        
  );


end sdp_bram;

architecture rtl of sdp_bram is

constant rd_valid_pipe  : integer := 2;

-- signal declarations:
signal write_enable     : std_logic_vector((C_DATAWIDTH/C_DATAWIDTH)-1 downto 0);
signal data_valid       : std_logic_vector(rd_valid_pipe-1 downto 0);

begin


write_enable(0) <= '1';
 
-- xilinx
gen_xilinx_sdpram: if ( C_FAMILY = "kintexu" ) generate

   xpm_memory_sdpram_inst : xpm_memory_sdpram
   generic map (
      ADDR_WIDTH_A => C_ADDRWIDTH,       -- DECIMAL
      ADDR_WIDTH_B => C_ADDRWIDTH,       -- DECIMAL
      AUTO_SLEEP_TIME => 0,              -- DECIMAL
      BYTE_WRITE_WIDTH_A => C_DATAWIDTH, -- DECIMAL
      CLOCKING_MODE => "common_clock",   -- String
      ECC_MODE => "no_ecc",              -- String
      MEMORY_INIT_FILE => "none",        -- String
      MEMORY_INIT_PARAM => "0",          -- String
      MEMORY_OPTIMIZATION => "true",     -- String
      MEMORY_PRIMITIVE => "block",       -- String
      MEMORY_SIZE => 32768,              -- DECIMAL
      MESSAGE_CONTROL => 0,              -- DECIMAL
      READ_DATA_WIDTH_B => C_DATAWIDTH,  -- DECIMAL
      READ_LATENCY_B => rd_valid_pipe,   -- DECIMAL
      READ_RESET_VALUE_B => "DEADBEEF",  -- String
      USE_EMBEDDED_CONSTRAINT => 0,      -- DECIMAL
      USE_MEM_INIT => 1,                 -- DECIMAL
      WAKEUP_TIME => "disable_sleep",    -- String
      WRITE_DATA_WIDTH_A => C_DATAWIDTH, -- DECIMAL
      WRITE_MODE_B => "no_change"        -- String
   )
   port map (

                                        
      clka => CLOCK,                    -- 1-bit input: Clock signal for port A. Also clocks port B when
                                        -- parameter CLOCKING_MODE is "common_clock".
      ena => ENABLE_PORTA,              -- 1-bit input: Memory enable signal for port A. Must be high on clock
                                        -- cycles when write operations are initiated. Pipelined internally.
      addra => ADDR_PORTA,              -- ADDR_WIDTH_A-bit input: Address for port A write operations.
      dina => DATA_PORTA,               -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      wea => write_enable,              -- WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                        -- data port dina. 1 bit wide when word-wide writes are used. In
                                        -- byte-wide write configurations, each bit controls the writing one
                                        -- byte of dina to address addra. For example, to synchronously write
                                        -- only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                        -- 4'b0010.
      
      
      clkb => CLOCK,                    -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                        -- "independent_clock". Unused when parameter CLOCKING_MODE is
                                        -- "common_clock".
      enb => ENABLE_PORTB,              -- 1-bit input: Memory enable signal for port B. Must be high on clock
                                        -- cycles when read operations are initiated. Pipelined internally.
      addrb => ADDR_PORTB,              -- ADDR_WIDTH_B-bit input: Address for port B read operations.
      doutb => DATA_PORTB,              -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      regceb => '1',                    -- 1-bit input: Clock Enable for the last register stage on the output
                                        -- data path.

      rstb => RESET_PORTB,              -- 1-bit input: Reset signal for the final port B output register
                                        -- stage. Synchronously resets output port doutb to the value specified
                                        -- by parameter READ_RESET_VALUE_B.


      injectdbiterra => '0',            -- 1-bit input: Controls double bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      injectsbiterra => '0',            -- 1-bit input: Controls single bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).
      dbiterrb => open,                 -- 1-bit output: Status signal to indicate double bit error occurrence
                                        -- on the data output of port B.


      sbiterrb => open,                 -- 1-bit output: Status signal to indicate single bit error occurrence
                                        -- on the data output of port B.
      sleep => '0'                      -- 1-bit input: sleep signal to enable the dynamic power saving feature.

   );
   
   valid_pr: process(CLOCK)
   begin
        if (CLOCK'event and (CLOCK = '1')) then
            data_valid(0) <= ENABLE_PORTB;
            for i in 1 to rd_valid_pipe-1 loop
                data_valid(i) <= data_valid(i-1);
            end loop;
        end if;
   end process;
   
   DATA_PORTB_VALID <= data_valid(rd_valid_pipe-1);
   

end generate;


-- intel: to add

end rtl;