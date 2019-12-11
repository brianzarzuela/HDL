--******************************  VHDL Source Code  ******************************
--*************  Copyright 2019, Rochester Institute of Technology  **************
--********************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 9:  Simple Audio Processor [2 Channel Mixer]
--
--      FILE NAME:  channel.vhd
--
----------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Channel instance for an embedded VHDL based audio processor that can process
--    10 bit instruction sets.
--
--********************************************************************************
--********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity channel is
  generic(
    ch_index      : integer := 0
  );
  port(
    clk           : in     std_logic;
    reset         : in     std_logic;
    sync          : in     std_logic;
    instruction   : in     std_logic_vector(9 downto 0);
    state_reg     : in     std_logic_vector(4 downto 0);
    data_address  : buffer std_logic_vector(14 downto 0)
  );
end channel;

architecture imp of channel is

----------------------------------------------------------------------------------

-- state machine states
constant idle                   : std_logic_vector(4 downto 0) := "00001";
constant fetch                  : std_logic_vector(4 downto 0) := "00010";
constant decode                 : std_logic_vector(4 downto 0) := "00100";
constant execute                : std_logic_vector(4 downto 0) := "01000";
constant decode_error           : std_logic_vector(4 downto 0) := "10000";

-- instruction signals
alias opcode               : std_logic_vector(1 downto 0) is instruction(9 downto 8);
alias ch                   : std_logic_vector(1 downto 0) is instruction(7 downto 6);
alias repeat               : std_logic                    is instruction(5);
alias seek_address         : std_logic_vector(4 downto 0) is instruction(4 downto 0);

-- data address signals
signal data_address_play   : std_logic_vector(14 downto 0);
signal data_address_repeat : std_logic_vector(14 downto 0);
signal data_address_pause  : std_logic_vector(14 downto 0);
signal data_address_seek   : std_logic_vector(14 downto 0);
signal data_address_stop   : std_logic_vector(14 downto 0);
signal data_address_reg    : std_logic_vector(14 downto 0);

-- operation codes
constant play                   : std_logic_vector(1 downto 0) := "00";
constant pause                  : std_logic_vector(1 downto 0) := "01";
constant seek                   : std_logic_vector(1 downto 0) := "10";
constant stop                   : std_logic_vector(1 downto 0) := "11";

----------------------------------------------------------------------------------

begin

----------------------------------------------------------------------------------

-- execution unit
data_address_play <=
  (others => '1') when data_address_reg = "11111111111111" else
  std_logic_vector(unsigned(data_address_reg) + 1);

data_address_repeat <=
  (others => '0') when data_address_reg = "11111111111111"
  else std_logic_vector(unsigned(data_address_reg) + 1);

data_address_pause       <= data_address_reg;
data_address_seek        <= seek_address & "000000000";
data_address_stop        <= (others => '0');

-- data address routing multiplexer
process (reset, opcode, repeat, ch)
begin
  if (reset = '1') then
    data_address_reg  <= (others => '0');
  else
    -- pause and stop regardless of current channel selection
    if (opcode = pause) then
      data_address_reg  <= data_address_pause;
    elsif (opcode = stop) then
      data_address_reg  <= data_address_stop;
    -- play, repeat, seek only if current channel is selected
    elsif (ch(ch_index) = '1') then
      if (opcode = play) then
        if (repeat = '1') then
          data_address_reg  <= data_address_repeat;
        else
          data_address_reg  <= data_address_play;
        end if;
      elsif (opcode = seek) then
        data_address_reg  <= data_address_seek;
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------

-- data address register
process (clk, reset)
begin
  if (reset = '1') then
    data_address <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (state_reg = execute) then
      if (sync = '1') then
        data_address <= data_address_reg;
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------

end imp;