--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 3:  Seven Segment Display Counter
--
--      FILE NAME:  top_tb.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Seven segment dipslay counter that counts from 0 through 9 repeating.
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
  port(
    clk     : in  std_logic;
    reset   : in  std_logic;
    display : out std_logic_vector(6 downto 0)
  );
end component;

signal display      : std_logic_vector(6 downto 0);
constant period     : time := 10 ns;
signal clk          : std_logic := '0';
signal reset        : std_logic := '0';

begin

uut: top
  port map(
    clk     => clk,
    reset   => reset,
    display => display
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

end arch;