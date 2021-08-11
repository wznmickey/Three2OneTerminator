module SimpleType exposing (LoadInfo(..), OnMovingCR, SetURL(..), initOnMovingCR)

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


{-| This type define the information when loading file.
-}
type LoadInfo
    = URL (Maybe String)
    | ShowMsg ( String, Maybe String )


type SetURL
    = Temp String
    | Final String
