library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
	port (
		clk    : in std_ulogic;
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
		sync_polarity: std_ulogic;
	end record;

	type vga_params_t is record
		h_sync : vga_sync_params_t;
		v_sync : vga_sync_params_t;
	end record;

	-- requires pixel clock: 25Mhz
	constant VGA_PARAMS_640x480 : vga_params_t := (
		h_sync => (
			front_border  => 48,
			visible_size  => 640,
			back_border   => 16,
			retrace       => 96,
			sync_polarity => '0'),
		v_sync => (
			front_border  => 33,
			visible_size  => 480,
			back_border   => 10,
			retrace       => 2,
			sync_polarity => '0'));

	-- requires pixel clock: 108Mhz
	constant VGA_PARAMS_1280x1024 : vga_params_t := (
		h_sync => (
			front_border  => 248,
			visible_size  => 1280,
			back_border   => 48,
			retrace       => 112,
			sync_polarity => '1'),
		v_sync => (
			front_border  => 38,
			visible_size  => 1024,
			back_border   => 1,
			retrace       => 3,
			sync_polarity => '1'));

	-- constant PARAMS : vga_params_t := VGA_PARAMS_640x480;
	constant PARAMS : vga_params_t := VGA_PARAMS_1280x1024;

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
				clk       => clk   ,
				reset     => reset,
				increment => '1',
				overflow  => increment_v,
				value     => count_h
			);

	counter_v : entity work.counter
			generic map (COUNTER_MAX => COUNTER_MAX_V)
			port map (
				clk       => clk   ,
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
			h_sync <= not PARAMS.h_sync.sync_polarity;
		else
			h_sync <= PARAMS.h_sync.sync_polarity;
		end if;

		if count_v < TOTAL_SIZE_V then
			v_sync <= not PARAMS.v_sync.sync_polarity;
		else
			v_sync <= PARAMS.v_sync.sync_polarity;
		end if;
	end process;

	colors : process (all)
	begin
		if (x_screen - 1280/2) * (x_screen - 1280/2)
		 + (y_screen - 1024/2) * (y_screen - 1024/2) < 600*600 then
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
