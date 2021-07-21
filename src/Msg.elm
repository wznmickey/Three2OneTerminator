module Msg exposing (Element(..), FileStatus(..), Msg(..), State(..))

import Browser.Events exposing (Visibility, onClick)
import File exposing (..)
import GameData exposing (..)
import Html exposing (time)
import Http


type State
    = Start
    | Loading
    | Running
    | Pause
    | End


type Element
    = CR String
    | Area String


type FileStatus
    = FileRequested
    | FileSelected File
    | FileLoaded String


type Msg
    = ToState State
    | GotText (Result Http.Error String)
    | Tick Float
    | Clickon Element
    | UploadFile FileStatus
