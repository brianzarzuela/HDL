--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 5:  Hardware Add and Subtract [8 bit] with State Machine
--
--      FILE NAME:  add_sub_state_machine.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    System for adding and subtracting two 8-bit numbers using a state machine
--    to manage the current state:
--    - load input a
--    - load input b
--    - add
--    - subtract
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity add_sub_state_machine is
  port ( 
    switch   : in std_logic_vector(7 downto 0);
    btn      : in std_logic;
    clk      : in std_logic;
    reset    : in std_logic;
    -- outputs
    led      : out std_logic_vector(3 downto 0);
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0)
  );
end add_sub_state_machine;

architecture arc of add_sub_state_machine is

--------------------------------------------------------------------------------

-- syncrhonized signals
signal btn_sync    : std_logic;
signal switch_sync : std_logic_vector(7 downto 0);

-- add sub signals
signal a      : std_logic_vector(7 downto 0) := (others => '0');
signal b      : std_logic_vector(7 downto 0) := (others => '0');
signal result : std_logic_vector(8 downto 0);
signal flag   : std_logic;

-- state machine declaration
type state is (input_a, input_b, disp_sum, disp_diff);
signal state_reg  : state := input_a;
signal next_state : state;

-- display signals
signal a_padded       : std_logic_vector(8 downto 0);
signal b_padded       : std_logic_vector(8 downto 0);
signal display        : std_logic_vector(8 downto 0);
signal display_padded : std_logic_vector(11 downto 0);
signal ones_bcd       : std_logic_vector(3 downto 0);
signal tens_bcd       : std_logic_vector(3 downto 0);
signal hundreds_bcd   : std_logic_vector(3 downto 0);

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

switch_sync_u : synchronizer_8bit
  port map(
    clk      => clk,
    reset    => reset,
    async_in => switch,
    sync_out => switch_sync
  );

btn_sync_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => btn,
    edge  => btn_sync
  );

addsub_u : gen_add_sub
  generic map(
    bits => 8)
  port map(
    a    => a,
    b    => b,
    flag => flag,
    c    => result
  );

--------------------------------------------------------------------------------

-- state register
process (clk, reset)
begin
  if (reset = '1') then
    state_reg <= input_a;
  elsif (clk'event and clk = '1') then
    state_reg <= next_state;
  end if;
end process;

-- next state logic
process (state_reg, btn_sync)
begin
  -- default value (prevents a latch)
  next_state <= state_reg;
  case state_reg is
    when input_a   =>
      if (btn_sync = '1') then next_state <= input_b;
      end if;
    when input_b   =>
      if (btn_sync = '1') then next_state <= disp_sum;
      end if;
    when disp_sum  =>
      if (btn_sync = '1') then next_state <= disp_diff;
      end if;
    when disp_diff =>
      if (btn_sync = '1') then next_state <= input_a;
      end if;
    when others    => next_state <= input_a; -- keep the compiler happy
  end case;
end process;

-- flag register
process (reset, state_reg)
begin
  if (reset = '1') then
    flag <= '0';
  elsif (state_reg = disp_sum) then
    flag <= '0';
  elsif (state_reg = disp_diff) then
    flag <= '1';
  end if;
end process;

-- display present state
with state_reg select led <=
  "0001" when input_a,
  "0010" when input_b,
  "0100" when disp_sum,
  "1000" when disp_diff;

--------------------------------------------------------------------------------

-- switch to inputs demultiplexer
process (switch_sync, state_reg)
begin
  if (state_reg = input_a) then
    a <= switch_sync;
  elsif (state_reg = input_b) then
    b <= switch_sync;
  end if;
end process;

-- display multiplexer
process (state_reg, a, b, result)
begin
  if (state_reg = input_a) then
    display <= a_padded;
  elsif (state_reg = input_b) then
    display <= b_padded;
  else
    display <= result;
  end if;
end process;

--------------------------------------------------------------------------------

a_padded <= "0" & a;
b_padded <= "0" & b;

display_padded <= "000" & display;

dd : double_dabble
  port map(
    result_padded => display_padded,
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

end architecture arc;