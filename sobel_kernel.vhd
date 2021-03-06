library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity sobel_kernel is
 generic (
 DATA_WIDTH : integer := 4 );
 port ( 
 pclk_i : in std_logic;
 ssel2 : in std_logic;
 fsync_i : in std_logic;
 rsync_i : in std_logic;
 pData1 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData2 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData3 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData4 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData5 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData6 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData7 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData8 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 pData9 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
 
 fsync_o : out std_logic;
 rsync_o : out std_logic;
 r_out: out std_logic_vector(3 downto 0);
g_out: out std_logic_vector(3 downto 0);
b_out: out std_logic_vector(3 downto 0) );
 
end entity sobel_kernel;
architecture Behavioral of sobel_kernel is
signal pdata_o,pdata_o1: std_logic_vector(3 downto 0);
signal gauss:  std_logic_vector(6 downto 0);
component mdl is
  port(
    a_i : in  std_logic_vector(6 downto 0);
    z_o : out std_logic_vector(3 downto 0));
end component;
begin
 maper: work.mdl port map (a_i => gauss, z_o => pdata_o1);

 sobel_kernel: process (pclk_i)
 variable summax, summay : std_logic_vector(6 downto 0);
 variable summa1, summa2 : std_logic_vector(6 downto 0);
 variable summa: std_logic_vector(6 downto 0);
 
 
 begin 


 if (pclk_i'event and pclk_i = '1') then 
 
 rsync_o <= rsync_i;
 fsync_o <= fsync_i;
 
 if fsync_i = '1' then 
 if rsync_i = '1' then 
	if ssel2 = '1' then
	 summax:=("000" & pdata3)+("00" & pdata6 & '0')+("000" & pdata9)
	 -("000" & pdata1)-("00" & pdata4 & '0')-("000" & pdata7);
	 
	 summay:=("000" & pdata7)+("00" & pdata8 & '0')+("000" & pdata9)
	 -("000" & pdata1)-("00" & pdata2 & '0')-("000" & pdata3);
	 
	 -- Here is computed the absolute value of the numbers
	 if summax(6)='1' then
	 summa1:= not summax+1;
	 else
	 summa1:= summax; 
	 end if;
	 if summay(6)='1' then
	 summa2:= not summay+1;

	 else
	 summa2:= summay;
	 end if;
	 
	 summa:=summa1+summa2;
	 
	 -- Threshold = 7
	 if summa>"0000111" then 
	 pdata_o<=(others => '1');
	 else 
	 pdata_o<=(others=> '0');
	 end if;
 else
	 gauss <= (pdata5 & "000")-("000" & pdata2)-("000" & pdata4)-("000" & pdata6)-("000" & pdata8);
	 pdata_o <= pdata_o1;
end if;
 END IF;
 end if;
 end if; -- pclk_i

 
 end process sobel_kernel;
  r_out<= pdata_o(3 downto 0);
 g_out<= pdata_o(3 downto 0);
 b_out<= pdata_o(3 downto 0);
end Behavioral;