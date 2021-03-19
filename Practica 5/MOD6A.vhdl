library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Entity P5MOD6A is
Port(CLKA, SetA, ResetA, EnableQA: in STD_LOGIC;
QA: out STD_LOGIC_VECTOR(3 downto 0));
end P5MOD6A;

Architecture Behavioral of P5MOD6A is
Component FFJK
port(CLK, J, K, Set, Rset, EnableQ: in STD_LOGIC;
 Q: out STD_LOGIC);
end component FFJK;
signal W: STD_LOGIC_VECTOR(3 downto 0);
signal Z, U: STD_LOGIC;
begin
QA <= W;
Z <= W(0) and W(1);
U <= W(0) and W(1) and W(2);
F0: FFJK port map (CLKA, '1', '1', SetA, ResetA, EnableQA, W(0));
F1: FFJK port map (CLKA, W(0), W(0), SetA, ResetA, EnableQA,W(1));
F2: FFJK port map (CLKA, Z, Z, SetA, ResetA, EnableQA, W(2));
F3: FFJK port map (CLKA, U, U, SetA, ResetA, EnableQA, W(3));
end Behavioral;
