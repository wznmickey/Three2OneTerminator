module CRdata exposing
    ( CRdata
    , initCRdata
    , decoder_CRdata, encodeCRdata
    )

{-| It is the module that defines type `CPtype` used as a subtype and related functions.


# Type

@docs CRdata


# Init

@docs initCRdata


# Json relate

@docs decoder_CRdata, encodeCRdata

-}

import Dict exposing (Dict)
import Json.Decode
    exposing
        ( Decoder
        , dict
        , field
        , float
        , map
        , map5
        , string
        )
import Json.Encode
    exposing
        ( Value
        , dict
        , float
        , object
        , string
        )
import PureCPdata
    exposing
        ( PureCPdata
        , decoder_PureCPdata
        , encodePureCPdata
        , initPureCPdata
        )


{-| This type defines the data of CR.
-}
type alias CRdata =
    { name : String

    -- The name of the area.
    , location : String
    , effect : Dict String PureCPdata
    , place : ( Float, Float )
    , color : String
    }


{-| This function gives a init `CRdata`, should not be actually used in `Running`.
-}
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


{-| This function decodes `CRdata`.
-}
decoder_CRdata : Decoder (Dict.Dict String CRdata)
decoder_CRdata =
    map
        (Dict.map
            infoToCRdata
        )
        (Json.Decode.dict
            infoDecoder
        )


{-| This type is a help type suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
type alias Info =
    { location : String
    , effect : Dict String PureCPdata
    , x : Float
    , y : Float
    , color : String
    }


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
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


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
infoToCRdata : String -> Info -> CRdata
infoToCRdata name { location, effect, x, y, color } =
    CRdata
        name
        location
        effect
        ( x, y )
        color


{-| This function encodes `CRdata`.
-}
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
