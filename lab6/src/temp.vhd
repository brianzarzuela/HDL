--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 6:  Calculator [8 bit]
--
--      FILE NAME:  add_sub_state_machine.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    8-bit calculator with basic add, subtract, multiply and divide operations.
--    Encorporates MS and MR buttons to save the present result into memory and
--    to retrueve values from memory, respectively.
--    4x8 bit memory diagram :
--     _________________________
--    | addr | reg description  |
--    |------+------------------|
--    |  00  | working register |
--    |------+------------------|
--    |  01  | save register    |
--    |------+------------------|
--    |  10  | not in use       |
--    |------+------------------|
--    |  11  | not in use       |
--    +-------------------------+
--
--    ALU operation codes :
--     ____________________
--    | opcode | operation |
--    |--------+-----------|
--    |   00   | add       |
--    |--------+-----------|
--    |   01   | subtract  |
--    |--------+-----------|
--    |   10   | multiply  |
--    |--------+-----------|
--    |   11   | divide    |
--    +--------------------+
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity calculator is
  port(
    input    : in  std_logic_vector(7 downto 0);
    opcode   : in  std_logic_vector(1 downto 0);
    clk      : in  std_logic;
    execute  : in  std_logic;
    ms       : in  std_logic;
    mr       : in  std_logic;
    reset    : in  std_logic;
    --
    ones     : out std_logic_vector(6 downto 0);
    tens     : out std_logic_vector(6 downto 0);
    hundreds : out std_logic_vector(6 downto 0);
    led      : out std_logic_vector(4 downto 0)
  );
end calculator;

architecture arc of calculator is

--------------------------------------------------------------------------------

-- synchronized signals
signal input_sync : std_logic_vector(7 downto 0);
signal execute_pulse : std_logic;
signal ms_pulse      : std_logic;
signal mr_pulse      : std_logic;

-- memory signals
signal we         : std_logic;
signal addr       : std_logic_vector(1 downto 0);
signal result_reg : std_logic_vector(7 downto 0) := (others => '0');
signal mem_to_alu : std_logic_vector(7 downto 0) := (others => '0');
signal result     : std_logic_vector(7 downto 0);

-- display signals
signal result_padded : std_logic_vector(11 downto 0);
signal ones_bcd      : std_logic_vector(3 downto 0);
signal tens_bcd      : std_logic_vector(3 downto 0);
signal hundreds_bcd  : std_logic_vector(3 downto 0);

-- state machine declaration
type state_type is (read_w, read_s, write_w, write_s, write_w_no_op);
signal state_reg  : state_type := read_w;
signal next_state : state_type;

--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------

execute_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => execute,
    edge  => execute_pulse
  );

ms_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => ms,
    edge  => ms_pulse
  );

mr_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => mr,
    edge  => mr_pulse
  );

--------------------------------------------------------------------------------

sync_u : synchronizer_8bit
  port map(
    input    => input,
    clk      => clk,
    reset    => reset,
    sync_out => input_sync
  );

--------------------------------------------------------------------------------

mem_u : memory
  generic map(
    addr_width => 2,
    data_width => 8)
  port map(
    clk  => clk,
    we   => we,
    addr => addr,
    din  => result_reg,
    dout => mem_to_alu
  );

--------------------------------------------------------------------------------

alu_u : alu
  port map(
    clk    => clk,
    reset  => reset,
    a      => input_sync,
    b      => mem_to_alu,
    op     => opcode,
    result => result
  );

--------------------------------------------------------------------------------

double_dabble_u : double_dabble
  port map(
    result_padded => result_padded,
    ones          => ones_bcd,
    tens          => tens_bcd,
    hundreds      => hundreds_bcd
  );

--------------------------------------------------------------------------------

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

-- state register
process (clk, reset)
begin
  if (reset = '0') then
    state_reg <= read_w;
  elsif (clk'event and clk = '1') then
    state_reg <= next_state;
  end if;
end process;

--------------------------------------------------------------------------------

-- next state logic
process (state_reg, ms_pulse, mr_pulse, execute_pulse)
begin
  -- default value (prevents a latch)
  next_state <= state_reg;
  case state_reg is
    when read_w =>
      if    (execute_pulse = '1') then next_state <= write_w_no_op;
      elsif (mr_pulse = '1')      then next_state <= read_s;
      elsif (ms_pulse = '1')      then next_state <= write_s;
      end if;
    when read_s =>
      next_state <= write_w_no_op;
    when write_w_no_op =>
      next_state <= write_w;
    when others =>
      next_state <= read_w;
  end case;
end process;

--------------------------------------------------------------------------------

-- result register
process (clk, reset)
begin
  if (reset = '0') then
    result_reg <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (state_reg = write_w_no_op) then
      result_reg <= result;
    elsif (state_reg = read_s) then
      result_reg <= mem_to_alu;
    end if;
  end if;
end process;

--------------------------------------------------------------------------------

result_padded <= "0000" & result_reg;

--------------------------------------------------------------------------------

-- state led
process (state_reg)
begin
  case state_reg is
    when read_w        => led <= "00001";
    when read_s        => led <= "00010";
    when write_s       => led <= "00100";
    when write_w       => led <= "01000";
    when write_w_no_op => led <= "10000";
    when others        => led <= "00000";
  end case;
end process;

--------------------------------------------------------------------------------

end arc;


