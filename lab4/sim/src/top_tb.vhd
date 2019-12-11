--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 4:  Hardware Add and Subtract [3 bit]
--
--      FILE NAME:  top_tb.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--    3 bit add/subtract circuit
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arch of top_tb is

component top is
  port(
    a          : in  std_logic_vector(2 downto 0);
    b          : in  std_logic_vector(2 downto 0);
    clk        : in  std_logic;
    reset      : in  std_logic;
    add_btn    : in  std_logic;
    sub_btn    : in  std_logic;
    --
    a_ssd      : out std_logic_vector(6 downto 0);
    b_ssd      : out std_logic_vector(6 downto 0);
    result_ssd : out std_logic_vector(6 downto 0)
  );
end component;

constant wait_time  : time := 50 ns;
constant period     : time := 20 ns;
signal clk          : std_logic := '0';
signal reset        : std_logic := '0';

signal a            : std_logic_vector(2 downto 0) := (others => '0');
signal b            : std_logic_vector(2 downto 0) := (others => '0');
signal add_btn      : std_logic := '0';
signal sub_btn      : std_logic := '0';
signal a_ssd        : std_logic_vector(6 downto 0);
signal b_ssd        : std_logic_vector(6 downto 0);
signal result_ssd   : std_logic_vector(6 downto 0);

begin

uut: top
  port map(
    a           => a,
    b           => b,
    clk         = clk,
    reset       => reset,
    add_btn     => add_btn,
    sub_btn     => sub_btn,
    a_ssd       => a_ssd,
    b_ssd       => b_ssd,
    result_ssd  => result_ssd
  );

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '1';
    wait;
end process;

tb : process
begin
  wait for wait_time;
  for logic in 0 to 1 loop
    a <= (others => '0');
    add_btn <= not (add_btn);
    wait for wait_time;
    
    for i in 0 to 15 loop
      b <= (others => '0');
      
        for j in 0 to 15 loop
          b <= std_logic_vector(unsigned(b) + 1);
          wait for wait_time;
        end loop;
      
      a <= std_logic_vector(unsigned(a) + 1);
    end loop;
    
    sub_btn <= not (sub_btn);
  end loop;
  wait;
end process;

end arch;