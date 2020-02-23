--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 4:  Hardware Add and Subtract [3 bit]
--
--      FILE NAME:  top.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--    3 bit add/subtract circuit that displays both the first and second inputs
--    and the result on seven segment displays. The result will be of addition
--    when the add button is pressed and subtraction when the subtract button is
--    pressed. Operates with unsigned based 16 numbers so that:
--    1 + 2 = 3 and 1 - 2 = F
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity top is
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
end entity top;

architecture implementation of top is

signal add_en : std_logic;
signal sub_en : std_logic;
signal flag   : std_logic := '0';

signal a_sync : std_logic_vector(2 downto 0);
signal b_sync : std_logic_vector(2 downto 0);

signal a_sync_bcd : std_logic_vector(3 downto 0);
signal b_sync_bcd : std_logic_vector(3 downto 0);

signal result      : std_logic_vector(3 downto 0) := (others => '0');

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

a_sync_u : gen_synchronizer
  generic map(
    bits     => 3)
  port map(
    clk      => clk,
    reset    => reset,
    async_in => a,
    sync_out => a_sync
  );

b_sync_u : gen_synchronizer
  generic map(
    bits     => 3)
  port map(
    clk      => clk,
    reset    => reset,
    async_in => b,
    sync_out => b_sync
  );

--------------------------------------------------------------------------------

add_sync : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => add_btn,
    edge  => add_en
  );

sub_sync : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => sub_btn,
    edge  => sub_en
  );

--------------------------------------------------------------------------------

addsub_u : gen_add_sub
  generic map(
    bits => 3)
  port map(
    a    => a_sync,
    b    => b_sync,
    flag => flag,
    c    => result
  );

--------------------------------------------------------------------------------

a_sync_bcd <= std_logic_vector(unsigned('0' & a_sync));
b_sync_bcd <= std_logic_vector(unsigned('0' & b_sync));

--------------------------------------------------------------------------------

a_display_u : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => a_sync_bcd,
    display => a_ssd
  );

b_display_u : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => b_sync_bcd,
    display => b_ssd
  );

result_display_u : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => result,
    display => result_ssd
  );

--------------------------------------------------------------------------------

-- flag register
process(clk, reset, add_en, sub_en)
begin
  if (reset = '0') then
    flag <= '0';
  elsif (clk'event and clk = '1') then
    if (add_en = '1') then
      flag <= '0';
    elsif (sub_en = '1') then
      flag <= '1';
    end if;
  end if;
end process;

--------------------------------------------------------------------------------

end architecture implementation;
