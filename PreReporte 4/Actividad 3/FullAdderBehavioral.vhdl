Entity Sum8 is
Port(v1, v2: IN std_logic vector(7 downtown 0);
        Selec: IN std_logic;
        S: OUT std_logic vector(7 downtown 0);
        F: out std_logic);
End Sum8;

Architecture behavioral of Sum8 is
Component FullAdder is 
Port (X, Y, Cin: std_logic;
         Count, sum: out std_logic);
End component
Signal R: std_logic vector (7 downto 0);
Signal K: std_logic vector (7 downto 0);
Begin
R(0) <= v2(0) XOR Selec;
R(1) <= v2(1) XOR Selec;
R(2) <= v2(2) XOR Selec;
R(3) <= v2(3) XOR Selec;
R(4) <= v2(4) XOR Selec;
R(5) <= v2(5) XOR Selec;
R(6) <= v2(6) XOR Selec;
R(7) <= v2(7) XOR Selec;
FA0: FullAdder port map (v1(0), R(0), Selec, K(1), S(0));
FA1: FullAdder port map (v1(1), R(1), K(1), K(2), S(1));
FA2: FullAdder port map (v1(2), R(2), K(2), K(3), S(2));
FA3: FullAdder port map (v1(3), R(3), K(3), K(4), S(3));
FA4: FullAdder port map (v1(4), R(4), K(4), K(5), S(4));
FA5: FullAdder port map (v1(5), R(5), K(5), K(6), S(5));
FA6: FullAdder port map (v1(6), R(6), K(6), K(7), S(6));
FA7: FullAdder port map (v1(7), R(7), K(7),F, S(7));
End behavioral
