--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 7:  Simple Processor [8 bit]
--
--      FILE NAME:  components.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Calculator Package contains for:
--      - rising edge synchronizer
--      - 8 bit synchronizer
--      - double dabble
--      - bcd to seven segment display
--      - alu
--      - ram (random access memory)
--      - calculator rom instance
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is

component calculator_rom is
  port(
    address : in  std_logic_vector (4 downto 0);
    clock   : in  std_logic  := '1';
    q       : out std_logic_vector (10 downto 0)
  );
end component;

component rising_edge_synchronizer
  port(
    clk   : in std_logic;
    reset : in std_logic;
    input : in std_logic;
    edge  : out std_logic
  );
end component;

component synchronizer_8bit
  port(
    clk      :  in std_logic;
    reset    :  in std_logic;
    async_in :  in std_logic_vector(7 downto 0);
    sync_out : out std_logic_vector(7 downto 0)
  );
end component;

component double_dabble
  port(
    result_padded :  in std_logic_vector(11 downto 0);
    ones          : out std_logic_vector(3 downto 0);
    tens          : out std_logic_vector(3 downto 0);
    hundreds      : out std_logic_vector(3 downto 0)
  );
end component;

component bcd_to_seven_seg
  port(
    clk     : in  std_logic;
    input   : in  std_logic_vector(3 downto 0);
    display : out std_logic_vector(6 downto 0)
  );
end component;

component alu
  port(
    clk           : in  std_logic;
    reset         : in  std_logic;
    a             : in  std_logic_vector(7 downto 0);
    b             : in  std_logic_vector(7 downto 0);
    op            : in  std_logic_vector(1 downto 0);
    result        : out std_logic_vector(7 downto 0)
  );
end component;

component memory
  generic(
    addr_width : integer := 2;
    data_width : integer := 4);
  port(
    clk               : in  std_logic;
    we                : in  std_logic;
    reset             : in  std_logic;
    addr              : in  std_logic_vector(addr_width - 1 downto 0);
    din               : in  std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end component;

end components;