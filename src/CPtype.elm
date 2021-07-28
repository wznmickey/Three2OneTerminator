module CPtype exposing (CPtype(..), dCPtype, encodeCPtype)

import Json.Decode exposing (..)
import Json.Encode exposing (..)


type CPtype
    = Local
    | Global


dCPtype : Decoder CPtype
dCPtype =
    Json.Decode.string
        |> Json.Decode.andThen
            dString2CPtype


dString2CPtype : String -> Decoder CPtype
dString2CPtype string =
    case string of
        "Local" ->
            Json.Decode.succeed
                Local

        "Global" ->
            Json.Decode.succeed
                Global

        _ ->
            Json.Decode.fail
                ("Invalid type: "
                    ++ string
                )


encodeCPtype : CPtype -> Json.Encode.Value
encodeCPtype data =
    case data of
        Local ->
            Json.Encode.string
                "Local"

        Global ->
            Json.Encode.string
                "Global"
