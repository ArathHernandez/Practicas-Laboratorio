library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FFJK is
port(CLK, J, K, Set, Reset, EQ: in STD_LOGIC;
Q: out STD_LOGIC);
end FFJK;

architecture behavioral of FFJK is
signal QI: STD_LOGIC;
begin
Q<= QI;
process(CLK, Set, Reset)
begin
if Reset='1' then QI<= '0';
elsif Set='1' then QI <='1';
elsif (rising_edge(CLK)) then
QI<= (J and not QI) or (not K and QI);
end if;
end process;
end behavioral;
