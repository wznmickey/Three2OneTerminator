module View exposing
    ( viewMovingCR, showPauseInfo, displayOnView, viewAreaData, viewGlobalData
    , viewCRs, viewAreas
    )

{-| This module gives functions related to viewing.


# Info

@docs viewMovingCR, showPauseInfo, displayOnView, viewAreaData, viewGlobalData


# Drawing

@docs viewCRs, viewAreas

-}

import Area exposing (Area)
import CPdata exposing (CPdata)
import CPtype exposing (CPtype(..))
import CRdata exposing (CRdata)
import Debug exposing (toString)
import Dict exposing (Dict, get)
import GameData
    exposing
        ( GameData
        , getAreaByName
        , getCPdataByName
        , getPureCPdataByName
        , initGameData
        )
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode exposing (Error, string)
import Msg
    exposing
        ( Element(..)
        , Msg(..)
        , State(..)
        )
import PureCPdata exposing (PureCPdata)
import Round exposing (round)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent exposing (onClick)


pink : String
pink =
    "rgb(157, 99, 110)"


viewUnitArea : ( String, Float, Float ) -> Area -> Svg Msg
viewUnitArea ( cp, max, min ) unitArea =
    let
        name =
            unitArea.name

        other =
            String.fromFloat
                (Basics.min
                    255
                    (((getPureCPdataByName
                        ( cp
                        , unitArea.localCP
                        )
                      ).data
                        - min
                     )
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
            (ClickOn
                (Msg.Area
                    name
                )
            )
        ]
        []


{-| This function returns `List (Svg Msg)` showing every area by getting `(String, Float, Float)` as color info and `List Area` as dict and location info. `( String, Float, Float )` is in order the color related local CP, max CP data and min CP data.
-}
viewAreas : ( String, Float, Float ) -> List Area -> List (Svg Msg)
viewAreas ( cp, max, min ) areaS =
    List.map
        (viewUnitArea ( cp, max, min ))
        areaS


{-| This function returns `Html Msg` showing global CP from `Dict String CPdata` as dict and `List PureCPdata` as the candidates of CPs.
-}
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
combineCPdata2String toCombineCP =
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
            toCombineCP
        )


{-| This function returns `Html Msg` based on `String` as onView area from `Dict String Area` as dict, showing the local CP.
-}
viewAreaData : Dict String Area -> String -> Html Msg
viewAreaData area onView =
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
                    (getAreaByName
                        ( onView
                        , area
                        )
                    ).localCP
                )
            )
        ]


{-| This function returns `Html Msg` showing `String` as the name of `Area`.
-}
displayOnView : String -> Html Msg
displayOnView onView =
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
            (if onView == "init" then
                ""

             else
                onView
            )
        ]


{-| This function returns `List (Svg Msg)` showing CRs from `Dict String Area` as dict of area and `List CRdata` to get CR logic location.
-}
viewCRs : Dict String Area -> List CRdata -> List (Svg Msg)
viewCRs dict cr =
    List.map
        (viewUnitCR
            dict
        )
        cr


viewUnitCR : Dict String Area -> CRdata -> Svg Msg
viewUnitCR dict cr =
    let
        name =
            cr.name

        ( xPos, yPos ) =
            (getAreaByName
                ( cr.location
                , dict
                )
            ).center

        color =
            cr.color
    in
    Svg.g
        [ SvgEvent.onClick
            (ClickOn
                (Msg.CR
                    { nameCR =
                        Just name
                    , fromArea =
                        Just
                            cr.location
                    , toArea =
                        Nothing
                    }
                )
            )
        ]
        [ Svg.circle
            [ SvgAttr.cx
                (String.fromFloat
                    (xPos
                        + Tuple.first
                            cr.place
                    )
                )
            , SvgAttr.cy
                (String.fromFloat
                    (yPos
                        + Tuple.second
                            cr.place
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
                    (xPos
                        + Tuple.first
                            cr.place
                    )
                )
            , SvgAttr.y
                (String.fromFloat
                    (yPos
                        + Tuple.second
                            cr.place
                        + 1
                    )
                )
            , SvgAttr.fontSize "4"
            , SvgAttr.textAnchor "middle"
            ]
            [ text (String.left 2 name) ]
        ]


{-| This function returns `Html Msg` showing player information of pause and help.
-}
showPauseInfo : Html Msg
showPauseInfo =
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


{-| This function returns `Html Msg` showing `String` as CR moving history.
-}
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
            "2vw"
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
