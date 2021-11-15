# GAP QPA

## Algebras
https://www.gap-system.org/Manuals/pkg/qpa/doc/chap4.html#X7E8A43A484CE0BA8

1) From quivers
example

```
Q1 := Quiver(1, [ [1,1,"a"], [1,1,"b"] ]);
A1 := PathAlgebra(Rationals, Q1);;

Q2 := Quiver( ["u","v", "w"] , [ ["u","v","a"], ["w","v"] ] );
A2 := PathAlgebra(GF(3), Q2);
```

## Modules
https://www.gap-system.org/Manuals/pkg/qpa/doc/chap6.html#X87EFC38F7BC77B27

1) `IndecInjectiveModules`
Return list of indecomposable injective representations over A (non isomorphic).

2) `IndecProjectiveModules`
Return list of indecomposable projective representations over A (non isomorphic).

3) `SimpleModules`
Return simple modules

## Almost split sequences
https://www.gap-system.org/Manuals/pkg/qpa/doc/chap9.html#X855427278501E7FB

Use GF(3), otherwise hard to decompose.

1) `AlmostSplitSequence`
The almost split sequence ending in the module M

2) `PredecessorsOfModule`
We spend most of the time using the function `PredecessorsOfModule`.
**Notice** that the function name is spelled wrongly in the documentation, but is spelled correctly in the example in the documentation.

This gives a list of the indecomposable in the Auslander-Reiten quiver, which have arrows to the given module together with the irreducible morphisms.

_How to read output_:
See w2.g for the gap code, with output P. It looks like

```
[
    [ 
        [ 
            <Module over <GF(3)[<quiver with 3 vertices and 2 arrows>]> with dimension vector [ 1, 0, 0 ]> 
        ], 
        [ 
            <Module over <GF(3)[<quiver with 3 vertices and 2 arrows>]> with dimension vector [ 1, 1, 1 ]> 
        ], 
        [ 
            <Module over <GF(3)[<quiver with 3 vertices and 2 arrows>]> with dimension vector [ 0, 1, 1 ]>,
            <Module over <GF(3)[<quiver with 3 vertices and 2 arrows>]> with dimension vector [ 1, 1, 0 ]>
        ], 
        [ 
            <Module over <GF(3)[<quiver with 3 vertices and 2 arrows>]> with dimension vector [ 0, 1, 0 ]> 
        ] 
    ], 

[
    [ 
        [ 1, 1, [ 1, false ] ] 
    ],
    [ 
        [ 1, 1, [ 1, 1 ] ], 
        [ 2, 1, [ 1, false ]]
    ],
    [ 
        [ 1, 1, [ false, 1 ] ],
        [ 1, 2, [ false, 1 ] ] 
    ]
]
```

If we clean this output up, by removing alle the `Modules over <...> with dim vector`, and just leave the dim vector, we have output


```
[
    [ 
        [ 
            <[ 1, 0, 0 ]> 
        ], 
        [ 
            <[ 1, 1, 1 ]> 
        ], 
        [ 
            <[ 0, 1, 1 ]>,
            <[ 1, 1, 0 ]>
        ], 
        [ 
            <[ 0, 1, 0 ]> 
        ] 
    ], 
    [
        [ 
            [ 1, 1, [ 1, false ] ] 
        ],
        [ 
            [ 1, 1, [ 1, 1 ] ], 
            [ 2, 1, [ 1, false ]]
        ],
        [ 
            [ 1, 1, [ false, 1 ] ],
            [ 1, 2, [ false, 1 ] ] 
        ]
    ]
]
```

There are two lists in this. Let us start with the first. This is a list of the rows of indecomposables in the AR quiver, which comes before I[1]

```
 [ 
        ROW 1[ 
            <[ 1, 0, 0 ]> =: I_u = S_u 
        ], 
        ROW 2[ 
            <[ 1, 1, 1 ]> =: I_v 
        ], 
        ROW 3[ 
            <[ 0, 1, 1 ]>, =: P_w
            <[ 1, 1, 0 ]> =: P_u
        ], 
        ROW 4[ 
            <[ 0, 1, 0 ]>  =: S_v
        ] 
    ], 
```

The second list tells us about the arrows  between these indecomposables

```
    [
        ROW 1[ 
            [ 1, 1, [ 1, false ] ] 
        ],
        ROW 2[ 
            [ 1, 1, [ 1, 1 ] ], 
            [ 2, 1, [ 1, false ]]
        ],
        ROW 3[ 
            [ 1, 1, [ false, 1 ] ],
            [ 1, 2, [ false, 1 ] ] 
        ]
    ]
```

Assume we have a list
```
 ROW m [
    [ i, j , [TRASH]]
 ]
```

This means That we have an arrow between indecomposables (in the indecomposable list) from from the i'th indecomposable in row m+1, to the j'th indecomposable in row m.

As an example we have:

```
ROW 2[ 
    [ 1, 1, [ 1, 1 ] ], 
    [ 2, 1, [ 1, false ]]
],
```

Meaning there are two arrows. from row 3 to row 2. The first one goes from `<[ 0, 1, 1 ]> = P_w` to `<[ 1, 1, 1 ]> = I_v`, and the second one goes from `<[ 1, 1, 0 ]> = P_u` to `<[ 1, 1, 1 ]> = I_v`


All gother we get the output means we have part of the auslander reiten quiver:

```
        P_w          I_u
      /     \       /
    /         \   /
S_v           I_v
    \         /
      \     /
        P_u
```
Where the arrows should be read as from left to right.












