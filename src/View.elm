module View exposing (..)

import Area exposing (..)
import CPdata exposing (..)
import CPtype exposing (..)
import Debug exposing (toString)
import Dict exposing (Dict)
import GameData exposing (..)
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode exposing (string)
import Msg exposing (Msg)
import PureCPdata exposing (..)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Msg exposing (Msg(..))
import Dict exposing (get)
import Json.Decode exposing (Error)
import Area exposing (initArea)
viewUnitArea : Area -> Svg Msg
viewUnitArea unitArea =
    let

        num = unitArea.no
        xpos =
            Tuple.first (init_AreaPos unitArea.no)

        ypos =
            Tuple.second (init_AreaPos unitArea.no)

    in
    Svg.rect
        [ SvgAttr.width (String.fromFloat 75 ++ "px")
        , SvgAttr.height (String.fromFloat 75 ++ "px")
        , SvgAttr.x (String.fromInt xpos ++ "px")
        , SvgAttr.y (String.fromInt ypos ++ "px")
        , SvgAttr.fill unitArea.areaColor
        , SvgAttr.stroke "white"
        , SvgEvent.onClick (Clickon num)
        ]
        [ text (String.fromInt unitArea.no) ]




init_AreaPos : Int -> ( Int, Int )
init_AreaPos areaNumber =
    if areaNumber == 1 then
        ( 200, 250 )

    else if areaNumber == 2 then
        ( 280, 200 )

    else if areaNumber == 3 then
        ( 350, 300 )

    else
        ( 50, 100 )


init_CRpos : Int -> ( Int, Int )
init_CRpos areaNumber =
    if areaNumber == 1 then
        ( 200, 250 )

    else if areaNumber == 2 then
        ( 280, 200 )

    else if areaNumber == 3 then
        ( 350, 300 )

    else
        ( 50, 100 )



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
        , style "width" "400px"
        , style "height" "400px"
        , style "white-space" "pre-line"
        ]
        [ text ("Global Control Point: \n" ++ (combineCPdata2String (filterGlobalData pure dict))) ]


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

view_Areadata : Dict String Area -> Int -> Html Msg
view_Areadata area onview =
    let        areaInfo = (checkArea onview area).name
               areaNum =  (checkArea onview area).no
    in
    div
        [ style "color" "pink"
        , style "font-size" "20px"
        , style "font-weight" "bold"
        , style "position" "absolute"
        , style "left" "1000px"
        , style "top" "1000"
        , style "width" "400px"
        , style "height" "400px"
        , style "white-space" "pre-line"
        ]
        [ text (areaInfo ++ (String.fromInt areaNum))]



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

checkArea : Int -> Dict String Area -> Area 
checkArea areaNum areaS =
   case  Dict.get (String.fromInt areaNum) areaS of 
        Just areaThis ->
            areaThis
        Nothing ->
            initArea
    


--  --view : Mapview,
--       name : "none"
--     , localCP : Dict String PureCPdata
--     , effect : Dict String PureCPdata
--     , --The index of the area. Start from **1**.
--       no : Int
--     , areaColor : String
--     }