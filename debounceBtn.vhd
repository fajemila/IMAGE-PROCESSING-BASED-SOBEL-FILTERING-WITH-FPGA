library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bufferedDebouncedBtn is
    Port ( bouncey : in STD_LOGIC;
           clk : in STD_LOGIC;
           debounced : out STD_LOGIC);
end bufferedDebouncedBtn;

architecture Behavioral of bufferedDebouncedBtn is
signal sDebounced : STD_LOGIC := '0';
signal temp, temp2, temp3 : STD_LOGIC := '0';
begin
    process(clk) -- read the value that is stored every 0.01 seconds i.e. if the clock is 100 MHz
    variable count : INTEGER := 0; 
    begin
        if falling_edge(clk) then
            temp2 <= bouncey;
            temp3 <= temp2;
            if count >= 1000000 then
                sDebounced <= temp;
                count := 0;
            elsif sDebounced /= temp3 then
                temp <= temp3;
            end if;
            count := count + 1;
        end if;
    end process;
debounced <= sDebounced;
end Behavioral;
