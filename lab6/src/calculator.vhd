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
    led      : out std_logic_vector(4 downto 0)
  );
end calculator;

architecture arc of calculator is

-- synchronized signals
signal execute_pulse : std_logic;
signal ms_pulse      : std_logic;
signal mr_pulse      : std_logic;

-- display signals
signal result_padded : std_logic_vector(11 downto 0);
signal ones_bcd      : std_logic_vector(3 downto 0);
signal tens_bcd      : std_logic_vector(3 downto 0);
signal hundreds_bcd  : std_logic_vector(3 downto 0);

signal to_alu     : std_logic_vector(7 downto 0);
signal result     : std_logic_vector(7 downto 0);
signal result_reg : std_logic_vector(7 downto 0) := (others => '0');

type state is (idle, operate);
signal state_reg  : state := idle;
signal state_next : state;

begin

--------------------------------------------------------------------------------

execute_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => execute,
    edge  => execute_pulse
  );

ms_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => ms,
    edge  => ms_pulse
  );

mr_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => mr,
    edge  => mr_pulse
  );

--------------------------------------------------------------------------------

alu_u : alu
  port map(
    clk    => clk,
    reset  => reset,
    a      => input,
    b      => to_alu,
    op     => opcode,
    result => result
  );

--------------------------------------------------------------------------------

result_padded <= "0000" & result_reg;

--------------------------------------------------------------------------------

double_dabble_u : double_dabble
  port map(
    result_padded => result_padded,
    ones          => ones_bcd,
    tens          => tens_bcd,
    hundreds      => hundreds_bcd
  );
  
--------------------------------------------------------------------------------

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

process (clk, reset)
begin
  if (reset = '0') then
    state_reg <= idle;
  elsif (clk'event and clk = '1') then
    state_reg <= state_next;
  end if;
end process;

--------------------------------------------------------------------------------

process (state_reg, execute_pulse)
begin
  state_next <= state_reg;
  case state_reg is
    when idle =>
      if (execute_pulse = '1') then state_next <= operate;
      end if;
    when others => state_next <= idle;
  end case;
end process;

--------------------------------------------------------------------------------

process (state_reg, reset)
begin
  if (reset = '0') then result_reg <= (others => '0');
  elsif (state_reg = operate) then result_reg <= result;
  end if;
end process;

--------------------------------------------------------------------------------

to_alu <= result_reg;

--------------------------------------------------------------------------------

end arc;
