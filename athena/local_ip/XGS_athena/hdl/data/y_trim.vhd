-----------------------------------------------------------------------
-- MODULE        : y_trim
-- 
-- DESCRIPTION   : Module used to crop line at the beginning and the
--                 end of an axi streamed frame.
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity y_trim is
  port (
    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    aclk_y_start : in unsigned(12 downto 0);
    aclk_y_size  : in unsigned(12 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    aclk       : in std_logic;
    aclk_reset : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    aclk_tready : out std_logic;
    aclk_tvalid : in  std_logic;
    aclk_tuser  : in  std_logic_vector(3 downto 0);
    aclk_tlast  : in  std_logic;
    aclk_tdata  : in  std_logic_vector(63 downto 0);


    ---------------------------------------------------------------------------
    -- AXI master stream output interface
    ---------------------------------------------------------------------------
    aclk_tready_out : in  std_logic;
    aclk_tvalid_out : out std_logic;
    aclk_tuser_out  : out std_logic_vector(3 downto 0);
    aclk_tlast_out  : out std_logic;
    aclk_tdata_out  : out std_logic_vector(63 downto 0)
    );
end y_trim;


architecture rtl of y_trim is


  attribute mark_debug : string;
  attribute keep       : string;


  type FSM_TYPE is (S_IDLE, S_CROP, S_SOF, S_SOL, S_WRITE, S_HBLANK, S_EOL, S_EOF, S_DONE);


  -----------------------------------------------------------------------------
  -- ACLK clock domain
  -----------------------------------------------------------------------------
  signal aclk_state      : FSM_TYPE := S_IDLE;
  signal aclk_y_stop     : unsigned(12 downto 0);
  signal aclk_line_cntr  : unsigned(12 downto 0);
  signal aclk_line_valid : std_logic;
  signal aclk_tvalid_int : std_logic;
  signal aclk_tuser_int  : std_logic_vector(3 downto 0);
  signal aclk_tlast_int  : std_logic;
  signal aclk_tdata_int  : std_logic_vector(63 downto 0);
  signal aclk_ack        : std_logic;


  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of bclk_tready          : signal is "true";


begin


  -----------------------------------------------------------------------------
  -- Infer y_stop boundary
  -----------------------------------------------------------------------------
  aclk_y_stop <= aclk_y_start + aclk_y_size - 1;



  -----------------------------------------------------------------------------
  -- Process     : P_aclk_line_cntr
  -- Description : Line counter. Count the number of valid line entering in the
  --               current stream
  -----------------------------------------------------------------------------
  P_aclk_line_cntr : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_line_cntr <= (others => '0');
      else
        -- On the start of frame we reset the line counter
        if (aclk_state = S_IDLE) then
          aclk_line_cntr <= (others => '0');
        elsif (aclk_ack = '1' and aclk_tvalid = '1' and aclk_tuser(3) = '1') then
          aclk_line_cntr <= aclk_line_cntr + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Combinatorial flag used for indicating if the current line is part of the
  -- valid window.
  -----------------------------------------------------------------------------
  aclk_line_valid <= aclk_tvalid when (aclk_line_cntr >= unsigned(aclk_y_start) and aclk_line_cntr <= aclk_y_stop) else
                     '0';


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_state
  -- Description : Main FSM
  -----------------------------------------------------------------------------
  P_aclk_state : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_state <= S_IDLE;
      else
        if (aclk_ack = '1') then

          case aclk_state is
            -------------------------------------------------------------------
            -- S_IDLE : Parking state
            -------------------------------------------------------------------
            when S_IDLE =>
              if (aclk_tvalid = '1') then
                -- If start of frame
                if (aclk_tuser(0) = '1') then
                  if (aclk_y_start = (aclk_y_start'range => '0')) then
                    aclk_state <= S_SOF;
                  else
                    aclk_state <= S_CROP;
                  end if;
                elsif (aclk_tuser(2) = '1') then
                  aclk_state <= S_SOL;
                end if;
              else
                aclk_state <= S_IDLE;
              end if;

            -------------------------------------------------------------------
            -- S_HBLANK : Inter row blanking
            -------------------------------------------------------------------
            when S_HBLANK =>
              if (aclk_tvalid = '1') then
                if (aclk_tuser(2) = '1') then
                  aclk_state <= S_SOL;
                end if;
              else
                aclk_state <= S_HBLANK;
              end if;

            -------------------------------------------------------------------
            -- S_SOF : Start of frame detected on the AXIS I/F
            -------------------------------------------------------------------
            when S_CROP =>
              if (aclk_tvalid = '1') then
                -- If first valid line of the frame : we declare a start of frame
                if (aclk_tuser(2) = '1' and aclk_line_cntr = unsigned(aclk_y_start)) then
                  aclk_state <= S_SOF;
                else
                  aclk_state <= S_CROP;
                end if;
              else
                aclk_state <= S_CROP;
              end if;


            -------------------------------------------------------------------
            -- S_SOF : Start of frame detected on the AXIS I/F
            -------------------------------------------------------------------
            when S_SOF =>
              aclk_state <= S_WRITE;


            -------------------------------------------------------------------
            -- S_SOL : Start of line; initialize the current buffer for a new
            --         line storage
            -------------------------------------------------------------------
            when S_SOL =>
              aclk_state <= S_WRITE;


            -------------------------------------------------------------------
            --  S_WRITE : Line data transfer
            -------------------------------------------------------------------
            when S_WRITE =>
              if (aclk_tvalid = '1') then
                -- If first valid line of the frame : start of frame
                if (aclk_tuser(3) = '1') then
                  aclk_state <= S_EOL;
                elsif (aclk_tuser(1) = '1') then
                  aclk_state <= S_EOF;
                else
                  aclk_state <= S_WRITE;
                end if;
              else
                aclk_state <= S_WRITE;
              end if;


            -------------------------------------------------------------------
            -- S_EOL : End of line encountered
            -------------------------------------------------------------------
            when S_EOL =>
              aclk_state <= S_HBLANK;

            -------------------------------------------------------------------
            -- S_EOF : End of frame encountered
            -------------------------------------------------------------------
            when S_EOF =>
              aclk_state <= S_DONE;


            -------------------------------------------------------------------
            -- S_DONE : Frame transfered
            -------------------------------------------------------------------
            when S_DONE =>
              aclk_state <= S_IDLE;

            -------------------------------------------------------------------
            -- Others states
            -------------------------------------------------------------------
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process P_aclk_state;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_tuser_int
  -- Description : Regenerate the sync when cropping occures SOF and/or EOF
  --               need to be regenerated. 
  -----------------------------------------------------------------------------
  P_aclk_tuser_int : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_tuser_int <= (others => '0');
      else
        if (aclk_ack = '1') then

          if (aclk_tvalid = '1' and aclk_line_valid = '1') then
            ---------------------------------------------------------------------
            -- Regenerate SOF and SOL of the cropped window
            ---------------------------------------------------------------------
            if (aclk_line_cntr = unsigned(aclk_y_start)) then
              aclk_tuser_int(0) <= aclk_tuser(0) or aclk_tuser(2);
              aclk_tuser_int(2) <= '0';
            else
              aclk_tuser_int(0) <= '0';
              aclk_tuser_int(2) <= aclk_tuser(2);
            end if;

            ---------------------------------------------------------------------
            -- Regenerate EOL and EOF of the cropped window
            ---------------------------------------------------------------------
            if (aclk_line_cntr = aclk_y_stop) then
              aclk_tuser_int(1) <= aclk_tuser(1) or aclk_tuser(3);
              aclk_tuser_int(3) <= '0';
            else
              aclk_tuser_int(1) <= '0';
              aclk_tuser_int(3) <= aclk_tuser(3);
            end if;
          else
            aclk_tuser_int <= (others => '0');
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_stream_input_pipeline
  -- Description : Line buffer pointer. 
  -----------------------------------------------------------------------------
  P_stream_input_pipeline : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_tvalid_int <= '0';
        aclk_tlast_int  <= '0';
        aclk_tdata_int  <= (others => '0');
      else
        if (aclk_ack = '1') then
          if (aclk_line_valid = '1') then
            aclk_tvalid_int <= '1';
            aclk_tlast_int  <= aclk_tlast;
            aclk_tdata_int  <= aclk_tdata;
          else
            aclk_tlast_int  <= '0';
            aclk_tvalid_int <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  aclk_ack    <= aclk_tready_out;


  -----------------------------------------------------------------------------
  -- Output port mapping
  -----------------------------------------------------------------------------
  -- Stream input I/F
  aclk_tready <= aclk_tready_out;

  -- Stream output I/F
  aclk_tvalid_out <= aclk_tvalid_int;
  aclk_tuser_out  <= aclk_tuser_int;
  aclk_tlast_out  <= aclk_tlast_int;
  aclk_tdata_out  <= aclk_tdata_int;

end architecture rtl;
