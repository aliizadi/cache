library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tagValidArray is port(

		 clk, reset_n: in STD_LOGIC;
         address: in STD_LOGIC_VECTOR(5 downto 0);
		 wren, invalidate : in STD_LOGIC; 
         wrdata: in STD_LOGIC_VECTOR(3 downto 0);
         output: out STD_LOGIC_VECTOR(4 downto 0)
     );
end entity;

architecture Behavioral of tagValidArray is 

type arr is array (63 downto 0) of STD_LOGIC_VECTOR(4 downto 0);

signal tag_arr : arr := (others => "11111"); 

begin 

	    output <= tag_arr(to_integer(unsigned(address)));

		process(clk,wren, tag_arr)
		begin
			
			if reset_n = '1'  then
				tag_arr <= (others => "11111");
			end if;
		
			if wren = '1' and clk = '1'  then
				tag_arr(to_integer(unsigned(address)))(3 downto 0) <= wrdata;
			end if;

			if (not invalidate) = '1' and clk = '1' then
				tag_arr(to_integer(unsigned(address)))(4) <= '1';
			end if;

			if invalidate ='1' and clk = '1'  then
				tag_arr(to_integer(unsigned(address)))(4) <= '0';
			end if;
			
		end process;

end architecture;