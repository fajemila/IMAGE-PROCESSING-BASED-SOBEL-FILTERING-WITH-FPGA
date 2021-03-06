library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_sobel_sync is
    Port ( clk_1		: in STD_LOGIC;
		   clk50MH_1	: in STD_LOGIC;
           sel1_1, sel2_1, resetPosition_1, BTNL_1, BTNR_1, BTNU_1, BTND_1, speed_1, sel_res_1 : in STD_LOGIC;
           hsync_1	: out STD_LOGIC;
           vsync_1	: out STD_LOGIC;
           r_1		: out STD_LOGIC_VECTOR (3 downto 0);
           g_1		: out STD_LOGIC_VECTOR (3 downto 0);
           b_1		: out STD_LOGIC_VECTOR (3 downto 0));
end my_sobel_sync;

architecture Behavioral of my_sobel_sync is
component Sync is
  Generic(
		  logoWidth		: INTEGER := 128;	-- Width of OAU Logo
		  logoHeight	: INTEGER := 128;	-- Height of OAU Logo
		  memSize		: INTEGER := 4		-- MSB of memory
		  );
  Port ( 
	clk 	: in STD_LOGIC;
	clk50MH	: in STD_LOGIC;
	sel1, sel2, resetPosition, BTNL, BTNR, BTNU, BTND, speed, sel_res : in STD_LOGIC;
	hsync, vsync : out STD_LOGIC;
	data_out : out STD_LOGIC_VECTOR(3 downto 0) );
end component;
component sobel_wrapper is
 generic (
 DATA_WIDTH : integer := 4 
 );
 port ( clk : in STD_LOGIC;
 ssel2 : in STD_LOGIC;
 fsync_in : in STD_LOGIC;
 rsync_in : in STD_LOGIC;
 pdata_in : in STD_LOGIC_VECTOR (3 downto 0);
 fsync_out : out STD_LOGIC;
 rsync_out : out STD_LOGIC;
 r_out : out STD_LOGIC_VECTOR (3 downto 0);
 g_out : out STD_LOGIC_VECTOR (3 downto 0);
 b_out : out STD_LOGIC_VECTOR (3 downto 0));
end component sobel_wrapper;
signal hsync_0, vsync_0,ssel : STD_LOGIC := '0';
signal r_0,r_k,g_k,b_k : STD_LOGIC_VECTOR(3 downto 0) ;
begin
mysync: Sync port map (clk => clk_1,
						clk50MH => clk50MH_1,
						sel1=> sel1_1, sel2=>sel2_1, resetPosition=>resetPosition_1, BTNL=>BTNL_1, BTNR=>BTNR_1, BTNU=>BTNU_1, BTND=>BTND_1, speed=>speed_1, sel_res=>sel_res_1,
						hsync=> hsync_0,
						vsync=> vsync_0,
						data_out=> r_0
						);
						
mysobel: sobel_wrapper generic map ( DATA_WIDTH=>4)
						port map (clk=> clk_1,
									ssel2=> sel2_1, 
									fsync_in=> vsync_0,
									rsync_in=> hsync_0,
									pdata_in=> r_0,
									fsync_out => vsync_1,
									rsync_out=> hsync_1,
									r_out=> r_k ,
									g_out=> g_k,
									b_out=> b_k );
r_1 <= r_k when (sel1_1 ='1') else r_0;
g_1 <= g_k when (sel1_1 ='1') else r_0;
b_1 <= b_k when (sel1_1 ='1') else r_0;
	
end Behavioral;
