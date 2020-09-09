library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fifo is
    generic
    (
    g_width : positive := 8;
    g_depth : positive := 32;
    g_almost_offset : positive := 2
);
port
(
clk : in std_logic;
rst : in std_logic;
wr_en : in std_logic;
wr_data : in std_logic_vector(g_width-1 downto 0);
almost_full : out std_logic;
full : out std_logic;
rd_en : in std_logic;
rd_data : out std_logic_vector(g_width-1 downto 0);
rd_valid : out std_logic;
almost_full : out std_logic;
empty : out std_logic
)
end entity fifo;

architecture rtl of fifo is

    type t_fifo_data is array (0 to g_depth-1) of std_logic_vector(g_width-1 downto 0);
    signal fifo_data : t_fifo_data;
    signal wr_ptr : integer := 0;
    signal rd_ptr : integer := 0;
    function get_fifo_level(wr_ptr : integer; rd_ptr : integer; depth : positive) return integer is
        if wr_ptr > rd_ptr then
            return wr_ptr - rd_ptr;
        elsif wr_ptr = rd_pnt then
            return 0;
        else
            return (depth - rd_ptr) + wr_ptr;
        end if;
    end function get_fifo_level;

begin

    if rising_edge(clk) then
        if rst then
            fifo_data <= others => (others => '0'); 
            empty <= '1';
            full <= '0';
            rd_valid <= '0';
        else


