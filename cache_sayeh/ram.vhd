library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is port(
		clk, reset_n, read, write : in std_logic;
        address : in STD_LOGIC_VECTOR(9 downto 0);
		indata : in STD_LOGIC_VECTOR (15 downto 0);
		outdata: out STD_LOGIC_VECTOR (15 downto 0);
		memDataready :out STD_LOGIC
     );
end entity;

architecture RTL of ram is 

	component cache is port(
		clk, write_to_cache, write, reset_n :in STD_LOGIC;
        address :in STD_LOGIC_VECTOR(9 downto 0);
        wrdata :in STD_LOGIC_VECTOR(15 downto 0);
        outdata :out STD_LOGIC_VECTOR(15 downto 0);
        hit: out STD_LOGIC
     );
	end component;
	
	component memory is
	generic (blocksize : integer := 1024);

	port (clk, writemem : in std_logic;
		addressbus: in std_logic_vector (9 downto 0);
		wrdata : in std_logic_vector (15 downto 0);
		outdata :out STD_LOGIC_VECTOR(15 downto 0);
		memdataready : out std_logic);
	end	component; 
	

	

	signal writemem : STD_LOGIC;
	signal memdatareadsy : STD_LOGIC;
	
	signal ram_Data_in,ram_Data_out:std_logic_vector(15 downto 0);
	
	signal write_to_cache_temp :STD_LOGIC; 
	signal write_temp : STD_LOGIC;
	signal hit_temp : STD_LOGIC; 
	
	signal cache_wrdata:std_logic_vector(15 downto 0);

 	type states is (s0, s1, s2, s3 );
	signal state : states := s0;


	
begin 

	mem : memory port map (clk, writemem, address, ram_Data_in ,ram_Data_out, memdatareadsy);
	ch : cache port map (clk, write_to_cache_temp, write_temp, reset_n, address,  cache_wrdata, outdata, hit_temp);
	

	
	process(clk)
	begin

		
			write_to_cache_temp <='0';
			write_temp<='0';
			writemem <= '0'; 
			
		
	if  clk'event and clk = '1' then
		case state is
			when s0=>
				write_to_cache_temp<='0';
				write_temp<='0';
				writemem <='0';
				if(write='1')then
					state<=s1;
				elsif(read='1')then
					state<=s2;
				end if;
			when s1=>
						  ram_Data_in<=indata;
				writemem<='1';
				write_temp<='1';
				state<= s0;   
			
			when s2=>
				if(hit_temp='1')then
					state<=s0;
					memDataready<= '1'; 
				elsif(hit_temp='0')then
					state<=s3;
				end if;	
			when s3=>
				cache_wrdata<=ram_Data_out;
				write_to_cache_temp<='1';
				write_to_cache_temp<=transport '0' after 10 ns;
				state<=s0;
				memDataready <= '1' ; 

				
		end case;
	end if;
	end process;
	


end architecture; 