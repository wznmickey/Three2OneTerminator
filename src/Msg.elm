module Msg exposing (..)
import Main exposing (..)
import GameData exposing (..)
import Browser.Events exposing (Visibility)
import Html exposing (time)

type Msg
    = ToState State
    | GotText (Result Http.Error String)
    | Tick Float