library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is

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

end components;