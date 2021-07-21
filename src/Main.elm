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
        [ HtmlAttr.style "width" "100vw"
        , HtmlAttr.style "height" "100vh"
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


moveCR : Dict String CRdata -> String -> String -> Dict String CRdata
moveCR before from to =
    Dict.update from (setCRlocation to) before


setCRlocation : String -> Maybe CRdata -> Maybe CRdata
setCRlocation to from =
    case from of
        Just fromArea ->
            Maybe.Just { fromArea | location = to }

        _ ->
            from
