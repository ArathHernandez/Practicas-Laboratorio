library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
Entity muestra is
Port (
CLK : in STD_LOGIC;
V3 : in STD_LOGIC_VECTOR(3 downto 0);
V2 : in STD_LOGIC_VECTOR (3 downto 0);
V1 : in STD_LOGIC_VECTOR (3 downto 0);
V0 : in STD_LOGIC_VECTOR (3 downto 0);
R: out STD_LOGIC_VECTOR (7 downto 0);
TA : out STD_LOGIC_VECTOR (3 downto 0)
);
End muestra;

Architecture Behavioral of muestra is
Signal Estado, NuevoEstado: STD_LOGIC_VECTOR (3 downto 0) := "1000";
Signal XH: STD_LOGIC_VECTOR(3 downto 0) := "0000";
Begin
Process (CLK)
Begin
IF (CLK = '1' AND CLK'EVENT) THEN
Estado <= NuevoEstado;
End IF;
End Process;
NuevoEstado <= "0001" When (Estado = "1000") Else
 "0010" When (Estado = "0001") Else
 "0100" When (Estado = "0010") Else
 "1000"  When (Estado = "0100") Else
 "0001";

XH <= V0 When (Estado = "0001") Else
V1 When (Estado = "0010") Else
V2 When (Estado = "0100") Else
V3 When (Estado = "1000") Else
"1111";

TA <= NOT STATE;

R <= "11000000" When TA = "0000" Else
         "11111001" When TA = "0001" Else
         "10100100" When TA = "0010" Else
         "10110000" When TA = "0011" Else
         "10011001" When TA = "0100" Else
         "10010010" When TA = "0101" Else
         "10000010" When TA = "0110" Else
         "11111000" When TA = "0111" Else
         "10000000" When TA = "1000" Else
         "10010000" When TA = "1001" Else
         "10001000" When TA = "1010" Else
         "10000011" When TA = "1011" Else
         "11000110" When TA = "1100" Else
         "10100001" When TA = "1101" ELse
         "10000110" When TA = "1110" Else
         "10001110";
End Behavioral;
