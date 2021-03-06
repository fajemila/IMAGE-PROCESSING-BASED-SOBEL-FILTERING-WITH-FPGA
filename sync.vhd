library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Sync is
  Generic(
		  logoWidth		: INTEGER := 227;	-- Width of OAU Logo
		  logoHeight	: INTEGER := 222;	-- Height of OAU Logo
		  memSize		: INTEGER := 7	-- MSB of memory
		  );
	Port ( clk 	: in STD_LOGIC;
	clk50MH	: in STD_LOGIC;
	sel1, sel2,sel3, resetPosition, BTNL, BTNR, BTNU, BTND, speed, sel_res : in STD_LOGIC;
	hsync, vsync : out STD_LOGIC;
	data_out : out STD_LOGIC_VECTOR(3 downto 0) );
end Sync;

architecture mySync of Sync is
component imageROM IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		rden		: IN STD_LOGIC  := '1';
		q			: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
end component imageROM;
component imageROM2 IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		rden		: IN STD_LOGIC  := '1';
		q			: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
end component imageROM2;
signal logoAddr		: STD_LOGIC_VECTOR (15 DOWNTO 0) := (others=>'0');
signal logoClk		: STD_LOGIC := '0';
signal logoRden		: STD_LOGIC := '1';
signal logoOut,logoOut1,logoOut2		: STD_LOGIC_VECTOR (3 DOWNTO 0) := (others=>'0');
signal vAddr		: INTEGER := 0;
signal vAddr2		: INTEGER := 0;
signal vlogoAddr	: UNSIGNED(15 downto 0) := (others=>'0');
constant imgOffset	: INTEGER := 4;

signal hpos : INTEGER := 0;
signal vpos : INTEGER := 0;
signal xpos, xpos2 : INTEGER := 500;
signal ypos, ypos2 : INTEGER := 200;
signal size : INTEGER := 50;
signal thickness : INTEGER := 10;
signal drawSquare, drawCircle : STD_LOGIC := '0';
------------Signals that are used to hold display parameters--------------------
signal hfp : INTEGER := 48;	-- Horizontal front porch
signal hpw : INTEGER := 112;	-- Horizontal width of sync signal
signal hbp : INTEGER := 248;	-- Horizontal back porch
signal hst : INTEGER := 1280;	-- Horizontal signal time
signal vfp : INTEGER := 1;	-- Vertical front porch
signal vpw : INTEGER := 3;	-- Vertical width of sync signal
signal vbp : INTEGER := 38;	-- Vertical back porch
signal vst : INTEGER := 1024;	-- Vertical signal time
------------Parameters for 1280 x 1024 displays (108 MHz)-----------------------
constant hfp1280 : INTEGER := 48;	-- Horizontal front porch
constant hpw1280 : INTEGER := 112;	-- Horizontal width of sync signal
constant hbp1280 : INTEGER := 248;	-- Horizontal back porch
constant hst1280 : INTEGER := 1280;	-- Horizontal signal time
constant vfp1280 : INTEGER := 1;	-- Vertical front porch
constant vpw1280 : INTEGER := 3;	-- Vertical width of sync signal
constant vbp1280 : INTEGER := 38;	-- Vertical back porch
constant vst1280 : INTEGER := 1024;	-- Vertical signal time
------------Parameters for 640 x 480 displays (25 MHz)-----------------------
constant hfp640 : INTEGER := 13;	-- Horizontal front porch
constant hpw640 : INTEGER := 95;	-- Horizontal width of sync signal
constant hbp640 : INTEGER := 47;	-- Horizontal back porch
constant hst640 : INTEGER := 640;	-- Horizontal signal time
constant vfp640 : INTEGER := 13;	-- Vertical front porch
constant vpw640 : INTEGER := 2;	-- Vertical width of sync signal
constant vbp640 : INTEGER := 33;	-- Vertical back porch
constant vst640 : INTEGER := 480;	-- Vertical signal time
begin
    
    -------------------------------------------------------------------
    ------- Connect to ROM --------------------------------------------
    mm1: imageROM port map (address => logoAddr, clock => logoClk, rden => logoRden, q => logoOut1);
	 mm2: imageROM2 port map (address => logoAddr, clock => logoClk, rden => logoRden, q => logoOut2);
--	 mm3: imageROM port map (address => logoAddr, clock => logoClk, rden => logoRden, q => logoOut);
	logoClk <= clk50MH;
    -------------------------------------------------------------------
	
	
	process(clk)
	variable count : INTEGER := 0;
	begin
		if rising_edge(clk) then
			----- Select Dispalay -----
			if sel_res = '1' then
				hfp <= hfp1280;
				hpw <= hpw1280;
				hbp <= hbp1280;
				hst <= hst1280;
				vfp <= vfp1280;
				vpw <= vpw1280;
				vbp <= vbp1280;
				vst <= vst1280;
			else
				hfp <= hfp640;
				hpw <= hpw640;
				hbp <= hbp640;
				hst <= hst640;
				vfp <= vfp640;
				vpw <= vpw640;
				vbp <= vbp640;
				vst <= vst640;
			end if;
		    if speed = '1' then --for speed of motion of item
		        count := count + 5;
		    else
                count := count + 2;
            end if;
	        
            
            
            
            ----------------Draw on screen-----------------------------
		    --- Draw Square ---
		    
		 
		    --- Image to Display ---
			 if ((hpos >= (hfp+hpw+hbp+hst/2-logoWidth/2) and hpos < (hfp+hpw+hbp+hst/2+logoWidth/2)) and (vpos >= (vfp+vpw+vbp+vst/2-logoHeight/2) and vpos < (vfp+vpw+vbp+vst/2+logoHeight/2))) then
		      vAddr  <= hpos - (hfp+hpw+hbp+hst/2-logoWidth/2);
			  vAddr2 <= vpos - (vfp+vpw+vbp+vst/2-logoHeight/2);
			  vlogoAddr <= to_unsigned(vAddr + vAddr2*(logoWidth), vlogoAddr'length);
			  logoAddr <= std_logic_vector(vlogoAddr + imgOffset);
			  if sel3 = '0' then
			  data_out <=logoOut2(3 downto 0);
			  else 
			  data_out <= logoOut2(3 downto 0);
			  end if;
			  --g <= logoOut(3 downto 0);
			  --b <= logoOut(3 downto 0);

		  

		    --- Black Background ---
		    else
		      data_out <= (others=>'0');
		     -- g <= (others=>'0');
		      --b <= (others=>'0');
		    end if;
------------ Increment hpos every clock tick and vpos on horizontal retrace ------------------------
			if (hpos < (hfp + hpw + hbp + hst)) then
				hpos <= hpos + 1;
			else
				hpos <= 0;
				if (vpos <= (vfp + vpw + vbp + vst)) then
					vpos <= vpos + 1;
				else
					vpos <= 0;
				end if;
			end if;
------------ Generate hsync and vsync pulses and make rgb black when doing so ------------------------
			if (hpos >= hfp) and (hpos < (hfp + hpw)) then 
				hsync <= '0';
			else
				hsync <= '1';
			end if;
			if (vpos >= vfp) and (vpos < (vfp + vpw)) then 
					vsync <= '0';
				else
					vsync <= '1';
			end if;
			if (((hpos >= 0) and hpos <= (hfp+hpw+hbp)) or ((vpos >= 0) and hpos <= (vfp+vpw+vbp)))then
				data_out <= x"0";
				--g <= x"0";
				--b <= x"0";
			end if;
		end if;
	end process;

end architecture mySync;







