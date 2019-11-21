--****************************  VHDL Source Code  ******************************
--***********  Copyright 2019, Rochester Institute of Technology  **************
--******************************************************************************
--
--  DESIGNER NAME:  Brian Zarzuela
--
--          LAB 3:  Seven Segment Display Counter
--
--      FILE NAME:  bcd_to_seven_seg.vhd
--
--------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    Clocked 4-bit BCD-to-seven-segment decoder for a common anode LED display
--    NOTE: In a common anode display, all the LED segments are joined together
--          to logic "1" therefor each individual segment is illuminated by
--          applying a ground, logic "0", or LOW signal.
--    BCD to 7 segment display decoder truth table:
--    ________________________________________
--   | # | BCD In | a | b | c | d | e | f | g |       ____a____
--   |===+========+===+===+===+===+===+===+===|      |         |
--   | 0 |  0000  | 0 | 0 | 0 | 0 | 0 | 0 | 1 |      |         |
--   | 1 |  0001  | 1 | 0 | 0 | 1 | 1 | 1 | 1 |     f|         |b
--   | 2 |  0010  | 0 | 0 | 1 | 0 | 0 | 1 | 0 |      |         |
--   | 3 |  0011  | 0 | 0 | 0 | 0 | 1 | 1 | 0 |      |____g____|
--   | 4 |  0100  | 1 | 0 | 0 | 1 | 1 | 0 | 0 |      |         |
--   | 5 |  0101  | 0 | 1 | 0 | 0 | 1 | 0 | 0 |      |         |
--   | 6 |  0110  | 0 | 1 | 0 | 0 | 0 | 0 | 0 |     e|         |c
--   | 7 |  0111  | 0 | 0 | 0 | 1 | 1 | 1 | 1 |      |         |
--   | 8 |  1000  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |      |____d____|
--   | 9 |  1001  | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
--   ==========================================
--
--******************************************************************************
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_seven_seg is
  port (
    clk     : in  std_logic;
    -- four-bit input that encodes a number digit between 0 and 9
    input   : in  std_logic_vector(3 downto 0);
    --
    -- seven-bit output indexed 'a' to 'g' as '6' to '0' respectively
    -- corresponding to the seven segments of the LED display
    display : out std_logic_vector(6 downto 0)
  );
end bcd_to_seven_seg;

architecture arc of bcd_to_seven_seg is
begin

  process(input, clk)
  begin
  
    if (clk'event and clk='1') then
      case input is
        when "0000" => display <= "1000000";
        when "0001" => display <= "1111001";
        when "0010" => display <= "0100100";
        when "0011" => display <= "0110000";
        when "0101" => display <= "0010010";
        when "0100" => display <= "0011001";
        when "0110" => display <= "0000010";
        when "0111" => display <= "1111000";
        when "1000" => display <= "0000000";
        when "1001" => display <= "0010000";
        when others => display <= "1111111"; -- blank display on illegel inputs
      end case;
    end if;
  
  end process;

end arc;