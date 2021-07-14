import Area exposing(..)
import Msg exposing (Msg)
import Svg exposing (Svg)

viewUnitArea : List Area -> List (Svg Msg)
viewUnitArea areaList =
    [ Svg.rect
        [ SvgAttr.width (String.fromFloat a.width ++ "px")
        , SvgAttr.height (String.fromFloat a.height ++ "px")
        , SvgAttr.x (String.fromFloat (Tuple.first a.leftTopPosition) ++ "px")
        , SvgAttr.y (String.fromFloat (Tuple.second a.leftTopPosition) ++ "px")
        , SvgAttr.fill (getcolor a.color)
        
        ]
        []
    ]