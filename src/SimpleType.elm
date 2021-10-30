module SimpleType exposing
    ( OnMovingCR, initOnMovingCR
    , LoadInfo(..)
    , SetURL(..)
    )

{-| This module defines several simple and basic types used in the program.


# OnMovingCR

@docs OnMovingCR, initOnMovingCR


# LoadInfo

@docs LoadInfo


# SetURL

@docs SetURL

-}


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


{-| This type defines the information when loading file.
-}
type LoadInfo
    = URL (Maybe String)
    | ShowMsg ( String, Maybe String )


{-| This type defines the url type.

  - `Temp` means the url is in second priority, can be taken by `Final` or other url.
  - `Final` means the url is in first priority, can take the place of other url and be always be the used url when there are more than 1 url.

-}
type SetURL
    = Temp String
    | Final String
