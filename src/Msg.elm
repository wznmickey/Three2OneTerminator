module Msg exposing (..)
import GameData exposing (..)
import Browser.Events exposing (Visibility)
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