library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity P5Alarma is
port(K1, K2, K3, K4, K5, K6, K7, K8, Button: in STD_LOGIC;
 M1, M2, M3, M4: out STD_LOGIC_VECTOR(3 downto 0));
End P5Alarma;

Architecture Behavioral of P5Alarma is
Signal HH1, HH2: STD_LOGIC_VECTOR(3 downto 0);
Signal BB1, BB2: STD_LOGIC_VECTOR(3 downto 0);
Begin
 BB1 <= K1&K2&K3&K4;
 BB2 <= K5&K6&K7&K8;
 HH1 <= "0000" when BB1 = "0000" else
 "0001" when BB1 = "0001" else
 "0010" when BB1= "0010" else
 "0011" when BB1 = "0011" else
 "0100" when BB1 = "0100" else
 "0101" when BB1 = "0101" else
 "0110" when BB1 = "0110" else
 "0111" when BB1 = "0111" else
 "1000" when BB1 = "1000" else
 "1001" when BB1 = "1001" else
 "1010" when BB1 = "1010" else
 "1011" when BB1 = "1011" else
 "0000";
 HH2 <= "0000" when BB2 = "0000" else
 "0001" when BB2 = "0001" else
 "0010" when BB2 = "0010" else
 "0011" when BB2 = "0011" else
 "0100" when BB2 = "0100" else
 "0101" when BB2 = "0101" else
 "0110" when BB2 = "0110" else
 "0111" when BB2 = "0111" else
 "1000" when BB2 = "1000" else
 "1001" when BB2 = "1001" else
 "1010" when BB2 = "1010" else
 "1011" when BB2 = "1011" else
 "0000";
M1 <= HH1 when Button = '0';
M2 <= HH2 when Button = '0';
M3 <= HH1 when Button = '1';
M4 <= HH2 when Button = '1';
End Behavioral;
