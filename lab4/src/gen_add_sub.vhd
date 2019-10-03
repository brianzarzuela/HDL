-- Brian Zarzuela
-- Generic Add Sub

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_add_sub is
  generic(
    bits : integer := 3;
  );
  port(
    a    : in std_logic_vector(bits-1 downto 0);
    b    : in std_logic_vector(bits-1 downto 0);
    flag : in std_logic;
    c    : out std_logic_vector(bits downto 0)
  );
end entity gen_add_sub;

architecture arc of gen_add_sub is

  signal add : std_logic_vector(bits downto 0);
  signal sub : std_logic_vector(bits downto 0);

begin

  add <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
  sub <= std_logic_vector(unsigned('0' & a) - unsigned('0' & b));
  
  c <= add when flag = '0' else sub;
  
end architecture arc;