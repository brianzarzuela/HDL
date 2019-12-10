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
    enable        : in     std_logic;
    instruction   : in     std_logic_vector(9 downto 0);
    state_reg     : in     std_logic_vector(4 downto 0);
    data_address  : buffer std_logic_vector(14 downto 0);
  );
end channel;

architecture imp of channel is

----------------------------------------------------------------------------------

signal data_address_play        : std_logic_vector(14 downto 0);
signal data_address_repeat      : std_logic_vector(14 downto 0);
signal data_address_pause       : std_logic_vector(14 downto 0);
signal data_address_seek        : std_logic_vector(14 downto 0);
signal data_address_stop        : std_logic_vector(14 downto 0);

----------------------------------------------------------------------------------

begin

----------------------------------------------------------------------------------

-- function unit modules

-- play
process (data_address)
begin
  if (data_address = "111111111111111") then
    data_address_play <= (others => '1');
  else
    data_address_play <= std_logic_vector(unsigned(data_address) + 1);
  end if;
end process;

-- repeat
process (data_address)
begin
  if (data_address = "111111111111111") then
    data_address_repeat <= (others => '0');
  else
    data_address_repeat <= std_logic_vector(unsigned(data_address) + 1);
  end if;
end process;

----------------------------------------------------------------------------------




data_address_pause       <= data_address_reg;
data_address_seek        <= seek_address & "000000000";
data_address_stop        <= (others => '0');

-- data address routing multiplexer
process (reset, opcode, repeat)
begin
  if (reset = '1') then
    data_address <= (others => '0');
  else
    case opcode is
      when play =>
        if (repeat = '1') then
          data_address <= data_address_repeat;
        else
          data_address <= data_address_play;
        end if;
      when pause  => data_address <= data_address_pause;
      when seek   => data_address <= data_address_seek;
      when stop   => data_address <= data_address_stop;
      when others => data_address <= data_address_pause;
    end case;
  end if;
end process;

----------------------------------------------------------------------------------

end imp;