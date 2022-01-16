library ieee;
use ieee.std_logic_1164.all;
entity mdl is
  port(
    a_i : in  std_logic_vector(6 downto 0);
    z_o : out std_logic_vector(3 downto 0));
end entity;


library ieee;
use ieee.numeric_std.all;
architecture syn of mdl is
begin

  process (a_i) is

    type mapping_t is array (0 to 6) of std_logic_vector(z_o'range);

    function mapping_fun return mapping_t is
      variable res_v : mapping_t;
    begin
      for i in 0 to 6 loop
        res_v(i) := std_logic_vector(to_signed(i, z_o'length));
      end loop;
      return res_v;
    end function;

    constant mapping : mapping_t := mapping_fun;

  begin
    z_o <= mapping(to_integer(unsigned(a_i)));
  end process;

end architecture;