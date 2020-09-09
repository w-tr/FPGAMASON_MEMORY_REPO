-- dual port ram
Library IEEE;
USE IEEE.Std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity bram_dp is 
    generic
    (
        g_data_width : positive;
        g_address_width : positive;
        g_depth : positive -- could ceil(log(address) 2**addr
    );
    port
    (

        clk       :  in std_logic;
        rst       :  in std_logic;
        r_addr    :  in  std_logic_vector(4 downto 0);
        we        :  in std_logic;
        w_addr    :  in  std_logic_vector(4 downto 0);
        data_out  :  out std_logic_vector(7 downto 0);
        data_in   :  in std_logic_vector(7 downto 0)
    );
end bram_dp;

architecture rtl of bram_dp is  
    type t_bram_array is array (0 to g_depth) of std_logic_vector(g_depth-1 downto 0);
    signal bram_dp : mem_array;
begin  

    process(clk)
    begin 
        if(rising_edge(clk)) then
            if rst then
                bram_dp <= others => (others => '0');
            else
                if(we='1') then 
                    bram_dp(to_integer(unsigned(w_addr))) <= data_in;
                -- NOTE w_addr must be within block size
                end if;
            end if;      
        end if;
    end process;  
    data_out <= data_out2(to_integer(unsigned(r_addr(3 downto 0))));

end Behavioral; 
