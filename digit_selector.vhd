library ieee;
use ieee.std_logic_1164.all;

entity digit_selector is
	port (
		clk : in std_logic;
		digit_select : out natural range 0 to 3
	);
end;

architecture behavioral of digit_selector is
begin
	main : process (clk)
		variable index : natural range 0 to 3 := 0;
		variable relax : natural := 0;
	begin
		if rising_edge(clk) then
			if relax = 1000 then
				relax := 0;
				if index = 3 then
					index := 0;
				else
					index := index + 1;
				end if;
				digit_select <= index;
			else
				relax := relax + 1;
			end if;
		end if;
	end process;
end;
	