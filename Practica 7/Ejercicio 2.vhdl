LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY EJ2 is
PORT(UD, CLK, CEP, CET, PE: IN std_logic;
     D: in std_logic_vector(7 downto 0);
     Q: out std_logic_vector(7 downto 0);
     TC: out std_logic);
END EJ2;

ARCHITECTURE BEHAVIORAL of EJ2 is
COMPONENT P74F169
PORT (UD, CLK1, CEP, CET, PE : in std_logic;
      D : in std_logic_vector( 3 downto 0);
      Q : out std_logic_vector (3 downto 0);
      TC: out std_logic);
END COMPONENT;
SIGNAL FRA: std_logic := '1';
SIGNAL NRA: std_logic := '0';
BEGIN
NRA <= not FRA;
C1: P74F169 PORT MAP(UD, CLK, '0', '0', PE, D(3 downto 0), Q(3 downto 0),FRA);
C2: P74F169 PORT MAP(UD, NRA, '0', '0', PE, D(7 downto 4), Q(7 downto 4),TC);
END BEHAVIORAL;
