library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	generic (blocksize : integer := 1024);

	port (clk, writemem : in std_logic;
		addressbus: in std_logic_vector (9 downto 0);
		wrdata : in std_logic_vector (15 downto 0);
		outdata :out STD_LOGIC_VECTOR(15 downto 0);
		memdataready : out std_logic);
end entity memory;

architecture behavioral of memory is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
begin
  	process (clk)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
	
   -- cwp
buffermem(0) := "0000000000000110";

-- mil r0, 01011101
buffermem(1) := "1111000001011101";

-- mih r0, 00000101
buffermem(2) := "1111000100000101";

-- mil r1, 00000001
buffermem(3) := "1111010000000001";

buffermem(64) := "0000000001110100" ;

-- mih r1, 00000000
buffermem(192) := "1111010100000000";
-- add r1, r0
  

     
			init := false;
		end if;

		memdataready <= '0';

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if writemem = '0' then -- Readiing :)
				memdataready <= '1';
				if ad >= blocksize then
					outdata <= (others => 'Z');
				else
					outdata <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				memdataready <= '1';
				if ad < blocksize then
					buffermem(ad) := wrdata;
				end if;
			end if;
		end if;
	end process;
end architecture behavioral;