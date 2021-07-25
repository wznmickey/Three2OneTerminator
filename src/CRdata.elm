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
    { name = newName
    , location = newLocation
    , effect = Dict.singleton newEffect.name newEffect
    }


decoder_CRdata : Decoder (Dict.Dict String CRdata)
decoder_CRdata =
    map (Dict.map infoToCRdata) (Json.Decode.dict infoDecoder)


type alias Info =
    { location : String
    , effect : Dict String PureCPdata
    }


infoDecoder : Decoder Info
infoDecoder =
    map2 Info
        (field "location" Json.Decode.string)
        (field "effect" decoder_PureCPdata)


infoToCRdata : String -> Info -> CRdata
infoToCRdata name { location, effect } =
    CRdata name location effect


encodeCRdata : CRdata -> Json.Encode.Value
encodeCRdata data =
    Json.Encode.object [ ( "effect", Json.Encode.dict identity encodePureCPdata data.effect ), ( "location", Json.Encode.string data.location ) ]
