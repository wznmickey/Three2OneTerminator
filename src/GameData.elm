module GameData exposing (..)

import Area exposing (..)
import CPdata exposing (..)
import CRdata exposing (..)
import Dict exposing (Dict)
import GameInfo exposing (..)
import HelpText exposing (..)
import Json.Decode exposing (..)
import Json.Encode exposing (..)
import PureCPdata exposing (..)


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


dGameData : Decoder GameData
dGameData =
    map8 GameData
        (field
            "CP"
            decoder_CPdata
        )
        (field
            "globalCP"
            decoder_PureCPdata
        )
        (field
            "CR"
            decoder_CRdata
        )
        (field
            "area"
            decoder_Area
        )
        (field
            "helpText"
            decoder_HelpText
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


getCPdataByName : ( String, Dict String CPdata ) -> CPdata
getCPdataByName ( name, dict ) =
    Maybe.withDefault
        initCPdata
        (Dict.get
            name
            dict
        )


getPureCPdataByName : ( String, Dict String PureCPdata ) -> PureCPdata
getPureCPdataByName ( name, dict ) =
    Maybe.withDefault
        initPureCPdata
        (Dict.get
            name
            dict
        )


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
