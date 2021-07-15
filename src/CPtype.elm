module CPtype exposing (CPtype(..), dCPtype)

import Json.Decode exposing (..)


type CPtype
    = Local
    | Global


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
