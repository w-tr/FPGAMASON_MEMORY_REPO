library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_sp is
    generic
    (
        data_width     :  integer;
        address_width  :  integer;
        block_size     :  integer
    );
    port
    (
        clk       :  in std_logic; 
        rst       :  in std_logic;
        addr      :  in std_logic_vector(address_width-1 downto 0); 
        data_in   :  in std_logic_vector(data_width-1 downto 0);
        wr        :  in std_logic; 
        data_out  :  out std_logic_vector(data_width-1 downto 0)
    );
end entity bram_sp;

architecture rtl of bram_sp is
    type t_bram_array is array (0 to block_size ) of std_logic_vector (data_width-1 downto 0);
    signal bram : t_bram_array ;
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if rst then 
                bram <= (others => (others => '0'));
                data_out <= (others => '0');
            else
                data_out <= bram(to_integer(unsigned(addr)));
                if wr then
                    bram(to_integer(unsigned(addr))) <= data_in;
                end if;
            end if;
        end if;
    end process;
end architecture rtl;
