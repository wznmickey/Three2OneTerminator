module Model exposing
    ( Model
    , initModel
    , runningHtmlMsg, update
    )

{-| This module defines `Model` and gives related functions.


# Type

@docs Model


# Init

@docs initModel


# Useful functions

@docs runningHtmlMsg, update

-}

import Area exposing (Area)
import Array exposing (fromList, get, length)
import CmdMsg exposing (fileRequest, fileSelect, loadUpdate)
import Dict exposing (Dict)
import GameData exposing (GameData, getPureCPdataByName, initGameData)
import Html exposing (Html, div)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (..)
import HtmlMsg
    exposing
        ( endHtmlMsg
        , loadHtmlMsg
        , pauseHtmlMsg
        , showButtons
        , startHtmlMsg
        , storyShow
        )
import Http
import LoadMod exposing (loadMod)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..), initOnMovingCR)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (restart)
import ToSaving exposing (save)
import Update
    exposing
        ( checkHelp
        , keyPress
        , moveCR
        , switchPause
        , updateData
        )
import View
    exposing
        ( displayOnView
        , showPauseInfo
        , viewAreaData
        , viewAreas
        , viewCRs
        , viewGlobalData
        , viewMovingCR
        )


timeChange : Float
timeChange =
    1000


{-| This type is a `Model` type, storing all necessary data.
-}
type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , loadInfo : String
    , onViewArea : String
    , time : ( Float, Float )
    , onMovingCR : OnMovingCR
    , movingInfoCR : List String
    }


{-| This function gives a init `Model`, should not be actually used in `Running`.
-}
initModel : Model
initModel =
    Model
        initGameData
        Start
        "modInfo"
        "Init"
        "init"
        ( 0, 0 )
        initOnMovingCR
        [ "CR MOVED:" ]


{-| This functions gives showing `Html Msg` based on the `Model`.
-}
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
            "rgb(173, 216, 230)"
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
                "45%"
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
        , viewAreaData
            model.data.area
            model.onViewArea
        , displayOnView
            model.onViewArea
        , storyShow
            (getStory
                model
            )
        , showPauseInfo
        , viewMovingCR
            (combineList2String
                model.movingInfoCR
            )
        , HtmlMsg.showButtons
            ( 15, 15 )
            ( 45, 10 )
            [ ( "pause", Msg.ToState Pause, 5 )
            , ( "help", Msg.ToState Pause, 5 )
            ]
        ]


getStory : Model -> String
getStory model =
    let
        i =
            Debug.log "Story" (Basics.max 0 (round (Tuple.second model.time) // 10000))
    in
    Maybe.withDefault
        (Maybe.withDefault
            ""
            (Array.get
                (Array.length
                    (Array.fromList
                        model.data.story
                    )
                    - 1
                )
                (Array.fromList
                    model.data.story
                )
            )
        )
        (Array.get
            i
            (Array.fromList
                model.data.story
            )
        )


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
        , time =
            ( 0
            , (Tuple.first
                (loadMod
                    fullText
                )
              ).time
            )
    }
        |> update
            (ToState
                Loading
            )


{-| This function receive `Msg` and `Model` to return `(Model,Cmd Msg)`, using `Msg` to know how to update data in `Model`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            updateGotText
                result
                model

        ClickOn element ->
            clickOnUpdate
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
            | onViewArea =
                name
        }
            |> changeCR
                name

      else
        model
    , Cmd.none
    )


clickCR : OnMovingCR -> Model -> ( Model, Cmd Msg )
clickCR infoCR model =
    ( let
        oldMovingCR =
            model.onMovingCR

        newNameCR =
            infoCR.nameCR

        newFromArea =
            infoCR.fromArea
      in
      if model.state == Msg.Running then
        { model
            | onMovingCR =
                { oldMovingCR
                    | nameCR =
                        newNameCR
                    , fromArea =
                        newFromArea
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


clickOnUpdate : Element -> Model -> ( Model, Cmd Msg )
clickOnUpdate element model =
    case element of
        Msg.Area name ->
            areaClick
                name
                model

        Msg.CR infoCR ->
            clickCR
                infoCR
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
        newTime =
            Basics.min
                100
                time

        newModel1 =
            { model
                | time =
                    ( Tuple.first
                        model.time
                        + newTime
                    , Tuple.second
                        model.time
                        + newTime
                    )
            }

        newModel2 =
            if Tuple.first newModel1.time >= timeChange then
                { newModel1
                    | data =
                        updateData
                            newModel1.data
                    , time =
                        ( Tuple.first
                            newModel1.time
                            - timeChange
                        , Tuple.second
                            newModel1.time
                        )
                }

            else
                newModel1

        newModel3 =
            { newModel2
                | state =
                    checkDead
                        newModel2
            }

        newModel4 =
            { newModel3
                | state =
                    checkWin
                        newModel3
            }
    in
    ( newModel4
    , Cmd.none
    )


checkWin : Model -> State
checkWin model =
    if Tuple.second model.time > model.data.gameInfo.win then
        Win

    else
        model.state


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
                (ClickOn
                    Restart
                )
                model

        Msg.H ->
            update
                (checkHelp model.state)
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


checkDeadLocalCP : Model -> Bool
checkDeadLocalCP model =
    let
        name =
            model.data.gameInfo.local

        local =
            List.map
                (\x ->
                    x.localCP
                )
                (Dict.values
                    model.data.area
                )
    in
    List.all
        (\x ->
            x == True
        )
        (List.map
            (\x ->
                (getPureCPdataByName
                    ( name, x )
                ).data
                    > model.data.gameInfo.min
            )
            local
        )


checkDead : Model -> State
checkDead model =
    let
        keyVal =
            List.map2 (\x y -> ( x.data, y ))
                (List.map
                    (\x ->
                        getPureCPdataByName
                            ( x
                            , model.data.globalCP
                            )
                    )
                    model.data.gameInfo.global
                )
                model.data.gameInfo.lose
    in
    if List.all (\( x, y ) -> x > y) keyVal && checkDeadLocalCP model then
        model.state

    else
        Lose


changeCR : String -> Model -> Model
changeCR newArea model =
    let
        oldMovingCR =
            model.onMovingCR
    in
    case model.onMovingCR.nameCR of
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

                newMovingCR =
                    { oldMovingCR
                        | nameCR =
                            Nothing
                    }

                oldInfo =
                    model.movingInfoCR
                        |> filterCRMovingInfo

                newInfo =
                    combineOnMoveCR2String
                        oldMovingCR
                        newArea
                        :: oldInfo
            in
            { model
                | data =
                    newData
                , onMovingCR =
                    newMovingCR
                , movingInfoCR =
                    newInfo
            }

        Nothing ->
            model


filterCRMovingInfo : List String -> List String
filterCRMovingInfo movingInfoCR =
    if List.length movingInfoCR >= 3 then
        updateCRMovingInfo
            movingInfoCR

    else
        movingInfoCR


updateCRMovingInfo : List String -> List String
updateCRMovingInfo old =
    List.take
        2
        old
        ++ [ "CR MOVED:" ]


combineList2String : List String -> String
combineList2String toCombine =
    List.foldl
        (++)
        ""
        toCombine


combineOnMoveCR2String : OnMovingCR -> String -> String
combineOnMoveCR2String infoCRToCombine toArea =
    case infoCRToCombine.nameCR of
        Just name ->
            case infoCRToCombine.fromArea of
                Just area ->
                    if area == toArea then
                        ""

                    else
                        "\n"
                            ++ name
                            ++ " : "
                            ++ area
                            ++ " -> "
                            ++ toArea

                Nothing ->
                    ""

        Nothing ->
            ""
