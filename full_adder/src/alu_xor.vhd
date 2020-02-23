--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  alu_xor.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Generic n-bit xor gate for alu implementation.
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

entity alu_xor is
  generic (
    n : positive := 2
  );
  port (
    input       : in  std_logic_vector(n-1 downto 0);
    --
    output      : out std_logic
  );  
end alu_xor;  

architecture structural of alu_xor  is
begin
  
  xor_proc : process (input)
  
    variable temp : std_logic;
  
  begin
    
    temp := input(0);
    
    if (n > 1)
      xor_loop : for i in 1 to (n-1) loop
        temp := temp xor input(i);
      end loop;
    end if;
    output <= temp;
    
  end process;

end structural;