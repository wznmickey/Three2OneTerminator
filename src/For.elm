module For exposing (for)

{-| `for` gives the usage of `for` function like that in other language.


# For

@docs for

-}


{-| First `Int` (`i`) is to check how the for process.

Second `Int` (`n`) set the times of function `f`.

Type `outer` (`o`) is the outer environment data.

Type `io` (`x`) is the data that will change during the for function.

`( outer -> Int->  io -> (io,outer))`(`f`) set a function which use (outer environment data) & (for function process) to map a function from type `io` to type `io`.

C++ style code :

```
for (int index = i ; index < n ; index++) (x,o)=f(x,index,o);
```

    for
        0
        10
        (\outer i io ->
            ( (i
                + outer
              )
                :: io
            , outer
            )
        )
        ( []
        , 10
        )
    == ([20,19,18,17,16,15,14,13,12,11,10],10)

-}
for : Int -> Int -> (outer -> Int -> io -> ( io, outer )) -> ( io, outer ) -> ( io, outer )
for i n f ( x, o ) =
    if i > n then
        ( x, o )

    else
        for
            (i + 1)
            n
            f
            (f
                o
                i
                x
            )
