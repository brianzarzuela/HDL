--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  adder_single_bit_behavioral_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This is a test bench to simulate the adder_single_bit_behavioral.vhd module.
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
use ieee.std_logic_unsigned.all;
library work;
use work.adder_single_bit_behavioral_pkg.all;

entity adder_single_bit_behavioral_tb is
end adder_single_bit_behavioral_tb;

architecture tb of adder_single_bit_behavioral_tb is

signal input_tb       : std_logic_vector(2 downto 0);
signal output_tb      : std_logic_vector(1 downto 0);

-- clock period
constant period     : time := 20ns; 

begin

  uut: adder_single_bit_behavioral  
    port map(
      input => input_tb,
      --
      output => output_tb
    );

    input_tb <= "111" after 20 ns, "000" after 40 ns, "100" after 60 ns;

--  input_tb <= "000";

  -- for i in 0 to 15 loop
    -- input_tb <= input_tb + 1;
    -- wait for 20 ns;
  -- end loop;
  
end tb;