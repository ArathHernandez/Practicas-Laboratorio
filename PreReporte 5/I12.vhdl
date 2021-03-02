library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity P5I12is
port(CLKF, SetF, ResetF, EnableQF: in STD_LOGIC;
QG, QH: out STD_LOGIC_VECTOR(3 downto 0));
End P5I12;

architecture Behavioral of P5I12 is
Component P5MOD10
Port(CLKB, SetB, ResetB, EnableQB: in STD_LOGIC;
QB: out STD_LOGIC_VECTOR(3 downto 0));
End Component;

Component Practica05_MOD6
Port(CLKC, SetC, ResetC, EnableQC: in STD_LOGIC;
QC: out STD_LOGIC_VECTOR(3 downto 0));
End Component;

Signal QI6, QI7: STD_LOGIC_VECTOR(3 downto 0);
Signal RR, RP, NN1, NN2: STD_LOGIC;
begin
QG <= QI6;
QH <= QI7;
NN1 <= QI6(1);
NN2 <= QI7(0);
RR <= NN1 or ResetF;
RP <= NN2 or ResetF;
F6: P5MOD10 port map(CLKF, SetF, RR, EnableQF, QI6);
F7: P5MOD6 port map(CLKF, SetF, RP, EnableQF, QI7);
End Behavioral;
