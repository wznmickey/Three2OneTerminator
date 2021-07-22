module Main exposing (main)

import Area exposing (..)
import Array exposing (..)
import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onClick, onKeyDown)
import CPdata exposing (..)
import CPtype exposing (CPtype(..))
import CRdata exposing (CRdata)
import Dict exposing (Dict)
import File exposing (File)
import File.Select as Select
import For exposing (..)
import GameData exposing (GameData, getPureCPdataByName, initGameData)
import HelpText exposing (initHelpText)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (..)
import Http
import Json.Decode as Decode
import LoadMod exposing (loadMod)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), State(..))
import PureCPdata exposing (PureCPdata)
import String exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Task
import Update exposing (..)
import View exposing (..)


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , loadInfo : String
    , onviewArea : String
    , time : Float
    , onMovingCR : Maybe String
    }


wholeURL : String
wholeURL =
    "asset/defaultMod.json"


initModel : Model
initModel =
    Model initGameData Start "modInfo" "Init" "init" 0 Nothing


init : () -> ( Model, Cmd Msg )
init result =
    ( initModel
    , Http.get
        { url = wholeURL
        , expect = Http.expectString GotText
        }
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyDown (Decode.map keyPress keyCode)
        ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    { model | modInfo = fullText, data = Tuple.first (loadMod fullText), loadInfo = Tuple.second (loadMod fullText) } |> update (ToState Running)

                _ ->
                    ( { model | modInfo = "error" }, Cmd.none )

        Clickon (Msg.Area name) ->
            if model.state == Msg.Running then
                ( { model | onviewArea = name } |> changeCR name, Cmd.none )

            else
                ( model, Cmd.none )

        Clickon (Msg.CR name) ->
            if model.state == Msg.Running then
                ( { model | onMovingCR = Just name }, Cmd.none )

            else
                ( model, Cmd.none )

        UploadFile fileStatus ->
            case fileStatus of
                FileRequested ->
                    ( model, Cmd.map UploadFile (Select.file [ "text/json" ] FileSelected) )

                FileSelected file ->
                    ( model, Cmd.map UploadFile (Task.perform FileLoaded (File.toString file)) )

                FileLoaded content ->
                    { model | modInfo = content, data = Tuple.first (loadMod content), loadInfo = Tuple.second (loadMod content) } |> update (ToState Running)

        Tick time ->
            if model.state == Msg.Running then
                let
                    newmodel1 =
                        { model | time = model.time + time }

                    newmodel2 =
                        if newmodel1.time >= 500 then
                            { newmodel1 | data = updateData newmodel1.data, time = newmodel1.time - 500 }

                        else
                            newmodel1

                    newmodel3 =
                        { newmodel2 | state = check_Dead newmodel2 }
                in
                ( newmodel3, Cmd.none )

            else
                ( model, Cmd.none )

        KeyPress key ->
            case key of
                Msg.Space ->
                    update (switchPause model) model

                Msg.R ->
                    update (ToState Start) model

                _ ->
                    ( model, Cmd.none )

        ToState newState ->
            ( { model | state = newState }, Cmd.none )


check_Dead : Model -> State
check_Dead model =
    let
        keyVal =
            getPureCPdataByName ( "Citizen trust", model.data.globalCP )
    in
    if keyVal.data <= 0 then
        End

    else
        model.state


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "95vw"
        , HtmlAttr.style "height" "95vh"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "text-align" "center"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            (viewAreas (Dict.values model.data.area) ++ viewCRs (Dict.values model.data.allCR))
        , viewGlobalData (Dict.values model.data.globalCP) model.data.infoCP
        , view_Areadata model.data.area model.onviewArea
        , disp_Onview model.onviewArea
        , button [ HtmlEvent.onClick (Msg.UploadFile FileRequested) ] [ text "Load Mod" ]
        , text (Debug.toString model.data.area)
        , text (Debug.toString model.time)
        , text (Debug.toString model.state)
        , show_PauseInfo
        , show_DeadInfo model
        ]
