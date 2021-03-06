module HelpText exposing
    ( HelpText
    , initHelpText
    , decoderHelpText, encodeHelpText
    )

{-| It is the module that defines type `HelpText` used as a subtype and related functions.


# Type

@docs HelpText


# Init

@docs initHelpText


# Json relate

@docs decoderHelpText, encodeHelpText

-}

import Dict exposing (Dict)
import Json.Decode
    exposing
        ( Decoder
        , dict
        , map
        , string
        )
import Json.Encode
    exposing
        ( Value
        , string
        )


{-| This type defines the help text of area, CP and CR.
-}
type alias HelpText =
    { name : String
    , -- Help text.
      text : String
    }


{-| This function gives a init `HelpText`, should not be actually used in `Running`.
-}
initHelpText : HelpText
initHelpText =
    { name =
        "init"
    , text =
        "init"
    }


{-| This function decodes `HelpText`.
-}
decoderHelpText : Decoder (Dict.Dict String HelpText)
decoderHelpText =
    map
        (Dict.map
            (\name value ->
                HelpText
                    name
                    value
            )
        )
        (dict
            Json.Decode.string
        )


{-| This function encodes `HelpText`.
-}
encodeHelpText : HelpText -> Json.Encode.Value
encodeHelpText data =
    Json.Encode.string
        data.text
