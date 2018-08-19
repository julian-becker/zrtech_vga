library ieee;
use ieee.std_logic_1164.all;
use work.sevenseg_pkg.all;

entity workbench is
end;

architecture wb of workbench is
	signal clk            : std_logic := '0';

	signal digits         : digit_vector_t(1 to 4) := (1,2,3,4);
	signal digit_sevenseg : sevenseg_t := (others => '0');
	signal digit_select   : std_logic_vector(1 to 4) := (others => '0');

	signal increment     : std_logic := '0';
	signal counter_value : natural range 0 to 10;

	signal ds_a_b_c_d_e_f_g : std_logic_vector(1 to 7);
	signal ds_dp            : std_logic;
	signal ds_en_n          : std_logic_vector(1 to 4);



begin
	clk <= not clk after 10 ps;

	top : entity work.zrtech_top
		port map(
			clk => clk,
			key4 => '1',
			ds_a_b_c_d_e_f_g => ds_a_b_c_d_e_f_g,
			ds_dp => ds_dp,
			ds_en_n => ds_en_n);


	--ss : entity work.sevenseg_display
	--	port map (
	--		clk            => clk,
	--		digits         => digits,
	--		digit_sevenseg => digit_sevenseg,
	--		digit_select   => digit_select);

	--count : entity work.counter
	--	generic map (
	--		COUNTER_MAX => 9
	--	)
	--	port map (
	--		clk       => clk,
	--		increment => increment,
	--		value     => counter_value
	--	);

	--relax : entity work.relax_clock
	--	generic map (
	--		RELAX_CYCLES => 5
	--	)
	--	port map (
	--		clk         => clk,
	--		clk_relaxed => increment
	--	);
				
end;
