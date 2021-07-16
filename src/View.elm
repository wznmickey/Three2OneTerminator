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


viewUnitArea : Area -> Svg Msg
viewUnitArea unitArea =
    let
        xpos =
            Tuple.first (init_AreaPos unitArea.no)

        ypos =
            Tuple.second (init_AreaPos unitArea.no)

        --ypos =
        --    (unitArea.no - 1) // 3
    in
    Svg.rect
        [ SvgAttr.width (String.fromFloat 75 ++ "px")
        , SvgAttr.height (String.fromFloat 75 ++ "px")
        , SvgAttr.x (String.fromInt xpos ++ "px")
        , SvgAttr.y (String.fromInt ypos ++ "px")
        , SvgAttr.fill unitArea.areaColor
        , SvgAttr.stroke "white"
        ]
        [ text (String.fromInt unitArea.no) ]



-- viewCR :  Area -> Svg Msg
-- viewCR unitArea =
--     let
--      areaXpos = Tuple.first (unitArea.areaPos)
--      areaYpos = Tuple.second (unitArea.areaPos)
--      xpos = Tuple.first (unitArea.areaPos)
--      ypos = Tuple.second (unitArea.areaPos)
--     in
--      Svg.rect
--         [ SvgAttr.width (String.fromFloat 75 ++ "px")
--         , SvgAttr.height (String.fromFloat 75 ++ "px")
--         , SvgAttr.x (String.fromInt ( xpos ) ++ "px")
--         , SvgAttr.y (String.fromInt ( ypos ) ++ "px")
--         , SvgAttr.fill unitArea.areaColor
--         , SvgAttr.stroke "white"
--         ]
--         [text (String.fromInt unitArea.no)]


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
        [ text (combineCPdata2String (filterGlobalData pure dict)) ]


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
