library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
	port (
		clk_25MHz : in std_ulogic;
		reset  : in std_ulogic;
		h_sync : out std_ulogic;
		v_sync : out std_ulogic;
		r,g,b  : out std_ulogic);
end;

architecture arch of vga is
	type vga_sync_params_t is record
		front_border : natural;
		visible_size : natural;
		back_border  : natural;
		retrace      : natural;
	end record;

	type vga_params_t is record
		h_sync : vga_sync_params_t;
		v_sync : vga_sync_params_t;
	end record;

	constant VGA_PARAMS_640x480 : vga_params_t := (
		h_sync => (
			front_border => 48,
			visible_size => 640,
			back_border  => 16,
			retrace      => 96),
		v_sync => (
			front_border => 33,
			visible_size => 480,
			back_border  => 10,
			retrace      => 2));

	constant PARAMS : vga_params_t := VGA_PARAMS_640x480;

	constant TOTAL_SIZE_H : natural :=
		PARAMS.h_sync.front_border +
		PARAMS.h_sync.visible_size +
		PARAMS.h_sync.back_border;
	constant TOTAL_SIZE_V : natural :=
		PARAMS.v_sync.front_border +
		PARAMS.v_sync.visible_size +
		PARAMS.v_sync.back_border;
	constant COUNTER_MAX_H : natural := TOTAL_SIZE_H + PARAMS.h_sync.retrace - 1;
	constant COUNTER_MAX_V : natural := TOTAL_SIZE_V + PARAMS.v_sync.retrace - 1;



	signal count_h : natural := 0;
	signal x_screen : integer := 0;

	signal count_v : natural := 0;
	signal y_screen : integer := 0;

	signal increment_v : std_ulogic := '0';



begin

	counter_h : entity work.counter
			generic map (COUNTER_MAX => COUNTER_MAX_H)
			port map (
				clk       => clk_25MHz,
				reset     => reset,
				increment => '1',
				overflow  => increment_v,
				value     => count_h
			);

	counter_v : entity work.counter
			generic map (COUNTER_MAX => COUNTER_MAX_V)
			port map (
				clk       => clk_25MHz,
				reset     => reset,
				increment => increment_v,
				overflow  => open,
				value     => count_v
			);

	x_screen <= count_h - PARAMS.h_sync.front_border;
	y_screen <= count_v - PARAMS.v_sync.front_border;


	combinatorial : process (all)
	is
	begin
		if count_h < TOTAL_SIZE_H then
			h_sync <= '1';
		else
			h_sync <= '0';
		end if;

		if count_v < TOTAL_SIZE_V then
			v_sync <= '1';
		else
			v_sync <= '0';
		end if;
	end process;

	colors : process (all)
	begin
		if (x_screen - 320) * (x_screen - 320)
		 + (y_screen - 240) * (y_screen - 240) < 100*100 then
			r <= '1';
			g <= '1';
			b <= '1';
		else
			r <= '0';
			g <= '0';
			b <= '0';
		end if;
	end process;
end;
