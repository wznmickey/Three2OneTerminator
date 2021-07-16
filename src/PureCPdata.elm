module PureCPdata exposing (PureCPdata, dPureCPdata, initPureCPdata)

import Dict exposing (Dict)
import Json.Decode exposing (..)


type alias PureCPdata =
    { name : String
    , {--
            The data have 2 meaning:
            1. when as effect: increase or decrease of certain CP each time loaded 
                1.1 In CR/Area, the value.
                1.2 In CP, the ratio.
            2. when as globalCP/localCP: the value of the certain CP
        --}
      data : Float
    }


initPureCPdata : PureCPdata
initPureCPdata =
    { name = "init", data = 0 }


dPureCPdata : Decoder (Dict.Dict String PureCPdata)
dPureCPdata =
    map (Dict.map (\name value -> PureCPdata name value)) (dict float)
