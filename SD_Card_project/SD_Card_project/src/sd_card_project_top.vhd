library ieee;
use	ieee.std_logic_1164.all;
library uart_lib;
library xil_defaultlib;
use     xil_defaultlib.all;

entity sd_card_project_top is
	port
	(
		CLK_100M  : in  std_logic;
		RESET_n   : in  std_logic;
		UART_rxd  : in  std_logic;
		UART_txd  : out std_logic; 
		BTN       : in  std_logic_vector(3 downto 0); 
		SWT       : in  std_logic_vector(3 downto 0); 
		LED       : out std_logic_vector(3 downto 0);
		LED_R     : out std_logic_vector(3 downto 0); 
		LED_B     : out std_logic_vector(3 downto 0);
		LED_G     : out std_logic_vector(3 downto 0);
		SD_DATA   : inout std_logic_vector(3 downto 0);
		SD_CMD	  : out	std_logic;
		SD_SCLK	  : out std_logic;
		SD_CD	  : in	std_logic; -- Card Detected
		SD_WP	  : out	std_logic
	);
end entity sd_card_project_top;


architecture struct of sd_card_project_top is 

signal locked : std_logic;
	signal probe0 : std_logic_vector(31 downto 0);

	signal sd_dat : std_logic_vector(3 downto 0);
	signal cmd    : std_logic;  -- MOSI (command)
	signal sclk   : std_logic;  -- serial clock
	signal cd     : std_logic;  -- card detect
	signal wp     : std_logic;  -- write protect

	signal clr       : std_logic;                     -- global reset input
	signal clk       : std_logic;                     -- global clock input
	signal clk_25m       : std_logic;                     -- global clock input
							      -- uart serial signals
	--signal serIn     : std_logic;                     -- serial data input
	--signal serOut    : std_logic;                     -- serial data output
	-- transmit and receive internal interface signals
	signal intAddress: std_logic_vector(15 downto 0);  -- data byte to transmit
	signal intRdData : std_logic_vector(7 downto 0);  -- data byte received
	signal intWrData : std_logic_vector(7 downto 0);  -- data byte received
							  -- baud rate configuration register - see baudGen.vhd for details
	signal baudFreq  : std_logic_vector(11 downto 0); -- baud rate setting registers - see header description
	signal baudLimit : std_logic_vector(15 downto 0); -- baud rate setting registers - see header description
	signal baudClk   : std_logic;                     -- 
	signal signal_a  : std_logic_vector(7 downto 0);
	constant per_25m : time := 40 ns;


begin

	clr <= not RESET_n;
	signal_a <= x"be";

	u_uart : entity uart_lib.uart2BusTop
	generic map ( AW => 16)
	port map ( -- global signals
			 clr          => clr,
			 clk          => clk_25M,
			 -- uart serial signals
			 serIn        => UART_rxd,
			 serOut       => UART_txd,
			 -- internal bus to register file
			 intAccessReq => open,
			 intAccessGnt => '1',
			 intRdData    => intRdData,
			 intAddress   => intAddress,
			 intWrData    => intWrData,
			 intWrite     => open,
			 intRead      => open
		 );                         -- read control to register file

	-- when intREad = '1' then
	intRdData <= signal_a when intAddress=x"ABCD" else
		     X"55"    when intAddress=x"f00D" else
		     X"aa"    when intAddress=x"0baD" else
		     (others => '1');



	ila : entity xil_defaultlib.ila_uart
	port map(
			clk => clk_25m,
			probe0 => probe0
		);
	probe0(31 downto 16) <= intAddress;
	probe0(15 downto 8)  <= intRdData;
	probe0(7  downto 0)  <= intWrData;

	clk_mgr_1: entity xil_defaultlib.pll_100mhz_2_25mhz
	port map ( 
			 -- Clock out ports  
			 clk_25m => clk_25m,
			 -- Status and control signals                
			 reset => clr,
			 locked => locked,
			 -- Clock in ports
			 clk_100m => clk_100m
		 );

	-- Heart beat
	process(clk_25m) is
		variable count : integer;
	begin
		if rising_edge(clk_25m) then
			if (locked='0') then
				count := 0;
				LED(3) <= '0';
			else	       
				if count < 12000000 then
					count := count + 1;
					LED(3) <= '1';
				elsif count < 25000000 then
					count := count + 1;
					LED(3) <= '0';
				else
					count := 0;
				end if;
			end if;
		end if;
	end process;



end architecture struct;
