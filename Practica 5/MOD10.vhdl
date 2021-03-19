library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Entity P5MOD10 is
port(CLKB, SetB, ResetB, EnableQB: in STD_LOGIC;
QB: out STD_LOGIC_VECTOR(3 downto 0));
end P5MOD10;

Architecture Behavioral of P5MOD10 is
Component P5MOD6A
port(CLKA, SetA, ResetA, EnableQA: in STD_LOGIC;
QA: out STD_LOGIC_VECTOR(3 downto 0));
End component;
Signal L, O: STD_LOGIC;
signal QI1: STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
QB <= QI1;
L <= QI1(1) and QI1(3);
O <= L or ResetB;
F4: P5MOD6A port map (CLKB, SetB, O, EnableQB, QI1);
End Behavioral;
