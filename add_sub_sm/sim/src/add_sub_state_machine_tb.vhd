--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 5:  Hardware Add and Subtract [8 bit] with State Machine
--
--      FILE NAME:  add_sub_state_machine_tb.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--    System for adding and subtracting two 8-bit numbers using a state machine
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_state_machine_tb is
end add_sub_state_machine_tb;

architecture arch of add_sub_state_machine_tb is

component add_sub_state_machine is
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
end component;

constant wait_time  : time := 30 ns;
constant period     : time := 20 ns;
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';

signal switch   : std_logic_vector(7 downto 0) := (others => '0');
signal btn      : std_logic := '0';
signal led      : std_logic_vector(3 downto 0);
signal ones     : std_logic_vector(6 downto 0);
signal tens     : std_logic_vector(6 downto 0);
signal hundreds : std_logic_vector(6 downto 0);

begin

uut: add_sub_state_machine
  port map(
    switch    => switch,
    btn       => btn,
    clk       => clk,
    reset     => reset,
    led       => led,
    ones      => ones,
    tens      => tens,
    hundreds  => hundreds
  );

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '0';
    wait;
end process;

tb : process
begin
  -- set a to 12
  wait for wait_time;
  switch <= "00001100";
  wait for wait_time;
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  -- set b to 4
  switch <= "00000100";
  wait for wait_time;
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  -- should be 12 + 4 = 16
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  -- should be 12 - 4 = 8
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  
  -----------------------
  
  -- set a to 0
  wait for wait_time;
  switch <= "00000000";
  wait for wait_time;
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  -- set b to 1
  switch <= "00000001";
  wait for wait_time;
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  -- should be 0 + 1 = 1
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;
  -- should be 0 - 1 = 511
  -- simulate button press
  for logic in 0 to 1 loop
    btn <= not (btn);
    wait for wait_time;
  end loop;

  reset <= '0';
  wait;

end process;

end arch;