--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 5:  Hardware Add and Subtract [8 bit] with State Machine
--
--      FILE NAME:  add_sub_state_machine.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--***************************************************************************
--***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_state_machine is
  port ( 
    sw    : in std_logic_vector(7 downto 0);
    btn   : in std_logic;
    clk   : in std_logic;
    reset : in std_logic
    -- output
    led   : out std_logic_vector(3 downto 0);
    
  );
end add_sub_state_machine;

architecture arc of add_sub_state_machine is

-- synchronised signals
signal sw_syn      : std_logic_vector(7 downto 0);
signal btn_pressed : std_logic;
signal 

-- state machine declaration
type state_type is (s_enter_a, s_enter_b, s_display_add, s_display_sub);
signal state_reg  : state_type := s_enter_a;
signal state_next : state_type;

-- display signals
signal ones     : std_logic_vector(3 downto 0);
signal tens     : std_logic_vector(3 downto 0);
signal hundreds : std_logic_vector(3 downto 0);

-------------------------------------------------------------------------------

begin

-------------------------------------------------------------------------------

-- next state logic
process (state_reg, btn_pressed)
begin
  -- default value (prevents a latch)
  state_next <= state_reg;
  
  case state_reg is
    when s_enter_a =>
      if (btn_pressed = '1') then
        state_next <= s_enter_b;
      end if;
    when s_enter_b =>
      if (btn_pressed = '1') then
        state_next <= s_display_add;
      end if;
    when s_display_add =>
      if (btn_pressed = '1') then
        state_next <= s_display_sub;
      end if;
    when s_display_sub =>
      if (btn_pressed = '1') then
        state_next <= s_enter_a
      end if;
    when others => state_next <= s_enter_a;
  end case;

end process;

-------------------------------------------------------------------------------

-- state register
process (clk, reset)
begin
  
  if (reset = '1') then 
    state_reg <= s_enter_a;
  elsif (clk'event and clk '1') then
    state_reg <= next_state;
  end if;
  
end process;

-------------------------------------------------------------------------------

add : gen_add_sub
  generic map ( bits => 8 )
  port map    ( )

-------------------------------------------------------------------------------

result_padded <= "000" & result;
led <= state_reg;

-------------------------------------------------------------------------------

-- double dabble povided code
bcd1: process(result_padded)
-- temporary variable
variable temp : STD_LOGIC_VECTOR (11 downto 0);

-- variable to store the output BCD number
-- organized as follows
-- thousands = bcd(15 downto 12)
-- hundreds = bcd(11 downto 8)
-- tens = bcd(7 downto 4)
-- units = bcd(3 downto 0)
variable bcd : UNSIGNED (15 downto 0) := (others => '0');

-- by
-- https://en.wikipedia.org/wiki/Double_dabble

begin
  -- zero the bcd variable
  bcd := (others => '0');
  
  -- read input into temp variable
  temp(11 downto 0) := result_padded;
  
  -- cycle 12 times as we have 12 input bits
  -- this could be optimized, we dont need to check and add 3 for the 
  -- first 3 iterations as the number can never be >4
  for i in 0 to 11 loop
    if bcd(3 downto 0) > 4 then 
      bcd(3 downto 0) := bcd(3 downto 0) + 3;
    end if;
    
    if bcd(7 downto 4) > 4 then 
      bcd(7 downto 4) := bcd(7 downto 4) + 3;
    end if;
  
    if bcd(11 downto 8) > 4 then  
      bcd(11 downto 8) := bcd(11 downto 8) + 3;
    end if;

    -- thousands can't be >4 for a 12-bit input number
    -- so don't need to do anything to upper 4 bits of bcd
  
    -- shift bcd left by 1 bit, copy MSB of temp into LSB of bcd
    bcd := bcd(14 downto 0) & temp(11);
  
    -- shift temp left by 1 bit
    temp := temp(10 downto 0) & '0';
  
  end loop;

  -- set outputs
  ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));
  tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
  hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));
  --thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
end process bcd1; 

-------------------------------------------------------------------------------

end architecture arc;