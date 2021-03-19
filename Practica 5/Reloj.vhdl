library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity P5Reloj is
Port(CLKJ, SetJ, ResetJ, EnableQJ, Button1, Button2, Button3, Button4: in
STD_LOGIC;
 AA1, AA2, AA3, AA4, AA5, AA6, AA7, AA8: in STD_LOGIC;
 R1: out STD_LOGIC_VECTOR(7 downto 0);
 TA1: out STD_LOGIC_VECTOR(3 downto 0);
 LED1, LED2, LED3: out STD_LOGIC);
end P5Reloj;
Architecture Behavioral of P5Reloj is
component muestra
 Port(
 CLK : IN STD_LOGIC;
 V3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 V2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 V1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 V0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 R : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
 TA : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
End component;
  Component Practica5
 Port(CLKI : in STD_LOGIC;
         CLKO : out STD_LOGIC);
End component;

Component P5MOD60
 port(CLKD, SetD, ResetD, EnableQD: in STD_LOGIC;
 QD, QE: out STD_LOGIC_VECTOR(3 downto 0));
End component;

Component P5I12 is
port(CLKF, SetF, ResetF, EnableQF: in STD_LOGIC;
 QG: out STD_LOGIC_VECTOR(3 downto 0));
End component;

Component FFJK is
port(CLK, J, K, Set, Reset, EQ: in STD_LOGIC;
Q: out STD_LOGIC);
End component;
Component P5Alarma
port(K1, K2, K3, K4, K5, K6, K7, K8, Button: in STD_LOGIC;
 M1, M2, M3, M4: out STD_LOGIC_VECTOR(3 downto 0));
End component;
Signal CLK500 : STD_LOGIC := '0';
Signal QI6, QI7, QI8, QI9, QI10, QI11: STD_LOGIC_VECTOR
(3 downto
 0);
Signal QI12, QI13, QI14, QI15: STD_LOGIC_VECTOR(3 downto 0);
Signal ZZ, WW, AAA, BBB, CCC, DDD, FFF, GGG: STD_LOGIC;
signal PP1, PP2, PP3, PP4: STD_LOGIC_VECTOR(3 downto 0);
Begin
QI12 <= QI6 when Button1 = '0' else PP2;
QI13 <= QI7 when Button1 = '0' else PP1;
QI14 <= QI8 when Button1 = '0' else PP4;
QI15 <= QI9 when Button1 = '0' else PP3;
LED2 <= CLKJ;
FFF <= '0';
LED1 <= DDD;
LED3 <= DDD when QI6&QI7&QI8&QI9&GGG = PP2&PP1&PP4&PP3&FFF else '0';
ZZ <= QI7(3) and QI7(0);
WW <= ZZ and AAA and BBB and EnableQJ;
AAA <= QI11(0) and QI11(2);
BBB <= QI10(3) and QI10(0);
CCC <= AAA and BBB and EnableQJ;

Q20: FFJK port map (CLK500, '1', '1', SetJ, ResetJ, Button4, DDD);
Q19: FFJK port map (CLK500, '1', '1', SetJ, ResetJ, Button2, GGG);
  Q18: P5Alarma port map (AA1, AA2, AA3, AA4, AA5, AA6, AA7, AA8, Button3, PP1, PP2,
PP3, PP4);
Q17: P5MOD60 port map (CLK500, SetJ, ResetJ, EnableQJ, QI10, QI11);
Q16: P5MOD60 port map (CLK500, SetJ, ResetJ, CCC, QI6, QI7);
Q15: P5I12 port map (CLK500, SetJ, ResetJ, WW ,QI8);
Q14: P5I12 port map(CLK500, SetJ, ResetJ, WW ,QI9);
Q13: Practica5 port map (CLKJ, CLK500);
DISPLAY1 : muestra port map (CLKJ, QI15, QI14, QI13, QI12, R1, TA1);
end Behavioral;
