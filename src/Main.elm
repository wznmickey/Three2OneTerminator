module Main exposing (main)

import Browser exposing (element)
import GameData exposing (GameData, initGameData)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Http
import Browser.Events exposing (onAnimationFrameDelta)


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    }





type State
    = Start
    | Loading
    | Running
    | Pause
    | End


initModel : Model
initModel =
    Model initGameData Start "modInfo"


init : () -> ( Model, Cmd Msg )
init result =
    ( initModel
    , Http.get
        { url = "/defaultMod.json"
        , expect = Http.expectString GotText
        }
    )


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ text model.modInfo ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | modInfo = fullText }, Cmd.none )

                _ ->
                    ( { model | modInfo = "error" }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ onAnimationFrameDelta Tick]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
