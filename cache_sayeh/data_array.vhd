LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataArray is port(
		clk: in STD_LOGIC;	
        address: in STD_LOGIC_VECTOR(5 downto 0);
		wren: in STD_LOGIC; 
        wrdata: in STD_LOGIC_VECTOR(15 downto 0);
        data: out STD_LOGIC_VECTOR(15 downto 0));
end entity;

architecture Behavioral of dataArray is 

type arr is array (63 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
signal data_arr : arr;

begin 

	
	process(clk, wren, data_arr)
	begin
	
		if wren = '1' and clk = '1' then
            data_arr(to_integer(unsigned(address))) <= wrdata;
        end if;
	
		data <= data_arr(to_integer(unsigned(address)));
	
	end process;

end architecture;