library IEEE;
use IEEE.std_logic_1164.all;

entity mux is port(
		sel:in STD_LOGIC;
        w0:in STD_LOGIC_VECTOR(15 downto 0);
        w1:in STD_LOGIC_VECTOR(15 downto 0);
        output: out STD_LOGIC_VECTOR(15 downto 0)
     );
end entity;

architecture RTL of mux is
begin

	output <= w0 when sel = '0' else
					w1 when sel = '1' else 
					"XXXXXXXXXXXXXXXX";
					
end architecture;