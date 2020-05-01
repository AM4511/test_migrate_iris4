library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.regfile_pcie2AxiMaster_pack.all;


entity tlp_to_axi_master is
  generic (
    BAR_ADDR_WIDTH : integer range 10 to 30 := 25;
    AXI_ID_WIDTH   : integer range 1 to 8   := 6
    );
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk     : in std_logic;
    sys_reset_n : in std_logic;

    ---------------------------------------------------------------------      
    -- New receive request interface
    ---------------------------------------------------------------------
    tlp_in_valid       : in  std_logic;
    tlp_in_abort       : out std_logic;
    tlp_in_accept_data : out std_logic;

    tlp_in_fmt_type       : in std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet 
    tlp_in_address        : in std_logic_vector(31 downto 0);  -- 2 LSB a decoded from byte enables
    tlp_in_length_in_dw   : in std_logic_vector(10 downto 0);
    tlp_in_attr           : in std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    tlp_in_transaction_id : in std_logic_vector(23 downto 0);  -- bus, device, function, tag
    tlp_in_data           : in std_logic_vector(31 downto 0);
    tlp_in_byte_en        : in std_logic_vector(3 downto 0);
    tlp_in_byte_count     : in std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables

    ---------------------------------------------------------------------
    -- New transmit interface
    ---------------------------------------------------------------------
    tlp_out_req_to_send : out std_logic;
    tlp_out_grant       : in  std_logic;

    tlp_out_fmt_type     : out std_logic_vector(6 downto 0);  -- fmt and type field 
    tlp_out_length_in_dw : out std_logic_vector(9 downto 0);

    tlp_out_src_rdy_n : out std_logic;
    tlp_out_dst_rdy_n : in  std_logic;
    tlp_out_data      : out std_logic_vector(31 downto 0);

    -- for master request transmit
    tlp_out_address     : out std_logic_vector(63 downto 2);
    tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
    tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
    tlp_out_lower_address  : out std_logic_vector(6 downto 0);

    -- TLP Status
    tlp_timeout_value    : in  std_logic_vector(31 downto 0);
    tlp_abort_cntr_init  : in  std_logic;
    tlp_abort_cntr_value : out std_logic_vector(30 downto 0);

    ---------------------------------------------------------------------------
    -- AXI windowing
    ---------------------------------------------------------------------------
    axi_window : inout AXI_WINDOW_TYPE_array := INIT_AXI_WINDOW_TYPE_array;

    ---------------------------------------------------------------------------
    -- Write Address Channel
    ---------------------------------------------------------------------------
    axim_awready : in  std_logic;
    axim_awvalid : out std_logic;

    axim_awid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_awaddr  : out std_logic_vector(31 downto 0);
    axim_awlen   : out std_logic_vector(7 downto 0);
    axim_awsize  : out std_logic_vector(2 downto 0);
    axim_awburst : out std_logic_vector(1 downto 0);
    axim_awlock  : out std_logic;
    axim_awcache : out std_logic_vector(3 downto 0);
    axim_awprot  : out std_logic_vector(2 downto 0);
    axim_awqos   : out std_logic_vector(3 downto 0);


    ---------------------------------------------------------------------------
    -- Write Data Channel
    ---------------------------------------------------------------------------
    axim_wready : in  std_logic;
    axim_wvalid : out std_logic;
    axim_wid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_wdata  : out std_logic_vector(31 downto 0);
    axim_wstrb  : out std_logic_vector(3 downto 0);
    axim_wlast  : out std_logic;


    ---------------------------------------------------------------------------
    -- AXI Write response
    ---------------------------------------------------------------------------
    axim_bvalid : in  std_logic;
    axim_bready : out std_logic;
    axim_bid    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_bresp  : in  std_logic_vector(1 downto 0);


    ---------------------------------------------------------------------------
    --  Read Address Channel
    ---------------------------------------------------------------------------
    axim_arready : in  std_logic;
    axim_arvalid : out std_logic;
    axim_arid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_araddr  : out std_logic_vector(31 downto 0);
    axim_arlen   : out std_logic_vector(7 downto 0);
    axim_arsize  : out std_logic_vector(2 downto 0);
    axim_arburst : out std_logic_vector(1 downto 0);
    axim_arlock  : out std_logic;
    axim_arcache : out std_logic_vector(3 downto 0);
    axim_arprot  : out std_logic_vector(2 downto 0);
    axim_arqos   : out std_logic_vector(3 downto 0);


    ---------------------------------------------------------------------------
    -- AXI Read data channel
    ---------------------------------------------------------------------------
    axim_rready : out std_logic;
    axim_rvalid : in  std_logic;
    axim_rid    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_rdata  : in  std_logic_vector(31 downto 0);
    axim_rresp  : in  std_logic_vector(1 downto 0);
    axim_rlast  : in  std_logic
    );
end entity;


architecture rtl of tlp_to_axi_master is


  component tlp_completion is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk   : in std_logic;
      sys_reset : in std_logic;

      ---------------------------------------------------------------------      
      -- Completion request
      ---------------------------------------------------------------------
      compl_req     : in  std_logic;
      compl_pending : out std_logic;

      compl_fmt_type        : in std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet 
      compl_lower_address   : in std_logic_vector(6 downto 0);  -- 2 LSB a decoded from byte enables
      compl_length_in_dw    : in std_logic_vector(10 downto 0);
      compl_length_in_bytes : in std_logic_vector(12 downto 0);
      compl_attr            : in std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      compl_transaction_id  : in std_logic_vector(23 downto 0);  -- bus, device, function, tag

      ---------------------------------------------------------------------      
      -- Read data
      ---------------------------------------------------------------------
      read_data_valid : in std_logic;
      read_last_data  : in std_logic;
      read_data       : in std_logic_vector(31 downto 0);

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      -- Arbitration
      tlp_out_req_to_send : out std_logic;
      tlp_out_grant       : in  std_logic;

      -- Parameters for completion
      tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
      tlp_out_lower_address  : out std_logic_vector(6 downto 0);
      tlp_out_fmt_type       : out std_logic_vector(6 downto 0);  -- fmt and type field 
      tlp_out_length_in_dw   : out std_logic_vector(9 downto 0);

      -- Data transmission
      tlp_out_src_rdy_n : out std_logic;
      tlp_out_dst_rdy_n : in  std_logic;
      tlp_out_data      : out std_logic_vector(31 downto 0)
      );
  end component;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  attribute MARK_DEBUG : string;

  type TRANSACTION_STATE_TYPE is (
    S_IDLE, S_LOAD_TLP,
    S_ABORT_TLP,
    S_ABORT_TLP_WAIT,
    S_WRITE_ADDR,
    S_WRITE_DATA,
    S_WRITE_LAST_DATA,
    S_WAIT_WRITE_RESP,
    S_TRANSACTION_ID,
    S_READ_ADDR,
    S_WAIT_COMPLETION
    );


  constant BAR_ADDR_MASK : std_logic_vector(31 downto 0) := (31 downto BAR_ADDR_WIDTH => '0') & (BAR_ADDR_WIDTH-1 downto 0 => '1');


  -- Transaction FSM
  signal nxtState : TRANSACTION_STATE_TYPE;
  signal state    : TRANSACTION_STATE_TYPE;

  signal sys_reset              : std_logic;
  signal isWrite                : std_logic;
  signal axi_awid               : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi_awaddr             : std_logic_vector(31 downto 0);
  signal axi_awlen              : std_logic_vector(7 downto 0);
  signal axi_awvalid            : std_logic;
  signal axi_wdata              : std_logic_vector(31 downto 0);
  signal axi_wstrb              : std_logic_vector(3 downto 0);
  signal axi_wlast              : std_logic;
  signal axi_wvalid             : std_logic;
  signal axi_bready             : std_logic;
  signal axi_arid               : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi_araddr             : std_logic_vector(31 downto 0);
  signal axi_arlen              : std_logic_vector(7 downto 0);
  signal axi_arvalid            : std_logic;
  signal axi_rready             : std_logic;
  signal axi_aw_ack             : std_logic;
  signal axi_w_ack              : std_logic;
  signal axi_b_ack              : std_logic;
  signal axi_ar_ack             : std_logic;
  signal axi_r_ack              : std_logic;
  signal axi_translated_address : integer;

  signal dw_burst_counter : unsigned(tlp_in_length_in_dw'range);
  signal load_tlp_data    : std_logic;
  signal compl_req        : std_logic;
  signal compl_pending    : std_logic;
  signal window_en        : std_logic_vector(3 downto 0);
  signal hit_window       : std_logic_vector(3 downto 0);

  signal timeout_cntr        : integer := 0;
  signal transaction_timeout : std_logic;
  signal timeout_cntr_init   : std_logic;
  signal tlp_abort_cntr      : integer := 0;

  signal transaction_cntr : unsigned(AXI_ID_WIDTH-1 downto 0);

  -----------------------------------------------------------------------------
  -- Debug probes 
  -----------------------------------------------------------------------------
  -- attribute MARK_DEBUG of tlp_in_valid           : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_abort           : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_accept_data     : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_fmt_type        : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_address         : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_length_in_dw    : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_attr            : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_transaction_id  : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_data            : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_byte_en         : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_in_byte_count      : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_req_to_send    : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_grant          : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_fmt_type       : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_length_in_dw   : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_src_rdy_n      : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_dst_rdy_n      : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_data           : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_address        : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_ldwbe_fdwbe    : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_attr           : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_transaction_id : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_byte_count     : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_out_lower_address  : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_timeout_value      : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_abort_cntr_init    : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_abort_cntr_value   : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_window             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awready           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awvalid           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awid              : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awaddr            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awlen             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awsize            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awburst           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awlock            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awcache           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awprot            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_awqos             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_wready            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_wvalid            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_wid               : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_wdata             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_wstrb             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_wlast             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_bvalid            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_bready            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_bid               : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_bresp             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arready           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arvalid           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arid              : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_araddr            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arlen             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arsize            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arburst           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arlock            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arcache           : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arprot            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_arqos             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_rready            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_rvalid            : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_rid               : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_rdata             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_rresp             : signal is "TRUE";
  -- attribute MARK_DEBUG of axim_rlast             : signal is "TRUE";
  -- attribute MARK_DEBUG of state                  : signal is "TRUE";
  -- attribute MARK_DEBUG of sys_reset              : signal is "TRUE";
  -- attribute MARK_DEBUG of isWrite                : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_awid               : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_awaddr             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_awlen              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_awvalid            : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_wdata              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_wstrb              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_wlast              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_wvalid             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_bready             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_arid               : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_araddr             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_arlen              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_arvalid            : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_rready             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_aw_ack             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_w_ack              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_b_ack              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_ar_ack             : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_r_ack              : signal is "TRUE";
  -- attribute MARK_DEBUG of axi_translated_address : signal is "TRUE";
  -- attribute MARK_DEBUG of dw_burst_counter       : signal is "TRUE";
  -- attribute MARK_DEBUG of load_tlp_data          : signal is "TRUE";
  -- attribute MARK_DEBUG of compl_req              : signal is "TRUE";
  -- attribute MARK_DEBUG of compl_pending          : signal is "TRUE";
  -- attribute MARK_DEBUG of window_en              : signal is "TRUE";
  -- attribute MARK_DEBUG of hit_window             : signal is "TRUE";
  -- attribute MARK_DEBUG of timeout_cntr           : signal is "TRUE";
  -- attribute MARK_DEBUG of transaction_timeout    : signal is "TRUE";
  -- attribute MARK_DEBUG of timeout_cntr_init      : signal is "TRUE";
  -- attribute MARK_DEBUG of tlp_abort_cntr         : signal is "TRUE";
  -- attribute MARK_DEBUG of transaction_cntr       : signal is "TRUE";


begin


  -------------------------------------------------------
  -- Active high reset
  -------------------------------------------------------
  sys_reset <= not sys_reset_n;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_nxtState
  --
  -----------------------------------------------------------------------------
  P_nxtState : process(
    state,
    tlp_in_valid,
    axi_aw_ack,
    axi_w_ack,
    axi_b_ack,
    axi_ar_ack,
    tlp_in_fmt_type,
    tlp_in_length_in_dw,
    dw_burst_counter,
    compl_pending,
    transaction_timeout,
    window_en,
    hit_window
    )
  begin
    if (transaction_timeout = '1') then
      nxtState <= S_ABORT_TLP;
    else
      case (state) is
        -------------------------------------------------------------------------
        -- State: S_IDLE
        -------------------------------------------------------------------------
        when S_IDLE =>
          -----------------------------------------------------------------------
          -- TLP transaction available
          -----------------------------------------------------------------------
          if (tlp_in_valid = '1') then

            ---------------------------------------------------------------------  
            -- If hit valid axi window
            ---------------------------------------------------------------------  
            if (window_en = "0000" or (hit_window /= "0000")) then
              nxtState <= S_LOAD_TLP;

            ---------------------------------------------------------------------  
            -- Invalid axi memory window; we abort the pcie transaction
            ---------------------------------------------------------------------  
            else
              nxtState <= S_ABORT_TLP;
            end if;

          -----------------------------------------------------------------------
          -- Waiting for a new transaction
          -----------------------------------------------------------------------
          else
            nxtState <= S_IDLE;
          end if;

        -------------------------------------------------------------------------
        -- State: S_LOAD_TLP
        -------------------------------------------------------------------------
        when S_LOAD_TLP =>
          -- PCI Write transaction
          if (tlp_in_fmt_type(6) = '1') then
            nxtState <= S_WRITE_ADDR;

          -- PCI READ transaction
          else
            nxtState <= S_READ_ADDR;
          end if;


        -------------------------------------------------------------------------
        -- State: S_WRITE_ADDR
        -------------------------------------------------------------------------
        when S_WRITE_ADDR =>
          if (axi_aw_ack = '1') then
            -- A burst > 1 DW
            if (unsigned(tlp_in_length_in_dw) > 1) then
              nxtState <= S_WRITE_DATA;
            -- A burst of 1 DW
            else
              nxtState <= S_WRITE_LAST_DATA;
            end if;
          else
            -- In a wait state
            nxtState <= S_WRITE_ADDR;
          end if;


        -------------------------------------------------------------------------
        -- State: S_WRITE_DATA
        -------------------------------------------------------------------------
        when S_WRITE_DATA =>
          if (axi_w_ack = '1' and (dw_burst_counter = 2)) then
            nxtState <= S_WRITE_LAST_DATA;
          else
            nxtState <= S_WRITE_DATA;
          end if;


        -------------------------------------------------------------------------
        -- State: S_WRITE_LAST_DATA
        -------------------------------------------------------------------------
        when S_WRITE_LAST_DATA =>
          if (axi_w_ack = '1') then
            nxtState <= S_WAIT_WRITE_RESP;
          else
            nxtState <= S_WRITE_LAST_DATA;
          end if;

        -------------------------------------------------------------------------
        -- State: S_WAIT_WRITE_RESP
        -------------------------------------------------------------------------
        when S_WAIT_WRITE_RESP =>
          if (axi_b_ack = '1') then
            nxtState <= S_IDLE;
          else
            nxtState <= S_WAIT_WRITE_RESP;
          end if;


        -------------------------------------------------------------------------
        -- State: S_READ_ADDR 
        -------------------------------------------------------------------------
        when S_READ_ADDR =>
          if (axi_ar_ack = '1') then
            nxtState <= S_TRANSACTION_ID;
          else
            -- In a wait state
            nxtState <= S_READ_ADDR;
          end if;


        -------------------------------------------------------------------------
        -- State: S_TRANSACTION_ID
        -------------------------------------------------------------------------
        when S_TRANSACTION_ID =>
          nxtState <= S_WAIT_COMPLETION;


        -------------------------------------------------------------------------
        -- State: S_WAIT_COMPLETION
        -------------------------------------------------------------------------
        when S_WAIT_COMPLETION =>
          if (compl_pending = '0') then
            nxtState <= S_IDLE;
          else
            nxtState <= S_WAIT_COMPLETION;
          end if;


        -------------------------------------------------------------------------
        -- State: S_ABORT_TLP
        -------------------------------------------------------------------------
        when S_ABORT_TLP =>
          nxtState <= S_ABORT_TLP_WAIT;

        -------------------------------------------------------------------------
        -- State: S_ABORT_TLP
        -------------------------------------------------------------------------
        when S_ABORT_TLP_WAIT =>
          if (tlp_in_valid = '0') then
            nxtState <= S_IDLE;
          else
            nxtState <= S_ABORT_TLP_WAIT;
          end if;

        -------------------------------------------------------------------------
        -- Default State
        -------------------------------------------------------------------------
        when others =>
          nxtState <= S_IDLE;

      end case;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Synchronous Process : P_state
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : Current state machine
  -----------------------------------------------------------------------------
  P_state : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        state <= S_IDLE;
      else
        state <= nxtState;
      end if;
    end if;
  end process;


  timeout_cntr_init <= '1' when (state /= nxtState) else
                       '1' when (state = S_IDLE) else
                       '0';

  -----------------------------------------------------------------------------
  -- Synchronous Process : P_timeout_cntr
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : Current state machine
  -----------------------------------------------------------------------------
  P_timeout_cntr : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        timeout_cntr <= 0;
      else
        if (timeout_cntr_init = '1') then
          timeout_cntr <= 0;
        else
          timeout_cntr <= timeout_cntr+1;
        end if;
      end if;
    end if;
  end process;


  transaction_timeout <= '1' when (timeout_cntr > to_integer(unsigned(tlp_timeout_value))) else
                         '0';

  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_in_abort
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : Abort a TLP transaction
  -----------------------------------------------------------------------------
  P_tlp_in_abort : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        tlp_in_abort <= '0';
      else
        if (state = S_ABORT_TLP) then
          tlp_in_abort <= '1';
        else
          tlp_in_abort <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_abort_cntr
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : Current state machine
  -----------------------------------------------------------------------------
  P_tlp_abort_cntr : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        tlp_abort_cntr <= 0;
      else
        if (tlp_abort_cntr_init = '1') then
          tlp_abort_cntr <= 0;
        elsif (state = S_ABORT_TLP) then
          tlp_abort_cntr <= tlp_abort_cntr + 1;
        end if;
      end if;
    end if;
  end process;

  tlp_abort_cntr_value <= std_logic_vector(to_unsigned(tlp_abort_cntr, 31));


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_isWrite
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : Ce bit indique si la transaction est du payload avec ou
  --               sans data, ce qui est suffisant pour identifier un write vs
  --               read.
  -----------------------------------------------------------------------------
  P_isWrite : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        isWrite <= '0';
      else
        if (state = S_LOAD_TLP) then
          isWrite <= tlp_in_fmt_type(6);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_transaction_cntr : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        transaction_cntr <= (others => '0');
      else
        if (axi_aw_ack = '1' or axi_ar_ack = '1') then
          transaction_cntr <= transaction_cntr +1;
        end if;
      end if;
    end if;
  end process;



  axi_aw_ack <= axi_awvalid and axim_awready;
  axi_w_ack  <= axi_wvalid and axim_wready;
  axi_b_ack  <= axi_bready and axim_bvalid;
  axi_ar_ack <= axi_arvalid and axim_arready;
  axi_r_ack  <= axi_rready and axim_rvalid;



-------------------------------------------------------------------------------
-- AXI DataTransfer algorithm :
-- ============================
--
-- DataTransfer(Start_Address, Number_Bytes, Burst_Length, Data_Bus_Bytes, Mode, IsWrite)
-- {
--      // Data_Bus_Bytes is the number of 8-bit byte lanes in the bus
--      // Mode is the AXI transfer mode
--      // IsWrite is TRUE for a write, and FALSE for a read
--      assert Mode IN {FIXED, WRAP, INCR};
--      addr = Start_Address; // Variable for current address
--      Aligned_Address = (INT(addr/Number_Bytes) * Number_Bytes);
--      aligned = (Aligned_Address == addr); // Check whether addr is aligned to nbytes
--      dtsize = Number_Bytes * Burst_Length; // Maximum total data transaction size
--
--      for (n = 1 to Burst_Length)
--      {
--              Lower_Byte_Lane = addr - (INT(addr/Data_Bus_Bytes)) * Data_Bus_Bytes;
--              if (aligned == TRUE) then
--              {
--                      Upper_Byte_Lane = Lower_Byte_Lane + Number_Bytes - 1
--              }
--              else
--              {
--                      Upper_Byte_Lane = Aligned_Address + Number_Bytes - 1 - (INT(addr/Data_Bus_Bytes)) * Data_Bus_Bytes;
--              }
--              // Peform data transfer
--              if (IsWrite == TRUE) then
--              {
--                      dwrite(addr, low_byte, high_byte)
--              }
--              else
--              {
--                      dread(addr, low_byte, high_byte);
--              }
--      }
--      return;
-- }
--

  -----------------------------------------------------------------------------
  -- Windowing mechanism
  -----------------------------------------------------------------------------
  window_en(0) <= axi_window(0).ctrl.enable;
  window_en(1) <= axi_window(1).ctrl.enable;
  window_en(2) <= axi_window(2).ctrl.enable;
  window_en(3) <= axi_window(3).ctrl.enable;


  -----------------------------------------------------------------------------
  -- Calculate the address translation from BAR0 offset to axi translation
  -- offset.
  -----------------------------------------------------------------------------
  P_axi_translated_address : process(window_en, axi_window, tlp_in_address) is
    variable addr   : integer;
    variable start  : integer;
    variable stop   : integer;
    variable offset : integer;

  begin
    addr := to_integer(unsigned(tlp_in_address and BAR_ADDR_MASK));

    if (window_en = "0000") then
      hit_window             <= "0000";
      axi_translated_address <= addr;
    else
      -------------------------------------------------------------------------
      -- 1 to 4 window activated 
      -------------------------------------------------------------------------
      -- Default values
      hit_window             <= "0000";
      axi_translated_address <= addr;

      for i in 0 to 3 loop
        start  := to_integer(unsigned(axi_window(i).pci_bar0_start.value));
        stop   := to_integer(unsigned(axi_window(i).pci_bar0_stop.value));
        offset := to_integer(unsigned(axi_window(i).axi_translation.value));

        if ((window_en(i) = '1') and (addr >= start) and (addr <= stop)) then
          hit_window(i)          <= '1';
          axi_translated_address <= (addr + offset) - start;
          exit;
        end if;
      end loop;
    end if;

  end process P_axi_translated_address;


  -----------------------------------------------------------------------------
  --Write Address Channel
  -----------------------------------------------------------------------------
  -- The purpose of the write address channel is to request the address and 
  -- command information for the entire transaction.  It is a single beat
  -- of information.

  -- The AXI4 Write address channel in this example will continue to initiate
  -- write commands as fast as it is allowed by the slave/interconnect.
  -- The address will be incremented on each accepted address transaction,
  -- by burst_size_byte to point to the next address. 
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_awvalid : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_awvalid <= '0';
      else
        -- If previously not valid , start next transaction            
        if (state = S_WRITE_ADDR and axi_aw_ack = '0') then
          axi_awvalid <= '1';
        -- Once asserted, VALIDs cannot be deasserted, so axi_awvalid
        -- must wait until transaction is accepted                   
        --elsif ((state = S_WRITE_ADDR) or (axi_aw_ack = '1')) then
        else
          axi_awvalid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Next address after AWREADY indicates previous address acceptance    
  -----------------------------------------------------------------------------
  P_axi_awaddr : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_awaddr <= (others => '0');
      else
--        if ((state = S_IDLE) or (state = S_WRITE_ADDR)) then
        if (state = S_WRITE_ADDR) then
          axi_awaddr <= std_logic_vector(to_unsigned(axi_translated_address, 32));
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_awlen : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_awlen <= (others => '0');
      else
        --if (state = S_WRITE_ADDR) then
        if (state = S_WRITE_ADDR) then
          axi_awlen <= std_logic_vector(unsigned(tlp_in_length_in_dw(axi_awlen'range)) - 1);
        end if;
      end if;
    end if;
  end process;



  ----------------------
  --Write Data Channel
  ----------------------

  --The write data will continually try to push write data across the interface.

  --The amount of data accepted will depend on the AXI slave and the AXI
  --Interconnect settings, such as if there are FIFOs enabled in interconnect.

  --Note that there is no explicit timing relationship to the write address channel.
  --The write channel has its own throttling flag, separate from the AW channel.

  --Synchronization between the channels must be determined by the user.

  --The simpliest but lowest performance would be to only issue one address write
  --and write data burst at a time.

  --In this example they are kept in sync by using the same address increment
  --and burst sizes. Then the AW and W channels have their transactions measured
  --with threshold counters as part of the user logic, to make sure neither 
  --channel gets too far ahead of each other.

  --Forward movement occurs when the write channel is valid and ready

  -- tlp_in_accept_data <= '1' when (axi_w_ack = '1' and tlp_in_valid = '1') else
  --                       '1' when (state = S_TRANSACTION_ID and tlp_in_valid = '1') else
  --                       '0';

  tlp_in_accept_data <= '1' when (axi_aw_ack = '1' and state = S_WRITE_ADDR) else
                        --'1' when (axi_w_ack = '1' and (state = S_WRITE_DATA or state = S_WRITE_LAST_DATA)) else
                        '1' when (axi_w_ack = '1' and (state = S_WRITE_DATA) ) else     --jmansill on genere pas au last car on a deja envoye un lors de l'acceptation du cycle d'adresse
                        '1' when (state = S_TRANSACTION_ID) else
                        '0';

                        
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_wvalid : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_wvalid <= '0';
      else
        if (nxtState = S_WRITE_DATA or nxtState = S_WRITE_LAST_DATA) then
          axi_wvalid <= '1';
        else
          axi_wvalid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_wlast : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_wlast <= '0';
      else
        if (nxtState = S_WRITE_LAST_DATA) then
          axi_wlast <= '1';
        else
          axi_wlast <= '0';
        end if;
      end if;
    end if;
  end process;


  -- Burst length counter. Uses extra counter register bit to indicate terminal       
  -- count to reduce decode logic */                                                  
  P_dw_burst_counter : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        dw_burst_counter <= (others => '0');
      else
        if (state = S_LOAD_TLP) then
          dw_burst_counter <= unsigned(tlp_in_length_in_dw);
        elsif ((dw_burst_counter > 0) and axi_w_ack = '1') then
          dw_burst_counter <= dw_burst_counter - 1;
        end if;
      end if;
    end if;
  end process;


  load_tlp_data <= '1' when (state = S_WRITE_ADDR and axi_aw_ack = '1') else
                   '1' when (axi_w_ack = '1' and ((state = S_WRITE_DATA) or (state = S_WRITE_DATA))) else
                   '0';


-- Write Data Generator
-- Data pattern is only a simple incrementing count from 0 for each burst  */
  P_axi_wdata : process(sys_clk)
    variable sig_one : natural := 1;
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_wdata <= (others => '0');
      else
        if (load_tlp_data = '1') then
          axi_wdata <= tlp_in_data;
        end if;
      end if;
    end if;
  end process;


-- Write Data Generator                                                             
-- Data pattern is only a simple incrementing count from 0 for each burst  */       
  P_axi_wstrb : process(sys_clk)
    variable sig_one : natural := 1;
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_wstrb <= (others => '0');
      else
        if (load_tlp_data = '1') then
          axi_wstrb <= tlp_in_byte_en;
        end if;
      end if;
    end if;
  end process;


------------------------------
--Write Response (B) Channel
------------------------------

--The write response channel provides feedback that the write has committed
--to memory. BREADY will occur when all of the data and the write address
--has arrived and been accepted by the slave.

--The write issuance (number of outstanding write addresses) is started by 
--the Address Write transfer, and is completed by a BREADY/BRESP.

--While negating BREADY will eventually throttle the AWREADY signal, 
--it is best not to throttle the whole data channel this way.

--The BRESP bit [1] is used indicate any errors from the interconnect or
--slave for the entire write burst. This example will capture the error 
--into the ERROR output. 

  P_axi_bready : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_bready <= '0';
      -- accept/acknowledge bresp with axi_bready by the master       
      -- when axim_bvalid is asserted by slave                       
      else
        if (state = S_WRITE_LAST_DATA) then
          axi_bready <= '1';
        -- deassert after one clock cycle                             
        elsif ((state = S_IDLE) or (axi_b_ack = '1')) then
          axi_bready <= '0';
        end if;
      end if;
    end if;
  end process;


------------------------------
--Read Address Channel
------------------------------

--The Read Address Channel (AW) provides a similar function to the
--Write Address channel- to provide the tranfer qualifiers for the burst.

--In this example, the read address increments in the same
--manner as the write address channel.

  P_axi_arvalid : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_arvalid <= '0';
      -- If previously not valid , start next transaction             
      else
        if (state = S_READ_ADDR and axi_ar_ack = '0') then
          axi_arvalid <= '1';
        --elsif ((state = S_IDLE) or (axi_ar_ack = '1')) then
        else
          axi_arvalid <= '0';
        end if;
      end if;
    end if;
  end process;


-- Next address after ARREADY indicates previous address acceptance  
  P_axi_araddr : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_araddr <= (others => '0');
      else
        if (state = S_READ_ADDR) then
          axi_araddr <= std_logic_vector(to_unsigned(axi_translated_address, 32));
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_awid : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_awid <= (others => '0');
      else
        if (state = S_WRITE_ADDR) then
          axi_awid <= std_logic_vector(transaction_cntr);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_arid : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_arid <= (others => '0');
      else
        if (state = S_READ_ADDR) then
          axi_arid <= std_logic_vector(transaction_cntr);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_axi_arlen : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      --if (sys_reset_n = '0' or state = S_IDLE) then -- Error here we do not
      --latch  axi_arlen. 
      if (sys_reset_n = '0') then
        axi_arlen <= (others => '0');
      else
        if (state = S_READ_ADDR) then
          axi_arlen <= std_logic_vector(unsigned(tlp_in_length_in_dw(axi_arlen'range)) -1);
        end if;
      end if;
    end if;
  end process;


----------------------------------
--Read Data (and Response) Channel
----------------------------------

--/*                                                                    
-- The Read Data channel returns the results of the read request        
--                                                                      
-- In this example the data checker is always able to accept            
-- more data, so no need to throttle the RREADY signal                  
-- */                                                                   
  P_axi_rready : process(sys_clk)
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset_n = '0') then
        axi_rready <= '0';
      -- accept/acknowledge rdata/rresp with axi_rready by the master    
      -- when axim_rvalid is asserted by slave                         
      else
        if (state = S_TRANSACTION_ID) then
          axi_rready <= '1';
        elsif ((state = S_IDLE) or (axim_rlast = '1' and axi_r_ack = '1')) then
          axi_rready <= '0';
        end if;
      end if;
    end if;
  end process;


  compl_req <= '1' when (nxtState = S_TRANSACTION_ID) else
               '0';

  xtlp_completion : tlp_completion
    port map(
      sys_clk                => sys_clk,
      sys_reset              => sys_reset,
      compl_req              => compl_req,
      compl_pending          => compl_pending,
      --compl_abort            => compl_abort,
      compl_fmt_type         => tlp_in_fmt_type,
      compl_lower_address    => tlp_in_address(6 downto 0),
      compl_length_in_dw     => tlp_in_length_in_dw,
      compl_length_in_bytes  => tlp_in_byte_count,
      compl_attr             => tlp_in_attr,
      compl_transaction_id   => tlp_in_transaction_id,
      --compl_max_timeout      => COMPL_MAX_TIMEOUT,
      read_data_valid        => axi_r_ack,
      read_last_data         => axim_rlast,
      read_data              => axim_rdata,
      tlp_out_req_to_send    => tlp_out_req_to_send,
      tlp_out_grant          => tlp_out_grant,
      tlp_out_attr           => tlp_out_attr,
      tlp_out_transaction_id => tlp_out_transaction_id,
      tlp_out_byte_count     => tlp_out_byte_count,
      tlp_out_lower_address  => tlp_out_lower_address,
      tlp_out_fmt_type       => tlp_out_fmt_type,
      tlp_out_length_in_dw   => tlp_out_length_in_dw,
      tlp_out_src_rdy_n      => tlp_out_src_rdy_n,
      tlp_out_dst_rdy_n      => tlp_out_dst_rdy_n,
      tlp_out_data           => tlp_out_data
      );


  -- Unused Ports
  tlp_out_address     <= (others => '-');
  tlp_out_ldwbe_fdwbe <= (others => '-');


  -- I/O Connections assignments
  axim_awvalid <= axi_awvalid;
  axim_awid    <= axi_awid;
  axim_awaddr  <= axi_awaddr;
  axim_awlen   <= axi_awlen;
  axim_awsize  <= "010";                -- Maximum Bytes per transfer = 4
  axim_awburst <= "01";                 -- Fixed burst type only
  axim_awlock  <= '0';
  axim_awcache <= "0011";
  axim_awprot  <= (others => '0');
  axim_awqos   <= (others => '0');

  axim_wvalid <= axi_wvalid;
  axim_wid    <= axi_awid;
  axim_wdata  <= axi_wdata;
  axim_wstrb  <= axi_wstrb;
  axim_wlast  <= axi_wlast;

  axim_bready <= axi_bready;

  axim_arvalid <= axi_arvalid;
  axim_arid    <= axi_arid;
  axim_araddr  <= axi_araddr;
  axim_arlen   <= axi_arlen;
  axim_arsize  <= "010";                -- Maximum Bytes per transfer = 4
  axim_arburst <= "01";                 -- Incr burst type only
  axim_arlock  <= '0';
  axim_arcache <= "0011";
  axim_arprot  <= (others => '0');
  axim_arqos   <= (others => '0');

  axim_rready <= axi_rready;

end rtl;
