module LoadMod exposing (loadMod)

import Area exposing (..)
import GameData exposing (..)
import Json.Decode exposing (..)


loadMod : String -> ( GameData, String )
loadMod st =
    let
        ans =
            decodeString
                dGameData
                st
    in
    case ans of
        Ok x ->
            ( x
            , "Ok"
            )

        Err x ->
            ( initGameData
            , Json.Decode.errorToString
                x
            )
