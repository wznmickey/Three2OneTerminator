module Main exposing (main)

{-| It is the module that contain the other functions to the main function.

# Main

@docs main

-}

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onClick, onKeyDown)
import Browser.Navigation exposing (load)
import Dict exposing (..)
import Html exposing (..)
import Html.Events as HtmlEvent exposing (..)
import HtmlMsg exposing (..)
import Json.Decode as Decode
import Model exposing (..)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..), init_onMovingCR)
import Update exposing (..)
import View exposing (..)


{-| This function gives an default Model and Cmd Msg as output for init.
-}
init : () -> ( Model, Cmd Msg )
init result =
    ( initModel
    , Cmd.none
    )


{-| This function subs onAnimationFrameDelta and onKeyDown events as Sub Msg.
-}
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


{-| This function is the main function, combining 4 functions to `Browser.element`:

  - `init`
  - `view`
  - `update`
  - `subscriptions`

-}
main : Program () Model Msg
main =
    Browser.element
        { init =
            init
        , view =
            view
        , update =
            Model.update
        , subscriptions =
            subscriptions
        }


{-| This function outputs different view based on the state of the Model.
-}
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
                (String.concat
                    (List.map (\( x, y ) -> x ++ " : " ++ y.text ++ "\n")
                        (Dict.toList
                            model.data.helpText
                        )
                    )
                )

        Win ->
            HtmlMsg.endHtmlMsg "Congratulation! You save the city.\n\n"

        Lose ->
            HtmlMsg.endHtmlMsg "You failed.\n\n"

        _ ->
            runningHtmlMsg
                model
