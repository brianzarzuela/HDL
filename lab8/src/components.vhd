--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 8:  Simple Audio Processor
--
--      FILE NAME:  components.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    Calculator Package contains for
--      - dj roomba 3000
--      - generic counter
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is

component dj_roomba_3000 is
  port(
    clk         : in  std_logic;
    reset       : in  std_logic;
    execute_btn : in  std_logic;
    sync        : in  std_logic;
    led         : out std_logic_vector(7  downto 0);
    audio_out   : out std_logic_vector(15 downto 0)
  );
end component;

component generic_counter is
  generic(
    max_count : integer range 0 to 10000 := 3);
  port(
    clk    : in  std_logic; 
    reset  : in  std_logic;
    output : out std_logic
  );
end component;

component clock_generator
  port(
    CLOCK_27 : in  std_logic;
    reset    : in  std_logic;
    AUD_XCK  : out std_logic
  );
end component;

component audio_and_video_config
  port(
    CLOCK_50 : in    std_logic;
    reset    : in    std_logic;
    I2C_SDAT : inout std_logic;
    I2C_SCLK : out   std_logic
  );
end component;

component audio_codec
  port(
    CLOCK_50        : in  std_logic;
    reset           : in  std_logic;
    read_s          : in  std_logic;
    write_s         : in  std_logic;
    writedata_left  : in  std_logic_vector(23 downto 0);
    writedata_right : in  std_logic_vector(23 downto 0);
    AUD_ADCDAT      : in  std_logic;
    AUD_BCLK        : in  std_logic;
    AUD_ADCLRCK     : in  std_logic;
    AUD_DACLRCK     : in  std_logic;
    read_ready      : out std_logic;
    write_ready     : out std_logic;
    readdata_left   : out std_logic_vector(23 downto 0);
    readdata_right  : out std_logic_vector(23 downto 0);
    AUD_DACDAT      : out std_logic
  );
end component;

end components;