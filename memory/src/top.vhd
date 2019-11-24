--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--        PROJECT: Memory Implementation
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
    hundreds : out std_logic_vector(6 downto 0)
  );
end top;

architecture implementation of top is

-------------------------------------------------------------------------------

signal temp : std_logic_vector(7 downto 0) := "00001010";

-------------------------------------------------------------------------------

mem_u : memory
  generic map(
    addr_width => 2,
    data_width => 8)
  port map(
    clk  => clk,
    we   => we,
    addr => addr,
    din  => result_reg,
    dout => mem_to_alu
  );

-------------------------------------------------------------------------------

end implementation;



