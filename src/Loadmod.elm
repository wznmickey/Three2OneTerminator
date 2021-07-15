module LoadMod exposing (loadMod)

import Area exposing (..)
import GameData exposing (..)
import Json.Decode exposing (..)


loadMod : String -> ( GameData, String )
loadMod st =
    let
        ans =
            decodeString dGameData st
    in
    case ans of
        Ok x ->
            ( x, "Ok" )

        Err x ->
            ( initGameData, Json.Decode.errorToString x )


dCPtype : Decoder CPtype
dCPtype =
    Json.Decode.string |> Json.Decode.andThen dString2CPtype


dString2CPtype : String -> Decoder CPtype
dString2CPtype string =
    case string of
        "Local" ->
            Json.Decode.succeed Local

        "Global" ->
            Json.Decode.succeed Global

        _ ->
            Json.Decode.fail ("Invalid type: " ++ string)


dGameData : Decoder GameData
dGameData =
    map3 GameData
        (field
            "CP"
            (list dCP)
        )
        (field
            "CR"
            (list dCR)
        )
        (field
            "helpText"
            (list dHelpText)
        )


dCP : Decoder CPdata
dCP =
    map3 CPdata
        dPureCP
        (field
            "effect"
            (list dPureCP)
        )
        (field
            "type"
            dCPtype
        )


dPureCP : Decoder PureCPdata
dPureCP =
    map2 PureCPdata
        (field
            "name"
            string
        )
        (oneOf
            [ field
                "initValue"
                float
            , field
                "value"
                float
            ]
        )


dCR : Decoder CRdata
dCR =
    map3 CRdata
        (field
            "name"
            string
        )
        (field
            "location"
            int
        )
        (field
            "effect"
            (list dPureCP)
        )



--darea : Decoder Area
--darea =
--    map3 Area
--        (field
--        "name" string)
--        (field
--        "location" int)
--        (field
--        "effect" (list dPureCP))


dHelpText : Decoder HelpText
dHelpText =
    map2 HelpText
        (field
            "name"
            string
        )
        (field
            "text"
            string
        )
