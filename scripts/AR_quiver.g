
LoadPackage("QPA");
BuildARQuiver := function(ModuleList, l)
    local arrows, vertices, M, P, indec, n, vertexNam, layer, layer_num, entry_num, arr, v, Q, dict,v_name;


    arrows := [];
    vertices := [];
    n:= 1; # Number of vertrices
    dict := NewDictionary(false, true);
    for M in ModuleList do
        P := PredecessorsOfModule(M, l);
        layer_num := 1;
        for layer in P[1] do
            entry_num := 1;
            for indec in layer do
                v_name := Concatenation("v", String(n));
                n := n + 1;
                AddDictionary(dict, [layer_num,entry_num], v_name);

                Append(vertices, [rec(
                    name:= v_name,
                    module:=indec
                )]);
                entry_num := entry_num + 1;
            od;
            layer_num := layer_num + 1;
        od;
        layer_num := 1;
        for layer in P[2] do
            for arr in layer do
                Append(arrows, [[
                    LookupDictionary(dict, [layer_num + 1, arr[1]]), # FROM
                    LookupDictionary(dict, [layer_num,     arr[2]]) # TO
                ]]);
            od;
            layer_num := layer_num + 1;
        od;
    od;

    Q := Quiver(List(vertices, x -> x.name), arrows);
    return Q;
end;

#TEST
Q := DynkinQuiver("A", 3, ["r","r"]);
A := PathAlgebra(GF(3), Q);
I := IndecInjectiveModules(A);


#BuildARQuiver([I[1]],4);
Display(BuildARQuiver([I[1]],4));

