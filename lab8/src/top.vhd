--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 8:  Simple Audio Processor
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity top is
  port(
    CLOCK_50      : in    std_logic;
    CLOCK2_50     : in    std_logic;
    AUD_DACLRCK   : in    std_logic;
    AUD_ADCLRCK   : in    std_logic;
    AUD_BCLK      : in    std_logic;
    AUD_ADCDAT    : in    std_logic;
    KEY           : in    std_logic_vector(1 downto 0);
    --
    FPGA_I2C_SDAT : inout std_logic;
    --
    FPGA_I2C_SCLK : out   std_logic;
    AUD_DACDAT    : out   std_logic;
    AUD_XCK       : out   std_logic;
    LEDR          : out   std_logic_vector(9 downto 0);
  );
end top;

architecture implementation of top is

-------------------------------------------------------------------------------

signal read_ready       : std_logic;
signal write_ready      : std_logic;
signal read_s           : std_logic;
signal write_s          : std_logic;
                        
signal readdata_left    : std_logic_vector(23 downto 0);
signal readdata_right   : std_logic_vector(23 downto 0);
signal writedata_left   : std_logic_vector(23 downto 0);
signal writedata_right  : std_logic_vector(23 downto 0);
                        
signal write_data       : std_logic_vector(15 downto 0);
signal write_data_24    : std_logic_vector(23 downto 0);
signal data_address     : std_logic_vector(13 downto 0) := (others => '0');

signal pc               : std_logic_vector(4  downto 0) := (others => '0');
signal instruction      : std_logic_vector(7  downto 0) := (others => '0');
signal led              : std_logic_vector(7  downto 0);
signal reset            : std_logic;
signal enable           : std_logic;
signal execute_btn      : std_logic;

-------------------------------------------------------------------------------

begin

-------------------------------------------------------------------------------

reset       <= NOT (KEY(0));
execute_btn <= KEY(1);

writedata_left  <= readdata_left;
writedata_right <= readdata_right;
read_s          <= read_ready;
write_s         <= write_ready AND read_ready;

-------------------------------------------------------------------------------

write_data_24 <= write_data & "00000000";
LEDR          <= "00" & led;

-------------------------------------------------------------------------------

uut : generic_counter
  generic map(
    max_count => 6249)  -- 8000 Hz
  port map(
    clk    => CLOCK_50,
    reset  => reset,
    output => enable
  );

dj_roomba : dj_roomba_3000
  port map(
    clk         => CLOCK_50,
    reset       => reset,
    execute_btn => execute_btn,
    sync        => enable,
    led         => led,
    audio_out   => write_data
  );

my_clock_gen : clock_generator
  port map(
    CLOCK_27 => CLOCK2_50,
    reset    => reset,
    AUD_XCK  => AUD_XCK
  );

cfg : audio_and_video_config
  port map(
    CLOCK_50 => CLOCK_50,
    reset    => reset,
    I2C_SDAT => FPGA_I2C_SDAT,
    I2C_SCLK => FPGA_I2C_SCLK
  );

codec : audio_codec
  port map(
    CLOCK_50        => CLOCK_50,
    reset           => reset,
    read_s          => read_s,
    write_s         => write_s,
    writedata_left  => write_data_24,
    writedata_right => write_data_24,
    AUD_ADCDAT      => AUD_ADCDAT,
    AUD_BCLK        => AUD_BCLK,
    AUD_ADCLRCK     => AUD_ADCLRCK,
    AUD_DACLRCK     => AUD_DACLRCK,
    read_ready      => read_ready,
    write_ready     => write_ready,
    readdata_left   => readdata_left,
    readdata_right  => readdata_right,
    AUD_DACDAT      => AUD_DACDAT
  );

-------------------------------------------------------------------------------

end implementation;



