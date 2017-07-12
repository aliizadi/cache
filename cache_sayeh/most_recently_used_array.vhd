library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MRU_array is port(
		address : in STD_LOGIC_VECTOR(5 downto 0);
        inform : in STD_LOGIC;
        clk : in STD_LOGIC;
        output : out STD_LOGIC;
		ready: buffer STD_LOGIC
     );
end entity;

architecture behavorial of MRU_array is

    type arr is array (63 downto 0) of std_logic;
    signal MRU_array : arr := (others=>'0');
	signal reset : STD_LOGIC := '0'; 
	signal virtual_clock : STD_LOGIC; 
	
begin
	
	virtual_clock <= clk and inform; 
		
    process (virtual_clock, reset)
    begin
		
		ready <= '0'; 
		
        if(reset = '1') then
		
            MRU_array(to_integer(unsigned(address))) <= '0';
				
        elsif virtual_clock'event and virtual_clock = '1'  then
		
          	MRU_array(to_integer(unsigned(address))) <= MRU_array(to_integer(unsigned(address))) xor '1';
			     output <= MRU_array(to_integer(unsigned(address)));						 
			     ready<='1';
			     ready<=transport '0' after 10 ns;
			
        end if;

		ready<=transport '0' after 10 ns;

    end process;
end behavorial;