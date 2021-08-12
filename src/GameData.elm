module GameData exposing
    ( GameData
    , initGameData
    , encodeGameData, decoderGameData
    , getPureCPdataByName, getCPdataByName, getAreaByName
    )

{-| It is the module that defines type `GameData` that contain all the necessary data for game running.


# Type

@docs GameData


# Init

@docs initGameData


# Json relate

@docs encodeGameData, decoderGameData


# Get element

@docs getPureCPdataByName, getCPdataByName, getAreaByName

-}

import Area
    exposing
        ( Area
        , decoderArea
        , encodeArea
        , initArea
        )
import CPdata
    exposing
        ( CPdata
        , decoderCPdata
        , encodeCPdata
        , initCPdata
        )
import CRdata
    exposing
        ( CRdata
        , decoderCRdata
        , encodeCRdata
        , initCRdata
        )
import Dict exposing (Dict)
import GameInfo
    exposing
        ( GameInfo
        , decoderGameInfo
        , encodeGameInfo
        , initGameInfo
        )
import HelpText
    exposing
        ( HelpText
        , decoderHelpText
        , encodeHelpText
        , initHelpText
        )
import Json.Decode
    exposing
        ( Decoder
        , field
        , float
        , list
        , map8
        , string
        )
import Json.Encode
    exposing
        ( Value
        , dict
        , float
        , list
        , object
        )
import Msg exposing (Element(..))
import PureCPdata
    exposing
        ( PureCPdata
        , decoderPureCPdata
        , encodePureCPdata
        , initPureCPdata
        )


{-| This type defines the data for game running.

`infoCP` is the dict of CP related information. It should not change during game.

`globalCP` is the data of globalCP.

`allCR` contains all the CR.

`area` contains all the information of areas.

`helpText` contains the help of each element.

`gameInfo` contains the rules of game.

`story` is where story words contained.

`time` is the game time.

-}
type alias GameData =
    { infoCP : Dict String CPdata
    , globalCP : Dict String PureCPdata
    , allCR : Dict String CRdata
    , area : Dict String Area
    , helpText : Dict String HelpText
    , gameInfo : GameInfo
    , story : List String
    , time : Float
    }


{-| This function gives a init `GameData`, should not be actually used in `Running`.
-}
initGameData : GameData
initGameData =
    { infoCP =
        Dict.singleton
            initCPdata.name
            initCPdata
    , globalCP =
        Dict.singleton
            initPureCPdata.name
            initPureCPdata
    , allCR =
        Dict.singleton
            initCRdata.name
            initCRdata
    , area =
        Dict.singleton
            initArea.name
            initArea
    , helpText =
        Dict.singleton
            initHelpText.name
            initHelpText
    , gameInfo =
        initGameInfo
    , story =
        [ "" ]
    , time =
        0
    }


{-| This function decodes `GameData`.
-}
decoderGameData : Decoder GameData
decoderGameData =
    map8 GameData
        (field
            "CP"
            decoderCPdata
        )
        (field
            "globalCP"
            decoderPureCPdata
        )
        (field
            "CR"
            decoderCRdata
        )
        (field
            "area"
            decoderArea
        )
        (field
            "helpText"
            decoderHelpText
        )
        (field
            "winningMsg"
            decoderGameInfo
        )
        (field
            "story"
            (Json.Decode.list
                Json.Decode.string
            )
        )
        (field
            "time"
            Json.Decode.float
        )


{-| This function gives certain `CPdata` by `String` in the `Dict String CPdata`.
-}
getCPdataByName : ( String, Dict String CPdata ) -> CPdata
getCPdataByName ( name, dict ) =
    Maybe.withDefault
        initCPdata
        (Dict.get
            name
            dict
        )


{-| This function gives certain `PureCPdata` by `String` in the `Dict String PureCPdata`.
-}
getPureCPdataByName : ( String, Dict String PureCPdata ) -> PureCPdata
getPureCPdataByName ( name, dict ) =
    Maybe.withDefault
        initPureCPdata
        (Dict.get
            name
            dict
        )


{-| This function gives certain `Area` by `String` in the `Dict String Area`.
-}
getAreaByName : ( String, Dict String Area ) -> Area
getAreaByName ( name, dict ) =
    Maybe.withDefault
        initArea
        (Dict.get
            name
            dict
        )


{-| This function encodes `GameData`.
-}
encodeGameData : GameData -> Json.Encode.Value
encodeGameData data =
    Json.Encode.object
        [ ( "CP"
          , Json.Encode.dict
                identity
                encodeCPdata
                data.infoCP
          )
        , ( "globalCP"
          , Json.Encode.dict
                identity
                encodePureCPdata
                data.globalCP
          )
        , ( "CR"
          , Json.Encode.dict
                identity
                encodeCRdata
                data.allCR
          )
        , ( "area"
          , Json.Encode.dict
                identity
                encodeArea
                data.area
          )
        , ( "helpText"
          , Json.Encode.dict
                identity
                encodeHelpText
                data.helpText
          )
        , ( "winningMsg"
          , encodeGameInfo
                data.gameInfo
          )
        , ( "story"
          , Json.Encode.list
                Json.Encode.string
                data.story
          )
        , ( "story"
          , Json.Encode.float
                data.time
          )
        ]
