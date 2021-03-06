module CPdata exposing
    ( CPdata
    , initCPdata
    , decoderCPdata, encodeCPdata
    )

{-| It is the module that defines type `CPdata` used as a subtype and related functions.


# Type

@docs CPdata


# Init

@docs initCPdata


# Json relate

@docs decoderCPdata, encodeCPdata

-}

import CPtype
    exposing
        ( CPtype(..)
        , decoderCPtype
        , encodeCPtype
        )
import Dict exposing (Dict)
import Json.Decode
    exposing
        ( Decoder
        , dict
        , field
        , map
        , map2
        )
import Json.Encode
    exposing
        ( Value
        , dict
        , object
        )
import PureCPdata
    exposing
        ( PureCPdata
        , decoderPureCPdata
        , encodePureCPdata
        , initPureCPdata
        )


{-| This type defines the data of CP.
-}
type alias CPdata =
    { name : String
    , effect : Dict String PureCPdata
    , typeCP : CPtype
    }


{-| This function gives a init `CPdata`, should not be actually used in `Running`.
-}
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
    { name =
        newName
    , effect =
        Dict.singleton
            newEffect.name
            newEffect
    , typeCP =
        newTypeCP
    }


{-| This function decodes `CPdata`.
-}
decoderCPdata : Decoder (Dict.Dict String CPdata)
decoderCPdata =
    map
        (Dict.map
            infoToCPdata
        )
        (Json.Decode.dict
            infoDecoder
        )


{-| This type is a help type suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
type alias Info =
    { effect : Dict String PureCPdata
    , typeCP : CPtype
    }


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
infoDecoder : Decoder Info
infoDecoder =
    map2 Info
        (field
            "effect"
            decoderPureCPdata
        )
        (field
            "type"
            decoderCPtype
        )


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
infoToCPdata : String -> Info -> CPdata
infoToCPdata name { effect, typeCP } =
    CPdata
        name
        effect
        typeCP


{-| This function encodes `CPdata`.
-}
encodeCPdata : CPdata -> Json.Encode.Value
encodeCPdata data =
    Json.Encode.object
        [ ( "effect"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.effect
          )
        , ( "type"
          , encodeCPtype
                data.typeCP
          )
        ]
