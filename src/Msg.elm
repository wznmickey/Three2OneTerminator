module Msg exposing (Msg(..), State(..),Element(..))

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

type Element 
    = CR String
    | Area String
type Msg
    = ToState State
    | GotText (Result Http.Error String)
    | Tick Float
    | Clickon Element
    | Clickout
