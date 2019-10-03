--***************************  VHDL Source Code******************************
--*********  Copyright 2018, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Dr. Kaputa
--
--       LAB NAME:  Lab 0
--
--      FILE NAME:  blink.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This is a generic module of a counter that counts up to the value specified
--    by the generic constant.  When it reaches the max count, it resets the 
--    counter to 0 and inverts the output signal.
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/01/18 | JWC  | 2.0 | separated processes so each only has one output
-- |          |      |     | made reset active low to match board 
-- |          |      |     |
--
--***************************************************************************
--***************************************************************************

library ieee;
use ieee.std_logic_1164.all;      

entity blink is
  generic (
    max_count       : integer := 25000000
  );
  port (
    clk             : in  std_logic; 
    reset_n         : in  std_logic;
    output          : out std_logic
  );  
end blink;  

architecture behavioral of blink  is

signal count_sig    : integer range 0 to max_count := 0;
signal output_sig   : std_logic;

begin
counter: process(clk,reset_n)
  begin
    if (reset_n = '0') then 
      count_sig <= 0;
    elsif (clk'event and clk = '1') then
      if (count_sig = max_count) then
        count_sig <= 0;
      else
        count_sig <= count_sig + 1;
      end if; 
    end if;
  end process;
  
  process(clk,reset_n)
  begin
    if (reset_n = '0') then 
      output_sig <= '0';
    elsif (clk'event and clk = '1') then
      if (count_sig = max_count) then
        output_sig <= not output_sig;
      end if; 
    end if;
  end process;
  
  output <= output_sig;
end behavioral;