--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 4:  Hardware Add and Subtract [3 bit]
--
--      FILE NAME:  add_sub.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity add_sub is
  port(
    a          : in  std_logic_vector(2 downto 0);
    b          : in  std_logic_vector(2 downto 0);
    clk        : in  std_logic;
    reset      : in  std_logic;
    add_btn    : in  std_logic_vector;
    sub_btn    : in  std_logic_vector;
    --
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

--------------------------------------------------------------------------------

component bcd_to_seven_seg
  port (clk     : in  std_logic;
        input   : in  std_logic_vector(3 downto 0);
        display : out std_logic_vector(6 downto 0));
end component;

component synchronizer_3bit
  port (clk      : in  std_logic;
        reset    : in  std_logic;
        async_in : in  std_logic_vector(2 downto 0);
        sync_out : out std_logic_vector(2 downto 0));
end component;

component rising_edge_synchronizer
  port (clk   : in  std_logic;
        reset : in  std_logic;
        input : in  std_logic;
        edge  : out std_logic);
end component;

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

synchronizer_3bit port map
  (clk => clk, reset => reset, async_in => a, sync_out => a_sync);
synchronizer_3bit port map
  (clk => clk, reset => reset, async_in => b, sync_out => b_sync);
synchronizer_3bit port map
  (clk => clk, reset => reset, async_in => result, sync_out => result_sync);

--------------------------------------------------------------------------------

a_sync_bcd <= '0' & a_sync;
b_sync_bcd <= '0' & b_sync;

--------------------------------------------------------------------------------

bcd_to_seven_seg port map (clk => clk, input => a_sync_bcd, display => a_ssd);
bcd_to_seven_seg port map (clk => clk, input => b_sync_bcd, display => a_ssd);
bcd_to_seven_seg port map (clk => clk, input => result_sync, display => result_ssd);

--------------------------------------------------------------------------------

rising_edge_synchronizer port map (clk => clk, reset => reset,

--------------------------------------------------------------------------------

end architecture arc;
