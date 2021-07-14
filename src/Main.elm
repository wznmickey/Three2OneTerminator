module Main exposing (main)

import Browser exposing (element)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)


type alias Area =
    { --view : Mapview,
      localCP : List CPdata
    , effect : List PureCPdata
    , no : Int
    , --The index of the area.
      helpText : List CPhelp
    }


type alias CRdata =
    { --view: CRview
      location : Int
    , -- The index of the area.
      effect : List PureCPdata
    }


type alias CPdata =
    { pure : PureCPdata
    , effect : List PureCPdata
    }


type alias PureCPdata =
    { name : String
    , data : Float

    {--
            The data have 2 meaning:
            1. when as effect: increase or decrease of certain CP each time loaded 
            2. when as globalCP/localCP: the value of the certain CP
        --}
    }


type alias CPhelp =
    { name : String
    , text : String -- Help text.
    }


type alias Model =
    { area : List Area
    , globalCP : List CPdata
    , cr : List CRdata
    }


type Msg
    = Run
    | Paue


initCPhelp : CPhelp
initCPhelp =
    { name = "init", text = "init" }


initPureCPdata : PureCPdata
initPureCPdata =
    { name = "init", data = 0 }


initCPdata : CPdata
initCPdata =
    { pure = initPureCPdata
    , effect = [ initPureCPdata ]
    }


initArea : Area
initArea =
    { localCP = [ initCPdata ]
    , effect = [ initPureCPdata ]
    , no = 0
    , helpText = [ initCPhelp ]
    }


initCRdata : CRdata
initCRdata =
    { location = 0
    , effect = [ initPureCPdata ]
    }


initModel : Model
initModel =
    Model [ initArea ] [ initCPdata ] [ initCRdata ]


init : () -> ( Model, Cmd Msg )
init a =
    ( initModel, Cmd.none )


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "100px"
        , HtmlAttr.style "height" "100px"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "text-align" "center"
        ]
        []


update : Msg -> Model -> ( Model, Cmd Msg )
update a b =
    ( b, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions a =
    Sub.batch []


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
