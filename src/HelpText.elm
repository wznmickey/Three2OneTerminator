module HelpText exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)


type alias HelpText =
    { name : String
    , -- Help text.
      text : String
    }


initHelpText : HelpText
initHelpText =
    { name = "init", text = "init" }


dHelpText : Decoder (Dict.Dict String HelpText)
dHelpText =
    map (Dict.map (\name value -> HelpText name value)) (dict string)
