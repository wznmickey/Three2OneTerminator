module Msg exposing (Msg(..), State(..),Element(..),FileStatus(..))

import Browser.Events exposing (Visibility, onClick)
import GameData exposing (..)
import Html exposing (time)
import Http
import File exposing(..)



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
    = ChangeState
    | GotText (Result Http.Error String)
    | Tick Float
    | Clickon Element
    | UploadFile FileStatus
