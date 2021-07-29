module HtmlMsg exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (..)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), State(..))


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
        [ button
            [ HtmlEvent.onClick
                (Msg.UploadFile
                    FileRequested
                )
            ]
            [ text
                "Upload file"
            ]
        , button
            [ HtmlEvent.onClick
                (Msg.Clickon
                    LoadDefault
                )
            ]
            [ text "Default starting" ]
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
        [ text
            loadInfo
        , button
            [ HtmlEvent.onClick
                (Msg.UploadFile
                    FileRequested
                )
            ]
            [ text
                "Upload file"
            ]
        , button
            [ HtmlEvent.onClick
                (Msg.Clickon
                    LoadDefault
                )
            ]
            [ text
                "Default starting"
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
            [ text "\nPress Space to continue\nPress R to restart\n"
            , text st
            , p []
                [ button
                    [ HtmlEvent.onClick
                        (ToState
                            Running
                        )
                    ]
                    [ text "continue" ]
                , button
                    [ HtmlEvent.onClick
                        (Msg.Clickon
                            Restart
                        )
                    ]
                    [ text "restart" ]
                , button
                    [ HtmlEvent.onClick
                        (Msg.Clickon
                            Download
                        )
                    ]
                    [ text "download" ]
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
        [ text story ]
