module Model exposing (..)

import Area exposing (..)
import Array exposing (..)
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


timeChange : Float
timeChange =
    1000


type alias Model =
    { data : GameData
    , state : State
    , modInfo : String
    , loadInfo : String
    , onviewArea : String
    , time : ( Float, Float )
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
        ( 0, 0 )
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
        , view_Areadata
            model.data.area
            model.onviewArea
        , disp_Onview
            model.onviewArea
        , storyShow
            (getStory
                model
            )
        , show_PauseInfo
        , show_DeadInfo
            model.state
        , viewMovingCR
            (combineList_2String
                model.cRmovingInfo
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
                    ( Tuple.first model.time + time, Tuple.second model.time + time )
            }

        newmodel2 =
            if Tuple.first newmodel1.time >= timeChange then
                { newmodel1
                    | data =
                        updateData
                            newmodel1.data
                    , time =
                        ( Tuple.first newmodel1.time - timeChange, Tuple.second newmodel1.time )
                }

            else
                newmodel1

        newmodel3 =
            { newmodel2
                | state =
                    check_Dead
                        newmodel2
            }

        newmodel4 =
            { newmodel3
                | state = checkWin newmodel3
            }
    in
    ( newmodel4
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
                (Clickon
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


check_DeadLocalCP : Model -> Bool
check_DeadLocalCP model =
    let
        name =
            model.data.gameInfo.local

        local =
            List.map (\x -> x.localCP) (Dict.values model.data.area)
    in
    List.all (\x -> x == True) (List.map (\x -> (getPureCPdataByName ( name, x )).data > model.data.gameInfo.min) local)


check_Dead : Model -> State
check_Dead model =
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
    if List.all (\( x, y ) -> x > y) keyVal && check_DeadLocalCP model then
        model.state

    else
        Lose


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
