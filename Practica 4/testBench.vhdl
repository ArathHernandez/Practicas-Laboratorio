library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Practica4 is
--  Port ( );
end tb_Practica4;

architecture Behavioral of tb_Practica4 is
component Sum8 is
Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Selec : in STD_LOGIC;
           O : out STD_LOGIC;
           Sm : out STD_LOGIC_VECTOR (7 downto 0));
end component;
signal A_s, B_s : STD_LOGIC_VECTOR(7 downto 0) := ("00000000");
signal Selec_s: STD_LOGIC := '0';
signal O_s: STD_LOGIC;
signal Sm_s: STD_LOGIC_VECTOR(7 downto 0);
begin
DUT: Sum8
Port map (A => A_s,
B => B_s,
Selec => Selec_s,
O => O_s,
Sm => Sm_s);
Process
Begin
Selec_s <= '0';
A_s <= x"07";
B_s <= x"04";
Wait for 50 ns;
A_s <= x"0F";
B_s <= x"FA";
Wait for 50 ns;
A_s <= x"10";
B_s <= x"E8";
Wait for 50 ns;
A_s <= x"0F";
B_s <= x"FA";
Wait for 50 ns;
A_s <= x"10";
B_s <= x"E8";
Wait for 50 ns;
A_s <= x"FB";
B_s <= x"F7";
Wait for 50 ns;
A_s <= x"FB";
B_s <= x"F7";
Wait for 50 ns;
Selec_s <= '1';
A_s <= x"0F";
B_s <= x"06";
Wait for 50 ns;
A_s <= x"10";
B_s <= x"18";
Wait for 50 ns;
A_s <= x"02";
B_s <= x"01";
Wait for 50 ns;
A_s <= x"FA";
B_s <= x"0C";
Wait for 50 ns;
A_s <= x"00";
B_s <= x"00";
Wait;
End Process;
end Behavioral;
