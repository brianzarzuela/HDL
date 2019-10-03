--  DESIGNER NAME:  Dr. Kaputa
--
--       LAB NAME:  Lab 0
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This is a to level vhd file that instantiates the blink module with a 
--    constant 50,000,000 thus causing it to blink every 1 second.
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/01/18 | JWC  | 2.0 | added comments
-- |          |      |     |
--
--***************************************************************************
--***************************************************************************
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    CLOCK_50             : in  std_logic; 
    KEY                  : in  std_logic_vector(3 downto 0);
    LEDR                 : out std_logic_vector(9 downto 0)
  );
end top;

architecture structural of top is

signal clk, reset_n, output : std_logic;

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

begin

clk <= CLOCK_50;
reset_n <= KEY(0);
LEDR(0) <= output;


uut: blink  
  generic map (
    max_count => 50000000
  )
  port map(
    clk       => clk,
    reset_n     => reset_n,
    output    => output
  );
end structural;