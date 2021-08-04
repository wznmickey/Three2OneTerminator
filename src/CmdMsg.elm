module CmdMsg exposing (loadUpdate, fileRequest, fileSelect)

{-| It is the module that define several `Cmd Msg` functions related to `File`.


# File

@docs loadUpdate, fileRequest, fileSelect

-}

import File exposing (File)
import File.Select as Select
import Http exposing(get)
import Msg
    exposing
        ( FileStatus(..)
        , Msg(..)
        )
import Task exposing (perform)


wholeURL : String
wholeURL =
    "asset/defaultMod.json"


{-| This functions gives `Cmd Msg` that requests to load default mod.
-}
loadUpdate : Cmd Msg
loadUpdate =
    Http.get
        { url =
            wholeURL
        , expect =
            Http.expectString GotText
        }


{-| This functions gives `Cmd Msg` that requests to upload a file.
-}
fileRequest : Cmd Msg
fileRequest =
    Cmd.map
        UploadFile
        (Select.file
            [ "text/json" ]
            FileSelected
        )


{-| This functions gives `Cmd Msg` that turns the file to `String` by giving a `File` as input.
-}
fileSelect : File -> Cmd Msg
fileSelect file =
    Cmd.map
        UploadFile
        (Task.perform
            FileLoaded
            (File.toString file)
        )
