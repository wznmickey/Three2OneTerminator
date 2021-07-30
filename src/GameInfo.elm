module GameInfo exposing (..)

import Json.Decode exposing (..)
import Json.Encode exposing (..)


type alias GameInfo =
    { local : String
    , global : List String
    , win : Float
    , lose : List Float
    , max : Float
    , min : Float
    }


initGameInfo : GameInfo
initGameInfo =
    GameInfo
        "init"
        [ "init" ]
        100
        [ 0 ]
        100
        0


decoderGameInfo : Decoder GameInfo
decoderGameInfo =
    map6 GameInfo
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
