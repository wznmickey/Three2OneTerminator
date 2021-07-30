module HtmlMsg exposing (..)

import Array
import For exposing (for_outer)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (..)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), State(..))
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import SvgMsg exposing (..)


showButtons : ( Float, Float ) -> ( Float, Float ) -> List ( String, Msg, Float ) -> Html Msg
showButtons ( w, h ) ( l, t ) x =
    div
        [ HtmlAttr.style
            "width"
            (String.fromFloat w ++ "vw")
        , HtmlAttr.style
            "height"
            (String.fromFloat h ++ "vh")
        , HtmlAttr.style
            "transform"
            "translate(-50%,-50%)"
        , HtmlAttr.style
            "left"
            (String.fromFloat l ++ "%")
        , HtmlAttr.style
            "top"
            (String.fromFloat t ++ "%")
        , HtmlAttr.style
            "position"
            "absolute"
        ]
        [ Svg.svg
            [ SvgAttr.viewBox
                ("-5 0 "
                    ++ String.fromInt (List.length x * 25 + 10)
                    ++ " 15"
                )
            , SvgAttr.width
                "100%"
            , SvgAttr.height
                "100%"
            ]
            (Tuple.first
                (for_outer
                    0
                    (List.length x - 1)
                    (\all i before ->
                        let
                            ( st, m, size ) =
                                Maybe.withDefault ( "", KeyPress NotCare, 0 ) (Array.get i (Array.fromList all))
                        in
                        ( SvgMsg.button
                            st
                            m
                            (toFloat (i * 30))
                            0
                            size
                            :: before
                        , all
                        )
                    )
                    ( [], x )
                )
            )
        ]


startHtmlMsg : Html Msg
startHtmlMsg =
    div
        [ HtmlAttr.style
            "width"
            "95vw"
        , HtmlAttr.style
            "height"
            "95vh"
        , HtmlAttr.style
            "left"
            "0"
        , HtmlAttr.style
            "top"
            "0"
        , HtmlAttr.style
            "text-align"
            "center"
        ]
        [ showButtons
            ( 20, 10 )
            ( 50, 70 )
            [ ( "Upload file"
              , Msg.UploadFile
                    FileRequested
              , 3
              )
            , ( "Quick start"
              , Msg.Clickon
                    LoadDefault
              , 3
              )
            ]
        ]


loadHtmlMsg : String -> Html Msg
loadHtmlMsg loadInfo =
    div
        [ HtmlAttr.style
            "width"
            "95vw"
        , HtmlAttr.style
            "height"
            "95vh"
        , HtmlAttr.style
            "left"
            "0"
        , HtmlAttr.style
            "top"
            "0"
        , HtmlAttr.style
            "text-align"
            "center"
        ]
        [ Html.text
            loadInfo
        , showButtons
            ( 20, 10 )
            ( 50, 70 )
            [ ( "Upload file"
              , Msg.UploadFile
                    FileRequested
              , 3
              )
            , ( "Quick start"
              , Msg.Clickon
                    LoadDefault
              , 3
              )
            ]
        ]


pauseHtmlMsg : String -> Html Msg
pauseHtmlMsg st =
    div
        [ HtmlAttr.style
            "width"
            "100vw"
        , HtmlAttr.style
            "height"
            "100vh"
        , HtmlAttr.style
            "left"
            "0"
        , HtmlAttr.style
            "top"
            "0"
        , HtmlAttr.style
            "text-align"
            "center"
        , HtmlAttr.style
            "background"
            "brown"
        ]
        [ p
            [ HtmlAttr.style
                "top"
                "50%"
            , HtmlAttr.style
                "left"
                "50%"
            , HtmlAttr.style
                "transform"
                "translate( -50%, -50%)"
            , HtmlAttr.style
                "position"
                "absolute"
            , HtmlAttr.style
                "white-space"
                "pre-line"
            , HtmlAttr.style
                "width"
                "80vw"
            , HtmlAttr.style
                "color"
                "white"
            ]
            [ Html.text "\nPress Space to continue\nPress R to restart\n"
            , Html.text st
            , p []
                [ showButtons
                    ( 80, 7 )
                    ( 50, 110 )
                    [ ( "continue"
                      , ToState
                            Running
                      , 3.5
                      )
                    , ( "restart"
                      , Msg.Clickon
                            Restart
                      , 3.5
                      )
                    , ( "download"
                      , Msg.Clickon
                            Download
                      , 3.5
                      )
                    ]
                ]
            ]
        ]


storyShow : String -> Html Msg
storyShow story =
    div
        [ HtmlAttr.style
            "width"
            "27vw"
        , HtmlAttr.style
            "height"
            "50vh"
        , HtmlAttr.style
            "left"
            "70%"
        , HtmlAttr.style
            "top"
            "20%"
        , HtmlAttr.style
            "text-align"
            "left"
        , HtmlAttr.style
            "position"
            "absolute"
        , HtmlAttr.style
            "white-space"
            "pre-line"
        ]
        [ Html.text story ]
