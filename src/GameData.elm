module GameData exposing (..)

import Area exposing (..)
import CPdata exposing (..)
import CRdata exposing (..)
import Dict exposing (Dict)
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
    }


initGameData : GameData
initGameData =
    let
        newInfoCP =
            initCPdata

        newGlobalCP =
            initPureCPdata

        newAllCR =
            initCRdata

        newArea =
            initArea

        newHelpText =
            initHelpText
    in
    { infoCP = Dict.singleton newInfoCP.name newInfoCP
    , globalCP = Dict.singleton newGlobalCP.name newGlobalCP
    , allCR = Dict.singleton newAllCR.name newAllCR
    , area = Dict.singleton newArea.name newArea
    , helpText = Dict.singleton newHelpText.name newHelpText
    }


dGameData : Decoder GameData
dGameData =
    map5 GameData
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


getCPdataByName : ( String, Dict String CPdata ) -> CPdata
getCPdataByName ( name, dict ) =
    Maybe.withDefault initCPdata (Dict.get name dict)


getPureCPdataByName : ( String, Dict String PureCPdata ) -> PureCPdata
getPureCPdataByName ( name, dict ) =
    Maybe.withDefault initPureCPdata (Dict.get name dict)


encodeGameData : GameData -> Json.Encode.Value
encodeGameData data =
    Json.Encode.object [ ( "CP", Json.Encode.dict identity encodeCPdata data.infoCP ), ( "globalCP", Json.Encode.dict identity encodePureCPdata data.globalCP ), ( "CR", Json.Encode.dict identity encodeCRdata data.allCR ), ( "area", Json.Encode.dict identity encodeArea data.area ), ( "helpText", Json.Encode.dict identity encodeHelpText data.helpText ) ]
