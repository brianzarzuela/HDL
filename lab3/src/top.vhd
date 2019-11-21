--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 3:  Seven Segment Display Counter
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Top-level implementation of a seven segment display counter.
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity top is
  port(
    clk     : in  std_logic;
    reset   : in  std_logic;
    display : out std_logic_vector(6 downto 0)
  );
end top;

architecture implementation of top is

--------------------------------------------------------------------------------

-- signal declaration
signal sum     : std_logic_vector(3 downto 0);
signal sum_sig : std_logic_vector(3 downto 0) := (others => '1');
signal enable  : std_logic;

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

adder_u : generic_adder_beh
  generic map(
    bits => 4)
  port map(
    a    => sum_sig,
    b    => "0001",
    cin  => '0',
    sum  => sum,
    cout => open
  );

counter_u : generic_counter
  generic map(
    max_count => 50000000)
  port map(
    clk    => clk,
    reset  => reset,
    output => enable
  );

display_u : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => sum_sig,
    display => display
  );

--------------------------------------------------------------------------------

-- sum register
process (clk, reset, enable, sum)
begin
  if (reset = '0') then
    sum_sig <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (enable = '1') then
      if (sum = "1010") then
        sum_sig <= (others => '0');
      else
        sum_sig <= sum;
      end if;
    end if;
  end if;
end process;

--------------------------------------------------------------------------------

end implementation;

