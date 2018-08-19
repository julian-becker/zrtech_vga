library ieee;
use ieee.std_logic_1164.all;

use work.sevenseg_pkg.all;

entity decimal_counter is
	generic (
		DIGITS       : positive
	);
	port (
		clk          : in  std_ulogic;
		reset        : in  std_ulogic;
		increment    : in  std_ulogic;
		digit_vector : out digit_vector_t(3 downto 0)
	);
end;

architecture impl of decimal_counter is
	signal increment_vector : std_ulogic_vector(3 downto 0) := "0000";
	signal overflow_vector  : std_ulogic_vector(3 downto 0) := "0000";

begin
	increment_vector <= overflow_vector(2 downto 0) & increment;

	counters : for i in 0 to 3 generate
		c1 : entity work.counter
			generic map (COUNTER_MAX => 9)
			port map (
				clk       => clk,
				reset     => reset,
				increment => increment_vector(i),
				overflow  => overflow_vector(i),
				value     => digit_vector(i)
			);
	end generate;


end;
