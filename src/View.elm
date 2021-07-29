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


pink : String
pink =
    "rgb(157, 99, 110)"


button : String -> Msg -> Float -> Float -> Svg Msg
button showText msg x y =
    Svg.g
        [ SvgEvent.onClick msg
        , SvgAttr.viewBox "0 0 20 10"
        ]
        [ Svg.rect
            [ SvgAttr.x (String.fromFloat(0+x))
            , SvgAttr.y (String.fromFloat(0+y))
            , SvgAttr.width "20"
            , SvgAttr.height "10"
            , SvgAttr.fill "transparent"
            ,SvgAttr.stroke "black"
            ]
            []
        , Svg.text_
            [ SvgAttr.x (String.fromFloat(10+x))
            , SvgAttr.y (String.fromFloat(7+y))
            , SvgAttr.fontSize "5"
            , SvgAttr.textAnchor "middle"
            ]
            [ text showText ]
        ]


viewUnitArea : ( String, Float, Float ) -> Area -> Svg Msg
viewUnitArea ( cp, max, min ) unitArea =
    let
        name =
            unitArea.name

        other =
            String.fromFloat
                (255
                    - Basics.min
                        255
                        ((Maybe.withDefault
                            initPureCPdata
                            (Dict.get
                                cp
                                unitArea.localCP
                            )
                         ).data
                            / (max - min)
                            * 255
                        )
                )
    in
    Svg.path
        [ SvgAttr.d
            unitArea.view
        , SvgAttr.fill
            ("rgb("
                ++ "255"
                ++ ","
                ++ other
                ++ ","
                ++ other
                ++ ")"
            )
        , SvgAttr.stroke
            "Black"
        , SvgAttr.strokeLinejoin
            "round"
        , SvgAttr.strokeLinecap
            "round"
        , SvgEvent.onClick
            (Clickon
                (Msg.Area
                    name
                )
            )
        ]
        []


viewAreas : ( String, Float, Float ) -> List Area -> List (Svg Msg)
viewAreas ( cp, max, min ) areaS =
    List.map
        (viewUnitArea ( cp, max, min ))
        areaS


viewGlobalData : List PureCPdata -> Dict String CPdata -> Html Msg
viewGlobalData pure dict =
    div
        [ style
            "color"
            pink
        , style
            "font-weight"
            "bold"
        , style
            "position"
            "absolute"
        , style
            "left"
            "2vw"
        , style
            "top"
            "10vh"
        , style
            "white-space"
            "pre-line"
        ]
        [ text
            (combineCPdata2String
                (filterGlobalData
                    pure
                    dict
                )
            )
        ]


filterGlobalData : List PureCPdata -> Dict String CPdata -> List PureCPdata
filterGlobalData cpAll dict =
    List.filter
        (\a ->
            case
                (getCPdataByName
                    ( a.name
                    , dict
                    )
                ).typeCP
            of
                Global ->
                    True

                Local ->
                    False
        )
        cpAll


combineCPdata2String : List PureCPdata -> String
combineCPdata2String cpTocombine =
    List.foldl
        (\x a ->
            x
                ++ a
        )
        ""
        (List.map
            (\a ->
                if a.name == "init" then
                    ""

                else
                    a.name
                        ++ ": "
                        ++ Round.round
                            2
                            a.data
                        ++ "\n"
            )
            cpTocombine
        )


view_Areadata : Dict String Area -> String -> Html Msg
view_Areadata area onview =
    let
        areaInfo =
            (checkArea
                onview
                area
            ).name

        areaNum =
            (checkArea
                onview
                area
            ).no
    in
    div
        [ style
            "color"
            pink
        , style
            "text-align"
            "center"
        , style
            "position"
            "absolute"
        , style
            "left"
            "70vw"
        , style
            "top"
            "10vh"
        , style
            "width"
            "27vw"
        , style
            "white-space"
            "pre-line"
        , style
            "font-weight"
            "bold"
        ]
        [ text
            (combineCPdata2String
                (Dict.values
                    (checkArea
                        onview
                        area
                    ).localCP
                )
            )
        ]


disp_Onview : String -> Html Msg
disp_Onview onview =
    div
        [ style
            "color"
            pink
        , style
            "position"
            "absolute"
        , style
            "left"
            "70vw"
        , style
            "top"
            "5vh"
        , style
            "width"
            "27vw"
        , style
            "white-space"
            "pre-line"
        , style
            "font-weight"
            "bold"
        , style
            "text-align"
            "center"
        ]
        [ text
            (if onview == "init" then
                ""

             else
                onview
            )
        ]


checkArea : String -> Dict String Area -> Area
checkArea areaName areaS =
    case
        Dict.get
            areaName
            areaS
    of
        Just areaThis ->
            areaThis

        Nothing ->
            initArea


viewCRs : Dict String Area -> List CRdata -> List (Svg Msg)
viewCRs dict cRS =
    List.map
        (viewUnitCR
            dict
        )
        cRS


viewUnitCR : Dict String Area -> CRdata -> Svg Msg
viewUnitCR dict cRpos =
    let
        name =
            cRpos.name

        ( xpos, ypos ) =
            (Maybe.withDefault
                initArea
                (Dict.get
                    cRpos.location
                    dict
                )
            ).center

        color =
            cRpos.color
    in
    Svg.g
        [ SvgEvent.onClick
            (Clickon
                (Msg.CR
                    { cRname =
                        Just name
                    , formerArea =
                        Just
                            cRpos.location
                    , toArea =
                        Nothing
                    }
                )
            )
        ]
        [ Svg.circle
            [ SvgAttr.cx
                (String.fromFloat
                    (xpos
                        + Tuple.first
                            cRpos.place
                    )
                )
            , SvgAttr.cy
                (String.fromFloat
                    (ypos
                        + Tuple.second
                            cRpos.place
                    )
                )
            , SvgAttr.r
                (String.fromFloat
                    4.5
                )
            , SvgAttr.fill
                color
            , SvgAttr.stroke
                "black"
            , SvgAttr.strokeWidth
                "0.5"
            ]
            []
        , Svg.text_
            [ SvgAttr.x
                (String.fromFloat
                    (xpos
                        + Tuple.first
                            cRpos.place
                    )
                )
            , SvgAttr.y
                (String.fromFloat
                    (ypos
                        + Tuple.second
                            cRpos.place
                        + 1
                    )
                )
            , SvgAttr.fontSize "3"
            , SvgAttr.textAnchor "middle"
            ]
            [ text (String.left 2 name) ]
        ]


show_PauseInfo : Html Msg
show_PauseInfo =
    div
        [ style
            "color"
            pink
        , style
            "position"
            "absolute"
        , style
            "font-size"
            "large"
        , style
            "left"
            "70vw"
        , style
            "top"
            "90vh"
        , style
            "width"
            "30vw"
        , style
            "white-space"
            "pre-line"
        ]
        [ text
            "Press Space to pause.\nPress H for help."
        ]


show_DeadInfo : State -> Html Msg
show_DeadInfo state =
    div
        [ style
            "color"
            "red"
        , style
            "font-size"
            "20px"
        , style
            "font-weight"
            "bold"
        , style
            "position"
            "absolute"
        , style
            "left"
            "2vw"
        , style
            "top"
            "5vh"
        , style
            "white-space"
            "pre-line"
        ]
        [ if state == End then
            text
                "Mission Failed! Retry the mission of a terminator! Press R to restart"

          else
            text
                "Save the world! Terminator!"
        ]


viewMovingCR : String -> Html Msg
viewMovingCR info =
    div
        [ style
            "color"
            pink
        , style
            "font-weight"
            "bold"
        , style
            "position"
            "absolute"
        , style
            "left"
            "0vw"
        , style
            "top"
            "60vh"
        , style
            "width"
            "20vw"
        , style
            "white-space"
            "pre-line"
        ]
        [ text
            info
        ]


combine_onmoveCR2String : OnMovingCR -> String -> String
combine_onmoveCR2String crInfoTocombine toArea =
    case crInfoTocombine.cRname of
        Just name ->
            case crInfoTocombine.formerArea of
                Just area ->
                    if area == toArea then
                        ""

                    else
                        "\n"
                            ++ name
                            ++ " : "
                            ++ area
                            ++ " -> "
                            ++ toArea

                Nothing ->
                    ""

        Nothing ->
            ""


combineList_2String : List String -> String
combineList_2String toCombine =
    List.foldl
        (++)
        ""
        toCombine


filter_CRMovinginfo : List String -> List String
filter_CRMovinginfo crMovingInfo =
    if List.length crMovingInfo >= 5 then
        update_CRMovinginfo
            crMovingInfo

    else
        crMovingInfo


update_CRMovinginfo : List String -> List String
update_CRMovinginfo old =
    List.take
        4
        old
        ++ [ "CR MOVED:" ]
