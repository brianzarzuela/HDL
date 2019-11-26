--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--     HOMEWORK 5:  State Machine
--
--      FILE NAME:  tb_hw5_state_machine.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Testbench for Finite State Machine [FSM] that detects, starting from the
--    left-most bit, the sequence "11101011"
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_hw5_state_machine is
end tb_hw5_state_machine;

architecture tb of tb_hw5_state_machine is

-- component declaration
component hw5_state_machine
  port(
    input   : in  std_logic;
    clk     : in  std_logic;
    reset_n : in  std_logic;
    flag    : out std_logic;
  );
end component;

-- intput signals
signal string  : std_logic_vector(15 downto 0);
variable input : std_logic := 0;
signal reset_n : std_logic := 0;
signal clk     : std_logic := 0;

-- output signals
signal flag : std_logic;

-- clock period definition
constant period : time := 20ns;

begin

fsm : hw5_state_machine
  port map(
    input => input,
    clk => clk,
    reset_n => reset_n,
    flag => flag
  );

stimulus : process
begin
  -- wait 100 ns for global reset to finish
  wait for 100 ns;
  
  string = "1110101011101011";
  
  for i in string'range loop
    input <= string(i);
    wait for period;
  end loop;
  
  wait; -- for forever
end process;

end tb;
