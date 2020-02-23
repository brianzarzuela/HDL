--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  alu_pkg.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    ALU Package file containing components for:
--    - alu_or
--    - alu_and
--    - alu_xor
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

package alu_pkg is
  
  component alu_or
    generic (
      n : positive := 2
    );
    port (
      input       : in  std_logic_vector(n-1 downto 0);
      --
      output      : out std_logic
    );
  end component;
  
  component alu_and
    generic (
      n : positive := 2
    );
    port (
      input       : in  std_logic_vector(n-1 downto 0);
      --
      output      : out std_logic
    );
  end component;
  
  component alu_xor
    generic (
      n : positive := 2
    );
    port (
      input       : in  std_logic_vector(n-1 downto 0);
      --
      output      : out std_logic
    );
  end component;
  
end package;