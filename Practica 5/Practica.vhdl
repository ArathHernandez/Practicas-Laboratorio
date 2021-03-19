PRACTICA5
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity Practica5 is
Port(CLKI : in STD_LOGIC;
        CLKO : out STD_LOGIC);
End Practica5;

Architecture Behavioral of Practica5 is
Signal Contador : Integer Range 0 to 49_999_999 := 0;
Signal C: STD_LOGIC;

Begin
Process (CLKI)
Begin
IF rising_edge(CLKI) Then
IF Contador = 49_999_999 Then
Contador <= 0;
C <= not C;
Else Contador <= Contador + 1;
End IF;
Else NULL;
End IF;
End Process;
CLKO <= C;
End Behavioral;
