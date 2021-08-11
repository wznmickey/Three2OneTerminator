module Msg exposing
    ( OnMovingCR, State(..), KeyInfo(..), Element(..), FileStatus(..), Msg(..)
    , init_onMovingCR
    )

{-| It is the module that defines all the necessary Msg used in the game.


# Type

@docs OnMovingCR, State, KeyInfo, Element, FileStatus, Msg


# Init

@docs init_onMovingCR

-}

import File exposing (File)
import Http exposing (Error)


{-| This type define the moving info of a CR.
-}
type alias OnMovingCR =
    { cRname : Maybe String
    , formerArea : Maybe String
    , toArea : Maybe String
    }


{-| This function init `OnMovingCR` with all `Nothing`.
-}
init_onMovingCR : OnMovingCR
init_onMovingCR =
    { cRname =
        Nothing
    , formerArea =
        Nothing
    , toArea =
        Nothing
    }


{-| This type defines the state of the game.
-}
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
    | LoadDefault
    | Restart
    | Download


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
    | Clickon Element
    | UploadFile FileStatus
    | KeyPress KeyInfo
