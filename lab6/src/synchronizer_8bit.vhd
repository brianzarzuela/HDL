--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 6:  Calculator [8 bit]
--
--      FILE NAME:  synchronizer_8bit.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    8-bit signal synchronizer
--
--******************************************************************************
--******************************************************************************
library ieee;
use ieee.std_logic_1164.all;      

entity synchronizer_8bit is 
  port (
    input    :  in std_logic_vector(7 downto 0);
    clk      :  in std_logic;
    reset    :  in std_logic;
    sync_out : out std_logic_vector(7 downto 0)
  );
end synchronizer_8bit;

architecture arc of synchronizer_8bit is

-- signal declarations
signal flop1     : std_logic_vector(7 downto 0);
signal flop2     : std_logic_vector(7 downto 0);

begin 

--------------------------------------------------------------------------------

process(reset, clk, async_in)
  begin
    if reset = '0' then
      flop1 <= "00000000";
      flop2 <= "00000000";
    elsif rising_edge(clk) then
      flop1 <= input;
      flop2 <= flop1;
    end if;
end process;

--------------------------------------------------------------------------------

sync_out <= flop2;

end arc; 