module CRdata exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode exposing (..)
import PureCPdata exposing (..)


type alias CRdata =
    { --view: CRview
      name : String

    -- The name of the area.
    , location : String
    , effect : Dict String PureCPdata
    , place : ( Float, Float )
    , color : String
    }


initCRdata : CRdata
initCRdata =
    let
        newName =
            "init"

        newLocation =
            "init"

        newEffect =
            initPureCPdata
    in
    { name =
        newName
    , location =
        newLocation
    , effect =
        Dict.singleton newEffect.name newEffect
    , place =
        ( 0, 0 )
    , color =
        "white"
    }


decoder_CRdata : Decoder (Dict.Dict String CRdata)
decoder_CRdata =
    map
        (Dict.map
            infoToCRdata
        )
        (Json.Decode.dict
            infoDecoder
        )


type alias Info =
    { location : String
    , effect : Dict String PureCPdata
    , x : Float
    , y : Float
    , color : String
    }


infoDecoder : Decoder Info
infoDecoder =
    map5 Info
        (field
            "location"
            Json.Decode.string
        )
        (field
            "effect"
            decoder_PureCPdata
        )
        (field
            "placeX"
            Json.Decode.float
        )
        (field
            "placeY"
            Json.Decode.float
        )
        (field
            "color"
            Json.Decode.string
        )


infoToCRdata : String -> Info -> CRdata
infoToCRdata name { location, effect, x, y, color } =
    CRdata
        name
        location
        effect
        ( x, y )
        color


encodeCRdata : CRdata -> Json.Encode.Value
encodeCRdata data =
    Json.Encode.object
        [ ( "effect"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.effect
          )
        , ( "location"
          , Json.Encode.string
                data.location
          )
        , ( "placeX"
          , Json.Encode.float
                (Tuple.first
                    data.place
                )
          )
        , ( "placeY"
          , Json.Encode.float
                (Tuple.second
                    data.place
                )
          )
        , ( "color"
          , Json.Encode.string
                data.color
          )
        ]
