library ieee;
use ieee.std_logic_1164.all;

use work.sevenseg_pkg.all;

entity zrtech_top is
	port (
		clk              : in  std_ulogic;
		key4             : in  std_ulogic;
		ds_a_b_c_d_e_f_g : out std_ulogic_vector(1 to 7);
		ds_dp            : out std_ulogic;
		ds_en_n          : out std_ulogic_vector(1 to 4);
		HSYNC            : out std_ulogic;
		VSYNC            : out std_ulogic;
		VR               : out std_ulogic_vector(4 downto 0);
		VG               : out std_ulogic_vector(5 downto 0);
		VB               : out std_ulogic_vector(4 downto 0)
	);
end;

architecture top of zrtech_top is
    component PLATFORM is
        port (
            altpll_0_areset_conduit_export : in  std_logic := 'X'; -- export
            altpll_0_c0_108mhz_clk         : out std_logic;        -- clk
            altpll_0_locked_conduit_export : out std_logic;        -- export
            clk_clk                        : in  std_logic := 'X'; -- clk
            reset_reset_n                  : in  std_logic := 'X'; -- reset_n
            altpll_0_c1_40mhz_clk          : out std_logic;        -- clk
            altpll_1_c0_65_mhz_clk         : out std_logic;        -- clk
            altpll_1_c1_25mhz_clk          : out std_logic;        -- clk
            altpll_1_areset_conduit_export : in  std_logic := 'X'; -- export
            altpll_1_locked_conduit_export : out std_logic         -- export
        );
    end component PLATFORM;

	signal digits            : digit_vector_t(1 to 4) := (1, 2, 3, 4);
	signal counter_value     : natural range 0 to 9 := 0;
	signal increment_counter : std_ulogic;
	signal reset             : std_ulogic := '1';
	
	signal clk_108MHz        : std_ulogic;
	signal clk_65MHz         : std_ulogic;
	signal clk_40MHz         : std_ulogic;
	signal clk_25MHz         : std_ulogic;
begin
	ds_dp <= '0';
	reset <= not key4;

    sopc_platform : component PLATFORM
        port map (
            clk_clk                        => clk,
            reset_reset_n                  => not reset,
            altpll_0_c0_108mhz_clk         => clk_108MHz,
            altpll_0_c1_40mhz_clk          => clk_40MHz,
            altpll_1_c0_65_mhz_clk         => clk_65MHz,
            altpll_1_c1_25mhz_clk          => clk_25MHz);

    vga_disp : entity work.vga
    	port map (
    		clk       => clk_108MHz,
    		reset     => reset,
    		h_sync    => HSYNC,
    		v_sync    => VSYNC,
    		r         => VR(4),
    		g         => VG(5),
    		b         => VB(4));

    VR(3 downto 0) <= "0000";
    VG(4 downto 0) <= "00000";
    VB(3 downto 0) <= "0000";

	display : entity work.sevenseg_display
		port map (
			clk            => clk,
			digits         => digits,
			digit_sevenseg => ds_a_b_c_d_e_f_g,
			digit_select   => ds_en_n);

	cntr : entity work.decimal_counter
		generic map (
			DIGITS => 4)
		port map (
			clk       => clk,
			reset     => reset,
			increment => increment_counter,
			digit_vector => digits);

	relax : entity work.relax_clock
		generic map (
			RELAX_CYCLES => 20000000)
		port map (
			clk         => clk,
			reset       => reset,
			clk_relaxed => increment_counter);
end;
