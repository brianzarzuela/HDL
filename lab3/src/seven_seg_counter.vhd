--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 3:  Seven Segment Display Counter
--
--      FILE NAME:  seven_seg_counter.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_counter is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    display : out std_logic_vector(6 downto 0)
  );
end seven_seg_counter;

architecture arc of seven_seg_counter is

component generic_adder_beh
  generic (
    bits    : integer := 4
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    cin     : in  std_logic;
    sum     : out std_logic_vector(bits-1 downto 0);
    cout    : out std_logic
  );
end component;

component generic_counter
  generic (
    max_count       : integer := 3
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    output          : out std_logic
  );  
end component;

component bcd_to_seven_seg
  port (
    clk     : in  std_logic;
    input   : in  std_logic_vector(3 downto 0);
    display : out std_logic_vector(6 downto 0)
  );
end component;

--------------------------------------------------------------------------------

variable bcd  : UNSIGNED (15 downto 0) := (others => '0');
signal sum    : std_logic_vector(3 downto 0);
signal enable : std_logic;

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

u1 : generic_adder
  generic map ( bits => 4 );
  port map    ( a    => bcd,
                b    => "0000",
                cin  => '0',
                sum  => sum,
                cout => open );

u2 : generic_counter
  generic map ( max_count => 5 )
  port map    ( clk       => clk,
                reset     => reset,
                output    => enable );

u3 : bcd_to_seven_seg
  port ( clk     => clk,
         input   => bcd,
         display => display );
                
--------------------------------------------------------------------------------

-- sum register
process (clk, enable, reset)
  begin
    -- default value (prevents a latch)
  bcd := (others => '0');
  
  if (reset = '1') then
    display <= (others => '1');
  elsif (clk'event and clk = '1') then
    if (enable = '1') then
        bcd := sum;
    end if;
  end if;

end process;

--------------------------------------------------------------------------------

end arc;