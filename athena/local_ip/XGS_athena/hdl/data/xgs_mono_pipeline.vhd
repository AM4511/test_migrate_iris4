library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;


library work;
use work.regfile_xgs_athena_pack.all;


entity xgs_mono_pipeline is
  generic (
    SIMULATION : integer := 0
    );
  port (
    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    sclk         : in std_logic;
    sclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    sclk_tready : out std_logic;
    sclk_tvalid : in  std_logic;
    sclk_tuser  : in  std_logic_vector(3 downto 0);
    sclk_tlast  : in  std_logic;
    sclk_tdata  : in  std_logic_vector(63 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    aclk         : in std_logic;
    aclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI master stream output interface
    ---------------------------------------------------------------------------
    aclk_tready : in  std_logic;
    aclk_tvalid : out std_logic;
    aclk_tuser  : out std_logic_vector(3 downto 0);
    aclk_tlast  : out std_logic;
    aclk_tdata  : out std_logic_vector(63 downto 0)
    );
end xgs_mono_pipeline;


architecture rtl of xgs_mono_pipeline is



  component mtxDCFIFO is
    generic
      (
        DATAWIDTH : natural := 32;
        ADDRWIDTH : natural := 12
        );
    port
      (
        -- Asynchronous reset
        aClr   : in  std_logic;
        -- Write port I/F (wClk)
        wClk   : in  std_logic;
        wEn    : in  std_logic;
        wData  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        wFull  : out std_logic;
        -- Read port I/F (rClk)
        rClk   : in  std_logic;
        rEn    : in  std_logic;
        rData  : out std_logic_vector (DATAWIDTH-1 downto 0);
        rEmpty : out std_logic
        );
  end component;



  type OUTPUT_FSM_TYPE is (S_IDLE, S_PREFETCH, S_TRANSFER, S_DONE);

  signal aclk_state : OUTPUT_FSM_TYPE;

  -----------------------------------------------------------------------------
  -- SCLK clock domain
  -----------------------------------------------------------------------------
  signal sclk_reset         : std_logic;
  signal sclk_wen           : std_logic;
  signal sclk_data          : std_logic_vector (71 downto 0) := (others => '0');
  signal sclk_full          : std_logic;
  signal sclk_data_phase    : std_logic;
  signal sclk_load_data     : std_logic;
  signal sclk_last_data     : std_logic;
  signal sclk_sync_packer   : std_logic_vector (3 downto 0);
  signal sclk_data_packer   : std_logic_vector (63 downto 0);
  signal sclk_packer_valid  : std_logic;
  signal sclk_pix_cntr      : integer;
  signal sclk_pix_cntr_en   : std_logic;
  signal sclk_pix_cntr_init : std_logic;


  -----------------------------------------------------------------------------
  -- ACLK clock domain
  -----------------------------------------------------------------------------
  signal aclk_read            : std_logic;
  signal aclk_read_data       : std_logic_vector (71 downto 0) := (others => '0');
  signal aclk_empty           : std_logic;
  signal aclk_tvalid_int      : std_logic;
  signal aclk_read_data_valid : std_logic;
  signal aclk_tlast_int       : std_logic;
  signal aclk_sync_packer     : std_logic_vector (3 downto 0);
  signal aclk_tlast_packer    : std_logic;
  signal aclk_pix_cntr        : integer;
  signal aclk_pix_cntr_en     : std_logic;
  signal aclk_pix_cntr_init   : std_logic;
  signal aclk_tuser_int       : std_logic_vector(3 downto 0);


begin


  sclk_reset <= not sclk_reset_n;


  sclk_load_data <= '1' when (sclk_full = '0' and sclk_tvalid = '1') else
                    '0';


  sclk_tready <= '1' when (sclk_full = '0') else
                 '0';


  sclk_pix_cntr_en <= '1' when (sclk_full = '0' and sclk_tvalid = '1') else
                      '0';


  sclk_pix_cntr_init <= '1' when (sclk_tuser(0) = '1' or sclk_tuser(2) = '1') else
                        '0';


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_pix_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_pix_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset_n = '0') then
        sclk_pix_cntr <= 0;
      else
        if (sclk_pix_cntr_en = '1') then
          if (sclk_pix_cntr_init = '1') then
            sclk_pix_cntr <= 4;
          else
            sclk_pix_cntr <= sclk_pix_cntr+4;
          end if;
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_sclk_data_phase
  -- Description : 2 Phase counter for 16bit to 8 bits pixel packing process
  -----------------------------------------------------------------------------
  P_sclk_data_phase : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset_n = '0') then
        sclk_data_phase <= '0';
      else
        if (sclk_load_data = '1') then
          if (sclk_tuser(1) = '1' or sclk_tuser(3) = '1') then
            sclk_data_phase <= '0';
          else
            sclk_data_phase <= not sclk_data_phase;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_8bits_packer
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_8bits_packer : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset_n = '0') then
        sclk_data_packer <= (others => '0');
      else
        if (sclk_load_data = '1') then

          ---------------------------------------------------------------------
          -- Normal packing
          ---------------------------------------------------------------------
          --if (SIMULATION = 0) then
            -- Phase 0
            if (sclk_data_phase = '0') then
              sclk_data_packer(7 downto 0)   <= sclk_tdata(11 downto 4);
              sclk_data_packer(15 downto 8)  <= sclk_tdata(27 downto 20);
              sclk_data_packer(23 downto 16) <= sclk_tdata(43 downto 36);
              sclk_data_packer(31 downto 24) <= sclk_tdata(59 downto 52);
            -- Phase 1
            else
              sclk_data_packer(39 downto 32) <= sclk_tdata(11 downto 4);
              sclk_data_packer(47 downto 40) <= sclk_tdata(27 downto 20);
              sclk_data_packer(55 downto 48) <= sclk_tdata(43 downto 36);
              sclk_data_packer(63 downto 56) <= sclk_tdata(59 downto 52);
            end if;
          ---------------------------------------------------------------------
          -- Simulation packing (removed MSB to keep the ramp)
          ---------------------------------------------------------------------
          --else
          --  -- Phase 0
          --  if (sclk_data_phase = '0') then
          --    sclk_data_packer(7 downto 0)   <= sclk_tdata(7 downto 0);
          --    sclk_data_packer(15 downto 8)  <= sclk_tdata(23 downto 16);
          --    sclk_data_packer(23 downto 16) <= sclk_tdata(39 downto 32);
          --    sclk_data_packer(31 downto 24) <= sclk_tdata(55 downto 48);
          --  -- Phase 1
          --  else
          --    sclk_data_packer(39 downto 32) <= sclk_tdata(7 downto 0);
          --    sclk_data_packer(47 downto 40) <= sclk_tdata(23 downto 16);
          --    sclk_data_packer(55 downto 48) <= sclk_tdata(39 downto 32);
          --    sclk_data_packer(63 downto 56) <= sclk_tdata(55 downto 48);
          --  end if;
          --end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_sync_packer
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_sync_packer : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset_n = '0') then
        sclk_sync_packer <= "0000";
      else
        if (sclk_load_data = '1') then
          ---------------------------------------------------------------------
          -- We catch on phase 0 SOF and SOL
          ---------------------------------------------------------------------
          if (sclk_data_phase = '0') then
            sclk_sync_packer <= sclk_tuser;
          ---------------------------------------------------------------------
          -- If no SOF and SOL detected in phase 0 we can catch EOL EOF and CONT
          ---------------------------------------------------------------------
          elsif (sclk_sync_packer(0) = '0' and sclk_sync_packer(2) = '0') then
            sclk_sync_packer <= sclk_tuser;
          end if;
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_sclk_packer_valid
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_packer_valid : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset_n = '0') then
        sclk_packer_valid <= '0';
      else
        if (sclk_load_data = '1'and sclk_data_phase = '1') then
          sclk_packer_valid <= '1';
        elsif (sclk_wen = '1') then
          sclk_packer_valid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_last_data
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_last_data : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset_n = '0') then
        sclk_last_data <= '0';
      else
        if (sclk_load_data = '1') then
          sclk_last_data <= sclk_tlast;
        end if;
      end if;
    end if;
  end process;


  sclk_wen <= '1' when (sclk_packer_valid = '1' and sclk_full = '0') else
              '0';

  -----------------------------------------------------------------------------
  -- FiFo sclk_data bus agregation
  -----------------------------------------------------------------------------
  sclk_data(63 downto 0)  <= sclk_data_packer;
  sclk_data(67 downto 64) <= sclk_sync_packer;
  sclk_data(68)           <= sclk_last_data;

  xoutput_fifo : mtxDCFIFO
    generic map (
      DATAWIDTH => 72,
      ADDRWIDTH => 10
      )
    port map(
      aClr   => sclk_reset,
      wClk   => sclk,
      wEn    => sclk_wen,
      wData  => sclk_data,
      wFull  => sclk_full,
      rClk   => aclk,
      rEn    => aclk_read,
      rData  => aclk_read_data,
      rEmpty => aclk_empty
      );



  aclk_read <= '1' when (aclk_state = S_PREFETCH) else
               '1' when (aclk_state = S_TRANSFER and aclk_tready = '1' and aclk_empty = '0') else
               '1' when (aclk_state = S_TRANSFER and aclk_tvalid_int = '0' and aclk_empty = '0') else
               '0';


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_state
  -- Description : 
  -----------------------------------------------------------------------------
  P_aclk_state : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_state <= S_IDLE;

      else
        case aclk_state is

          ---------------------------------------------------------------------
          -- S_IDLE : Parking state
          ---------------------------------------------------------------------
          when S_IDLE =>
            if (aclk_empty = '0') then
              aclk_state <= S_PREFETCH;
            else
              aclk_state <= S_IDLE;
            end if;

          ---------------------------------------------------------------------
          -- S_PREFETCH : 
          ---------------------------------------------------------------------
          when S_PREFETCH =>
            aclk_state <= S_TRANSFER;

          ---------------------------------------------------------------------
          -- S_TRANSFER
          ---------------------------------------------------------------------
          when S_TRANSFER =>
            if (aclk_empty = '1' and aclk_read_data(68) = '1') then
              aclk_state <= S_DONE;
            end if;

          ---------------------------------------------------------------------
          -- S_DONE
          ---------------------------------------------------------------------
          when S_DONE =>
            aclk_state <= S_IDLE;

          ---------------------------------------------------------------------
          -- 
          ---------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_aclk_state;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_read_data_valid
  -- Description : Indicates data that the read data from the buffer is
  --               available
  -----------------------------------------------------------------------------
  P_aclk_read_data_valid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_read_data_valid <= '0';
      else
        if (aclk_read = '1') then
          aclk_read_data_valid <= '1';
        elsif (aclk_tready = '1') then
          aclk_read_data_valid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_tvalid
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_aclk_tvalid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_tvalid_int <= '0';
      else
        if (aclk_tready = '1' or aclk_tvalid_int = '0') then
          aclk_tvalid_int <= aclk_read_data_valid;
        end if;
      end if;
    end if;
  end process;


  aclk_tvalid <= aclk_tvalid_int;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_tdata
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_aclk_tdata : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_tdata <= (others => '0');
      else
        if ((aclk_tready = '1' or aclk_tvalid_int = '0')and aclk_read_data_valid = '1') then
          aclk_tdata <= aclk_read_data(63 downto 0);
        end if;
      end if;
    end if;
  end process;


  aclk_sync_packer  <= aclk_read_data(67 downto 64);
  aclk_tlast_packer <= aclk_read_data(68);


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_tuser
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_aclk_tuser : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_tuser_int <= (others => '0');
      else
        if (aclk_tready = '1' or aclk_tvalid_int = '0') then
          if (aclk_read_data_valid = '1') then
            aclk_tuser_int <= aclk_sync_packer;
          else
            aclk_tuser_int <= (others => '0');
          end if;
        end if;
      end if;
    end if;
  end process;


  aclk_tuser <= aclk_tuser_int;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_tlast_int
  -- Description : In the AXI stream video protocol TLAST is used as the EOL
  --               sync marker
  -----------------------------------------------------------------------------
  P_aclk_tlast : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_tlast_int <= '0';
      else
        if ((aclk_tready = '1' or aclk_tvalid_int = '0') and aclk_read_data_valid = '1') then
          aclk_tlast_int <= aclk_tlast_packer;
        elsif (aclk_tlast_int = '1' and aclk_tready = '1') then
          aclk_tlast_int <= '0';
        end if;
      end if;
    end if;
  end process;


  aclk_tlast <= aclk_tlast_int;


  aclk_pix_cntr_en <= '1' when (aclk_tvalid_int = '1' and aclk_tready = '1') else
                      '0';


  aclk_pix_cntr_init <= '1' when (aclk_tuser_int(0) = '1' or aclk_tuser_int(2) = '1') else
                        '0';

  
  -----------------------------------------------------------------------------
  -- Process     : P_aclk_pix_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_aclk_pix_cntr : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        aclk_pix_cntr <= 0;
      else
        if (aclk_pix_cntr_en = '1') then
          if (aclk_tlast_int = '1') then
            aclk_pix_cntr <= 0;
          elsif (aclk_pix_cntr_init = '1') then
            aclk_pix_cntr <= 8;
          else
            aclk_pix_cntr <= aclk_pix_cntr+8;
          end if;
        end if;
      end if;
    end if;
  end process;


end architecture rtl;
