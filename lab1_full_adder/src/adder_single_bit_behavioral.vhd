--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  adder_single_bit_behavioral.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Behavioural implementaion of a single bit adder. This version of a single
--    bit adder focuses on the direct relationship between the inputs and the
--    outputs based on the following equations:
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

entity adder_single_bit_behavioral is
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
end adder_single_bit_behavioral;  

architecture behavioral of adder_single_bit_behavioral  is
begin
  
  sum : process (input)
  begin
    -- solve for sum
    case input is
      when "001" | "010" | "100" | "111" => output(1) <= '1';
      when others => output(1) <= '0';
    end case;
  end process;
  
  carryout : process (input)
  begin
    -- solve for carryout
    case input is
      when "110" | "011" | "101" | "111" => output(0) <= '1';
      when others => output(0) <= '0';
    end case;
  end process;
  
end behavioral;