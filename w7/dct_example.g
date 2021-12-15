
LoadPackage("QPA");;

A := NakayamaAlgebra([2,2,2], GF(3));;
In := AllIndecModulesOfLengthAtMost(A, 3);; # List of all indecomposables
M := DirectSumOfQPAModules([In[1],In[4], In[5], In[6]]);; # A potential d-cluster tilting module

is_rigid := N_RigidModule(M, 2);;

Display(Concatenation(["is M 2-rigid: ", String(is_rigid)]));


dim1 := Size(ExtOverAlgebra(NthSyzygy(M,0), In[2])[2]);
dim2 := Size(ExtOverAlgebra(NthSyzygy(M,1), In[3])[2]);
dim3 := Size(ExtOverAlgebra(NthSyzygy(In[2],1), M)[2]);
dim4 := Size(ExtOverAlgebra(NthSyzygy(In[3],0), M)[2]);

Display(Concatenation(["dimensions are: ", String([dim1,dim2,dim3,dim4])]));



d := 2;;

# Starts out assuming that M is cluster-tilting algebra.
# If it finds a witness for M not to be d-cluster-tilting, this will change to true.
is_d_cluster_tilting := true;

# First step is to check tilting.
is_d_cluster_tilting := N_RigidModule(M, 2);;
for N in In do
    if not IsDirectSummand(N, M) then # We only need to check for indecomposables not direct summand of M
        # For notation, we denote VM = { X \in ind | Ext^i(M,N) = 0, for 0<i<d}
        N_in_VM := true;
        N_in_VM_op := true;

        # This for loop will go through each i, and check if Ext^i+1(M,N) = 0. If everyone of the are 0, N_in_Vm will be true. and M is therefore not cluster tilting
        # Similarly N_in_VM_op will check is Ext^i+1(N,M) = 0 for each i. and if it is 0 for every i, then N_in_VM_op will be true, and M will not be cluster tilting.
        for i in [0..d-1] do 
            N_in_VM := N_in_VM and Size(ExtOverAlgebra(NthSyzygy(M,i), N)[2]) = 0; 
            N_in_VM_op := N_in_VM_op and Size(ExtOverAlgebra(NthSyzygy(N,i), M)[2]) = 0;
        od;
        is_d_cluster_tilting := is_d_cluster_tilting and not N_in_VM and not N_in_VM_op; # Since for M to be d-ct, we not N not in VM
        if is_d_cluster_tilting then
          break;
        fi;
    fi;
od;
Display(is_d_cluster_tilting);


