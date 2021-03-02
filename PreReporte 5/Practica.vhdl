library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity Practica5 is
Port(CLKI : in STD_LOGIC;
        CLKO : out STD_LOGIC);
End Practica5;

Architecture Behavioral of Practica5 is
Signal Contador : Integer Range 0 to 99_999 := 0;
Signal C: STD_LOGIC;

Begin
Process (CLKI)
Begin
IF rising_edge(MCLK) Then
IF Contador = 99_999 Then
Contador <= 0;
C <= not C;
Else Contador <= Contador + 1;
End IF;
Else NULL;
End IF;
End Process;
CLKO <= C;
End Behavioral;
