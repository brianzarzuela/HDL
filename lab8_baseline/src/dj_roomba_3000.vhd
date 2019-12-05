-- Dr. Kaputa
-- Lab 8: DJ Roomba 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dj_roomba_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(7 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end dj_roomba_3000;

architecture beh of dj_roomba_3000 is
  -- instruction memory
  component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (7 DOWNTO 0)
    );
  end component;
  
  -- data memory
  component rom_data
    port(
      address  : in std_logic_vector (13 DOWNTO 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 DOWNTO 0)
    );
  end component;
  
signal data_address  : std_logic_vector(13 downto 0);

-- execute edge detector
component rising_edge_synchronizer is
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;

constant idle         : std_logic_vector(6 downto 0) := "0000001";
constant fetch        : std_logic_vector(6 downto 0) := "0000010";
constant decode       : std_logic_vector(6 downto 0) := "0000100";
constant execute      : std_logic_vector(6 downto 0) := "0001000";
constant decode_error : std_logic_vector(6 downto 0) := "0010000";
constant fetch_wait1  : std_logic_vector(6 downto 0) := "0100000";
constant fetch_wait2  : std_logic_vector(6 downto 0) := "1000000";

signal state_reg      : std_logic_vector(6 downto 0);
signal state_next     : std_logic_vector(6 downto 0);

signal instruction    : std_logic_vector(7 downto 0);
alias  opcode         : std_logic_vector(1 downto 0) is instruction(7 downto 6);
alias  repeat         : std_logic is instruction(5);
alias  seek_addr      : std_logic_vector(4 downto 0) is instruction(4 downto 0);

constant play         : std_logic_vector(1 downto 0) := "00";
constant pause        : std_logic_vector(1 downto 0) := "01";
constant seek         : std_logic_vector(1 downto 0) := "10";
constant stop         : std_logic_vector(1 downto 0) := "11";

signal pc : std_logic_vector(4 downto 0);
signal edge : std_logic;

begin

-- execute edge
execute_u : rising_edge_synchronizer
  port map(
    clk   => clk,
    reset => reset,
    input => execute_btn,
    edge  => edge
  );

-- instruction memory instantiation
instruction_mem : rom_instructions
  port map(
    address => pc,
    clock   => clk,
    q       => instruction
  );

-- data instantiation
u_rom_data_inst : rom_data
  port map (
    address    => data_address,
    clock      => clk,
    q          => audio_out
  );
---------------------------------

-- state register
process(clk, reset)
begin
  if (reset = '1') then
    state_reg <= fetch;
  elsif (clk'event and clk = '1') then
    state_reg <= state_next;
  end if;
end  process;

-- next state logic
process(state_reg, edge)
begin
  -- prevent latch
  state_next <= state_reg;
  case state_reg is
    when idle =>
      if (edge = '1') then state_next <= fetch;
      end if;
    when fetch => state_next <= decode;
    when decode => state_next <= execute;
    when others => state_next <= fetch;
  end case;
end process;

---------------------------------

  -- loop audio file
  process(clk,reset)
  begin 
    if (reset = '1') then 
      data_address <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (sync = '1') then    
        data_address <= std_logic_vector(unsigned(data_address) + 1 );
      end if;
    end if;
  end process;

  led <= instruction;
end beh;