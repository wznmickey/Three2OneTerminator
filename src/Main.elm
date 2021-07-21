module Main exposing (main)

import Area exposing (..)
import Array exposing (..)
import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onClick)
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
import LoadMod exposing (loadMod)
import Msg exposing (FileStatus(..), Msg(..), State(..))
import PureCPdata exposing (PureCPdata)
import String exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Task
import View exposing (..)
import Update exposing (..)


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
        , button [ HtmlEvent.onClick (Msg.UploadFile FileRequested) ] [ text "Load Mod" ],
         text (Debug.toString model.data.area)

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

        Clickon (Msg.Area name) ->
            ( { model | onviewArea = name } |> changeCR name, Cmd.none )

        Clickon (Msg.CR name) ->
            ( { model | onMovingCR = Just name }, Cmd.none )

        UploadFile fileStatus ->
            case fileStatus of
                FileRequested ->
                    ( model, Cmd.map UploadFile (Select.file [ "text/json" ] FileSelected) )

                FileSelected file ->
                    ( model, Cmd.map UploadFile (Task.perform FileLoaded (File.toString file)) )

                FileLoaded content ->
                    ( { model | modInfo = content, data = Tuple.first (loadMod content), loadInfo = Tuple.second (loadMod content) }, Cmd.none )

        Tick time ->
            let
                newmodel1 =
                    { model | time = model.time + time }

                newmodel2 =
                    { model | data = updateData newmodel1.data }
                
                -- newmodel3=
                --     { model | data = changeCP_byCP newmodel2.data }
            in
            ( newmodel2, Cmd.none )

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





changeCR : String -> Model -> Model
changeCR newArea model =
    case model.onMovingCR of
        Just x ->
            let
                data =
                    model.data

                newData =
                    { data | allCR = moveCR model.data.allCR x newArea }
            in
            { model | data = newData,onMovingCR=Nothing }

        Nothing ->
            model


