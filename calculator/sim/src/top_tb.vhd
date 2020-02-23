--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 5:  Hardware Add and Subtract [8 bit] with State Machine
--
--      FILE NAME:  top_tb.vhd
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

entity top_tb is
end top_tb;

architecture arch of top_tb is

component top is
  port ( 
    switch   : in  std_logic_vector(7 downto 0);
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
end component;

constant wait_time  : time := 50 ns;
constant period     : time := 20 ns;
signal clk          : std_logic := '0';
signal reset        : std_logic := '0';

signal switch   : std_logic_vector(7 downto 0) := (others => '0');
signal opcode   : std_logic_vector(1 downto 0) := (others => '0');
signal execute  : std_logic := '0';
signal ms       : std_logic := '0';
signal mr       : std_logic := '0';
signal led      : std_logic_vector(4 downto 0);
signal ones     : std_logic_vector(6 downto 0);
signal tens     : std_logic_vector(6 downto 0);
signal hundreds : std_logic_vector(6 downto 0);

begin

uut: top
  port map(
    switch    => switch,
    opcode    => opcode,
    execute   => execute,
    ms        => ms,
    mr        => mr,
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
    reset <= '1';
    wait;
end process;

tb : process
begin
  
  -- add 4
  wait for wait_time;
  opcode <= "00";
  switch <= "00000100";
  
  -- execute - display 4
  wait for wait_time;
  for logic in 0 to 1 loop
    execute <= not (execute);
    wait for wait_time;
  end loop;
  
  -- multiply 8
  wait for wait_time;
  opcode <= "10";
  switch <= "00001000";
  
  -- execute - display 32
  wait for wait_time;
  for logic in 0 to 1 loop
    execute <= not (execute);
    wait for wait_time;
  end loop;
  
  -- ms - display 32
  wait for wait_time;
  for logic in 0 to 1 loop
    ms <= not (ms);
    wait for wait_time;
  end loop;
  
  -- subtract 8
  wait for wait_time;
  opcode <= "01";
  switch <= "00001000";
  
  -- execute - display 24
  wait for wait_time;
  for logic in 0 to 1 loop
    execute <= not (execute);
    wait for wait_time;
  end loop;
  
  -- divide 2
  wait for wait_time;
  opcode <= "11";
  switch <= "00000010";
  
  -- execute - display 12
  wait for wait_time;
  for logic in 0 to 1 loop
    execute <= not (execute);
    wait for wait_time;
  end loop;
  
  -- mr - display 32
  wait for wait_time;
  for logic in 0 to 1 loop
    mr <= not (mr);
    wait for wait_time;
  end loop;
  
  -- divide 2
  wait for wait_time;
  opcode <= "11";
  switch <= "00000010";
  
  -- execute - display 16
  wait for wait_time;
  for logic in 0 to 1 loop
    execute <= not (execute);
    wait for wait_time;
  end loop;

end process;

end arch;