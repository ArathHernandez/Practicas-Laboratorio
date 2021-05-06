library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity P6Calculadora is
port(CLK: in STD_LOGIC;
 A, B: in STD_LOGIC_VECTOR(7 downto 0);
 SelOp: in STD_LOGIC_VECTOR(2 downto 0);
 SelDis:in STD_LOGIC;
 Signo: out STD_LOGIC;
 LED: out STD_LOGIC_VECTOR(2 downto 0);
 Display: out STD_LOGIC_VECTOR(7 downto 0);
 Enable1: out STD_LOGIC_VECTOR(3 downto 0));
end P6Calculadora;
architecture Behavioral of P6Calculadora is
component P6DISPLAY 
PORT (
CLK : IN STD_LOGIC; 
 D3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 D2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 D1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 D0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 S8 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
 EN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
);
end component;
signal Result: STD_LOGIC_VECTOR(7 downto 0);
signal AuxResult: STD_LOGIC_VECTOR(7 downto 0);
signal AuxSigno: STD_LOGIC;
constant SigP: std_logic:='0' ;
constant SigN: std_logic:='1' ;
Type state is (State0, State1, State2);
Signal Estado, SigEstado : state;
begin
process(A,B,SelOp)
 begin
 case SelOp is
 when "001" => AuxResult <= A+B; --Suma
 when "010" => AuxResult <= A-B; -- Resta
if(A>=B) then
 AuxSigno <= SigP ;
 else
 AuxSigno <= SigN ;
 end if;
 when "100" => AuxResult <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),4)); --Multiplicacion
 when others => AuxResult <= "00000000"; -- otros = 00000000
 end case;
 end process;
 
 process (CLK, SelDis)
 begin
 if (CLK = '1' and SelDis = '1') then
 Estado<=SigEstado;
 end if;
 end process;
process(Result,Estado) begin
 case Estado is
 when state0 =>
 Result <= A;
 SigEstado <= State1;
 when state1 =>
 Result <= B;
 SigEstado <= State2;
 when state2 =>
 Result <= AuxResult;
 SigEstado <= State0;
 end case;
 end process;
 LED <= SelOp;
 Signo <= AuxSigno;
DIS: P6DISPLAY port map(CLK, Result(3 downto 0), Result(3 downto 0), Result(3 downto 0), Result(3 downto 0), Display,
 Enable1);

end Behavioral;
