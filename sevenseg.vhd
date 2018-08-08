library ieee;
use ieee.std_logic_1164.all;
use work.sevenseg_pkg.all;

entity sevenseg is
	port (
		digit : in digit_t;
		sevenseg : out sevenseg_t
	);
end;

architecture combinatorial of sevenseg is
	type sevenseg_map_t is array (0 to 9) of sevenseg_t;
	constant SEVEN_SEG_MAP : sevenseg_map_t := (
		"1111110",
		"0110000",
		"1101101",
		"1111001",
		"0110011",
		"1011011",
		"1111101",
		"1110000",
		"1111111",
		"1111011"
	);
begin
	sevenseg <= SEVEN_SEG_MAP(digit);
end;
