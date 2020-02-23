--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  adder_single_bit_behavioral_pkg.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Package file containing components for:
--    - adder_single_bit_behavioral
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/12/19 | B Z  | 1.0 | Initial commit.
-- |          |      |     |
--
--***************************************************************************
--***************************************************************************

library ieee;
use ieee.std_logic_1164.all;      

package adder_single_bit_behavioral_pkg is
  
  component adder_single_bit_behavioral
    port (
      -- input(2) = a
      -- input(1) = b
      -- input(0) = cin
      input     : in  std_logic_vector(2 downto 0);
      --
      -- output(1) = sum
      -- output(0) = carryout
      output    : out std_logic_vector(1 downto 0)
    );  
  end component;
  
end package;