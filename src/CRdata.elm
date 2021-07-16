module CRdata exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
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


dCRdata : Decoder (Dict.Dict String CRdata)
dCRdata =
    map (Dict.map infoToCRdata) (dict infoDecoder)


type alias Info =
    { location : String
    , effect : Dict String PureCPdata
    }


infoDecoder : Decoder Info
infoDecoder =
    map2 Info
        (field "location" string)
        (field "effect" decoder_PureCPdata)


infoToCRdata : String -> Info -> CRdata
infoToCRdata name { location, effect } =
    CRdata name location effect
