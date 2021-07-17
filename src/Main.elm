module Main exposing (main)

import Area exposing (..)
import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onClick)
import Dict exposing (Dict)
import GameData exposing (GameData, initGameData,getPureCPdataByName)
import HelpText exposing (initHelpText)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Http
import LoadMod exposing (loadMod)
import Msg exposing (Msg(..), State(..))
import String exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import View exposing (..)
import CRdata exposing (CRdata)
import PureCPdata exposing (PureCPdata)
import CPdata exposing(..)

type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , loadInfo : String
    , onviewArea : String
    }


initModel : Model
initModel =
    Model initGameData Start "modInfo" "Init" "init"


init : () -> ( Model, Cmd Msg )
init result =
    ( initModel
    , Http.get
        { url = "/src/defaultMod.json"
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
            (viewAreas (Dict.values model.data.area))
        , viewGlobalData (Dict.values model.data.globalCP) model.data.infoCP
        , view_Areadata model.data.area model.onviewArea
        , disp_Onview model.onviewArea
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

        Clickon areaNum ->
            ( { model | onviewArea = areaNum }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

effectCP :  Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata -> (Dict String PureCPdata,Dict String PureCPdata)
effectCP  effect global local =
    (dictEffectCP effect global,dictEffectCP effect global)


dictEffectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata
dictEffectCP effect before =
    Dict.map (getEffect effect) before

getEffect : Dict String PureCPdata-> String -> PureCPdata -> PureCPdata
getEffect effect key before =
    if (before.name==key) then
        valueEffectCP (getPureCPdataByName (key,effect)) before 
    else 
        before

valueEffectCP : PureCPdata -> PureCPdata -> PureCPdata
valueEffectCP effect before =
    {before|data=before.data+effect.data}

