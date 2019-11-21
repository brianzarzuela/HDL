--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 3:  Seven Segment Display Counter
--
--      FILE NAME:  components.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Seven segment display counter package containing components for:
--    - generic adder
--    - generic counter
--    - bcd to seven segment display
--
--***************************************************************************
--***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is

-------------------------------------------------------------------------------

component generic_adder_beh
  generic(
    bits    : integer := 4);
  port(
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    cin     : in  std_logic;
    sum     : out std_logic_vector(bits-1 downto 0);
    cout    : out std_logic
  );
end component;

component generic_counter
  generic(
    max_count : integer := 3);
  port(
    clk       : in  std_logic; 
    reset     : in  std_logic;
    output    : out std_logic
  );
end component;

component bcd_to_seven_seg
  port(
    clk     : in  std_logic;
    input   : in  std_logic_vector(3 downto 0);
    display : out std_logic_vector(6 downto 0)
  );
end component;

-------------------------------------------------------------------------------

end components;

