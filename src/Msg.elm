module Msg exposing
    ( OnMovingCR, State(..), KeyInfo(..), Element(..), FileStatus(..), Msg(..)
    , initOnMovingCR
    )

{-| It is the module that defines all the necessary Msg used in the game.


# Type

@docs OnMovingCR, State, KeyInfo, Element, FileStatus, Msg


# Init

@docs initOnMovingCR

-}

import File exposing (File)
import Http exposing (Error)


{-| This type define the moving info of a CR.
-}
type alias OnMovingCR =
    { nameCR : Maybe String
    , fromArea : Maybe String
    , toArea : Maybe String
    }


{-| This function init `OnMovingCR` with all `Nothing`.
-}
initOnMovingCR : OnMovingCR
initOnMovingCR =
    { nameCR =
        Nothing
    , fromArea =
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
    | ClickOn Element
    | UploadFile FileStatus
    | KeyPress KeyInfo
