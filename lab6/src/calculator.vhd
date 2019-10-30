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
    hundreds : out std_logic_vector(6 downto 0)
  );
end calculator;

architecture arc of calculator is

--------------------------------------------------------------------------------

-- component declarations

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

component alu
  port(
    clk           : in  std_logic;
    reset         : in  std_logic;
    a             : in  std_logic_vector(7 downto 0);
    b             : in  std_logic_vector(7 downto 0);
    op            : in  std_logic_vector(1 downto 0);
    result        : out std_logic_vector(7 downto 0)
  );
end component;

component memory
  generic(
    addr_width : integer := 2;
    data_width : integer := 4);
  port(
    clk               : in  std_logic;
    we                : in  std_logic;
    addr              : in  std_logic_vector(addr_width - 1 downto 0);
    din               : in  std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end component;

--------------------------------------------------------------------------------

-- memory signals
signal we         : std_logic;
signal addr       : std_logic_vector(1 downto 0);
signal result_reg : std_logic_vector(7 downto 0) := (others => '0');
signal mem_to_alu : std_logic_vector(7 downto 0) := (others => '0');

-- display signals
signal result_padded : std_logic_vector(11 downto 0);
signal ones_bcd      : std_logic_vector(3 downto 0);
signal tens_bcd      : std_logic_vector(3 downto 0);
signal hundreds_bcd  : std_logic_vector(3 downto 0);

-- state machine declaration
type state_type is (read_w, read_s, write_w, write_s, write_w_no_op);
signal state_reg  : state_type := read_w;
signal state_next : state_type;

--------------------------------------------------------------------------------

begin

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
    a      => input,
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
  if (reset = '1') then
    state_reg <= read_w;
  elsif (clk'event and clk = '1') then
    state_reg <= next_state;
  end if;
end process;

--------------------------------------------------------------------------------

-- next state logic
process (state_reg, ms, mr, ex)
begin
  -- default value (prevents a latch)
  state_next <= state_reg;
  case state_reg is
    when read_w =>
      if (ex = '1') then
        next_state <= write_w_no_op;
      elsif (mr = '1') then
        next_state <= read_s;
      elsif (ms = '1') then
        next_state <= write_s;
      end if;
    when read_s =>
      next_state <= write_w_no_op;
    when write_w_no_op =>
      next_state <= write_w;
    when others =>
      next_state => read_w;
  end case;
end process;

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

result_padded <= "0000" & result_reg;

--------------------------------------------------------------------------------

end arc;


