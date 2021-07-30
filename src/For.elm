module For exposing (..)

{--
    First Int (`i`) is to check how the for process
    Second Int (`n`) set the times of function `f`
    Type outer (`o`) is the outer environment data
    ( outer -> Int->  io -> (io,outer)) set a function which use (outer environment data) & (for function process) to map a function from type io to type io
    the left is used for the above function
--}


for_outer : Int -> Int -> (outer -> Int -> io -> ( io, outer )) -> ( io, outer ) -> ( io, outer )
for_outer i n f ( x, o ) =
    if i > n then
        ( x, o )

    else
        for_outer
            (i + 1)
            n
            f
            (f
                o
                i
                x
            )



{--No outer var for function--}


for_no_outer : Int -> Int -> (Int -> io -> io) -> io -> io
for_no_outer i n f x =
    if i >= n then
        x

    else
        for_no_outer
            (i + 1)
            n
            f
            (f
                i
                x
            )
