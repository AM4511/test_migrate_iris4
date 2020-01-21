library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_if is
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

        START_TRAINING              : out std_logic;
        BUSY_TRAINING               : in  std_logic;

        FIFO_EN                     : out std_logic;
        FIFO_RESET                  : out std_logic;
        EN_DECODER                  : out std_logic;
        FILTER_MODE                 : out std_logic;


        MANUAL_TAP                  : out std_logic_vector(15 downto 0);
        TRAINING                    : out std_logic_vector(gMax_Datawidth-1 downto 0);
        ENABLE_TRAINING             : out std_logic_vector(gNrOf_DataConn-1 downto 0);


        -- Training pattern on data channels
        TR_DATA                     : out  std_logic_vector(gMax_Datawidth-1 downto 0);
            

        --status pins
        SERDES_CLK_STATUS           : in std_logic_vector(31 downto 0);
        SERDES_WORD_ALIGN           : in std_logic_vector(gNrOf_DataConn-1 downto 0);
        SERDES_SLIP_COUNT           : in std_logic_vector(((gNrOf_DataConn)*8)-1 downto 0);
        SERDES_SHIFT_STATUS         : in std_logic_vector((6*(gNrOf_DataConn))-1 downto 0);
        SERDES_ERROR                : in std_logic_vector(gNrOf_DataConn-1 downto 0);



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
end register_if;

architecture arch_imp of register_if is

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
    signal slv_reg15 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);


    signal slv_reg_rden : std_logic;
    signal slv_reg_wren : std_logic;
    signal reg_data_out :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal byte_index   : integer;

type handshaketxtp is (     idle,
                            wait_ack_high,
                            wait_ack_low
                            );

signal handshaketx : handshaketxtp;

type handshakerxtp is (     idle,
                            wait_req_low
                            );

signal handshakerx : handshakerxtp;

signal req, req_s, req_s2 : std_logic := '0';
signal ack, ack_s, ack_s2 : std_logic := '0';

signal start_cmd    : std_logic := '0';

signal slv_reg0_req : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

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
signal slv_reg15_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');


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
signal slv_reg12_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg13_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg14_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg15_rd_rec : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

signal slv_reg0_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg1_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg2_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg3_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg4_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg5_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg6_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg7_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg8_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg9_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg10_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg11_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg12_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg13_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg14_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal slv_reg15_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');



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
          slv_reg15 <= (others => '0');


          start_cmd <= '0';
        else
          loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
          start_cmd <= '0';
          if (slv_reg_wren = '1') then
            case loc_addr is
              when "0000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 0
                    slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                    start_cmd <= '1';
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
              when "1111" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes
                    -- slave registor 15
                    slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
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
                slv_reg15 <= slv_reg15;

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

    process (slv_reg0_rd, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9,
             slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, 
             axi_araddr, S_AXI_ARESETN, slv_reg_rden)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    begin
        -- Address decoding for reading registers
        loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
        case loc_addr is
          when "0000" =>
            reg_data_out <= slv_reg0_rd;
          when "0001" =>
            reg_data_out <= slv_reg1;
          when "0010" =>
            reg_data_out <= slv_reg2;
          when "0011" =>
            reg_data_out <= slv_reg3;
          when "0100" =>
            reg_data_out <= slv_reg4;
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
            reg_data_out <= slv_reg12_rd;
          when "1101" =>
            reg_data_out <= slv_reg13_rd;
          when "1110" =>
            reg_data_out <= slv_reg14_rd;
          when "1111" =>
            reg_data_out <= slv_reg15_rd;

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
    START_TRAINING <= slv_reg0_rec(0); --cmd
    slv_reg0_rd_rec(0) <= BUSY_TRAINING;
    slv_reg0_rd_rec(31 downto 1) <= (others => '0');

    TRAINING <= slv_reg1_rec(gMax_Datawidth-1 downto 0);

    ENABLE_TRAINING <= slv_reg2_rec(gNrOf_DataConn-1 downto 0);
    MANUAL_TAP(15 downto   0) <= slv_reg3_rec(15 downto   0);

    FIFO_EN     <= slv_reg4_rec(0);
    FIFO_RESET  <= slv_reg4_rec(1);
    EN_DECODER  <= slv_reg4_rec(2);
    FILTER_MODE <= slv_reg4_rec(3);




    slv_reg5_rd_rec(31 downto 0) <= SERDES_CLK_STATUS;
    slv_reg6_rd_rec(gNrOf_DataConn-1 downto 0) <= SERDES_WORD_ALIGN;
    slv_reg6_rd_rec(31 downto gNrOf_DataConn) <= (others => '0');

    --these registers assume the nrof connections set to 12, 3  PHY's 

    slv_reg8_rd_rec <= SERDES_SLIP_COUNT(  31 downto    0);
    slv_reg9_rd_rec <= SERDES_SLIP_COUNT(  63 downto   32);
    slv_reg10_rd_rec <= SERDES_SLIP_COUNT(  95 downto   64);

    slv_reg11_rd_rec <= "00000000" & SERDES_SHIFT_STATUS( 23 downto   0);
    slv_reg12_rd_rec <= "00000000" & SERDES_SHIFT_STATUS( 47 downto  24);
    slv_reg13_rd_rec <= "00000000" & SERDES_SHIFT_STATUS( 71 downto  48);

    slv_reg14_rd_rec(gNrOf_DataConn-1 downto 0) <= SERDES_ERROR;
    slv_reg14_rd_rec(31 downto gNrOf_DataConn) <= (others => '0');


    TR_DATA<= slv_reg15_rec(gMax_Datawidth-1 downto 0);

    --clock domain crossing
    --from receiver clk domain to axi mm clk domain
    rec_to_axi: process(S_AXI_ACLK)
      begin
        if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
            slv_reg0_rd  <= slv_reg0_rd_rec;

            slv_reg5_rd <= slv_reg5_rd_rec;
            slv_reg6_rd <= slv_reg6_rd_rec;
            slv_reg7_rd <= slv_reg7_rd_rec;
            slv_reg8_rd <= slv_reg8_rd_rec;
            slv_reg9_rd <= slv_reg9_rd_rec;
            slv_reg10_rd <= slv_reg10_rd_rec;
            slv_reg11_rd <= slv_reg11_rd_rec;
            slv_reg12_rd <= slv_reg12_rd_rec;
            slv_reg13_rd <= slv_reg13_rd_rec;
            slv_reg14_rd <= slv_reg14_rd_rec;
            slv_reg15_rd <= slv_reg15_rd_rec;

      
        end if;
    end process;

    axi_to_rec: process(CLOCK)
      begin
        if (CLOCK'event and CLOCK = '1') then
            slv_reg1_rec    <= slv_reg1;
            slv_reg2_rec    <= slv_reg2;
            slv_reg3_rec    <= slv_reg3;
            slv_reg4_rec    <= slv_reg4;
            slv_reg5_rec    <= slv_reg5;            
            slv_reg6_rec    <= slv_reg6;            
            slv_reg7_rec    <= slv_reg7;            
            slv_reg8_rec    <= slv_reg8;            
            slv_reg9_rec    <= slv_reg9;
            slv_reg10_rec    <= slv_reg10;
            slv_reg11_rec    <= slv_reg11;
            slv_reg12_rec    <= slv_reg12;
            slv_reg13_rec    <= slv_reg13;            
            slv_reg14_rec    <= slv_reg14;            
            slv_reg15_rec    <= slv_reg15;            


        end if;
    end process;

    handshake_tx: process(S_AXI_ACLK)
        begin
            if (S_AXI_ACLK'event and S_AXI_ACLK = '1') then
                if S_AXI_ARESETN = '0' then
                    req             <= '0';
                    ack_s           <= '0';
                    ack_s2          <= '0';
                    handshaketx     <= idle;
                else
                    ack_s  <= ack;
                    ack_s2 <= ack_s;

                    case handshaketx is
                        when idle =>
                            if (start_cmd = '1') then
                                req             <= '1';
                                slv_reg0_req    <= slv_reg0;
                                handshaketx     <= wait_ack_high;
                            end if;

                        when wait_ack_high =>
                            if (ack_s2 = '1') then
                                req             <= '0';
                                handshaketx     <= wait_ack_low;
                            end if;

                        when wait_ack_low =>
                            if (ack_s2 = '0') then
                                handshaketx     <= idle;
                            end if;

                        when others =>
                            handshaketx     <= idle;

                    end case;
                end if;
            end if;
    end process handshake_tx;

    handshake_rx: process(CLOCK)
        begin
            if (CLOCK'event and CLOCK = '1') then
                if (RESET = '1') then
                    ack             <= '0';
                    req_s           <= '0';
                    req_s2          <= '0';
                    slv_reg0_rec    <= (others => '0');
                    handshakerx     <= idle;
                else
                    req_s       <= req;
                    req_s2      <= req_s;

                    slv_reg0_rec <= (others => '0');

                    case handshakerx is
                        when idle =>
                            if (req_s2 = '1') then
                                 ack                    <= '1';
                                 slv_reg0_rec           <= slv_reg0_req;
                                 handshakerx            <= wait_req_low;
                            end if;

                        when wait_req_low =>
                            if (req_s2 = '0') then
                                ack                     <= '0';
                                handshakerx             <= idle;
                            end if;

                        when others =>
                            handshakerx                 <= idle;
                    end case;
                end if;
            end if;
    end process handshake_rx;
    -- User logic ends

end arch_imp;
