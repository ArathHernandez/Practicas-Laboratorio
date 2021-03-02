Entity adder is
Port(A, B, CaIn: IN std_logic;
     S, Co: out std_logic);
End adder;

Architecture structural of adder is
Component FullAdder is 
Port (X, Y, Cin: std_logic;
         Count, sum: out std_logic);
End component
Begin
FA: FullAdder port map (A, B, CaIn,Co,S);
End structural
