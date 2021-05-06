library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY PWM is
generic( Max: natural := 500000);
Port (clk : in STD_LOGIC;--reloj de 50MHz
 botonselector : in std_logic;
 PWM : out STD_LOGIC;
 S8: out std_logic_vector(7 downto 0);
 EN: out std_logic_vector (3 downto 0));
end PWM;
ARCHITECTURE behavioral of PWM is
component Practica09_Display is
port (
CLK : IN STD_LOGIC;
D3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
D2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
D1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
D0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
S8 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
EN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
);
end component;
signal Contador:integer:=1;signal Contador2 :integer:=1;
signal PWM_Count: integer range 1 to Max;--500000;
signal selectorPosicion : STD_LOGIC_VECTOR (2 downto 0);
Type state is (state0, state45, state90,state135,state180);
Signal servo_state, nx_state : state;
signal DD0: std_Logic_vector(3 downto 0); 
signal DD1: std_Logic_vector(3 downto 0); 
signal DD2: std_Logic_vector(3 downto 0); 
signal DD3: std_Logic_vector(3 downto 0); 
signal Clock50 : std_logic ;
signal reset : std_logic ;
signal locked : std_logic ;
component clk_wiz_0
port
(-- Clock in ports
 -- Clock out ports
 clk_out1 : out std_logic;
 -- Status and control signals
 reset : in std_logic;
 locked : out std_logic;
 clk_in1 : in std_logic
);
end component;
beginClock_50_MHZ : clk_wiz_0
 port map ( 
 -- Clock out ports 
 clk_out1 => Clock50, --clock salida
 -- Status and control signals 
 reset => reset,
 locked => locked,
 -- Clock in ports
 clk_in1 => clk -- Clock Entrada
);
--Maquina estados
process(Clock50,botonselector)
begin 
if ((rising_edge(Clock50)) and (botonselector = '1')) then
servo_state<=nx_state;
end if;
end process;
process(servo_state,selectorPosicion)
begin
case servo_state is
when state0 =>
selectorPosicion <= "000";
nx_state <=state45;
when state45 => 
selectorPosicion <= "001";
nx_state <=state90;
when state90 => 
selectorPosicion <= "010";nx_state <=state135;
when state135 =>
selectorPosicion <= "011";
nx_state <=state180;
when state180 =>
selectorPosicion <= "100";
nx_state <=state0;
end case;
end process;
generacion_PWM:
process( Clock50, selectorPosicion,PWM_Count,Contador)
 constant pos1: integer := 50000;
 constant pos2: integer := 62500; 
begin 
case (selectorPosicion) is
when "000" =>
if (Contador2 = 1) then
PWM_Count <= 1;
Contador2 <= 2;
end if;
if rising_edge(Clock50) then 
if (Contador = 1) then
PWM_Count <= PWM_Count + 1;
else 
 PWM_Count <= 1;
PWM <= '0';
end if;
end if;
if ((PWM_Count < pos1) and (Contador=1)) then  PWM <= '1';
else 
 PWM <= '0';
Contador <= 2;
end if;
when "001" =>
if (Contador2=2) then
PWM_Count<=1;
Contador2<=3;
end if;
if rising_edge(Clock50) then 
if (Contador)=2 then
PWM_Count <= PWM_Count + 1;
else 
 PWM_Count <= 1;
 PWM <= '0';
 end if;
 end if;
 if ((PWM_Count < pos2) and (Contador=2)) then 
 PWM <= '1';
 DD0 <= "0101";
 DD1 <= "0100";
 DD2 <= "0000";
 DD3 <= "0000";
else 
PWM <= '0';
 Contador <= 3;
 end if; 
when "010" =>
 if (Contador2 = 3) thenPWM_Count <= 1;
Contador2 <= 4;
end if;
if rising_edge(Clock50) then 
if Contador = 3 then
PWM_Count <= PWM_Count + 1;
else 
 PWM_Count <= 1;
 PWM <= '0';
end if;
 end if;
if ((PWM_Count < pos2) and (Contador=3)) then 
 PWM <= '1';
 DD0 <= "0000";
 DD1 <= "1001";
 DD2 <= "0000";
 DD3 <= "0000";
else 
PWM <= '0';
Contador <= 4;
end if;
when "011" =>
if (Contador2 = 4) then
PWM_Count <= 1;
Contador2 <= 5;
end if;
if rising_edge(Clock50) then 
if Contador=4 then
PWM_Count <= PWM_Count + 1;
else PWM_Count <= 1;
PWM <= '0';
end if;
end if;
if ((PWM_Count < pos2) and (Contador=4)) then 
 PWM <= '1';
 DD0 <= "0101";
 DD1 <= "0011";
 DD2 <= "0001";
 DD3 <= "0000"; 
else 
 PWM <= '0';
 Contador <= 5;
end if;
when "100" =>
if (Contador2 = 5) then
PWM_Count <= 1;
Contador2 <= 1;
end if;
if rising_edge(Clock50) then 
if Contador = 5 then
PWM_Count <= PWM_Count + 1;
else 
 PWM_Count <= 1;
 PWM <= '0';
end if;
end if;
if ((PWM_Count < pos2) and (Contador=5)) then 
 PWM <= '1';
 DD0 <= "0000"; DD1 <= "1000";
 DD2 <= "0001";
 DD3 <= "0000";
else 
PWM <= '0';
Contador <= 1;
end if;
when others => null;
end case;
end process generacion_PWM;
DISPLAY: Practica09_Display port map(Clock50, DD0, DD1, DD2, DD3, S8, EN);
end behavioral;
