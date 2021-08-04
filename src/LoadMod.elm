module LoadMod exposing (loadMod)

{-| This module gives functions to transfer `String` to organized data.


# Load

@docs loadMod

-}

import GameData
    exposing
        ( GameData
        , dGameData
        , initGameData
        )
import Json.Decode
    exposing
        ( decodeString
        , errorToString
        )


{-| Input `String` as data. Output `(GameData,String)` as the organized data and loading information.("Ok" for right and other message for error)
-}
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
