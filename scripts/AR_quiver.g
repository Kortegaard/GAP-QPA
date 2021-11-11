
LoadPackage("QPA");

BuildARQuiver := function(ModuleList, l)

    local arrows, vertices, M, P, indec, n, vertexNam, layer, layer_num, entry_num, arr,  Q, dict,v_name,v, a;

    arrows := [];
    vertices := [];
    n:= 1; # Number of vertrices
    for M in ModuleList do
        P := PredecessorsOfModule(M, l);
        dict := NewDictionary(false, true);
        layer_num := 1;
        for layer in P[1] do
            entry_num := 1;
            for indec in layer do

                v_name := false;

                
                for v in vertices do
                    if IsomorphicModules(indec, v.module) then
                        v_name := v.name;
                    fi;
                od;

                if not IsString(v_name) then
                    #v_name := Concatenation("v", String(n));
                    v_name := String(DimensionVector(indec));
                    n := n + 1;
                    Append(vertices, [rec(
                        name:= v_name,
                        module:=indec
                    )]);
                fi;

                AddDictionary(dict, [layer_num,entry_num], v_name);
                entry_num := entry_num + 1;
            od;
            layer_num := layer_num + 1;
        od;
        layer_num := 1;
        for layer in P[2] do
            for arr in layer do

                a := [LookupDictionary(dict, [layer_num + 1, arr[1]]), # FROM
                      LookupDictionary(dict, [layer_num,     arr[2]]) # TO
                ];
                if not a in arrows then
                    Append(arrows, [a]);
                fi;
            od;
            layer_num := layer_num + 1;
        od;
    od;

    Q := Quiver(List(vertices, x -> x.name), arrows);
    return Q;
end;


#TEST
Q := DynkinQuiver("A", 3, ["r","l"]);
A := PathAlgebra(GF(3), Q);
I := IndecInjectiveModules(A);
#Display(I);


#BuildARQuiver([I[1]],4);
Display(BuildARQuiver([I[1], I[3]],4));

