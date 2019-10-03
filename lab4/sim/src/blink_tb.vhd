--  DESIGNER NAME:  Dr. Kaputa
--
--       LAB NAME:  Lab 0
--
--      FILE NAME:  blink_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This is a test bench to simulate the blink.vhd module.  It instantiates the
--    the module with a constant of 4. As such, the output signal will invert
--    every 4 clock cycles.
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/01/18 | JWC  | 2.0 | Edited the component ports
-- |          |      |     |
--
--***************************************************************************
--***************************************************************************
library ieee;
use ieee.std_logic_1164.all;

entity blink_tb is
end blink_tb;

architecture arch of blink_tb is

component blink is
  generic (
    max_count       : integer := 25000000
  );
  port (
    clk               : in  std_logic; 
    reset_n           : in  std_logic;
    output            : out std_logic
  );  
end component;  

signal output_tb       : std_logic;
constant period     : time := 20ns;                                              
signal clk_tb          : std_logic := '0';
signal reset_n_tb      : std_logic := '0';

begin

-- clock process
clock: process
  begin
    clk_tb <= not clk_tb;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset_n_tb <= '1';
    wait;
end process; 

uut: blink  
  generic map (
    max_count => 4
  )
  port map(
    clk       => clk_tb,
    reset_n     => reset_n_tb,
    output    => output_tb
  );
end arch;