module PureCPdata exposing (PureCPdata, decoder_PureCPdata, encodePureCPdata, initPureCPdata)

{-| It is the module that defines type `PureCPdata` used as a subtype and related functions.


# Type

@docs PureCPdata


# Init

@docs initPureCPdata


# Json relate

@docs decoder_PureCPdata, encodePureCPdata

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder, dict, float, map)
import Json.Encode exposing (Value, float)


{-| This type has two name (`String`) and data (`Float`).
The data have 2 meaning:

1. when as effect: increase or decrease of certain CP each time loaded

    1.1 In CR/Area, the value.

    1.2 In CP, the ratio.

2. when as globalCP/localCP: the value of the certain CP
-}
type alias PureCPdata =
    { name : String
    , data : Float
    }


{-| This function gives a init `PureCPdata` , should never be used in running.
-}
initPureCPdata : PureCPdata
initPureCPdata =
    { name =
        "init"
    , data =
        0
    }


{-| This function decodes `PureCPdata`.
-}
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


{-| This function encodes `PureCPdata`.
-}
encodePureCPdata : PureCPdata -> Json.Encode.Value
encodePureCPdata data =
    Json.Encode.float
        data.data
