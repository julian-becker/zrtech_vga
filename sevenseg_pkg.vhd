library ieee;
use ieee.std_logic_1164.all;

package sevenseg_pkg is

	subtype digit_t is natural range 0 to 9;
	subtype sevenseg_t is std_logic_vector(1 to 7);
	type digit_vector_t is array (natural range <>) of digit_t;
end;