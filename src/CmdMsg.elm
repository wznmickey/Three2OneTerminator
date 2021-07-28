module CmdMsg exposing (..)

import File exposing (File)
import File.Select as Select
import Http
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..))
import Task


wholeURL : String
wholeURL =
    "asset/defaultMod.json"


loadUpdate : Cmd Msg
loadUpdate =
    Http.get
        { url =
            wholeURL
        , expect =
            Http.expectString GotText
        }


fileRequest : Cmd Msg
fileRequest =
    Cmd.map
        UploadFile
        (Select.file
            [ "text/json" ]
            FileSelected
        )


fileSelect : File -> Cmd Msg
fileSelect file =
    Cmd.map
        UploadFile
        (Task.perform
            FileLoaded
            (File.toString file)
        )
