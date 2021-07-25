module Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..))

import Browser.Events exposing (Visibility, onClick)
import File exposing (..)
import GameData exposing (..)
import Html exposing (time)
import Http


type alias OnMovingCR =
    { cRname : Maybe String
    , formerArea : Maybe String
    , toArea : Maybe String
    }


type State
    = Start
    | Loading
    | Running
    | Pause
    | End


type KeyInfo
    = Space
    | R
    | NotCare


type Element
    = CR OnMovingCR
    | Area String
    | LoadDefault
    | Restart
    | Download


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
    | KeyPress KeyInfo
