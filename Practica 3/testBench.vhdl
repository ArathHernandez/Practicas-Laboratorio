-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2021 03:04:16 PM
-- Design Name: 
-- Module Name: TB_Practica3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_source02 is
--Port ( );
end tb_source02;
--Conexión del testbench al diseño deseado. En este caso "source02"
architecture Behavioral of tb_source02 is
component source02 is 
Port (P1 : in STD_LOGIC;
      P2 : in STD_LOGIC;
From Juan Carlos Serrato to Everyone:  03:05 PM
P3 : in STD_LOGIC;
      A : out STD_LOGIC;
      B : out STD_LOGIC;
      C : out STD_LOGIC;
      D : out STD_LOGIC);
end component;
--Creación de señales de estimulación y monitoreo
signal P1_s : STD_LOGIC;
signal P2_s : STD_LOGIC;
signal P3_s : STD_LOGIC;
signal A_s : STD_LOGIC :='0';
signal B_s : STD_LOGIC :='0';
signal C_s : STD_LOGIC :='0';
signal D_s : STD_LOGIC :='0';

begin
--Mapeo de entradas y salidas a señales del testbench
DUT: source02 port map(P1 => P1_s,P2 => P2_s,P3 => P3_s,A => A_s,B => B_s,C => C_s,D => D_s);--Estimulación de entradas mediante señales de testbench
process
begin
P1_s <= '0';
P2_s <= '0';
P3_s <= '0';
wait for 10 ns;
P1_s <= '0';
P2_s <= '0';
P3_s <= '1';
wait for 10 ns;
P1_s <= '0';
P2_s <= '1';
P3_s <= '0';
wait for 10 ns;
P1_s <= '0';
P2_s <= '1';
P3_s <= '1';
wait for 10 ns;
P1_s <= '1';
P2_s <= '0';
P3_s <= '0';
wait for 10 ns;
P1_s <= '1';
P2_s <= '0';
P3_s <= '1';
wait for 10 ns;
P1_s <= '1';
P2_s <= '1';
P3_s <= '0';
wait for 10 ns;
P1_s <= '1';
P2_s <= '1';

P3_s <= '1';
wait;
end process;
end Behavioral;
