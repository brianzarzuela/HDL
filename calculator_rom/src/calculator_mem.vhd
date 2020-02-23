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
use work.components.all;

entity calculator_mem is
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    execute  : in  std_logic;
    --
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
  );
end calculator_mem;

architecture arc of calculator_mem is

--------------------------------------------------------------------------------

-- execute button
signal execute_pulse : std_logic;

-- rom signals
signal address     : std_logic_vector(4 downto 0) := "00000";
signal instruction : std_logic_vector(10 downto 0) := (others => '0');
alias  input       : std_logic_vector(7 downto 0) is instruction(7  downto 0);
alias  opcode      : std_logic_vector(2 downto 0) is instruction(10 downto 8);

-- alu signals
signal result     : std_logic_vector(7 downto 0) := (others => '0');
signal mem_to_alu : std_logic_vector(7 downto 0) := (others => '0');
signal result_reg : std_logic_vector(7 downto 0) := (others => '0');

-- ram signals
signal we   : std_logic := '0';
signal addr : std_logic_vector(1 downto 0) := "00";

-- calculator signals
signal alu_op : std_logic_vector(1 downto 0) := (others => '0');
signal mr     : std_logic := '0';
signal ms     : std_logic := '0';

-- display signals
signal result_padded : std_logic_vector(11 downto 0);
signal ones_bcd     : std_logic_vector(3 downto 0);
signal tens_bcd     : std_logic_vector(3 downto 0);
signal hundreds_bcd : std_logic_vector(3 downto 0);

-- state machine declaration
type state is (read_w, read_s, write_w, write_s, write_w_no_op);
signal state_reg  : state := read_w;
signal next_state : state;

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

alu_u : alu
  port map(
    clk    => clk,
    reset  => reset,
    a      => mem_to_alu,
    b      => input,
    op     => alu_op,
    result => result
  );

--------------------------------------------------------------------------------

mem_u : memory
  generic map(
    addr_width => 2,
    data_width => 8)
  port map(
    clk   => clk,
    we    => we,
    reset => reset,
    addr  => addr,
    din   => result_reg,
    dout  => mem_to_alu
  );

--------------------------------------------------------------------------------

execute_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => execute,
    edge  => execute_pulse
  );

rom_u : calculator_rom
  port map(
    address => address,
    clock   => clk,
    q       => instruction
  );

--------------------------------------------------------------------------------

-- update rom address
process (clk, reset, execute_pulse)
begin
  if (reset = '1') then
    address <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (execute_pulse = '1') then
      address <= std_logic_vector(unsigned(address) + 1);
    end if;
  end if;
end process;

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

-- ram manager
process (state_reg)
begin
  case state_reg is
    when read_w =>
      we   <= '0';
      addr <= "00";
    when write_s =>
      we   <= '1';
      addr <= "01";
    when read_s =>
      we   <= '0';
      addr <= "01";
    when write_w_no_op =>
      we   <= '1';
      addr <= "00";
    when write_w =>
      we   <= '1';
      addr <= "00";
    when others =>
      we   <= '0';
      addr <= "00";
  end case;
end process;

--------------------------------------------------------------------------------

-- state register
process (clk, reset)
begin
  if (reset = '1') then
    state_reg <= read_w;
  elsif (clk'event and clk = '1') then
    state_reg <= next_state;
  end if;
end process;

-- result register
process (clk, reset)
begin
  if (reset = '1') then
    result_reg <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (state_reg = write_w_no_op) then
      result_reg <= result;
    elsif (state_reg = read_s) then
      result_reg <= mem_to_alu;
    end if;
  end if;
end process;

-- state led display
with state_reg select led <=
  "00001" when read_w,
  "00010" when write_w_no_op,
  "00100" when write_w,
  "01000" when write_s,
  "10000" when read_s;

--------------------------------------------------------------------------------

-- next state logic
process (state_reg, execute_pulse, mr, ms)
begin
  -- default value (prevents a latch)
  next_state <= state_reg;
  case state_reg is
    when read_w =>
      if (execute_pulse = '1') then
        if    (mr = '1') then next_state <= read_s;
        elsif (ms = '1') then next_state <= write_s;
        else                  next_state <= write_w_no_op;
        end if;
      end if;
    when read_s        => 
      if    (execute_pulse = '1') then next_state <= write_w_no_op;
      end if;
    when write_s       => next_state <= read_w;
    when write_w_no_op => next_state <= write_w;
    when write_w       => next_state <= read_w;
    when others        => next_state <= read_w;
  end case;
end process;

--------------------------------------------------------------------------------

result_padded <= "0000" & result_reg;

dd : double_dabble
  port map(
    result_padded => result_padded,
    ones          => ones_bcd,
    tens          => tens_bcd,
    hundreds      => hundreds_bcd
  );

ones_display : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => ones_bcd,
    display => ones
  );

tens_display : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => tens_bcd,
    display => tens
  );

hundreds_display : bcd_to_seven_seg
  port map(
    clk     => clk,
    input   => hundreds_bcd,
    display => hundreds
  );

--------------------------------------------------------------------------------

end arc;

