module View exposing (..)

import Area exposing (..)
import CPdata exposing (..)
import CPtype exposing (..)
import CRdata exposing (CRdata)
import Debug exposing (toString)
import Dict exposing (Dict, get)
import GameData exposing (..)
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode exposing (Error, string)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..))
import PureCPdata exposing (..)
import Round exposing (round)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent


viewUnitArea : Area -> Svg Msg
viewUnitArea unitArea =
    let
        name =
            unitArea.name
    in
    Svg.path
        [ SvgAttr.d unitArea.view
        , SvgAttr.fill "Red"
        , SvgAttr.stroke "Black"
        , SvgEvent.onClick (Clickon (Msg.Area name))
        ]
        []


viewAreas : List Area -> List (Svg Msg)
viewAreas areaS =
    List.map viewUnitArea areaS


viewGlobalData : List PureCPdata -> Dict String CPdata -> Html Msg
viewGlobalData pure dict =
    div
        [ style "color" "pink"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "left" "2vw"
        , style "top" "2vh"
        , style "white-space" "pre-line"
        ]
        [ text ("Global Control Points: \n" ++ combineCPdata2String (filterGlobalData pure dict)) ]


filterGlobalData : List PureCPdata -> Dict String CPdata -> List PureCPdata
filterGlobalData cpAll dict =
    List.filter
        (\a ->
            case (getCPdataByName ( a.name, dict )).typeCP of
                Global ->
                    True

                Local ->
                    False
        )
        cpAll


combineCPdata2String : List PureCPdata -> String
combineCPdata2String cpTocombine =
    List.foldl (\x a -> x ++ a)
        ""
        (List.map
            (\a ->
                a.name ++ ": " ++ Round.round 2 a.data ++ "\n"
            )
            cpTocombine
        )


view_Areadata : Dict String Area -> String -> Html Msg
view_Areadata area onview =
    let
        areaInfo =
            (checkArea onview area).name

        areaNum =
            (checkArea onview area).no
    in
    div
        [ style "color" "pink"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "left" "70vw"
        , style "top" "10vh"
        , style "width" "20vw"
        , style "white-space" "pre-line"
        ]
        [ text (combineCPdata2String (Dict.values (checkArea onview area).localCP)) ]


disp_Onview : String -> Html Msg
disp_Onview onview =
    div
        [ style "color" "pink"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "font-size" "large"
        , style "left" "70vw"
        , style "top" "5vh"
        , style "width" "20vw"
        , style "white-space" "pre-line"
        ]
        [ text ("onview is " ++ onview) ]


combine_LocalCPdata2String : List PureCPdata -> String
combine_LocalCPdata2String cpTocombine =
    List.foldl (\x a -> x ++ a)
        "Local Control Points"
        (List.map
            (\a ->
                a.name ++ ": " ++ Round.round 2 a.data ++ "\n"
            )
            cpTocombine
        )


checkArea : String -> Dict String Area -> Area
checkArea areaName areaS =
    case Dict.get areaName areaS of
        Just areaThis ->
            areaThis

        Nothing ->
            initArea


viewCRs : Dict String Area -> List CRdata -> List (Svg Msg)
viewCRs dict cRS =
    List.map (viewUnitCR dict) cRS


viewUnitCR : Dict String Area -> CRdata -> Svg Msg
viewUnitCR dict cRpos =
    let
        name =
            cRpos.name

        ( xpos, ypos ) =
            (Maybe.withDefault initArea (Dict.get cRpos.location dict)).center

        color =
            cRpos.color
    in
    Svg.circle
        [ SvgAttr.cx (String.fromFloat (xpos + Tuple.first cRpos.place))
        , SvgAttr.cy (String.fromFloat (ypos + Tuple.second cRpos.place))
        , SvgAttr.r (String.fromFloat 3)
        , SvgAttr.fill color
        , SvgAttr.stroke "white"
        , SvgEvent.onClick (Clickon (Msg.CR { cRname = Just name, formerArea = Just cRpos.location, toArea = Nothing }))
        ]
        []


show_PauseInfo : Html Msg
show_PauseInfo =
    div
        [ style "color" "pink"
        , style "position" "absolute"
        , style "font-size" "large"
        , style "left" "80vw"
        , style "top" "50vh"
        , style "width" "20vw"
        , style "white-space" "pre-line"
        ]
        [ text "press space to continue/pause" ]


show_DeadInfo : State -> Html Msg
show_DeadInfo state =
    div
        [ style "color" "red"
        , style "font-size" "20px"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "left" "2vw"
        , style "top" "0vh"
        , style "white-space" "pre-line"
        ]
        [ if state == End then
            text "Mission Failed! Retry the mission of a terminator! Press R to restart"

          else
            text "Save the world! Terminator!"
        ]


viewMovingCR : String -> Html Msg
viewMovingCR info =
    div
        [ style "color" "pink"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "font-size" "large"
        , style "left" "0vw"
        , style "top" "50vh"
        , style "width" "20vw"
        , style "white-space" "pre-line"
        ]
        [ text info ]


combine_onmoveCR2String : OnMovingCR -> String -> String
combine_onmoveCR2String crInfoTocombine toArea =
    case crInfoTocombine.cRname of
        Just name ->
            case crInfoTocombine.formerArea of
                Just area ->
                    "\n"
                        ++ name
                        ++ " : "
                        ++ area
                        ++ " -> "
                        ++ toArea
                        ++ " ."

                Nothing ->
                    ""

        Nothing ->
            ""


combineList_2String : List String -> String
combineList_2String toCombine =
    List.foldl (++) "" toCombine


filter_CRMovinginfo : List String -> List String
filter_CRMovinginfo crMovingInfo =
    if List.length crMovingInfo >= 5 then
        update_CRMovinginfo crMovingInfo

    else
        crMovingInfo


update_CRMovinginfo : List String -> List String
update_CRMovinginfo old =
    List.take 4 old ++ [ "CR MOVED:" ]
