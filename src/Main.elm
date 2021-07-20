module Main exposing (main)

import Area exposing (..)
import Array exposing (..)
import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onClick)
import CPdata exposing (..)
import CPtype exposing (CPtype(..))
import CRdata exposing (CRdata)
import Dict exposing (Dict)
import For exposing (..)
import GameData exposing (GameData, getPureCPdataByName, initGameData)
import HelpText exposing (initHelpText)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Http
import LoadMod exposing (loadMod)
import Msg exposing (Msg(..), State(..))
import PureCPdata exposing (PureCPdata)
import String exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import View exposing (..)


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , loadInfo : String
    , onviewArea : String
    , time : Float
    }


initModel : Model
initModel =
    Model initGameData Start "modInfo" "Init" "init" 0


init : () -> ( Model, Cmd Msg )
init result =
    ( initModel
    , Http.get
        { url = "asset/defaultMod.json"
        , expect = Http.expectString GotText
        }
    )


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "1000"
        , HtmlAttr.style "height" "1000"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "text-align" "center"
        ]
        [ Svg.svg
            [ SvgAttr.width "1000"
            , SvgAttr.height "1000"
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

        Tick time ->
            let
                newmodel1 =
                    { model | time = model.time + time }

                newmodel2 =
                    { model | data = updateData model.data }
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


effectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata -> ( Dict String PureCPdata, Dict String PureCPdata )
effectCP effect global local =
    ( dictEffectCP effect global, dictEffectCP effect local )


dictEffectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata
dictEffectCP effect before =
    Dict.map (getEffect effect) before


getEffect : Dict String PureCPdata -> String -> PureCPdata -> PureCPdata
getEffect effect key before =
    if before.name == key then
        valueEffectCP (getPureCPdataByName ( key, effect )) before

    else
        before


valueEffectCP : PureCPdata -> PureCPdata -> PureCPdata
valueEffectCP effect before =
    { before | data = before.data + effect.data }


updateData : GameData -> GameData
updateData data =
    let
        ( newArea, newGlobal ) =
            areaCPchange data.area data.globalCP
    in
    { data | area = newArea, globalCP = newGlobal }


areaCPchange : Dict String Area -> Dict String PureCPdata -> ( Dict String Area, Dict String PureCPdata )
areaCPchange area global =
    let
        pureArea =
            Array.map (\( x, y ) -> y) (Array.fromList (Dict.toList area))

        ( afterAreaArray, afterGlobal ) =
            for_outer 0 (Dict.size area) eachAreaCPchange ( pureArea, global )
    in
    ( Dict.fromList (List.map (\x -> ( x.name, x )) (Array.toList afterAreaArray)), afterGlobal )


eachAreaCPchange : Dict String PureCPdata -> Int -> Array Area -> ( Array Area, Dict String PureCPdata )
eachAreaCPchange global i a =
    let
        newArea =
            Maybe.withDefault initArea (Array.get i a)

        ( newGlobal, local ) =
            effectCP newArea.effect global newArea.localCP
    in
    ( Array.map ((\y x -> { x | localCP = y }) local) a, newGlobal )
