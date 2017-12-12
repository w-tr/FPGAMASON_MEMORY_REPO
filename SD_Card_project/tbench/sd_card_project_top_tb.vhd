
library std;
use	std.textio.all;
library ieee;
use	ieee.std_logic_1164.all;
library top;
library uart_lib;
use	uart_lib.helpers_pkg.all;

entity sd_card_project_top_tb is
	end entity sd_card_project_top_tb;

architecture tb of sd_card_project_top_tb is

	signal CLK_100M : std_logic; -- E3.
		signal CLK_25M : std_logic; -- E3.
	signal RESET_n : std_logic; -- C2
	signal UART_rxd: std_logic; -- A9
	signal UART_txd: std_logic; -- D10
	signal BTN :  std_logic_vector(3 downto 0);
	signal SWT :  std_logic_vector(3 downto 0);
	signal LED : std_logic_vector(3 downto 0);
	--signal TLED : word3_ar_t(3 downto 0);--B3-k2, G3-H6, R3-K1, h4,j2,j3|G4,J4,G3|E1,F6,G6 
	constant per_100m : time := 10 ns;
	constant per_25m : time := 40 ns;
	signal newRxData : std_logic;                     -- signs that a new byte was received
  constant BAUD_115200  : real := 115200.0;
  constant BAUD_38400   : real := 38400.0;
  constant BAUD_28800   : real := 28800.0;
  constant BAUD_19200   : real := 19200.0;
  constant BAUD_9600    : real := 9600.0;
  constant BAUD_4800    : real := 4800.0;
  constant BAUD_2400    : real := 2400.0;
  constant BAUD_1200    : real := 1200.0;
  
  constant NSTOPS_1     : real := 1.0;
  constant NSTOPS_1_5   : real := 1.5;
  constant NSTOPS_2     : real := 2.0;
  
  constant PARITY_NONE  : integer := 0;
  constant PARITY_EVEN  : integer := 1;
  constant PARITY_ODD   : integer := 2;
  constant PARITY_MARK  : integer := 3;
  constant PARITY_SPACE : integer := 4;
  
  constant NBITS_7      : integer := 6;
  constant NBITS_8      : integer := 7;
  signal recvData : std_logic_vector(7 downto 0);
  signal clr		 : std_logic;
  signal LED_R     : std_logic_vector(3 downto 0); 
  signal LED_B     : std_logic_vector(3 downto 0);
  signal LED_G     : std_logic_vector(3 downto 0);
  signal SD_DATA   : std_logic_vector(3 downto 0);
  signal SD_CMD	  :	std_logic;
  signal SD_SCLK	  : std_logic;
  signal SD_CD	  :	std_logic; -- Card Detected
  signal SD_WP	  :	std_logic;
begin

	clr <= not RESET_n;
	process is
	begin
		CLK_100M <=  '1';
		wait for per_100m/2;
		CLK_100M <= '0';
		wait for per_100m/2;
	end process;
		process is
    begin
        CLK_25M <=  '1';
        wait for per_25m/2;
        CLK_25M <= '0';
        wait for per_25m/2;
    end process;

	RESET_n <= '0', '1' after 250 ns;

	uut : entity top.sd_card_project_top 
		port map
		(
			CLK_100M => CLK_100M,
			RESET_n => RESET_n,
			UART_rxd=> UART_rxd,
			UART_txd=> UART_txd,
			BTN => BTN,
			SWT => SWT,
			LED => LED,
		LED_R     => LED_R,
		LED_B     => LED_B,
		LED_G     => LED_G,
		SD_DATA   => SD_DATA,
		SD_CMD	  => SD_CMD,
		SD_SCLK	  => SD_SCLK,
		SD_CD	  => SD_CD,
		SD_WP	  => SD_WP
			--TLED => TLED
		);


--------------------------------------------------------------------
--test bench receiver 
		process

		begin
			newRxData <= '0';
			recvData <= (others => '0');
			wait until (clr = '0');
			loop
				recvSerial(UART_txd, BAUD_115200, PARITY_NONE, NSTOPS_1, NBITS_8, 0.0, recvData);
				newRxData <= '1';
				wait for 25 ns;
				newRxData <= '0';
			end loop;
		end process;

--------------------------------------------------------------------
-- uart transmit - test bench control 
		process

			type     dataFile is file of character;
			file     testTextFile : dataFile open READ_MODE is "sd_card_uart_test.txt";
			variable charBuf      : character;
			variable data         : integer;
			variable tempLine     : line;

		begin
																			      -- default value of serial output 
			UART_rxd <= '1';
																				    -- text mode simulation 
			write(tempLine, string'("Starting text mode simulation"));
			writeline(output, tempLine);
			wait until (clr = '0');
			wait for 1 ms;
			wait until (rising_edge(clk_25m));
			for index in 0 to 99 loop
				wait until (rising_edge(clk_25m));
			end loop;
			while not endfile(testTextFile) loop
				-- transmit the byte in the command file one by one 
				read(testTextFile, charBuf);
				data := character'pos(charBuf);
				sendSerial(data, BAUD_115200, PARITY_NONE, NSTOPS_1, NBITS_8, 0.0, UART_rxd);
				wait for 800 us;
			end loop;
			report "" severity failure;
			wait;
		end process;

end architecture tb;
