--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 6:  Calculator [8 bit]
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Top-level implementation of 8-bit calculator.
--    Includes basic add, subtract, multiply and divide operations.
--    Encorporates MS and MR buttons to save the present result into memory and
--    to retrueve values from memory, respectively.
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
    switch   : in  std_logic_vector(7 downto 0);
    opcode   : in  std_logic_vector(1 downto 0);
    clk      : in  std_logic;
    execute  : in  std_logic;
    ms       : in  std_logic;
    mr       : in  std_logic;
    reset    : in  std_logic;
    --
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
  );
end top;

architecture implementation of top is

signal reset_n : std_logic;

component calculator
  port(
    input    : in  std_logic_vector(7 downto 0);
    opcode   : in  std_logic_vector(1 downto 0);
    clk      : in  std_logic;
    execute  : in  std_logic;
    ms       : in  std_logic;
    mr       : in  std_logic;
    reset    : in  std_logic;
    --
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
  );
end component;

begin

reset_n <= not reset;

calculator_u : calculator
  port map(
    input    => switch,
    opcode   => opcode,
    clk      => clk,
    execute  => execute,
    ms       => ms,
    mr       => mr,
    reset    => reset_n,
    ones     => ones,
    tens     => tens,
    hundreds => hundreds,
    led      => led
  );

end implementation;



