--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--     HOMEWORK 5:  State Machine
--
--      FILE NAME:  hw5_state_machine.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Three-process Finite State Machine [FSM] that detects, starting from the
--    left-most bit, the sequence "11101011"
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hw5_state_machine is
  port(
    input   : in  std_logic;
    clk     : in  std_logic;
    reset_n : in  std_logic;
    flag    : out std_logic;
  );
end hw5_state_machine;

architecture arc of hw5_state_machine is

type state_type is (idle, s1, s11, s111, s1110, s11101, s111010, s1110101, s11101011);
signal state_reg : state_type := idle;
signal state_next : state_type;

begin

-- state register
process (clk, reset_n)
begin
  if (reset_n = '0' then
    state_reg <= idle;
  elsif (clk'event and clk = '1') then
    state_reg <= next_state;
  end if;
end process;

-- next state logic
process (state_reg, input)
begin
  -- default value (prevents a latch)
  state_next <= state_reg;
  case state_reg is
    when idle =>
      if    (input = '1') then next_state <= s1;
      elsif (input = '0') then next_state <= idle;
      end if;
    when s1 =>
      if    (input = '1') then next_state <= s11;
      elsif (input = '0') then next_state <= idle;
      end if;
    when s111 =>
      if    (input = '1') then next_state <= s111;
      elsif (input = '0') then next_state <= s1110;
      end if;
    when s1110 =>
      if    (input = '1') then next_state <= s11101;
      elsif (input = '0') then next_state <= idle;
      end if;
    when s11101 =>
      if    (input = '1') then next_state <= s11;
      elsif (input = '0') then next_state <= s111010;
      end if;
    when s111010 =>
      if    (input = '1') then next_state <= s1110101;
      elsif (input = '0') then next_state <= idle;
      end if;
    when s1110101 =>
      if    (input = '1') then next_state <= s11101011;
      elsif (input = '0') then next_state <= idle;
      end if;
    when s11101011 =>
      if    (input = '1') then next_state <= s1;
      elsif (input = '0') then next_state <= idle;
      end if;
    when others => next_state <= idle;
  end case;
end process;

-- output logic for flag
with state_reg select
  flag <= '1' when s11101011,
          '0' when others;

end arc;
