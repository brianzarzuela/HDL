--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--       LAB NAME:  Lab 1
--
--      FILE NAME:  alu_or.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Generic n-bit or gate for alu implementation.
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

entity alu_or is
  generic (
    n : positive := 2
  );
  port (
    input       : in  std_logic_vector(n-1 downto 0);
    --
    output      : out std_logic
  );  
end alu_or;  

architecture structural of alu_or  is
begin
  
  or_proc : process (input)
  
    variable temp : std_logic;
  
  begin
    
    temp := '0';
    
    or_loop : for i in 0 to (n-1) loop
      temp := temp or input(i);
    end loop;
    
    output <= temp;
    
  end process;

end structural;