library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cache is port(
		clk, write_to_cache, write, reset_n :in STD_LOGIC;
        address :in STD_LOGIC_VECTOR(9 downto 0);
        wrdata :in STD_LOGIC_VECTOR(15 downto 0);
        outdata :out STD_LOGIC_VECTOR(15 downto 0);
        hit: out STD_LOGIC
     );
end entity;

architecture Behavioral of cache is 

component tagValidArray is port(

		 clk, reset_n: in STD_LOGIC;
         address: in STD_LOGIC_VECTOR(5 downto 0);
		 wren, invalidate : in STD_LOGIC; 
         wrdata: in STD_LOGIC_VECTOR(3 downto 0);
         output: out STD_LOGIC_VECTOR(4 downto 0)
     );
end component;

component missHitLogic is
    port(tag : in STD_LOGIC_VECTOR(3 downto 0);
         w0 : in STD_LOGIC_VECTOR(4 downto 0);
         w1 : in STD_LOGIC_VECTOR(4 downto 0);
         hit : out STD_LOGIC;
         w0_valid : out STD_LOGIC;
         w1_valid : out STD_LOGIC
     );
end component; 

component MRU_array is port(
		address : in STD_LOGIC_VECTOR(5 downto 0);
        inform : in STD_LOGIC;
        clk : in STD_LOGIC;
        output : out STD_LOGIC;
		ready: buffer STD_LOGIC
     );
end component;

component mux is port(
		sel:in STD_LOGIC;
        w0:in STD_LOGIC_VECTOR(15 downto 0);
        w1:in STD_LOGIC_VECTOR(15 downto 0);
        output: out STD_LOGIC_VECTOR(15 downto 0)
     );
end component; 

component dataArray is port(
		clk: in STD_LOGIC;	
        address: in STD_LOGIC_VECTOR(5 downto 0);
		wren: in STD_LOGIC; 
        wrdata: in STD_LOGIC_VECTOR(15 downto 0);
        data: out STD_LOGIC_VECTOR(15 downto 0));
end component; 

signal wren0 : STD_LOGIC := '0'; 
signal wren1 : STD_LOGIC := '0'; 

signal tagWren0 : STD_LOGIC := '0'; 
signal tagWren1 : STD_LOGIC := '0'; 


signal data0 : STD_LOGIC_VECTOR (15 downto 0);
signal data1 : STD_LOGIC_VECTOR (15 downto 0);

signal tagValid0 : STD_LOGIC_VECTOR (4 downto 0);
signal tagValid1 : STD_LOGIC_VECTOR (4 downto 0);

signal invalidate0, invalidate1 :STD_LOGIC;


signal ouput_MRU, ready_MRU : STD_LOGIC; 




signal hit_temp : STD_LOGIC;

signal w0_valid, w1_valid : STD_LOGIC;


signal w0_valid_MRU : STD_LOGIC;

 



begin 

	invalidate0 <= w0_valid and write;
	invalidate1 <= w1_valid and write; 
	
	tagWren0 <= wren0;
	tagWren1 <= wren1;
	
	wren0 <= (not tagValid0(4) and write_to_cache) or (not ouput_MRU and write_to_cache and ready_MRU);
	wren1 <= ((not tagValid1(4) and write_to_cache and tagValid0(4)) or ( ouput_MRU and write_to_cache and ready_MRU)) and (not tagWren0);	
	

	dataArray0 : dataArray port map (clk, address(5 downto 0), wren0, wrdata, data0);
	dataArray1 : dataArray port map (clk, address(5 downto 0), wren1, wrdata, data1);	
	-----------------
	tagValidArray0 : tagValidArray port map (clk, reset_n, address(5 downto 0), tagWren0, invalidate0, address(9 downto 6), tagValid0);
	tagValidArray1 : tagValidArray port map (clk, reset_n, address(5 downto 0), tagWren1, invalidate1, address(9 downto 6), tagValid1);
	-----------------
	miss_hit_logic : missHitLogic port map (address(9 downto 6), tagValid0, tagValid1, hit_temp, w0_valid => w0_valid, w1_valid => w1_valid ); 
	hit <= hit_temp; 
	-----------------
	MRU : MRU_array port map (address(5 downto 0), write_to_cache, clk,  output => ouput_MRU, ready => ready_MRU);
	-----------------
	muxOut : mux port map (w1_valid, data0, data1, outdata); 
	-----------------
	

end architecture; 