LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;



ENTITY tb_bram_sp IS
END tb_bram_sp;

ARCHITECTURE tb OF tb_bram_sp IS 

    --Inputs
    signal RAM_ADDR : std_logic_vector(6 downto 0) := (others => '0');
    signal RAM_DATA_IN : std_logic_vector(7 downto 0) := (others => '0');
    signal RAM_WR : std_logic := '0';
    signal RAM_CLOCK : std_logic := '0';
    signal rst : std_logic;

    --Outputs
    signal RAM_DATA_OUT : std_logic_vector(7 downto 0);

    -- Clock period definitions
    constant RAM_CLOCK_period : time := 10 ns;

BEGIN


    -- Instantiate the single-port RAM in VHDL
    uut: entity work.bram_sp 
    generic map 
    (
        data_width     => RAM_DATA_IN'length,
        address_width  => RAM_ADDR'length,
        block_size     => 128
    )
    PORT MAP 
    (
        clk       => ram_clock,
        rst       => rst,
        addr     => RAM_ADDR,
        DATA_IN  => RAM_DATA_IN,
        WR       => RAM_WR,
        DATA_OUT => RAM_DATA_OUT
    );

    -- Clock process definitions
    RAM_CLOCK_process :process
    begin
        RAM_CLOCK <= '0';
        wait for RAM_CLOCK_period/2;
        RAM_CLOCK <= '1';
        wait for RAM_CLOCK_period/2;
    end process;

    rst <= '1', '0' after 199 ns;

    stim_proc: process
    begin  
        RAM_WR <= '0'; 
        RAM_ADDR <= "0000000";
        RAM_DATA_IN <= x"FF";
        wait until rst = '0';
        wait for 100 ns; 
        -- start reading data from RAM 
        for i in 0 to 5 loop
            RAM_ADDR <= RAM_ADDR + "0000001";
            wait for RAM_CLOCK_period*5;
            wait until rising_edge(ram_clock);
        end loop;
        RAM_ADDR <= "0000000";
        RAM_WR <= '1';
        -- start writing to RAM
        wait for 100 ns; 
        for i in 0 to 5 loop
            RAM_ADDR <= RAM_ADDR + "0000001";
            RAM_DATA_IN <= RAM_DATA_IN-x"01";
            wait for RAM_CLOCK_period*5;
            wait until rising_edge(ram_clock);
        end loop;  
        RAM_WR <= '0';
        wait;
    end process;

END;
