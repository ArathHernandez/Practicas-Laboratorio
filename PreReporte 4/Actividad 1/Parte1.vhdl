Entity FullAdder is
port (X, Y, Cin: in STD_LOGIC;
      Cout, Sum: out STD_LOGIC);
End FullAdder

architecture Equations of FullAdder is
begin
Sum <= X or Y or Cin;
Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end Equations
