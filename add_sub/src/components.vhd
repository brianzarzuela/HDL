--***************************  VHDL Source Code******************************
--*********  Copyright 2019, Rochester Institute of Technology***************
--***************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 4:  Hardware Add and Subtract [3 bit]
--
--      FILE NAME:  components.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Seven segment display counter package containing components for:
--    - bcd to seven segment display
--
--***************************************************************************
--***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is

-------------------------------------------------------------------------------

component bcd_to_seven_seg
  port(
    clk     : in  std_logic;
    input   : in  std_logic_vector(3 downto 0);
    display : out std_logic_vector(6 downto 0)
  );
end component;

component gen_synchronizer
  generic(
    bits     : integer);
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    async_in : in  std_logic_vector(bits-1 downto 0);
    sync_out : out std_logic_vector(bits-1 downto 0)
  );
end component;

component rising_edge_synchronizer
  port(
    clk   : in  std_logic;
    reset : in  std_logic;
    input : in  std_logic;
    edge  : out std_logic
  );
end component;

component gen_add_sub
  generic(
    bits : integer);
  port(
    a    : in std_logic_vector(bits-1 downto 0);
    b    : in std_logic_vector(bits-1 downto 0);
    flag : in std_logic;
    c    : out std_logic_vector(bits downto 0)
  );
end component;

-------------------------------------------------------------------------------

end components;