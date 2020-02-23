--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 7:  Simple Processor [8 bit]
--
--      FILE NAME:  top_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Testbench for top-level implementation of 8-bit calculator.
--    Includes basic add, subtract, multiply and divide operations.
--    Encorporates MS and MR buttons to save the present result into memory and
--    to retrueve values from memory, respectively.
--
--******************************************************************************
--******************************************************************************
library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arch of top_tb is

component top is
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    execute  : in  std_logic;
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
  );
end component; 

constant wait_time  : time := 50 ns;
constant period     : time := 20 ns;
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';

signal execute  : std_logic := '0';
signal led      : std_logic_vector(4 downto 0);
signal ones     : std_logic_vector(6 downto 0);
signal tens     : std_logic_vector(6 downto 0);
signal hundreds : std_logic_vector(6 downto 0);

begin

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

uut: blink_block_mem  
  generic map (
    update_rate   => UPDATE_RATE
  )
  port map(
    clk           => clk,
    reset         => reset,
    led_out       => led_out
  );
end arch;