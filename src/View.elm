module View exposing (..)
import Area exposing(..)
import Msg exposing (Msg)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr

viewUnitArea :  Area -> Svg Msg
viewUnitArea unitArea =
    let 
     xpos = remainderBy 3 unitArea.no
     ypos = ( unitArea.no - 1 ) // 3

    in
     Svg.rect
        [ SvgAttr.width (String.fromFloat 50 ++ "px")
        , SvgAttr.height (String.fromFloat 50 ++ "px")
        , SvgAttr.x (String.fromInt (xpos * 50) ++ "px")
        , SvgAttr.y (String.fromInt (ypos * 50) ++ "px")
        , SvgAttr.fill unitArea.areaColor
        ]
        []
    

viewAreas : List Area -> List (Svg Msg)
viewAreas areaS =
    List.map viewUnitArea areaS