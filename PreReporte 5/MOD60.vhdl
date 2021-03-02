library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity P5MOD60 is
Port(CLKD, SetD, ResetD, EnableQD: in STD_LOGIC;
QD, QE: out STD_LOGIC_VECTOR(3 downto 0));
end P5MOD60;

Architecture Behavioral of P5MOD60 is
Component P5MOD10
Port(CLKB, SetB, ResetB, EnableQB: in STD_LOGIC;
QB: out STD_LOGIC_VECTOR(3 downto 0));
End component;

Component P5MOD6
Port(CLKC, SetC, ResetC, EnableQC: in STD_LOGIC;
QC: out STD_LOGIC_VECTOR(3 downto 0));
End component;

Signal QI3, QI4: STD_LOGIC_VECTOR(3 downto 0);
Signal RR, RP: STD_LOGIC;
begin
QD <= QI3;
QE <= QI4;
RR <= QI(3) and QI(0);
RP <= RR and EnableQD;
F6: P5MOD10 port map(CLKD, SetD, ResetD, EnableQD, QI3);
F7: P5MOD6 port map(CLKD, SetD, ResetD, RP, QI4);
End Behavioral;
