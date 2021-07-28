module GameInfo exposing (..)

import Json.Decode exposing (..)
import Json.Encode exposing (..)


type alias GameInfo =
    { local : String
    , global : String
    , win : Float
    , lose : Float
    }


initGameInfo : GameInfo
initGameInfo =
    GameInfo
        "init"
        "init"
        100
        0


decoderGameInfo : Decoder GameInfo
decoderGameInfo =
    map4 GameInfo
        (field
            "localCP"
            Json.Decode.string
        )
        (field
            "GlobalCP"
            Json.Decode.string
        )
        (field
            "winning"
            Json.Decode.float
        )
        (field
            "losing"
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
          , Json.Encode.string
                data.global
          )
        , ( "winning"
          , Json.Encode.float
                data.win
          )
        , ( "losing"
          , Json.Encode.float
                data.lose
          )
        ]
