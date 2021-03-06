library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga3 is
    Port ( clk		: in STD_LOGIC;
		   clk50MH	: in STD_LOGIC;
           sel1, sel2,sel3, resetPosition, BTNL, BTNR, BTNU, BTND, speed, sel_res : in STD_LOGIC;
           hsync	: out STD_LOGIC;
           vsync	: out STD_LOGIC;
           r		: out STD_LOGIC_VECTOR (3 downto 0);
           g		: out STD_LOGIC_VECTOR (3 downto 0);
           b		: out STD_LOGIC_VECTOR (3 downto 0));
end vga3;

architecture Behavioral of vga3 is
component my_sobel_sync is
	Port ( clk_1		: in STD_LOGIC;
		   clk50MH_1	: in STD_LOGIC;
           sel1_1, sel2_1, resetPosition_1, BTNL_1, BTNR_1, BTNU_1, BTND_1, speed_1, sel_res_1 : in STD_LOGIC;
           hsync_1	: out STD_LOGIC;
           vsync_1	: out STD_LOGIC;
           r_1		: out STD_LOGIC_VECTOR (3 downto 0);
           g_1		: out STD_LOGIC_VECTOR (3 downto 0);
           b_1		: out STD_LOGIC_VECTOR (3 downto 0));
end component my_sobel_sync;
component clkpll1 IS
	PORT (inclk0: IN STD_LOGIC  := '0';
		  c0	: OUT STD_LOGIC ;
		  c1	: OUT STD_LOGIC ;
		  c2	: OUT STD_LOGIC );
END component clkpll1;
component bufferedDebouncedBtn is
    Port ( bouncey : in STD_LOGIC;
           clk : in STD_LOGIC;
           debounced : out STD_LOGIC);
end component bufferedDebouncedBtn;
signal sBTNU, sBTND, sBTNL, sBTNR, sResetPosition : STD_LOGIC := '0';
signal clk108MHz, clk100MHz, clk25MHz, sreset, sDispClk : STD_LOGIC := '0';
begin
    debBTNU: bufferedDebouncedBtn port map(bouncey=>BTNU,clk=>clk100MHz,debounced=>sBTNU);
    debBTND: bufferedDebouncedBtn port map(bouncey=>BTND,clk=>clk100MHz,debounced=>sBTND);
    debBTNL: bufferedDebouncedBtn port map(bouncey=>BTNL,clk=>clk100MHz,debounced=>sBTNL);
    debBTNR: bufferedDebouncedBtn port map(bouncey=>BTNR,clk=>clk100MHz,debounced=>sBTNR);
    debResPos: bufferedDebouncedBtn port map(bouncey=>not resetPosition,clk=>clk100MHz,debounced=>sResetPosition);
	myclk: clkpll1 port map(inclk0=>clk,c0=>clk108MHz,c1=>clk100MHz,c2=>clk25MHz);
	myDisp: my_sobel_sync 
				 port map(
						  clk_1	=> sDispClk,
						  clk50MH_1 => clk50MH,
						  sel1_1	=> sel1,
						  sel2_1	=> sel2,
						  resetPosition_1 => sResetPosition,
						  BTNL_1	=> sBTNL,
						  BTNR_1	=> sBTNR,
						  BTNU_1	=> sBTNU,
						  BTND_1	=> sBTND,
						  speed_1	=> speed,
						  sel_res_1 => sel_res,
						  hsync_1	=> hsync,
						  vsync_1	=> vsync,
						  r_1		=> r,
						  g_1		=> g,
						  b_1		=> b
						  );
	process(sel_res)
	begin
		if sel_res = '1' then
			sDispClk <= clk108MHz;
		else
			sDispClk <= clk25MHz;
		end if;
	end process;
end Behavioral;
