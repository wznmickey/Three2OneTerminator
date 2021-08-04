module Area exposing
    ( Area
    , initArea
    , decoder_Area, encodeArea
    )

{-| It is the module that defines type `Area` used as a subtype and related functions.


# Type

@docs Area


# Init

@docs initArea


# Json relate

@docs decoder_Area, encodeArea

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
        , map6
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
        , decoder_PureCPdata
        , encodePureCPdata
        , initPureCPdata
        )


{-| This type defines the infomation of `Area`.
_no is not used now_
-}
type alias Area =
    { view : String
    , center : ( Float, Float )
    , name : String
    , localCP : Dict String PureCPdata
    , effect : Dict String PureCPdata
    , --The index of the area. Start from **1**. Not use now.
      no : Int
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

        newNo =
            0
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
    , no =
        newNo
    , view =
        ""
    , center =
        ( 0, 0 )
    }


{-| This function decodes `Area`.
-}
decoder_Area : Decoder (Dict.Dict String Area)
decoder_Area =
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
    , no : Int
    , view : String
    , x : Float
    , y : Float
    }


{-| This function is a help function suggested in <https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict>.
-}
infoDecoder : Decoder Info
infoDecoder =
    map6 Info
        (field
            "init"
            decoder_PureCPdata
        )
        (field
            "effect"
            decoder_PureCPdata
        )
        (field
            "location"
            Json.Decode.int
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
infoToArea name { localCP, effect, no, view, x, y } =
    Area
        view
        ( x, y )
        name
        localCP
        effect
        no


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
        , ( "location"
          , Json.Encode.int
                data.no
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
