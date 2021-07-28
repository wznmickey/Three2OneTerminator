module Model exposing (..)

import Area exposing (..)
import CmdMsg exposing (..)
import Dict exposing (Dict)
import GameData exposing (GameData, getPureCPdataByName, initGameData)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (..)
import HtmlMsg exposing (..)
import Http
import LoadMod exposing (loadMod)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..), init_onMovingCR)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (restart)
import ToSaving exposing (..)
import Update exposing (..)
import View exposing (..)


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , loadInfo : String
    , onviewArea : String
    , time : Float
    , onMovingCR : OnMovingCR
    , cRmovingInfo : List String
    }


initModel : Model
initModel =
    Model
        initGameData
        Start
        "modInfo"
        "Init"
        "init"
        0
        init_onMovingCR
        [ "CR MOVED:" ]


runningHtmlMsg : Model -> Html Msg
runningHtmlMsg model =
    div
        [ HtmlAttr.style
            "width"
            "100vw"
        , HtmlAttr.style
            "height"
            "100vh"
        , HtmlAttr.style
            "left"
            "0"
        , HtmlAttr.style
            "top"
            "0"
        , HtmlAttr.style
            "text-align"
            "center"
        , HtmlAttr.style
            "background"
            "blue"
        ]
        [ div
            [ HtmlAttr.style
                "width"
                "70vw"
            , HtmlAttr.style
                "height"
                "70vh"
            , HtmlAttr.style
                "transform"
                "translate(-50%,-50%)"
            , HtmlAttr.style
                "left"
                "50%"
            , HtmlAttr.style
                "top"
                "50%"
            , HtmlAttr.style
                "position"
                "absolute"
            ]
            [ Svg.svg
                [ SvgAttr.width
                    "100%"
                , SvgAttr.height
                    "100%"
                , SvgAttr.viewBox
                    "0 0 150 150"
                ]
                (viewAreas
                    ( model.data.gameInfo.local
                    , model.data.gameInfo.max
                    , model.data.gameInfo.min
                    )
                    (Dict.values model.data.area)
                    ++ viewCRs
                        model.data.area
                        (Dict.values
                            model.data.allCR
                        )
                )
            ]
        , viewGlobalData
            (Dict.values
                model.data.globalCP
            )
            model.data.infoCP
        , view_Areadata
            model.data.area
            model.onviewArea
        , disp_Onview
            model.onviewArea

        --, text (Debug.toString model.data.area)
        -- , text (Debug.toString model.time)
        , text
            (Debug.toString
                model.data.area
            )
        , show_PauseInfo
        , show_DeadInfo
            model.state
        , viewMovingCR
            (combineList_2String
                model.cRmovingInfo
            )
        , button
            [ HtmlEvent.onClick
                (ToState
                    Pause
                )
            ]
            [ text
                "pause"
            ]
        ]


updateGotTextOK : String -> Model -> ( Model, Cmd Msg )
updateGotTextOK fullText model =
    { model
        | modInfo =
            fullText
        , data =
            Tuple.first
                (loadMod
                    fullText
                )
        , loadInfo =
            Tuple.second
                (loadMod
                    fullText
                )
    }
        |> update
            (ToState
                Loading
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            updateGotText
                result
                model

        Clickon element ->
            clickonUpdate
                element
                model

        UploadFile fileStatus ->
            uploadUpdate
                fileStatus
                model

        Tick time ->
            timeUpdate
                time
                model

        KeyPress key ->
            keyUpdate
                key
                model

        ToState newState ->
            toState
                newState
                model


updateGotTextFail : Model -> ( Model, Cmd Msg )
updateGotTextFail model =
    { model
        | modInfo =
            "Error code : 1002"
        , loadInfo =
            "Error code : 1001"
    }
        |> update
            (ToState
                Loading
            )


areaClick : String -> Model -> ( Model, Cmd Msg )
areaClick name model =
    ( if model.state == Msg.Running then
        { model
            | onviewArea =
                name
        }
            |> changeCR
                name

      else
        model
    , Cmd.none
    )


crClick : OnMovingCR -> Model -> ( Model, Cmd Msg )
crClick crInfo model =
    ( let
        oldMovingCR =
            model.onMovingCR

        newcRname =
            crInfo.cRname

        newformerArea =
            crInfo.formerArea
      in
      if model.state == Msg.Running then
        { model
            | onMovingCR =
                { oldMovingCR
                    | cRname =
                        newcRname
                    , formerArea =
                        newformerArea
                }
        }

      else
        model
    , Cmd.none
    )


updateGotText : Result Http.Error String -> Model -> ( Model, Cmd Msg )
updateGotText result model =
    case result of
        Ok fullText ->
            updateGotTextOK
                fullText
                model

        _ ->
            updateGotTextFail
                model


downloadUpdate : Model -> Cmd Msg
downloadUpdate model =
    save
        model.data


restartUpdate : Model -> ( Model, Cmd Msg )
restartUpdate model =
    model
        |> update
            (UploadFile
                (FileLoaded
                    model.modInfo
                )
            )


clickonUpdate : Element -> Model -> ( Model, Cmd Msg )
clickonUpdate ele model =
    case ele of
        Msg.Area name ->
            areaClick
                name
                model

        Msg.CR crInfo ->
            crClick
                crInfo
                model

        Msg.LoadDefault ->
            ( model
            , loadUpdate
            )

        Msg.Download ->
            ( model
            , downloadUpdate
                model
            )

        Msg.Restart ->
            restartUpdate
                model


uploadUpdate : FileStatus -> Model -> ( Model, Cmd Msg )
uploadUpdate fileStatus model =
    case fileStatus of
        FileRequested ->
            ( model
            , fileRequest
            )

        FileSelected file ->
            ( model
            , fileSelect file
            )

        FileLoaded content ->
            updateGotTextOK
                content
                model


runningUpdate : Float -> Model -> ( Model, Cmd Msg )
runningUpdate time model =
    let
        newmodel1 =
            { model
                | time =
                    model.time + time
            }

        newmodel2 =
            if newmodel1.time >= 4000 then
                { newmodel1
                    | data =
                        updateData
                            newmodel1.data
                    , time =
                        newmodel1.time - 4000
                }

            else
                newmodel1

        newmodel3 =
            { newmodel2
                | state =
                    check_Dead
                        newmodel2
            }
    in
    ( newmodel3
    , Cmd.none
    )


loadingUpdate : Model -> ( Model, Cmd Msg )
loadingUpdate model =
    if Debug.log "info" model.loadInfo == "Ok" then
        model
            |> update
                (ToState
                    Running
                )

    else
        ( model
        , Cmd.none
        )


timeUpdate : Float -> Model -> ( Model, Cmd Msg )
timeUpdate time model =
    case model.state of
        Msg.Running ->
            runningUpdate
                time
                model

        Msg.Loading ->
            loadingUpdate
                model

        _ ->
            ( model
            , Cmd.none
            )


keyUpdate : KeyInfo -> Model -> ( Model, Cmd Msg )
keyUpdate key model =
    case key of
        Msg.Space ->
            update
                (switchPause
                    model.state
                )
                model

        Msg.R ->
            update
                (Clickon
                    Restart
                )
                model

        _ ->
            ( model
            , Cmd.none
            )


toState : State -> Model -> ( Model, Cmd Msg )
toState newState model =
    ( { model
        | state =
            newState
      }
    , Cmd.none
    )


check_Dead : Model -> State
check_Dead model =
    let
        keyVal =
            getPureCPdataByName
                ( model.data.gameInfo.global
                , model.data.globalCP
                )
    in
    if keyVal.data <= model.data.gameInfo.lose then
        End

    else
        model.state


changeCR : String -> Model -> Model
changeCR newArea model =
    let
        oldMovingCR =
            model.onMovingCR
    in
    case model.onMovingCR.cRname of
        Just x ->
            let
                data =
                    model.data

                newData =
                    { data
                        | allCR =
                            moveCR
                                model.data.allCR
                                x
                                newArea
                    }

                newmovingCR =
                    { oldMovingCR
                        | cRname =
                            Nothing
                    }

                oldInfo =
                    model.cRmovingInfo
                        |> filter_CRMovinginfo

                newInfo =
                    combine_onmoveCR2String
                        oldMovingCR
                        newArea
                        :: oldInfo
            in
            { model
                | data =
                    newData
                , onMovingCR =
                    newmovingCR
                , cRmovingInfo =
                    newInfo
            }

        Nothing ->
            model
