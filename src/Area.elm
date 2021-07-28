--unit area


module Area exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode exposing (..)
import PureCPdata exposing (..)


type alias Area =
    { view : String
    , center : ( Float, Float )
    , name : String
    , localCP : Dict String PureCPdata
    , effect : Dict String PureCPdata
    , --The index of the area. Start from **1**.
      no : Int
    , areaColor : String
    }


initArea : Area
initArea =
    let
        newName =
            "init"

        newLocalCP =
            initPureCPdata

        newEffect =
            initPureCPdata

        newNo =
            0

        newAreaColor =
            "Pink"
    in
    { name =
        newName
    , localCP =
        Dict.singleton
            newLocalCP.name
            newLocalCP
    , effect =
        Dict.singleton
            newEffect.name
            newEffect
    , no =
        newNo
    , areaColor =
        newAreaColor
    , view =
        ""
    , center =
        ( 0, 0 )
    }


decoder_Area : Decoder (Dict.Dict String Area)
decoder_Area =
    Debug.log "1"
        (map
            (Dict.map
                infoToArea
            )
            (Json.Decode.dict
                infoDecoder
            )
        )


type alias Info =
    { localCP : Dict String PureCPdata
    , effect : Dict String PureCPdata
    , no : Int
    , view : String
    , x : Float
    , y : Float
    }


infoDecoder : Decoder Info
infoDecoder =
    map6 Info
        (field
            "init"
            decoder_PureCPdata
        )
        (field
            "effect"
            decoder_PureCPdata
        )
        (field
            "location"
            Json.Decode.int
        )
        (field
            "path"
            Json.Decode.string
        )
        (field
            "centerX"
            Json.Decode.float
        )
        (field
            "centerY"
            Json.Decode.float
        )


infoToArea : String -> Info -> Area
infoToArea name { localCP, effect, no, view, x, y } =
    Area
        view
        ( x, y )
        name
        localCP
        effect
        no
        "pink"


encodeArea : Area -> Json.Encode.Value
encodeArea data =
    Json.Encode.object
        [ ( "init"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.localCP
          )
        , ( "effect"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.effect
          )
        , ( "location"
          , Json.Encode.int
                data.no
          )
        , ( "path"
          , Json.Encode.string
                data.view
          )
        , ( "centerX"
          , Json.Encode.float
                (Tuple.first
                    data.center
                )
          )
        , ( "centerY"
          , Json.Encode.float
                (Tuple.second
                    data.center
                )
          )
        ]
