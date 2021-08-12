module CPtype exposing
    ( CPtype(..)
    , decoderCPtype, encodeCPtype
    )

{-| It is the module that defines type `CPtype` used as a subtype and related functions.


# Type

@docs CPtype


# Json relate

@docs decoderCPtype, encodeCPtype

-}

import Json.Decode
    exposing
        ( Decoder
        , andThen
        , fail
        , string
        , succeed
        )
import Json.Encode
    exposing
        ( Value
        , string
        )


{-| This type defines the type of CP.
-}
type CPtype
    = Local
    | Global


{-| This function decode `CPtype`.
-}
decoderCPtype : Decoder CPtype
decoderCPtype =
    Json.Decode.string
        |> Json.Decode.andThen
            decoderString2CPtype


decoderString2CPtype : String -> Decoder CPtype
decoderString2CPtype string =
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


{-| This function encode `CPtype`.
-}
encodeCPtype : CPtype -> Json.Encode.Value
encodeCPtype data =
    case data of
        Local ->
            Json.Encode.string
                "Local"

        Global ->
            Json.Encode.string
                "Global"
