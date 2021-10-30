module Area exposing
    ( Area
    , initArea
    , decoderArea, encodeArea
    )

{-| It is the module that defines type `Area` used as a subtype and related functions.


# Type

@docs Area


# Init

@docs initArea


# Json relate

@docs decoderArea, encodeArea

-}

import Dict exposing (Dict)
import Json.Decode
    exposing
        ( Decoder
        , dict
        , field
        , float
        , int
        , map
        , map5
        , string
        )
import Json.Encode
    exposing
        ( Value
        , dict
        , int
        , object
        , string
        )
import PureCPdata
    exposing
        ( PureCPdata
        , decoderPureCPdata
        , encodePureCPdata
        , initPureCPdata
        )


{-| This type defines the information of `Area`.


-}
type alias Area =
    { view : String
    , center : ( Float, Float )
    , name : String
    , localCP : Dict String PureCPdata
    , effect : Dict String PureCPdata
    }


{-| This function gives a init `Area`, should not be actually used in `Running`.
-}
initArea : Area
initArea =
    let
        newName =
            "init"

        newLocalCP =
            initPureCPdata

        newEffect =
            initPureCPdata

    in
    { name =
        newName
    , localCP =
        Dict.singleton
            newLocalCP.name
            newLocalCP
    , effect =
        Dict.singleton
            newEffect.name
            newEffect
    , view =
        ""
    , center =
        ( 0, 0 )
    }


{-| This function decodes `Area`.
-}
decoderArea : Decoder (Dict.Dict String Area)
decoderArea =
    map
        (Dict.map
            infoToArea
        )
        (Json.Decode.dict
            infoDecoder
        )


{-| This type is a help type suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
type alias Info =
    { localCP : Dict String PureCPdata
    , effect : Dict String PureCPdata
    , view : String
    , x : Float
    , y : Float
    }


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
infoDecoder : Decoder Info
infoDecoder =
    map5 Info
        (field
            "init"
            decoderPureCPdata
        )
        (field
            "effect"
            decoderPureCPdata
        )
        (field
            "path"
            Json.Decode.string
        )
        (field
            "centerX"
            Json.Decode.float
        )
        (field
            "centerY"
            Json.Decode.float
        )


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
infoToArea : String -> Info -> Area
infoToArea name { localCP, effect, view, x, y } =
    Area
        view
        ( x, y )
        name
        localCP
        effect


{-| This function encodes `Area`.
-}
encodeArea : Area -> Json.Encode.Value
encodeArea data =
    Json.Encode.object
        [ ( "init"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.localCP
          )
        , ( "effect"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.effect
          )
        , ( "path"
          , Json.Encode.string
                data.view
          )
        , ( "centerX"
          , Json.Encode.float
                (Tuple.first
                    data.center
                )
          )
        , ( "centerY"
          , Json.Encode.float
                (Tuple.second
                    data.center
                )
          )
        ]
