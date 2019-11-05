library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity calculator is
  port(
    input    : in  std_logic_vector(7 downto 0);
    opcode   : in  std_logic_vector(1 downto 0);
    clk      : in  std_logic;
    execute  : in  std_logic;
    ms       : in  std_logic;
    mr       : in  std_logic;
    reset    : in  std_logic;
    --
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
--    led      : out std_logic_vector(4 downto 0)
  );
end calculator;

architecture arc of calculator is

--------------------------------------------------------------------------------

-- synchronized signals
signal execute_pulse : std_logic;
signal ms_pulse      : std_logic;
signal mr_pulse      : std_logic;

-- alu signals
signal result     : std_logic_vector(7 downto 0);
signal to_alu     : std_logic_vector(7 downto 0);
signal result_reg : std_logic_vector(7 downto 0) := (others => '0');

-- memory signals
signal we   : std_logic := '1';
signal addr : std_logic_vector(1 downto 0) := "00";

-- state machine declaration
type state is (read_w, read_s, write_w, write_s, write_w_no_op);
signal state_reg  : state := read_w;
signal next_state : state;

-- display signals
signal result_padded : std_logic_vector(11 downto 0);
signal ones_bcd     : std_logic_vector(3 downto 0);
signal tens_bcd     : std_logic_vector(3 downto 0);
signal hundreds_bcd : std_logic_vector(3 downto 0);

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

execute_edge : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => execute,
    edge  => execute_pulse
  );

ms_edge : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => ms,
    edge  => ms_pulse
  );

mr_edge : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => mr,
    edge  => mr_pulse
  );

--------------------------------------------------------------------------------

comp : alu
  port map(
    clk    => clk,
    reset  => reset,
    a      => to_alu,
    b      => input,
    op     => opcode,
    result => result
  );

--------------------------------------------------------------------------------

mem : memory
  generic map(
    addr_width => 2,
    data_width => 8)
  port map(
    clk  => clk,
    we   => we,
    addr => addr,
    din  => result_reg,
    dout => to_alu
  );

--------------------------------------------------------------------------------

-- state register
process (clk, reset)
begin
  if (reset = '0') then
    state_reg <= read_w;
  elsif (clk'event and clk = '1') then
    state_reg <= next_state;
  end if;
end process;

-- next state logic
process (state_reg, execute_pulse, ms_pulse, mr_pulse)
begin
  -- default value (prevents a latch)
  next_state <= state_reg;
  case state_reg is
    when read_w =>
      if    (execute_pulse = '1') then next_state <= write_w_no_op;
      elsif (mr_pulse = '1')      then next_state <= read_s;
      elsif (ms_pulse = '1')      then next_state <= write_s;
      end if;
    when read_s =>
      next_state <= write_w_no_op;
    when write_w_no_op =>
      next_state <= write_w;
    when others =>
      next_state <= read_w;
  end case;
end process;

-- result register
process (clk, reset, state_reg)
begin
  if (reset = '0') then
    result_reg <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (state_reg = read_s) then
      result_reg <= to_alu;
    elsif (state_reg = write_w) then
      result_reg <= result;
    end if;
  end if;
end process;

-- -- address
-- process (state_reg)
-- begin
  -- case state_reg is
    -- when write_s => addr <= "01";
    -- when read_s  => addr <= "01";
    -- when write_w => addr <= "00";
    -- when read_w  => addr <= "00";
    -- when others  => addr <= "00";
  -- end case;
-- end process;

-- -- write enable
-- process (state_reg)
-- begin
  -- case state_reg is
    -- when read_w  => we <= '0';
    -- when read_s  => we <= '0';
    -- when write_w => we <= '1';
    -- when write_s => we <= '1';
    -- when others  => we <= '1';
  -- end case;
-- end process;
--------------------------------------------------------------------------------

result_padded <= "0000" & result_reg;

dd : double_dabble
  port map(
    result_padded => result_padded,
    ones          => ones_bcd,
    tens          => tens_bcd,
    hundreds      => hundreds_bcd
  );

ones_display : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => ones_bcd,
    display => ones
  );

tens_display : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => tens_bcd,
    display => tens
  );

hundreds_display : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => hundreds_bcd,
    display => hundreds
  );

--------------------------------------------------------------------------------

end arc;
