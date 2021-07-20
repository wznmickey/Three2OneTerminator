module View exposing (..)

import Area exposing (..)
import CPdata exposing (..)
import CPtype exposing (..)
import Debug exposing (toString)
import Dict exposing (Dict, get)
import GameData exposing (..)
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode exposing (Error, string)
import Msg exposing (Msg(..))
import PureCPdata exposing (..)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import CRdata exposing (CRdata)


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
        [ SvgAttr.width (String.fromFloat 150 ++ "px")
        , SvgAttr.height (String.fromFloat 150 ++ "px")
        , SvgAttr.x (String.fromInt xpos ++ "px")
        , SvgAttr.y (String.fromInt ypos ++ "px")
        , SvgAttr.fill unitArea.areaColor
        , SvgAttr.stroke "white"
        , SvgEvent.onClick (Clickon name)
        ]
        [ text (String.fromInt unitArea.no) ]


init_AreaPos : Int -> ( Int, Int )
init_AreaPos areaNumber =
    if areaNumber == 1 then
        ( 400, 400 )

    else if areaNumber == 2 then
        ( 650, 550 )

    else if areaNumber == 3 then
        ( 600, 300 )

    else
        ( 100, 200 )


-- 


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
        , style "left" "0"
        , style "top" "0"
        , style "white-space" "pre-line"
        ]
        [ text ("Global Control Point: \n" ++ combineCPdata2String (filterGlobalData pure dict)) ]


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
                a.name ++ ": " ++ String.fromFloat a.data ++ "\n"
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
        , style "font-size" "20px"
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
        , style "font-size" "20px"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "left" "70vw"
        , style "top" "5vh"
        , style "width" "20vw"
        , style "white-space" "pre-line"
        ]
        [ text ("onview is " ++ onview) ]


combine_LocalCPdata2String : List PureCPdata -> String
combine_LocalCPdata2String cpTocombine =
    List.foldl (\x a -> x ++ a)
        "Local Control Point"
        (List.map
            (\a ->
                a.name ++ ": " ++ String.fromFloat a.data ++ "\n"
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

        xpos =
            Tuple.first (get_CRpos cRpos)

        ypos =
            Tuple.second (get_CRpos cRpos)
    in
    
        Svg.circle
        [ 
        SvgAttr.cx (String.fromInt xpos ++ "px")
        , SvgAttr.cy (String.fromInt ypos ++ "px")
        , SvgAttr.r (String.fromFloat 10 ++ "px")
        , SvgAttr.fill "yellow"
        , SvgAttr.stroke "red"
        -- , SvgEvent.onClick (Clickon name)
        ]
        []
    


get_CRpos : CRdata -> (Int,Int)
get_CRpos crData = 
    case crData.location of 
        "Gotham"->
            (get_CRpos_inCRtype crData.name 1  )
        "BomBay"->
            (get_CRpos_inCRtype crData.name 2  )
        "GassVille"->
            (get_CRpos_inCRtype crData.name 3  )
        "Burnley"->
            (get_CRpos_inCRtype crData.name 4  )
        _->
            (1,1)

get_CRpos_inCRtype : String -> Int -> (Int, Int)
get_CRpos_inCRtype crType crAreapos = 
    let

        xpos =
            Tuple.first (init_AreaPos crAreapos)

        ypos =
            Tuple.second (init_AreaPos crAreapos)
    in
    case crType of
    "CR1"->
        (xpos + 20 , ypos + 20)
    "CR2"->
        (xpos + 50 , ypos + 50)
    _->
        (0,0) 




-- viewCRs_onArea : Area -> Dict String CRdata ->List CList (Svg Msg)
-- viewCRs_onArea  areaS cRs=
--     List.map viewUnitCR areaS






--  --view : Mapview,
--       name : "none"
--     , localCP : Dict String PureCPdata
--     , effect : Dict String PureCPdata
--     , --The index of the area. Start from **1**.
--       no : Int
--     , areaColor : String
--     }
