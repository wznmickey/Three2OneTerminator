module Main exposing (main)

import View exposing (..)
import Browser exposing (element)
import GameData exposing (GameData, initGameData)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Http
import Browser.Events exposing (onAnimationFrameDelta,onClick)
import Msg exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Json.Decode as D
import Area exposing (..)
import Browser.Events exposing (onClick)


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , area : List Area
    }







initModel : Model
initModel =
    Model initGameData Start "modInfo" (init_AreaS 4)


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
            (viewAreas model.area )
            , (view_GlobalData model.data.globalCP)
            -- model.data.allCP
        ] 
        
        



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | modInfo = fullText }, Cmd.none )

                _ ->
                    ( { model | modInfo = "error" }, Cmd.none )
        Tick float ->
            (  model, Cmd.none )--update_Gamedata
        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ onAnimationFrameDelta Tick
                ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- update_Gamedata : Model -> Model
-- update_Gamedata oldModel = 
--      oldModel.data