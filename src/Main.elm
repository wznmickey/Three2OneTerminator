module Main exposing (main)

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onClick, onKeyDown)
import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (..)
import HtmlMsg exposing (..)
import Json.Decode as Decode
import Model exposing (..)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..), init_onMovingCR)
import Update exposing (..)
import View exposing (..)


init : () -> ( Model, Cmd Msg )
init result =
    ( initModel
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta
            Tick
        , onKeyDown
            (Decode.map
                keyPress
                keyCode
            )
        ]


main =
    Browser.element
        { init =
            init
        , view =
            view
        , update =
            update
        , subscriptions =
            subscriptions
        }


view : Model -> Html Msg
view model =
    case model.state of
        Start ->
            startHtmlMsg

        Loading ->
            loadHtmlMsg
                model.loadInfo

        Pause ->
            pauseHtmlMsg

        _ ->
            runningHtmlMsg
                model
