library ieee;
use ieee.std_logic_1164.all;

entity relax_clock is
	generic (
		RELAX_CYCLES : positive
	);
	port (
		clk         : in  std_ulogic;
		reset       : in  std_ulogic;
		clk_relaxed : out std_ulogic
	);
end;

architecture impl of relax_clock is
begin
	main : process (clk,reset)
		variable count : natural range 0 to RELAX_CYCLES := 0;
	begin
		if reset = '1' then
			count := 0;
			clk_relaxed <= '0';
		elsif rising_edge(clk) then
			clk_relaxed <= '0';
			if count = 0 then
				clk_relaxed <= '1';
			end if;

			if count < RELAX_CYCLES then
				count := count + 1;
			else
				count := 0;
			end if;
		--elsif falling_edge(clk) then
		--	clk_relaxed <= '0';
		end if;
	end process;
end;
