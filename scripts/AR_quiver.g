
LoadPackage("QPA");
BuildARQuiver := function(ModuleList, l)
    local indecList, arrows, vertices, M, P, indec, n, vertexNam, layer, layer_num, entry_num, arr, flatVerticesList, v, Q;
    #local vertexName;
    indecList := [];

    arrows := [];
    vertices := [];
    n:= 1; # Number of vertrices

    for M in ModuleList do
        P := PredecessorsOfModule(M, l);
        layer_num := 1;
        for layer in P[1] do
            entry_num := 1;
            for indec in layer do
                Append(vertices, [rec(
                    name:= Concatenation("L", String(layer_num), "E", String(entry_num)),
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
                    Concatenation("L", String(layer_num+1), "E", String(arr[1])), # FROM
                    Concatenation("L", String(layer_num),   "E", String(arr[2]))  # TO
                ]]);
                #Print(arr, " \t FROM ", String(arr[1]) , " TO ", String(arr[2]),"\n");
            od;
            layer_num := layer_num + 1;
        od;
        #Print(P);
        #Print(P[2]);
    od;

    flatVerticesList := [];
    for v in vertices do
        Append(flatVerticesList,[v.name]);
    od;
    Q := Quiver(flatVerticesList, arrows);
    Display(Q);
end;

#TEST
Q := DynkinQuiver("A", 3, ["r","r"]);
A := PathAlgebra(GF(3), Q);
I := IndecInjectiveModules(A);


BuildARQuiver([I[1]],4);

