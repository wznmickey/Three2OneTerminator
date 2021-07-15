module Msg exposing (..)

import Browser.Events exposing (Visibility)
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
