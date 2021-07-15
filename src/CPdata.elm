module CPdata exposing (CPdata, dCPdata, initCPdata)

import CPtype exposing (..)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import PureCPdata exposing (..)


type alias CPdata =
    { name : String
    , effect : Dict String PureCPdata
    , typeCP : CPtype
    }


initCPdata : CPdata
initCPdata =
    let
        newName =
            "init"

        newEffect =
            initPureCPdata

        newTypeCP =
            Global
    in
    { name = newName
    , effect = Dict.singleton newEffect.name newEffect
    , typeCP = newTypeCP
    }


dCPdata : Decoder (Dict.Dict String CPdata)
dCPdata =
    map (Dict.map infoToCPdata) (dict infoDecoder)


type alias Info =
    { effect : Dict String PureCPdata
    , typeCP : CPtype
    }


infoDecoder : Decoder Info
infoDecoder =
    map2 Info
        (field "effect" dPureCPdata)
        (field "type" dCPtype)


infoToCPdata : String -> Info -> CPdata
infoToCPdata name { effect, typeCP } =
    CPdata name effect typeCP
