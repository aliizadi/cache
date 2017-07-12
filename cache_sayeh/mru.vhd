library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MRU_array is port(
		address : in STD_LOGIC_VECTOR(5 downto 0);
		    reset: in STD_LOGIC; 
		    way: in STD_LOGIC; 
		    valid0, valid1 : in STD_LOGIC; 
        inform : in STD_LOGIC;
        clk : in STD_LOGIC;
        output : out STD_LOGIC;
		ready: buffer STD_LOGIC
     );
end entity;

architecture behavorial of MRU_array is

    type arr is array (63 downto 0) of integer;
    signal MRU_array0 : arr := (others=>0);
    signal MRU_array1 : arr := (others=>0);
	signal virtual_clock : STD_LOGIC; 
	
begin
	
	virtual_clock <= clk and inform; 
		
    process (virtual_clock, reset)
    begin
		
		ready <= '0'; 
		
          
				
        if virtual_clock'event and virtual_clock = '1'  then
          
            if( MRU_array0(to_integer(unsigned(address))) > MRU_array1(to_integer(unsigned(address))) )then 
			         output <= '0' ;
			      else
			         output  <='1';  
			         
			      end if; 
          
          if(reset = '1') then
          
            if(way='0')then
		
              MRU_array0(to_integer(unsigned(address))) <= 0;
            
            else
          
              MRU_array1(to_integer(unsigned(address))) <= 0;
          
            
            end if;
         
         
          end if; 
          
            if(way='0')then
		      
              	MRU_array0(to_integer(unsigned(address))) <= MRU_array0(to_integer(unsigned(address))) + 1 ; 
          	
        	   else
          	
  	           	MRU_array1(to_integer(unsigned(address))) <= MRU_array1(to_integer(unsigned(address))) + 1 ; 
 	          
 	          end if; 
 	          ready<='1';
       
			        						 
			     ready<='1';
			     ready<=transport '0' after 10 ns;
			
        
    end if;

           
			 
    
		ready<=transport '0' after 10 ns;

    end process;
    
    
   


end behavorial;
