--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  adder_single_bit_structural.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Strucutural implementaion of a single bit adder. This version of a single
--    bit adder uses and, or, and xor gates based on the following equations:
--    Sum = a XOR b XOR Cin
--    CarryOut = (a AND b) OR (a AND Cin) OR (b AND Cin)
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
library work;
use work.alu_pkg.all;      

entity adder_single_bit_structural is
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
end adder_single_bit_structural;  

architecture structural of adder_single_bit_structural  is

  signal sum       : std_logic;
  signal a_b       : std_logic;
  signal a_cin     : std_logic;
  signal b_cin     : std_logic;
  signal carry_out : std_logic;

begin

  xor3 : alu_xor
  generic map( n => 3 )
  port map( 
    input(0) => input(2),
    input(1) => input(1),
    input(2) => input(0),
    --
    output => sum
  );
  
  a_and_b : alu_and
  generic map( n => 2 )
  port map(
    input(0) => input(2),
    input(1) => input(1),
    --
    output => a_b
  );
  
  a_and_cin : alu_and
  generic map( n => 2 )
  port map(
    input(0) => input(2),
    input(1) => input(0),
    --
    output => a_cin
  );
  
  b_and_cin : alu_and
  generic map( n => 2 )
  port map(
    input(0) => input(1),
    input(1) => input(0),
    --
    output => b_cin
  );
  
  or3 : alu_or
  generic map( n => 3 )
  port map(
    input(0) => a_b,
    input(1) => a_cin,
    input(2) => b_cin,
    --
    output => carry_out
  );
  
  --
  output(1) <= sum;
  output(0) <= carry_out;

end structural;