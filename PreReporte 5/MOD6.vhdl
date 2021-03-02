library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity P5MOD6 is
port(CLKC, SetC, ResetC, EnableQC: in STD_LOGIC;
QC: out STD_LOGIC_VECTOR(3 downto 0));
End P5MOD6;

Architecture Behavioral of P6MOD6 is
Component P5MOD6A
port(CLKA, SetA, ResetA, EnableQA: in STD_LOGIC;
QA: out STD_LOGIC_VECTOR(3 downto 0));
end Component;

signal CC, Y: STD_LOGIC;
signal QI2: STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
QC <= QI2;
CC <= QI2(2) and QI2(1);
Y <= CC or ResetC;

F5: P5MOD6A port map (CLKC, SetC, Y, EnableQC, QI2);
End Behavioral;
