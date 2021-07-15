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
import Json.Decode exposing (string)
import Debug exposing (toString)


viewUnitArea :   Area ->  Svg Msg
viewUnitArea  unitArea =
    let 
     xpos = Tuple.first (init_AreaPos unitArea.no)
     ypos = Tuple.second (init_AreaPos unitArea.no)

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

init_AreaPos: Int -> (Int,Int)
init_AreaPos areaNumber =
  if areaNumber == 1 then
  (200,250)
  else if areaNumber == 2 then
  (280,200)
  else if areaNumber == 3 then
  (350,300)
  else (50,100)

    
viewAreas : List Area -> List (Svg Msg)
viewAreas areaS =
    List.map viewUnitArea  areaS 



view_GlobalData : List CPdata ->  Html Msg
view_GlobalData dispData  =

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
        [text (combine_Cpdata_toString(filter_GlobalData dispData))  ]
      
filter_GlobalData : List CPdata -> List CPdata
filter_GlobalData cpAll =
    List.filter (
                \a ->
                    case a.typeCP of
                        Global ->
                                True
                        Local ->
                                False 
                )  
                cpAll

combine_Cpdata_toString : List CPdata ->  String
combine_Cpdata_toString cpTocombine =
    List.foldl (\x a -> x ++ a) "" 
    (
        (List.map (
        \a-> 
            a.pure.name ++ ": " ++ (String.fromFloat a.pure.data) ++ "\n"
        ) 
        cpTocombine
        )
    )





