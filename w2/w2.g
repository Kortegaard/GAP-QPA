
LoadPackage("QPA");

# Loading quiver and defining pathalgebra
# Q := u --> v <-- w
Q := Quiver( ["u","v","w"], [["u","v","a"],["w","v","b"]] );
A := PathAlgebra(GF(3), Q);

# Getting a list of all the indecomposable injective modules over A
I := IndecInjectiveModules(A);

# Getting the predecessors of the modules I[1] (indecomposable I_u).
# With length at most 3 from I[1]
P := PredecessorsOfModule(I[1], 3);

Print(P);
