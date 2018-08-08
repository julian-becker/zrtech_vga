library ieee;
use ieee.std_logic_1164.all;

use work.sevenseg_pkg.all;

entity sevenseg_display is
	port (
		clk : in std_logic;
		digits : in digit_vector_t(3 downto 0);
		digit_sevenseg : out sevenseg_t;
		digit_select   : out std_logic_vector(1 to 4)
	);
end;

architecture impl of sevenseg_display is
	signal digit_select_int : natural range 0 to 3 := 0;
	signal digit : digit_t;
begin

	digit <= digits(digit_select_int);

	select_digit_to_encode : entity work.digit_selector 
		port map (
			clk          => clk, 
			digit_select => digit_select_int
		);

	convert_digit : entity work.sevenseg
		port map (
			digit    => digit,
			sevenseg => digit_sevenseg
		);

	with digit_select_int select digit_select <=
		"0111" when 0,
		"1011" when 1,
		"1101" when 2,
		"1110" when 3;
end;
	