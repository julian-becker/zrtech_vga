library ieee;
use ieee.std_logic_1164.all;

use work.sevenseg_pkg.all;

entity zrtech_top is
	port (
		clk              : in  std_logic;
		ds_a_b_c_d_e_f_g : out std_logic_vector(1 to 7);
		ds_dp            : out std_logic;
		ds_en_n          : out std_logic_vector(1 to 4)
	);
end;

architecture top of zrtech_top is
	signal digits : digit_vector_t(1 to 4) := (1, 2, 3, 4);
begin
	ds_dp <= '0';

	display : entity work.sevenseg_display
		port map (
			clk            => clk,
			digits         => digits,
			digit_sevenseg => ds_a_b_c_d_e_f_g,
			digit_select   => ds_en_n);

end;
