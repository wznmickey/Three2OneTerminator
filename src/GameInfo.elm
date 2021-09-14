module GameInfo exposing
    ( GameInfo
    , initGameInfo
    , decoderGameInfo, encodeGameInfo
    )

{-| It is the module that defines type `GameInfo` used as a subtype describing game rules and related functions.


# Type

@docs GameInfo


# Init

@docs initGameInfo


# Json relate

@docs decoderGameInfo, encodeGameInfo

-}

import Json.Decode
    exposing
        ( Decoder
        , field
        , float
        , map6
        , string
        )
import Json.Encode
    exposing
        ( Value
        , float
        , list
        , object
        , string
        )


{-| This type defines the game rules.

`local` shows that localCP related to color.

`global` shows the list of globalCP related to lose.

`win` shows the time needed to win.

`lose` shows the list of min number for lose.

`max` and `min` shows color range of `local`. When reach `min`, also lose.

-}
type alias GameInfo =
    { local : String
    , global : List String
    , win : Float
    , lose : List Float
    , max : Float
    , min : Float
    }


{-| This function gives a init `GameInfo`, should not be actually used in `Running`.
-}
initGameInfo : GameInfo
initGameInfo =
    GameInfo
        "init"
        [ "init" ]
        100
        [ 0 ]
        100
        0


{-| This function decodes `GameInfo`.
-}
decoderGameInfo : Decoder GameInfo
decoderGameInfo =
    map6
        GameInfo
        (field
            "LocalCP"
            Json.Decode.string
        )
        (field
            "GlobalCP"
            (Json.Decode.list
                Json.Decode.string
            )
        )
        (field
            "winningTime"
            Json.Decode.float
        )
        (field
            "losing"
            (Json.Decode.list
                Json.Decode.float
            )
        )
        (field
            "max"
            Json.Decode.float
        )
        (field
            "min"
            Json.Decode.float
        )


{-| This function encodes `GameInfo`.
-}
encodeGameInfo : GameInfo -> Json.Encode.Value
encodeGameInfo data =
    Json.Encode.object
        [ ( "LocalCP"
          , Json.Encode.string
                data.local
          )
        , ( "GlobalCP"
          , Json.Encode.list
                Json.Encode.string
                data.global
          )
        , ( "winningTime"
          , Json.Encode.float
                data.win
          )
        , ( "losing"
          , Json.Encode.list
                Json.Encode.float
                data.lose
          )
        , ( "max"
          , Json.Encode.float
                data.max
          )
        , ( "min"
          , Json.Encode.float
                data.min
          )
        ]
