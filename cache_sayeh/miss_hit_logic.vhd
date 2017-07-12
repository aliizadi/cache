library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity missHitLogic is
    port(tag : in STD_LOGIC_VECTOR(3 downto 0);
         w0 : in STD_LOGIC_VECTOR(4 downto 0);
         w1 : in STD_LOGIC_VECTOR(4 downto 0);
         hit : out STD_LOGIC;
         w0_valid : out STD_LOGIC;
         w1_valid : out STD_LOGIC
     );
end entity;

architecture gate_level of missHitLogic is

	signal w0_equal_to_tag : STD_LOGIC; 
	signal w1_equal_to_tag : STD_LOGIC;
	
begin

	w0_equal_to_tag <= ( w0(3) xnor tag(3) ) and 
									( w0(2) xnor tag(2) ) and
									( w0(1) xnor tag(1) ) and
									( w0(0) xnor tag(0) );
	
	w1_equal_to_tag <= ( w1(3) xnor tag(3) ) and 
									( w1(2) xnor tag(2) ) and
									( w1(1) xnor tag(1) ) and
									( w1(0) xnor tag(0) );
									
	w0_valid <= w0_equal_to_tag and w0(4); 
	w1_valid <= w1_equal_to_tag and w1(4); 
    
    hit <= (w0_equal_to_tag and w0(4)) or 
			  (w1_equal_to_tag and w1(4));
			  
end architecture;


