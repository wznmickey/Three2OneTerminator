module View exposing (..)
import Area exposing(..)
import Msg exposing (Msg)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg exposing (text)
import GameData exposing (GameData)
import GameData exposing (CPdata)
import Html exposing (Html)
import Html exposing (div)
import Html.Attributes exposing (style)
import GameData exposing (PureCPdata)
import GameData exposing (CPtype(..))


viewUnitArea :  Area -> Svg Msg
viewUnitArea unitArea =
    let 
     xpos = Tuple.first (unitArea.areaPos)
     ypos = Tuple.second (unitArea.areaPos)

    in
   
     Svg.rect
        [ SvgAttr.width (String.fromFloat 75 ++ "px")
        , SvgAttr.height (String.fromFloat 75 ++ "px")
        , SvgAttr.x (String.fromInt ( xpos ) ++ "px")
        , SvgAttr.y (String.fromInt ( ypos ) ++ "px")
        , SvgAttr.fill unitArea.areaColor
        , SvgAttr.stroke "white"
        ]
        [text (String.fromInt unitArea.no)]
    
viewAreas : List Area -> List (Svg Msg)
viewAreas areaS =
    List.map viewUnitArea areaS



view_GlobalData : CPdata ->  Html Msg
view_GlobalData dispData  =

    div
        [ style "color" "pink"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "10px"
        , style "font-weight" "bold"
        , style "line-height" "10"
        , style "position" "absolute"
        , style "left" "1000px"
        , style "top" "0"
        , style "width" "400px"
        , style "height" "400px"
        , style "display"
            (
             if dispData.typeCP == Global then
                "block"
             else "none"
            )
        ]
        [text (dispData.pure.name ++ ": " ++ (String.fromFloat dispData.pure.data) ++ "/p" )  ]
      
filter_GlobalData : List CPdata -> List CPdata
filter_GlobalData cpGlobal =
    List.filter (\a ->
                    case a.typeCP of
                        Global ->
                                True
                        Local ->
                                False 
                )  
                cpGlobal