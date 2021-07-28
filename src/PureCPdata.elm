module PureCPdata exposing (PureCPdata, decoder_PureCPdata, encodePureCPdata, initPureCPdata)

import Dict exposing (Dict)
import Json.Decode exposing (Decoder, dict, float, map)
import Json.Encode exposing (Value, float)


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
    { name =
        "init"
    , data =
        0
    }


decoder_PureCPdata : Decoder (Dict.Dict String PureCPdata)
decoder_PureCPdata =
    map
        (Dict.map
            (\name value ->
                PureCPdata
                    name
                    value
            )
        )
        (dict
            Json.Decode.float
        )


encodePureCPdata : PureCPdata -> Json.Encode.Value
encodePureCPdata data =
    Json.Encode.float
        data.data
