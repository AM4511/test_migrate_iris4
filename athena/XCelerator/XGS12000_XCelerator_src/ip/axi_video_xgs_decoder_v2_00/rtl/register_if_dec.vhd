library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_if_dec is
    generic (
        -- Users to add parameters here
        gNrOf_DataConn   : integer   := 12;
        gMax_Datawidth   : integer   := 12;

        -- User parameters ends
        -- Do not modify the parameters beyond this line

        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH  : integer   := 32;
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH  : integer   := 32
    );
    port (
        -- Users to add ports here
        CLOCK                       : in  std_logic;
        RESET                       : in  std_logic;

        EN_DECODER                  : out std_logic;
        reset_fifo                  : out std_logic;

        sof_emb                     : out  std_logic_vector(4 downto 0);
        sof_img                     : out  std_logic_vector(4 downto 0);
        eof                         : out  std_logic_vector(4 downto 0);

        sol_emb                     : out  std_logic_vector(4 downto 0);
        sol_img                     : out  std_logic_vector(4 downto 0);
        eol                         : out  std_logic_vector(4 downto 0);

        --write controls for AXIS outputs
        write_img                   : out  std_logic;
        write_emb                   : out  std_logic;
        write_crc                   : out  std_logic;

        tid                         : out  std_logic_vector(3 downto 0); 
        tdest                       : out  std_logic_vector(7 downto 0);

        DATAWIDTH                   : out std_logic_vector(3 downto 0);
        FILL_ENABLE                 : out std_logic;
        CRC_LANE_ENABLE             : out std_logic;
        CHANNELS_ENABLE             : out std_logic_vector(25 downto 0);

        FRAMESCNT                   : in  std_logic_vector(31 downto 0);
        IMGLINESCNT                 : in  std_logic_vector(31 downto 0);
        EMBLINESCNT                 : in  std_logic_vector(31 downto 0);
        IMGPIXELCNT                 : in  std_logic_vector(31 downto 0);
        CLOCKSCNT                   : in  std_logic_vector(31 downto 0);
        STARTLINECNT                : in  std_logic_vector(31 downto 0);
        ENDLINECNT                  : in  std_logic_vector(31 downto 0);
        STATUSBITS                  : in  std_logic_vector(31 downto 0);
        CRCSTATUS                   : in  std_logic_vector(31 downto 0);
        
        XSAMPLE                     : out std_logic_vector(31 downto 0);
        YSAMPLE                     : out std_logic_vector(31 downto 0);
        FRAMESAMPLE                 : out std_logic_vector(31 downto 0);

        -- User ports ends
        -- Do not modify the ports beyond this line

        -- Global Clock Signal
        S_AXI_ACLK  : in std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN   : in std_logic;
        -- Write address (issued by master, acceped by Slave)
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Write channel Protection type. This signal indicates the
            -- privilege and security level of the transaction, and whether
            -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        -- Write address valid. This signal indicates that the master signaling
            -- valid write address and control information.
        S_AXI_AWVALID   : in std_logic;
        -- Write address ready. This signal indicates that the slave is ready
            -- to accept an address and associated control signals.
        S_AXI_AWREADY   : out std_logic;
        -- Write data (issued by master, acceped by Slave)
        S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte lanes hold
            -- valid data. There is one write strobe bit for each eight
            -- bits of the write data bus.
        S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write valid. This signal indicates that valid write
            -- data and strobes are available.
        S_AXI_WVALID    : in std_logic;
        -- Write ready. This signal indicates that the slave
            -- can accept the write data.
        S_AXI_WREADY    : out std_logic;
        -- Write response. This signal indicates the status
            -- of the write transaction.
        S_AXI_BRESP : out std_logic_vector(1 downto 0);
        -- Write response valid. This signal indicates that the channel
            -- is signaling a valid write response.
        S_AXI_BVALID    : out std_logic;
        -- Response ready. This signal indicates that the master
            -- can accept a write response.
        S_AXI_BREADY    : in std_logic;
        -- Read address (issued by master, acceped by Slave)
        S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Protection type. This signal indicates the privilege
            -- and security level of the transaction, and whether the
            -- transaction is a data access or an instruction access.
        S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
        -- Read address valid. This signal indicates that the channel
            -- is signaling valid read address and control information.
        S_AXI_ARVALID   : in std_logic;
        -- Read address ready. This signal indicates that the slave is
            -- ready to accept an address and associated control signals.
        S_AXI_ARREADY   : out std_logic;
        -- Read data (issued by slave)
        S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of the
            -- read transfer.
        S_AXI_RRESP : out std_logic_vector(1 downto 0);
        -- Read valid. This signal indicates that the channel is
            -- signaling the required read data.
        S_AXI_RVALID    : out std_logic;
        -- Read ready. This signal indicates that the master can
            -- accept the read data and response information.
        S_AXI_RREADY    : in std_logic
    );
end register_if_dec;

architecture arch_imp of register_if_dec is

    -- AXI4LITE signals
    signal axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_awready  : std_logic;
    signal axi_wready   : std_logic;
    signal axi_bresp    : std_logic_vector(1 downto 0);
    signal axi_bvalid   : std_logic;
    signal axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_arready  : std_logic;
    signal axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp    : std_logic_vector(1 downto 0);
    signal axi_rvalid   : std_logic;

    -- Example-specific design signals
    -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    -- ADDR_LSB is used for addressing 32/64 bit registers/memories
    -- ADDR_LSB = 2 for 32 bits (n downto 2)
    -- ADDR_LSB = 3 for 64 bits (n downto 3)
    constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
    constant OPT_MEM_ADDR_BITS : integer := 3;
    ------------------------------------------------
    ---- Signals for user logic register space example
    --------------------------------------------------
    ---- Number of Slave Registers 16
    signal slv_reg0 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg1 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg2 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg3 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg4 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg5 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg6 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg7 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg8 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg9 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg10 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg11 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg12 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg13 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg14 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

    signal slv_reg_rden : std_logic;
    signal slv_reg_wren : std_logic;
    signal reg_data_out :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal byte_index   : integer;


    signal slv_reg0_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg1_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg2_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg3_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg4_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg5_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg6_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg7_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg8_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg9_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg10_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg11_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg12_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg13_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg14_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

    signal slv_reg0_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg1_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg2_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg3_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg4_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg5_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg6_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg7_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg8_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg9_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg10_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg11_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

    signal slv_reg3_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg4_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg5_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg6_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg7_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg8_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg9_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg10_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg11_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

begin
    -- I/O Connections assignments

    S_AXI_AWREADY   <= axi_awready;
    S_AXI_WREADY    <= axi_wready;
    S_AXI_BRESP <= axi_bresp;
    S_AXI_BVALID    <= axi_bvalid;
    S_AXI_ARREADY   <= axi_arready;
    S_AXI_RDATA <= axi_rdata;
    S_AXI_RRESP <= axi_rresp;
    S_AXI_RVALID    <= axi_rvalid;
    -- Implement axi_awready generation
    -- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    -- de-asserted when reset is low.

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

    process (S_AXI_ACLK)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    begin
      if rising_edge(S_AXI_ACLK) then
        if S_AXI_ARESETN = '0' then
          slv_reg0 <= (others => '0');
          slv_reg1 <= (others => '0');
          slv_reg2 <= (others => '0');
          slv_reg3 <= (others => '0');
          slv_reg4 <= (others => '0');
          slv_reg5 <= (others => '0');
          slv_reg6 <= (others => '0');
          slv_reg7 <= (others => '0');
          slv_reg8 <= (others => '0');
          slv_reg9 <= (others => '0');
          slv_reg10 <= (others => '0');
          slv_reg11 <= (others => '0');
          slv_reg12 <= (others => '0');
          slv_reg13 <= (others => '0');
          slv_reg14 <= (others => '0');

        else
          loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
          if (slv_reg_wren = '1') then
            case loc_addr is
              when "0000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 0
                    slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0001" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 1
                    slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0010" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 2
                    slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0011" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 3
                    slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0100" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 4
                    slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0101" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 5
                    slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0110" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 6
                    slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "0111" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 7
                    slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 8
                    slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1001" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 9
                    slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1010" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 10
                    slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1011" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 11
                    slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1100" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 12
                    slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1101" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 13
                    slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when "1110" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 14
                    slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;  


              when others =>
                slv_reg0 <= slv_reg0;
                slv_reg1 <= slv_reg1;
                slv_reg2 <= slv_reg2;
                slv_reg3 <= slv_reg3;
                slv_reg4 <= slv_reg4;
                slv_reg5 <= slv_reg5;
                slv_reg6 <= slv_reg6;
                slv_reg7 <= slv_reg7;
                slv_reg8 <= slv_reg8;
                slv_reg9 <= slv_reg9;
                slv_reg10 <= slv_reg10;
                slv_reg11 <= slv_reg11;
                slv_reg12 <= slv_reg12;
                slv_reg13 <= slv_reg13;
                slv_reg14 <= slv_reg14;

            end case;
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

    process (slv_reg0, slv_reg1, slv_reg2, slv_reg3_rd, slv_reg4_rd, slv_reg5_rd, slv_reg6_rd, slv_reg7_rd, slv_reg8_rd, slv_reg9_rd,
             slv_reg10_rd, slv_reg11_rd, slv_reg12, slv_reg13, slv_reg14,
             axi_araddr, S_AXI_ARESETN, slv_reg_rden)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    begin
        -- Address decoding for reading registers
        loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
        case loc_addr is
          when "0000" =>
            reg_data_out <= slv_reg0;
          when "0001" =>
            reg_data_out <= slv_reg1;
          when "0010" =>
            reg_data_out <= slv_reg2;
          when "0011" =>
            reg_data_out <= slv_reg3_rd;
          when "0100" =>
            reg_data_out <= slv_reg4_rd;
          when "0101" =>
            reg_data_out <= slv_reg5_rd;
          when "0110" =>
            reg_data_out <= slv_reg6_rd;
          when "0111" =>
            reg_data_out <= slv_reg7_rd;
          when "1000" =>
            reg_data_out <= slv_reg8_rd;
          when "1001" =>
            reg_data_out <= slv_reg9_rd;
          when "1010" =>
            reg_data_out <= slv_reg10_rd;
          when "1011" =>
            reg_data_out <= slv_reg11_rd;
          when "1100" =>
            reg_data_out <= slv_reg12;
          when "1101" =>
            reg_data_out <= slv_reg13;
          when "1110" =>
            reg_data_out <= slv_reg14;

          when others =>
            reg_data_out  <= (others => '0');
        end case;
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
              axi_rdata <= reg_data_out;     -- register read data
          end if;
        end if;
      end if;
    end process;

    -- Add user logic here
    EN_DECODER <= slv_reg0_rec(0);

    write_img <= slv_reg0_rec(1);
    write_emb <= slv_reg0_rec(2);
    write_crc <= slv_reg0_rec(3);

    reset_fifo <= slv_reg0_rec(4);

    tid   <= slv_reg0_rec(11 downto 8);
    tdest <= slv_reg0_rec(23 downto 16);

    sof_emb <= slv_reg1_rec(4 downto 0);
    sof_img <= slv_reg1_rec(9 downto 5);
    eof <= slv_reg1_rec(14 downto 10);
    
    sol_emb <= slv_reg1_rec(20 downto 16);
    sol_img <= slv_reg1_rec(25 downto 21);
    eol <= slv_reg1_rec(30 downto 26);
    
    DATAWIDTH     <= slv_reg2_rec(3 downto 0);
    FILL_ENABLE   <= slv_reg2_rec(4);
    CRC_LANE_ENABLE <= slv_reg2_rec(5);
    CHANNELS_ENABLE <= slv_reg2_rec(31 downto 6);
    
    slv_reg3_rd_rec <= FRAMESCNT;
    slv_reg4_rd_rec <= IMGLINESCNT;
    slv_reg5_rd_rec <= EMBLINESCNT;
    slv_reg6_rd_rec <= IMGPIXELCNT;
    slv_reg7_rd_rec <= CLOCKSCNT;
    slv_reg8_rd_rec <= STARTLINECNT;
    slv_reg9_rd_rec <= ENDLINECNT;
    slv_reg10_rd_rec <= STATUSBITS;
    slv_reg11_rd_rec <= CRCSTATUS;

    XSAMPLE <= slv_reg12_rec;
    YSAMPLE <= slv_reg13_rec;
    FRAMESAMPLE <= slv_reg14_rec;


    --clock domain crossing
    --from receiver clk domain to axi mm clk domain
    rec_to_axi: process(S_AXI_ACLK)
      begin
        if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
            slv_reg3_rd <= slv_reg3_rd_rec;
            slv_reg4_rd <= slv_reg4_rd_rec;
            slv_reg5_rd <= slv_reg5_rd_rec;
            slv_reg6_rd <= slv_reg6_rd_rec;
            slv_reg7_rd <= slv_reg7_rd_rec;
            slv_reg8_rd <= slv_reg8_rd_rec;
            slv_reg9_rd <= slv_reg9_rd_rec;
            slv_reg10_rd <= slv_reg10_rd_rec;
            slv_reg11_rd <= slv_reg11_rd_rec;
        end if;
    end process;

    axi_to_rec: process(CLOCK)
      begin
        if (CLOCK'event and CLOCK = '1') then
            slv_reg0_rec    <= slv_reg0;
            slv_reg1_rec    <= slv_reg1;
            slv_reg2_rec    <= slv_reg2;
            slv_reg3_rec    <= slv_reg3;
            slv_reg4_rec    <= slv_reg4;
            slv_reg5_rec    <= slv_reg5;
            slv_reg6_rec    <= slv_reg6;
            slv_reg7_rec    <= slv_reg7;
            slv_reg8_rec    <= slv_reg8;
            slv_reg9_rec    <= slv_reg9;
            slv_reg10_rec   <= slv_reg10;
            slv_reg11_rec   <= slv_reg11;
            slv_reg12_rec   <= slv_reg12;
            slv_reg13_rec   <= slv_reg13;
            slv_reg14_rec   <= slv_reg14;
        end if;
    end process;

    -- User logic ends

end arch_imp;
