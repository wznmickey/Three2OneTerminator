module Msg exposing (Msg(..),State(..))

import Browser.Events exposing (Visibility, onClick)
import GameData exposing (..)
import Html exposing (time)
import Http


type State
    = Start
    | Loading
    | Running
    | Pause
    | End


type Msg
    = ToState State
    | GotText (Result Http.Error String)
    | Tick Float
    | Clickon  Int
    | Clickout