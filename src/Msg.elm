module Msg exposing (State(..), KeyInfo(..), Element(..), FileStatus(..), Msg(..))

{-| It is the module that defines all the necessary Msg used in the game.


# Type

@docs State, KeyInfo, Element, FileStatus, Msg

-}

import File exposing (File)
import Http exposing (Error)
import SimpleType exposing (OnMovingCR, SetURL(..))


type State
    = Start
    | Loading
    | Running
    | Pause
    | Lose
    | Win


{-| This type defines the key message.
-}
type KeyInfo
    = Space
    | R
    | NotCare
    | H


{-| This type defines the element that is clicked.
-}
type Element
    = CR OnMovingCR
    | Area String
    | Restart
    | Download
    | SetURL (Maybe SetURL)


{-| This type defines the state of the file operation.
-}
type FileStatus
    = FileRequested
    | FileSelected File
    | FileLoaded String


{-| This type defines Msg that is used in the game.
-}
type Msg
    = ToState State
    | GotText (Result Http.Error String)
    | Tick Float
    | ClickOn Element
    | UploadFile FileStatus
    | KeyPress KeyInfo
