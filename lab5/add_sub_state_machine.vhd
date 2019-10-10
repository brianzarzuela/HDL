-- Brian Zarzuela
-- Lab 5

entity add_sub_state_machine is
  port ( sw : in std_logic_vector(7 downto 0);
         clk : in std_logic;
         reset : in std_logic);
end add_sub_state_machine;

architecture arc of add_sub_state_machine is

begin

-- state register
process (clk, reset)

end architecture arc;