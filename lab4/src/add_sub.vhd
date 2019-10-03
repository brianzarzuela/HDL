-- Brian Zarzuela
-- Lab 4

library ieee;
use ieee.std_logic_1164.all;

entity add_sub is
  port(
    -- inputs
    in_a    : in std_logic_vector(2 downto 0);
    in_b    : in std_logic_vector(2 downto 0);
    clk     : in std_logic;
    add_btn : in std_logic_vector;
    sub_btn : in std_logic_vector;
    -- outputs
    a_ssd      : out std_logic_vector(7 downto 0);
    b_ssd      : out std_logic_vector(7 downto 0);
    result_ssd : out std_logic_vector(7 downto 0);
  );
end entity add_sub;

architecture arc of add_sub is

  signal add_en : std_logic;
  signal sub_en : std_logic;
  
  signal a_sync : std_logic_vector(2 downto 0) := (others => '0');
  signal b_sync : std_logic_vector(2 downto 0) := (others => '0');
  
  signal a_sync_bcd : std_logic_vector(3 downto 0);
  signal b_sync_bcd : std_logic_vector(3 downto 0);
  
  signal result      : std_logic_vector(3 downto 0);
  signal result_sync : std_logic_vector(3 downto 0);
  
begin
  
  synchronizer : process(reset, clk, in_a, in_b)
  begin
    if reset = '1' then
      a_sync <= (others => '0');
      b_sync <= (others => '0');
    elsif rising_edge(clk) then
      a_sync <= in_a;
      b_sync <= in_b;
    end if;
  end process;
  
  a_sync_bcd <= '0' & a_sync;
  b_sync_bcd <= '0' & b_sync;
  
end architecture arc;