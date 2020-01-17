library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lpc_to_AXI_prodcons_S00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 13
	);
	port (
		-- Users to add ports here
    sysclk                     : in    std_logic;                                               -- System clock
    sysrst                     : in    std_logic;                                               -- reset synchrone au sysclk
    ------------------------------------------------------------------------------------
    -- Interface name: External interface
    -- Description: 
    ------------------------------------------------------------------------------------
    ext_writeBeN               : in   std_logic_vector(3 downto 0);                            -- Write Byte Enable Bus for all external sections
    ext_writeData              : in   std_logic_vector(31 downto 0);                           -- Write Data Bus for all external sections
    ------------------------------------------------------------------------------------
    -- Interface name: ProdCons
    -- Description: 
    ------------------------------------------------------------------------------------
    ext_ProdCons_addr          : in   std_logic_vector(10 downto 0);                           -- Address Bus for ProdCons external section
    ext_ProdCons_writeEn       : in   std_logic;                                               -- Write enable for ProdCons external section
    ext_ProdCons_readEn        : in   std_logic;                                               -- Read enable for ProdCons external section
    ext_ProdCons_readDataValid : out   std_logic;                                               -- Read Data Valid for ProdCons external section
    ext_ProdCons_readData      : out   std_logic_vector(31 downto 0);         
    host_irq                   : out  std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end Lpc_to_AXI_prodcons_S00_AXI;

architecture arch_imp of Lpc_to_AXI_prodcons_S00_AXI is

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;
  signal axi_reset  : std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 10;  -- c'est ici qu'on hardcode 4k d'espace pour un registre 32 bits suivit de 4k de DPRAM
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 4
	signal input_free_start	:std_logic_vector(7 downto 0);
	signal input_free_end	:std_logic_vector(7 downto 0);
	signal output_free_start	:std_logic_vector(7 downto 0);
	signal output_free_end	:std_logic_vector(7 downto 0);

  -- autre clock domain
  signal input_free_start_axi : std_logic_vector(input_free_start'range);
  signal input_free_end_sysclk    : std_logic_vector(input_free_end'range);
  signal output_free_start_sysclk : std_logic_vector(output_free_start'range);
  signal output_free_end_axi      : std_logic_vector(output_free_end'range);

	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  -- Parametre de la BRAM infere 
  constant C_NB_COL    : integer := 4;
  constant C_COL_WIDTH : integer := 8;               
  constant C_RAM_DEPTH : integer := 1024;               
 
  signal douta_reg : std_logic_vector(C_NB_COL*C_COL_WIDTH-1 downto 0) := (others => '0');
  signal doutb_reg : std_logic_vector(C_NB_COL*C_COL_WIDTH-1 downto 0) := (others => '0');

  type ram_type is array (C_RAM_DEPTH-1 downto 0) of std_logic_vector (C_NB_COL*C_COL_WIDTH-1 downto 0);          -- 2D Array Declaration for RAM signal

  signal ram_data_a : std_logic_vector(C_NB_COL*C_COL_WIDTH-1 downto 0) ;
  signal ram_data_b : std_logic_vector(C_NB_COL*C_COL_WIDTH-1 downto 0) ;
  -- Following code defines RAM
  shared variable ram_name : ram_type := (others => (others => '0'));

  signal host_write_enable : std_logic_vector(ext_writeBeN'range);
  signal axi_ram_enable    : std_logic;
  signal axi_bram_addr     : std_logic_vector(9 downto 0);  -- pourrait etre deduit du C_RAM_DEPTH plus haut...
  signal axi_write_strobe   : std_logic_vector(S_AXI_WSTRB'range);

  component safe_domain_change_vector is
    port (
      src_clk     : in std_logic;
      dst_clk     : in std_logic;
    
      src_reset   : in std_logic;
      dst_reset   : in std_logic;
    
      dst_updated : out std_logic;
    
      src_data    : in std_logic_vector;
      dst_data    : out std_logic_vector
    );
  end component;

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.
  axi_reset <= not S_AXI_ARESETN;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

  -- il n'y a que 2 registres, qu'on hard code a des position byte pour optimiser la lecture sur le LPC
	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
    constant addr_0 : std_logic_vector(loc_addr'range) := (others => '0');
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      --input_free_start <= (others => '0');
	      input_free_end <= (others => '1');
	      output_free_start <= (others => '0');
	      --output_free_end <= (others => '1');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
        
	      if (slv_reg_wren = '1') and loc_addr = addr_0 then
          -- on accede au registre!
          if ( S_AXI_WSTRB(1) = '1' ) then
            -- input free end est defini au byte 1
            input_free_end <= S_AXI_WDATA(1*8+7 downto 1*8);
          end if;

	        if ( S_AXI_WSTRB(2) = '1' ) then
	          -- output_free_start est au byte 2
	          output_free_start <= S_AXI_WDATA(2*8+7 downto 2*8);
	        end if;

	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

  process (input_free_start_axi, input_free_end, output_free_start, output_free_end_axi, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	  variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    constant addr_0 : std_logic_vector(loc_addr'range) := (others => '0');
	begin
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
    if loc_addr = addr_0 then
      reg_data_out <= output_free_end_axi & output_free_start & input_free_end & input_free_start_axi;  -- sur le AXI, on met toutes les variables, sans regarder les domaines d'horloge pour l'instant
    else
      -- il faut mettre le readback de la BRAM ici
	        reg_data_out  <= (others => '0');
	  end if;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
          if axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS) = '0' then
	          axi_rdata <= reg_data_out;     -- register read data
          else
	          axi_rdata <= ram_data_b;     -- lire de la BRAM
          end if;
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here

  -- implantation des registre ecrit par le host, RO par le Microblaze
  hsrregprc: process(sysclk)
    constant addr_0 : std_logic_vector(ext_ProdCons_addr'range) := (others => '0');
  begin
    if rising_edge(sysclk) then
	    if sysrst = '1' then
        input_free_start <= ( others => '0');
        output_free_end <= ( others => '1');
      elsif ext_ProdCons_addr = addr_0 and ext_ProdCons_writeEn = '1' then
        if ext_writeBeN(0) = '0' then
          input_free_start <= ext_writeData(7 downto 0);
        end if;
        if ext_writeBeN(3) = '0' then
          output_free_end <= ext_writeData(31 downto 24);
        end if;
      end if;
    end if;
  end process;
  
  -- faire passer du sysclk au axi clock
  ifsresync: safe_domain_change_vector 
    port map (
      src_clk     => sysclk,
      dst_clk     => S_AXI_ACLK,
    
      src_reset   => sysrst,
      dst_reset   => axi_reset,
    
      src_data    => input_free_start,
      dst_data    => input_free_start_axi
    );
  
  -- faire passer du sysclk au axi clock
  oferesync: safe_domain_change_vector 
    port map (
      src_clk     => sysclk,
      dst_clk     => S_AXI_ACLK,
    
      src_reset   => sysrst,
      dst_reset   => axi_reset,
    
      src_data    => output_free_end,
      dst_data    => output_free_end_axi
    );

  -- faire passer du axi clock au sysclk
  ofsresync: safe_domain_change_vector 
    port map (
      src_clk     => S_AXI_ACLK,
      dst_clk     => sysclk,
    
      src_reset   => axi_reset,
      dst_reset   => sysrst,
    
      dst_updated => host_irq,  -- on genere une interruption au host lorsqu'il y a mise-a-jour du OUTPUT_FREE_START
    
      src_data    => output_free_start,
      dst_data    => output_free_start_sysclk
    );

  -- faire passer du axi clock au sysclk
  iferesync: safe_domain_change_vector 
    port map (
      src_clk     => S_AXI_ACLK,
      dst_clk     => sysclk,
    
      src_reset   => axi_reset,
      dst_reset   => sysrst,
    
      src_data    => input_free_end,
      dst_data    => input_free_end_sysclk
    );
  
  -- on repond toujours en un coup de clock.
  rdvldprc: process(sysclk)
  begin
    if rising_edge(sysclk) then
      ext_ProdCons_readDataValid <= ext_ProdCons_readEn;

    end if;
  end process;

  ext_ProdCons_readData <= output_free_end & output_free_start_sysclk & input_free_end_sysclk & input_free_start when ext_ProdCons_addr(ext_ProdCons_addr'high) = '0' else ram_data_a;  -- sur le host, on met toutes les variables, sans regarder les domaines d'horloge pour l'instant
  -- il faut muxer les donnees de la BRAM

  -- inverser la polarite des byte enable et combiner avec la commande de write global
  host_write_enable <= not ext_writeBeN when ext_ProdCons_writeEn = '1' else (others => '0');

  process(sysclk)
  begin
      if(sysclk'event and sysclk = '1') then
          if(ext_ProdCons_addr(ext_ProdCons_addr'high) = '1') then -- le MSB de l'external sert a selectionner le block de memoire/ on pourrait optimiser la puissance en gatant avec la commande read ou write venant du LPC
        -- pour faire un mode NO_CHANGE, on ne lit que si on ne write pas
        if host_write_enable = (host_write_enable'range => '0') then
          ram_data_a <= ram_name(to_integer(unsigned(ext_ProdCons_addr(ext_ProdCons_addr'high-1 downto ext_ProdCons_addr'low))));
        end if;
              for i in 0 to C_NB_COL-1 loop
                  if(host_write_enable(i) = '1') then
            ram_name(to_integer(unsigned(ext_ProdCons_addr(ext_ProdCons_addr'high-1 downto ext_ProdCons_addr'low))))((i+1)*C_COL_WIDTH-1 downto i*C_COL_WIDTH) := ext_writeData((i+1)*C_COL_WIDTH-1 downto i*C_COL_WIDTH);
                  end if;
              end loop;
          end if;
      end if;
  end process;

  -- version combinatoire. Il faudra reflopper au lieu d'utiliser des signaux deja floppe pour rien... 
  axi_ram_enable <= (S_AXI_ARVALID and S_AXI_ARADDR(ADDR_LSB + OPT_MEM_ADDR_BITS)) or (slv_reg_wren and S_AXI_AWADDR(ADDR_LSB + OPT_MEM_ADDR_BITS));
  axistrbprc: process(S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if(S_AXI_WVALID = '1') then
        axi_write_strobe <= S_AXI_WSTRB;
      else
        axi_write_strobe <= (others => '0'); -- desactiver les strobes pendant un read pour en pas que la RAM soit ecrite
      end if;
    end if;       
  end process;
  
  -- au niveau de l'adresse AXI on a un petit probleme theorique.
  -- que faire lorsque le microblaze faire un read et un write EN MEME TEMPS a des adresses differentes? 
  -- Ca va nous prendre un arbitre OU une garantie systeme que ca arrivera jamais...
  -- Cependant, ARADDR et AWADDR devraient toujours etre la meme valeur car on est un peripherique axi_lite. J'espere que Vivado va s'en rendre compte tout seul
  -- et qu'il va eleminer la logique inutile tout seul. C'est a verifier.
  -- aussi, ce process est combinatoire, car en floppe, l'adresse arrive trop tard. En theorie, ca pourrait etre dur a passer en timing.
  -- pour un write, on a la requete avec S_AXI_AWVALID = '1' et S_AXI_WVALID = '1'.  Le coup de clock suivant, on repond ready.  
  -- Tant qu'on ne repond pas ready, on est certain que l'adresse demeure valide, on peut donc la flopper
  axiaddrmux:process(S_AXI_ACLK,axi_arready,S_AXI_ARVALID,S_AXI_ARADDR,axi_awready,S_AXI_AWVALID,S_AXI_WVALID,S_AXI_AWADDR)
  begin
 	  if (S_AXI_ARVALID = '1') then
	    -- Read Address latching 
	    axi_bram_addr  <= S_AXI_ARADDR(ADDR_LSB + OPT_MEM_ADDR_BITS-1 downto ADDR_LSB);           
 	  elsif (S_AXI_AWVALID = '1') then
	    -- Write Address latching
	    axi_bram_addr <= S_AXI_AWADDR(ADDR_LSB + OPT_MEM_ADDR_BITS-1 downto ADDR_LSB);
     else
       axi_bram_addr <= (others => '-');  -- pour ne pas que ca fasse un latch.
	  end if;
  end process; 
  
  process(S_AXI_ACLK)
  begin
      if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
          if(axi_ram_enable = '1') then
        if axi_write_strobe = (S_AXI_WSTRB'range => '0') then
          ram_data_b <= ram_name(to_integer(unsigned(axi_bram_addr)));
        end if;
              for i in 0 to C_NB_COL-1 loop
          if(axi_write_strobe(i) = '1') then
            ram_name(to_integer(unsigned(axi_bram_addr)))((i+1)*C_COL_WIDTH-1 downto i*C_COL_WIDTH) := S_AXI_WDATA((i+1)*C_COL_WIDTH-1 downto i*C_COL_WIDTH);
                  end if;
              end loop;
        
          end if;
      end if;
  end process;

  --  Following code generates LOW_LATENCY (no output register)
  --  Following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing

  --no_output_register : if C_RAM_PERFORMANCE = "LOW_LATENCY" generate
  --  douta <= ram_data_a;
  --  doutb <= ram_data_b;
  --end generate;

  --  Following code generates HIGH_PERFORMANCE (use output register) 
  --  Following is a 2 clock cycle read latency with improved clock-to-out timing
  -- 
  -- output_register : if C_RAM_PERFORMANCE = "HIGH_PERFORMANCE"  generate
  -- process(sysclk)
  -- begin
  --     if(sysclk'event and sysclk = '1') then
  --         if(rsta = '1') then
  --             douta_reg <= (others => '0');
  --         elsif(regcea = '1') then
  --             douta_reg <= ram_data_a;
  --         end if;
  --     end if;
  -- end process;
  -- douta <= douta_reg;
  -- 
  -- process(S_AXI_ACLK)
  -- begin
  --     if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
  --         if(rstb = '1') then
  --             doutb_reg <= (others => '0');
  --         elsif(regceb = '1') then
  --             doutb_reg <= ram_data_b;
  --         end if;
  --     end if;
  -- end process;
  -- doutb <= doutb_reg;
  -- 
  -- end generate;

	-- User logic ends

end arch_imp;


library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;


-- fait passer un pointeur d'un domaine d'horloge a l'autre, sans danger, peut-importe les frequences d'operation.
-- ce qui est important ici, c'est que qu'en regime permanent, la destination soit la meme que la source.  
-- Il peut y avoir un delai relativement grand avant que le changement soit visible dans le domaine destination.
-- Il est possible que des transitions du cote source ne soient pas vues du cote destination.
-- Dans le cas ou la source change plus vite que ce qui est possible au niveau destination, ce qui est important
-- c'est que la derniere transition soit vue a la destination.
entity safe_domain_change_vector is
  port (
    src_clk     : in std_logic;
    dst_clk     : in std_logic;
    
    src_reset   : in std_logic;
    dst_reset   : in std_logic;
    
    dst_updated : out std_logic;
    
    src_data    : in std_logic_vector;
    dst_data    : out std_logic_vector
  );
end safe_domain_change_vector;

architecture fonctionnel of safe_domain_change_vector is
  
  signal src_data_saved : std_logic_vector(src_data'range);
  signal src_changed : std_logic;
  
  signal dst_changed_meta   : std_logic;
  signal dst_changed        : std_logic;
  
  signal change_received    : std_logic;
  signal received_meta      : std_logic;
  signal received           : std_logic;

begin

  process(src_clk)
  begin
    if rising_edge(src_clk) then
      if src_reset = '1' then
        src_changed <= '1'; -- forcer une transmission de donne au premier reset
      elsif src_data /= src_data_saved and received = '0' then -- on ne peut signaler un changement a la destination QUE si elle est
        src_changed <= '1';
      elsif received = '1' then -- si la destination nous dit qu'elle a recu un changement, alors on peut cesser de lui signaler
        src_changed <= '0';
      end if;

      -- on enregistre le data QUE si on est capable de transmettre l'information au domaine de destination. Sinon, on garde le vielle etat pour pouvoir redetecter le changement au cycle suivant
      -- aussi, sur un reset, on provoque un changement, donc il faut latcher l'information a ce moment.
      if src_reset = '1' or (src_changed = '0' and received = '0') then
        src_data_saved <= src_data;
      end if;
      
    end if;
  end process;
  
  -- detecter le changement de la source dans le domaine destination et enregister
  process(dst_clk)
  begin
    if rising_edge(dst_clk) then
      if dst_reset = '1' then
        dst_changed_meta  <= '0';  -- je reset pour qu'au reset initial, le passage de la clock src a dst soit retardee jusqu'a la fin du reset.
        dst_changed       <= '0';
      else
      dst_changed_meta <= src_changed;
      dst_changed <= dst_changed_meta;
      end if;
      
      -- leading edge d'un changement, c'est le bon temps pour ramasser le data car ca fait plus d'un cycle (destination) qu'il est stable
      if dst_reset = '1' then
        change_received <= '0';
      elsif dst_changed = '1' and change_received = '0' then 
        dst_data <= src_data_saved;
        change_received <= '1';
      elsif dst_changed = '0' then
        change_received <= '0';
      end if;
      
    end if;
  end process;
 
  -- chemin de feedback de la destination a la source
  process(src_clk)
  begin
    if rising_edge(src_clk) then
      received_meta <= change_received;
      received      <= received_meta;
    end if;
  end process;
    
  -- indique que la valeur destination est mise-a-jour, on prend la meme condition que ce qui update la destination
  dstchprc:process(dst_clk)
  begin
    if rising_edge(dst_clk) then
      dst_updated <= dst_changed and not change_received;
    end if;
  end process;

end fonctionnel;
