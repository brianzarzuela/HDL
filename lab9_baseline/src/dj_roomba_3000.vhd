--******************************  VHDL Source Code  ******************************
--*************  Copyright 2019, Rochester Institute of Technology  **************
--********************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 9:  Simple Audio Processor [2 Channel Mixer]
--
--      FILE NAME:  dj_roomba_3000.vhd
--
----------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Embedded VHDL based audio processor that can process 10 bit instruction sets
--
--  NOTE
--    This is the modified version of previous dj_roomba_3000 created for Lab 8
--    Allows for the playback and mixing up of up to two audio files
--
--    Bits 9 and 8 are the operation codes:
--      00 : Play
--      01 : Pause
--      10 : Seek
--      11 : Stop
--    Bits 7 and 6 are the channel selection:
--      00 : don't play channel 1 & don't play channel 0
--      01 : don't play channel 1 &       play channel 0
--      10 :       play channel 1 & don't play channel 0
--      11 :       play channel 1 &       play channel 0
--    Bit 5 is the repeat bit
--      0  : don't repeat
--      1  : repeat
--    Bits 4 through 0 are the seek address which is prepended to trailing zeros
--    to arrive at a 15 bit memory address.
--
--********************************************************************************
--********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------------------------------------------------------

-- Provided entity declaration...DO NOT CHANGE
entity dj_roomba_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(9 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end dj_roomba_3000;

----------------------------------------------------------------------------------

architecture beh of dj_roomba_3000 is

----------------------------------------------------------------------------------

-- execute edge
signal   edge                   : std_logic;

-- operation codes
constant play                   : std_logic_vector(1 downto 0) := "00";
constant pause                  : std_logic_vector(1 downto 0) := "01";
constant seek                   : std_logic_vector(1 downto 0) := "10";
constant stop                   : std_logic_vector(1 downto 0) := "11";

-- state machine signals
signal state_reg                : std_logic_vector(4 downto 0);
signal state_next               : std_logic_vector(4 downto 0);

-- state machine states
constant idle                   : std_logic_vector(4 downto 0) := "00001";
constant fetch                  : std_logic_vector(4 downto 0) := "00010";
constant decode                 : std_logic_vector(4 downto 0) := "00100";
constant execute                : std_logic_vector(4 downto 0) := "01000";
constant decode_error           : std_logic_vector(4 downto 0) := "10000";

-- channel state machine states
constant ch_idle                : std_logic_vector(4 downto 0) := "00001";
constant ch0_da                 : std_logic_vector(4 downto 0) := "00010";
constant ch0_audio              : std_logic_vector(4 downto 0) := "00100";
constant ch1_da                 : std_logic_vector(4 downto 0) := "01000";
constant ch1_audio              : std_logic_vector(4 downto 0) := "10000";

-- program counter (instruction memory address)
signal pc                       : std_logic_vector(4 downto 0);

-- instruction signal
signal instruction              : std_logic_vector(9 downto 0);
alias  opcode                   : std_logic_vector(1 downto 0) is instruction(9 downto 8);
alias  ch1                      : std_logic                    is instruction(7);
alias  ch0                      : std_logic                    is instruction(6);
alias  repeat                   : std_logic                    is instruction(5);
alias  seek_address             : std_logic_vector(4 downto 0) is instruction(4 downto 0);

-- data address signals
signal data_address             : std_logic_vector(15 downto 0);
signal data_address_reg         : std_logic_vector(13 downto 0);

----------------------------------------------------------------------------------

-- data memory
component rom_data
  port(
    address  : in std_logic_vector (15 DOWNTO 0);
    clock    : in std_logic  := '1';
    q        : out std_logic_vector (15 DOWNTO 0)
  );
end component;

-- instruction memory
component rom_instructions
  port(
    address    : in std_logic_vector (4 DOWNTO 0);
    clock      : in std_logic  := '1';
    q          : out std_logic_vector (9 DOWNTO 0)
  );
end component;

-- execute edge detector
component rising_edge_synchronizer is
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;

-- channel routing
component channel is
  port(
    clk           : in     std_logic;
    reset         : in     std_logic;
    enable        : in     std_logic;
    instruction   : in     std_logic_vector(9 downto 0);
    state_reg     : in     std_logic_vector(4 downto 0);
    data_address  : buffer std_logic_vector(14 downto 0);
  );
end component;

----------------------------------------------------------------------------------

begin

----------------------------------------------------------------------------------

-- data memory instantiation
data_mem_u : rom_data
  port map (
    address    => data_address,
    clock      => clk,
    q          => audio_out
  );

-- instruction memory instantiation
instruction_mem : rom_instructions
  port map(
    address => pc,
    clock   => clk,
    q       => instruction
  );

-- execute edge
execute_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => execute_btn,
    edge  => edge
  );

-- channel 1
ch1_inst : channel
  generic map(
    ch_index      => 1
  )
  port map(
    clk           => clk,
    reset         => reset,
    enable        => sync,
    instruction   => instruction,
    state_reg     => state_reg,
    data_address  => da1
  );

-- channel 0
ch0_inst : channel
  generic map(
    ch_index      => 0
  )
  port map(
    clk           => clk,
    reset         => reset,
    enable        => sync,
    instruction   => instruction,
    state_reg     => state_reg,
    data_address  => da0
  );

----------------------------------------------------------------------------------

-- state register
process (clk, reset)
begin
  if (reset = '1') then
    state_reg <= fetch;
  elsif (clk'event and clk = '1') then
    state_reg <= state_next;
  end if;
end  process;

-- next state logic
process (state_reg, opcode, edge)
begin
  -- prevent latch
  state_next <= state_reg;
  case state_reg is
    when idle         =>
      if (edge = '1') then state_next <= fetch;
      end if;
    when fetch        =>   state_next <= decode;
    when decode       =>
      case opcode is
        when play   => state_next <= execute;
        when pause  => state_next <= execute;
        when seek   => state_next <= execute;
        when stop   => state_next <= execute;
        when others => state_next <= decode_error;
      end case;
    when execute      =>
      if (edge = '1') then state_next <= fetch;
      end if;
    when decode_error =>   state_next <= idle;
    when others       =>   state_next <= idle;
  end case;
end process;

----------------------------------------------------------------------------------

-- data register
process (clk, reset)
begin
  if (reset = '1') then
    data_address_reg <= (others => '0');
  elsif (clk'event and clk = '1') then
    if (state_reg = execute) then
      if (sync = '1') then
        data_address_reg <= data_address;
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------

-- increment program counter when in fetch state
process (clk, reset, state_reg)
begin
  if (reset = '1') then
    pc <= (others => '1');
  elsif (clk'event and clk = '1') then
    if state_reg = fetch then
      -- only 9 instructions given in instructions.mif
      if (pc = "01000") then
        pc <= (others => '0');
      else
        pc <= std_logic_vector(unsigned(pc) + 1);
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------

  led <= instruction;

end beh;