module HelpText exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode


type alias HelpText =
    { name : String
    , -- Help text.
      text : String
    }


initHelpText : HelpText
initHelpText =
    { name =
        "init"
    , text =
        "init"
    }


decoder_HelpText : Decoder (Dict.Dict String HelpText)
decoder_HelpText =
    map
        (Dict.map
            (\name value ->
                HelpText
                    name
                    value
            )
        )
        (dict
            string
        )


encodeHelpText : HelpText -> Json.Encode.Value
encodeHelpText data =
    Json.Encode.string
        data.text
