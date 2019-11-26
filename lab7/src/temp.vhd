--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 7:  Simple Processor [8 bit]
--
--      FILE NAME:  calculator_mem.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_mem is
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    enable   : in  std_logic;
    --
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
  );
end calculator_mem;

architecture arc of calculator_mem is

--------------------------------------------------------------------------------

component calculator_rom is
  port(
    address : in  std_logic_vector (4 downto 0);
    clock   : in  std_logic  := '1';
    q       : out std_logic_vector (10 downto 0)
  );
end component;

component calculator is
  port(
    input    : in  std_logic_vector(7 downto 0);
    opcode   : in  std_logic_vector(1 downto 0);
    clk      : in  std_logic;
    execute  : in  std_logic;
    ms       : in  std_logic;
    mr       : in  std_logic;
    reset    : in  std_logic;
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
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

--------------------------------------------------------------------------------

-- enable (execute) button
signal enable_pulse : std_logic;

-- memory signals
signal address     : std_logic_vector(4 downto 0) := "00000";
signal instruction : std_logic_vector(10 downto 0);
alias  input       : std_logic_vector(7 downto 0) is instruction(7  downto 0);
alias  opcode      : std_logic_vector(2 downto 0) is instruction(10 downto 8);

-- calculator signals
signal alu_op : std_logic_vector(1 downto 0) := (others => '0');
signal mr     : std_logic := '0';
signal ms     : std_logic := '0';

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

enable_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => enable,
    edge  => enable_pulse
  );

rom_u : calculator_rom
  port map(
    address => address,
    clock   => clk,
    q       => instruction
  );

calculator_u : calculator
  port map(
    input    => input,
    opcode   => alu_op,
    clk      => clk,
    execute  => enable,
    ms       => ms,
    mr       => mr,
    reset    => reset,
    ones     => ones,
    tens     => tens,
    hundreds => hundreds,
    led      => led
  );

--------------------------------------------------------------------------------

-- update address
process (clk, reset, enable_pulse)
begin
  if (reset = '1') then
    address <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (enable_pulse = '1') then
      address <= std_logic_vector(unsigned(address) + 1);
    end if;
  end if;
end process;

--------------------------------------------------------------------------------

-- instruction operation to alu operation
process (opcode)
begin
  case opcode is
    when "000" =>
      alu_op <= "00";
      ms     <= '0';
      mr     <= '0';
    when "001" =>
      alu_op <= "01";
      ms     <= '0';
      mr     <= '0';
    when "010" =>
      alu_op <= "10";
      ms     <= '0';
      mr     <= '0';
    when "011" =>
      alu_op <= "11";
      ms     <= '0';
      mr     <= '0';
    when "100" =>
      alu_op <= "00";
      ms     <= '1';
      mr     <= '0';
    when "101" =>
      alu_op <= "00";
      ms     <= '0';
      mr     <= '1';
    when others =>
      alu_op <= "00";
      ms     <= '0';
      mr     <= '0';
  end case;
end process;

--------------------------------------------------------------------------------

end arc;

