LoadPackage("qpa");

#Q := Quiver(3,[[1,2],[2,3]]);;
#kQ := PathAlgebra(GF(3), Q);;
#gens := GeneratorsOfAlgebra(kQ);;
#a := gens[4];;
#b := gens[5];;
#I := Ideal(kQ, [a*b]);
#
#IsAdmissibleIdeal(I);
#A := kQ/I;

#indP := IndecProjectiveModules(A);;
#P := DirectSumOfQPAModules([indP[1],indP[2], indP[3]]);;
#M := DirectSumOfQPAModules([indP[1],indP[2]]);
#
#
#Simps := SimpleModules(A);
#N := DirectSumOfQPAModules([indP[1],indP[2], Simps[2]]);


BiggerThanMut := function(U,X)
  return not (Source(RightFacApproximation(U, X)) = X);
end;

# (U + X,P) support tau tilting, where pair = (U,P) Support tau tilting, U,P list, X module
MutateSupportTauTiltingPairA := function(pair,X, indecProj)
    local la, Mp, Pp, Y,v,proj,U,P;
    U := pair[1];
    P := pair[2];
    Mp := [];
    Pp := [];
    # (Mp,Pp) new support tau tilting pair
    for v in U do
        Append(Mp, [v]);
    od;
    for v in P do
        Append(Pp, [v]);
    od;
    la := MinimalLeftAddMApproximation(X,DirectSumOfQPAModules(U));
    if IsSurjective(la) then
        # TEST ALL Projs
        for proj in indecProj do
            if Size(HomOverAlgebra(proj, DirectSumOfQPAModules(U))) = 0 and not proj in Pp then
                Append(Pp,[proj]);
            fi;
        od;
    else
        # Coker
        Y := CoKernel(la);
        Append(Mp,[Y]);
    fi;
    return [Mp, Pp];
end;

MutateSupportTauTiltingPairAAtIndex := function(pair, index, indecProj)
    local Mp, v;
    Mp := [];
    for v in pair[1] do
        if not pair[1][index] = v then
            Append(Mp,[v]);
        fi;
    od;
    return MutateSupportTauTiltingPairA([Mp, pair[2]], pair[1][index], indecProj);
end;

IsSupportTauTiltingPair := function(pair,algebraSize)
    local proj;
    if not Size(pair[2]) = 0 and not Size(pair[1]) = 0 then
        if not Size(HomOverAlgebra(DirectSumOfQPAModules(pair[2]), DirectSumOfQPAModules(pair[1]))) = 0 then
            return false;
        fi;
    fi;
    return Size(pair[1]) + Size(pair[2]) = algebraSize;
end;

ddd := [];

SupportTauTiltingMutationGraph := function(A)
    local almostSTtiltingMutationPair,almostSTtiltingMutation,almostSTiltingPairsDone, indecProjs, aSize, tauTiltPairs, order, unMutated, currPair, temp, i, j, v, skip, SetInclusion,PairInList;
    #p1 in p2
    SetInclusion := function(p1,p2)
        local m,n,tmp;
        for m in p1 do
            tmp := false;
            for n in p2 do
                if m = n then
                  tmp := true;
                fi;
            od;
            if not tmp then
              return false;
            fi;
        od;
        return true;
    end;

    PairInList := function(pair,list)
        local vv;
        for vv in list do
            if SetInclusion(vv[1], pair[1]) and SetInclusion(vv[2], pair[2]) then
                return true;
            fi;
        od;
        return false;
    end;

    indecProjs := IndecProjectiveModules(A);
    # Number for now, true for algebras im interested in now
    aSize := Size(indecProjs);
    tauTiltPairs := [ [indecProjs,[]] ];
    unMutated := [ [indecProjs,[]] ];
    order := [];
    almostSTiltingPairsDone := []; # Makes sure not to go backwards,
    while true do
        if Size(unMutated) = 0 then
            break;
        fi;
        currPair := unMutated[1];
        i := Position(tauTiltPairs, currPair);
        Remove(unMutated, 1);
        if Size(currPair[1]) = 1 then
          continue;
        fi;
        for j in [1..Size(currPair[1])] do
            almostSTtiltingMutation := Filtered(currPair[1], c -> not c = currPair[1][j]);
            almostSTtiltingMutationPair := [almostSTtiltingMutation, currPair[2]];
            # Go through to check if current pair is in there
            skip := false;


            if PairInList(almostSTtiltingMutationPair, almostSTiltingPairsDone) then
                continue;
            fi;

            Append(almostSTiltingPairsDone, [almostSTtiltingMutationPair]);
            Append(ddd, [almostSTtiltingMutationPair]);
            temp := MutateSupportTauTiltingPairAAtIndex(currPair, j, indecProjs);
            if not IsSupportTauTiltingPair(temp, aSize) then
                continue;
            fi;
           
            if PairInList(temp, tauTiltPairs) then
                v := Position(tauTiltPairs, temp);
                Append(order, [[i, v]]); # Add to order
            else
                Append(unMutated, [temp]);
                Append(tauTiltPairs, [temp]);
                Append(order, [[i, Size(tauTiltPairs)]]); # Add to order
            fi;
        od;
    od;
    return [tauTiltPairs, order,almostSTiltingPairsDone];
end;

# Right perp of M
RightPerp := function(indecs, M)
    local rp, isIn,v,m;
    rp := [];
    isIn := true;
    for v in indecs do
        for m in M do
            if not Size(HomOverAlgebra(m,v)) = 0 then
                isIn := false;
                break;
            fi;
        od;
        if isIn then
            Append(rp, [v]);
        fi;
        isIn := true;
    od;
    return rp;
end;




Read("./IndecomposableObjects.g");


TorsionFreeClasses := function(A)
    local indI, sttg, TauTilt, AI, TorsionFree;
    indI := IndecInjectiveModules(A);;
    
    sttg := SupportTauTiltingMutationGraph(A);
    TauTilt := List(sttg[1], x->x[1]); 
    AI := AllIndecomposableModules(indI, 10);
    TorsionFree := String(List(TauTilt, x->List(RightPerp(AI, x), y->DimensionVector(y))));
    return TorsionFree;
end;

#Display(TorsionFreeClasses(A));


