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
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), State(..))
import PureCPdata exposing (..)
import Round exposing (round)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Msg exposing (OnMovingCR)


viewUnitArea : Area -> Svg Msg
viewUnitArea unitArea =
    let
        name =
            unitArea.name

        xpos =
            Tuple.first (init_AreaPos unitArea.no)

        ypos =
            Tuple.second (init_AreaPos unitArea.no)
    in
    Svg.rect
        [ SvgAttr.width (String.fromFloat 10 ++ "vw")
        , SvgAttr.height (String.fromFloat 20 ++ "vh")
        , SvgAttr.x (String.fromFloat xpos ++ "vw")
        , SvgAttr.y (String.fromFloat ypos ++ "vh")
        , SvgAttr.fill unitArea.areaColor
        , SvgAttr.stroke "white"
        , SvgEvent.onClick (Clickon (Msg.Area name))
        , SvgAttr.title name
        ]
        [ text (String.fromInt unitArea.no) ]


init_AreaPos : Int -> ( Float, Float )
init_AreaPos areaNumber =
    if areaNumber == 1 then
        ( 40, 40 )

    else if areaNumber == 2 then
        ( 65, 55 )

    else if areaNumber == 3 then
        ( 60, 30 )

    else
        ( 10, 20 )


viewAreas : List Area -> List (Svg Msg)
viewAreas areaS =
    List.map viewUnitArea areaS


viewGlobalData : List PureCPdata -> Dict String CPdata -> Html Msg
viewGlobalData pure dict =
    div
        [ style "color" "pink"
        , style "font-size" "20px"
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


viewCRs : List CRdata -> List (Svg Msg)
viewCRs cRS =
    List.map viewUnitCR cRS


viewUnitCR : CRdata -> Svg Msg
viewUnitCR cRpos =
    let
        name =
            cRpos.name

        xpos =
            Tuple.first (get_CRpos cRpos)

        ypos =
            Tuple.second (get_CRpos cRpos)

        color = get_CRcolor cRpos
    in
    Svg.circle
        [ SvgAttr.cx (String.fromFloat xpos ++ "vw")
        , SvgAttr.cy (String.fromFloat ypos ++ "vh")
        , SvgAttr.r (String.fromFloat 1.5 ++ "vh")
        , SvgAttr.fill color
        , SvgAttr.stroke "white"
        , SvgEvent.onClick (Clickon (Msg.CR { cRname = Just name , formerArea = Just cRpos.location , toArea = Nothing }))
        ]
        []


get_CRcolor : CRdata -> String
get_CRcolor crData =
    case crData.name of
        "Material Support1" ->
            "red"

        "Material Support2" ->
            "green"

        "Material Support3" ->
            "blue"

        "Material Support4" ->
            "yellow"

        _ ->
            ""


get_CRpos : CRdata -> ( Float, Float )
get_CRpos crData =
    case crData.location of
        "Gotham" ->
            get_CRpos_inCRtype crData.name 1

        "BomBay" ->
            get_CRpos_inCRtype crData.name 2

        "GassVille" ->
            get_CRpos_inCRtype crData.name 3

        "Burnley" ->
            get_CRpos_inCRtype crData.name 4

        _ ->
            ( 1, 1 )


get_CRpos_inCRtype : String -> Int -> ( Float, Float )
get_CRpos_inCRtype crType crAreapos =
    let
        xpos =
            Tuple.first (init_AreaPos crAreapos)

        ypos =
            Tuple.second (init_AreaPos crAreapos)
    in
    case crType of
        "Material Support1" ->
            ( xpos + 2, ypos + 3 )

        "Material Support2" ->
            ( xpos + 5, ypos + 3 )

        "Material Support3" ->
            ( xpos + 8, ypos + 3 )

        "Material Support4" ->
            ( xpos + 2, ypos + 8 )

        _ ->
            ( 0, 0 )


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
combine_onmoveCR2String crInfoTocombine toArea=
  case crInfoTocombine.cRname of 

    Just name ->

     case crInfoTocombine.formerArea of 

      Just area ->

        "\n Moved "
        ++ name
        ++ " from "
        ++ area
        ++ " to "
        ++ toArea
        ++ " ."

      Nothing ->
        ""

    Nothing ->
        ""

combineList_2String : List String -> String
combineList_2String toCombine = 
    List.foldl (++) "" (toCombine)