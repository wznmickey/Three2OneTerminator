module Main exposing (main)

import Area exposing (..)
import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta)
import GameData exposing (GameData, initGameData)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Http
import LoadMod exposing (loadMod)
import Msg exposing (..)
import String exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import View exposing (..)


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , area : List Area
    , loadInfo : String
    }


initModel : Model
initModel =
    Model initGameData Start "modInfo" (init_AreaS 9) "Init"


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
        [ HtmlAttr.style "width" "500"
        , HtmlAttr.style "height" "500"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "text-align" "center"
        ]
        [ Svg.svg
            [ SvgAttr.width "500"
            , SvgAttr.height "500"
            ]
            (viewAreas model.area)
        , p [] [ text (concat (List.map (\x -> x.text) model.data.helpText)) ]
        , p [] [ text model.loadInfo ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | modInfo = fullText, data = Tuple.first (loadMod fullText), loadInfo = Tuple.second (loadMod fullText) }, Cmd.none )

                _ ->
                    ( { model | modInfo = "error" }, Cmd.none )

        Tick float ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ onAnimationFrameDelta Tick ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
