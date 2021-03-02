library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Entity P5Reloj is
Port(CLKJ, SetJ, ResetJ, EnableQJ, CLKK, Button1, Button2, Button3, Button4: in
STD_LOGIC;
 AA1, AA2, AA3, AA4, AA5, AA6, AA7, AA8: in STD_LOGIC;
 R1: out STD_LOGIC_VECTOR(7 downto 0);
 TA1: out STD_LOGIC_VECTOR(3 downto 0);
 LED1, LED2, LED3: out STD_LOGIC);
end P5Reloj;
