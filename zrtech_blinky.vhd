library ieee;
use ieee.std_logic_1164.all;

entity zrtech_blinky is
	port (
		clk      : in  std_logic;
		led_d2_n : out std_logic;
		led_d3_n : out std_logic;
		led_d4_n : out std_logic;
		led_d5_n : out std_logic
	);
end;

architecture top of zrtech_blinky is
	signal led_d2 : std_ulogic := '0';
	signal led_d3 : std_ulogic := '0';
	signal led_d4 : std_ulogic := '0';
	signal led_d5 : std_ulogic := '0';
begin
	led_d2_n <= not led_d2;
	led_d3_n <= not led_d3;
	led_d4_n <= not led_d4;
	led_d5_n <= not led_d5;

	count_d2 : process (clk)
		variable counter : integer := 0;
	begin
		if rising_edge(clk) then
			counter := counter + 1;
			if counter = 5000000 then
				counter := 0;
				led_d2 <= not led_d2;
			end if;
		end if;
	end process;

	count_d3 : process (clk)
		variable counter : integer := 0;
	begin
		if rising_edge(clk) then
			counter := counter + 1;
			if counter = 10000000 then
				counter := 0;
				led_d3 <= not led_d3;
			end if;
		end if;
	end process;

	count_d4 : process (clk)
		variable counter : integer := 0;
	begin
		if rising_edge(clk) then
			counter := counter + 1;
			if counter = 15000000 then
				counter := 0;
				led_d4 <= not led_d4;
			end if;
		end if;
	end process;

	count_d5 : process (clk)
		variable counter : integer := 0;
	begin
		if rising_edge(clk) then
			counter := counter + 1;
			if counter = 20000000 then
				counter := 0;
				led_d5 <= not led_d5;
			end if;
		end if;
	end process;
end;
