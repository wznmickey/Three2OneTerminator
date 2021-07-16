--unit area


module Area exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import PureCPdata exposing (..)


type alias Area =
    { --view : Mapview,
      name : String
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
    { name = newName
    , localCP = Dict.singleton newLocalCP.name newLocalCP
    , effect = Dict.singleton newEffect.name newEffect
    , no = newNo
    , areaColor = newAreaColor
    }


dArea : Decoder (Dict.Dict String Area)
dArea =
    map (Dict.map infoToArea) (dict infoDecoder)


type alias Info =
    { localCP : Dict String PureCPdata
    , effect : Dict String PureCPdata
    , no : Int
    }


infoDecoder : Decoder Info
infoDecoder =
    map3 Info
        (field "init" dPureCPdata)
        (field "effect" dPureCPdata)
        (field "location" int)


infoToArea : String -> Info -> Area
infoToArea name { localCP, effect, no } =
    Area name localCP effect no "pink"
