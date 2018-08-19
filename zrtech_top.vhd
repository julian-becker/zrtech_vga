library ieee;
use ieee.std_logic_1164.all;

use work.sevenseg_pkg.all;

entity zrtech_top is
	port (
		clk              : in  std_logic;
		key4             : in  std_logic;
		ds_a_b_c_d_e_f_g : out std_logic_vector(1 to 7);
		ds_dp            : out std_logic;
		ds_en_n          : out std_logic_vector(1 to 4)
	);
end;

architecture top of zrtech_top is
	signal digits            : digit_vector_t(1 to 4) := (1, 2, 3, 4);
	signal counter_value     : natural range 0 to 9 := 0;
	signal increment_counter : std_logic;
	signal reset             : std_logic := '1';
begin
	ds_dp <= '0';
	reset <= not key4;


	display : entity work.sevenseg_display
		port map (
			clk            => clk,
			digits         => digits,
			digit_sevenseg => ds_a_b_c_d_e_f_g,
			digit_select   => ds_en_n);

	cntr : entity work.decimal_counter
		generic map (
			DIGITS => 4
		)
		port map (
			clk       => clk,
			reset     => reset,
			increment => increment_counter,
			digit_vector => digits
		);

	relax : entity work.relax_clock
		generic map (
			RELAX_CYCLES => 20000000
		)
		port map (
			clk         => clk,
			reset       => reset,
			clk_relaxed => increment_counter
		);
end;
