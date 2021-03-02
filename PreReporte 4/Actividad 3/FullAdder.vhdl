architecture Equations of FullAdder is
begin
Sum <= X or Y or Cin;
Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end Equations
