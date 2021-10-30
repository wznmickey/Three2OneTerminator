module HtmlMsg exposing
    ( endHtmlMsg, loadHtmlMsg, pauseHtmlMsg, startHtmlMsg, storyShow
    , showButtons
    )

{-| This module gives functions that to show on the screen as `Html Msg`.


# Text

@docs endHtmlMsg, loadHtmlMsg, pauseHtmlMsg, startHtmlMsg, storyShow


# Draw

@docs showButtons

-}

import Array exposing (get)
import For exposing (for)
import Html exposing (Html, div, img, input, p)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events as HtmlEvent exposing (onInput)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), State(..))
import SimpleType exposing (LoadInfo(..), SetURL(..))
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent exposing (onClick)
import SvgMsg exposing (button)


assetURL : String
assetURL =
    "asset/"


defaultModName : String
defaultModName =
    "defaultMod.json"


{-| This function returns `Html Msg` as several buttons based on :

  - `(Float,Float)` as width and height
  - `(Float,Float)` as left and top
  - `List ( String, Msg, Float )` as showing text, bounded `Msg` and showing size

-}
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
                    ++ String.fromInt (List.length x * 25 + 15)
                    ++ " 15"
                )
            , SvgAttr.width
                "100%"
            , SvgAttr.height
                "100%"
            ]
            (Tuple.first
                (For.for
                    0
                    (List.length x - 1)
                    (\i ( before, all ) ->
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


setCenter : List (Html.Attribute Msg)
setCenter =
    [ HtmlAttr.style
        "transform"
        "translate(-50%,-50%)"
    , HtmlAttr.style
        "left"
        "50%"
    , HtmlAttr.style
        "position"
        "absolute"
    ]


{-| This function returns `Html Msg` in start page.
-}
startHtmlMsg : Html Msg
startHtmlMsg =
    div
        [ HtmlAttr.style
            "width"
            "100vw"
        , HtmlAttr.style
            "height"
            "100vh"
        ]
        [ img
            ([ HtmlAttr.src (assetURL ++ "game.png")
             , HtmlAttr.style
                "height"
                "20vh"
             , HtmlAttr.style
                "top"
                "15%"
             , HtmlAttr.style
                "position"
                "absolute"
             ]
                ++ setCenter
            )
            []
        , img
            ([ HtmlAttr.src (assetURL ++ "logo.svg")
             , HtmlAttr.style
                "height"
                "30vh"
             , HtmlAttr.style
                "top"
                "45%"
             ]
                ++ setCenter
            )
            []
        , showButtons
            ( 30, 10 )
            ( 50, 70 )
            [ ( "From local"
              , Msg.UploadFile
                    FileRequested
              , 3
              )
            , ( "Quick start"
              , Msg.ClickOn
                    (SetURL
                        (Just
                            (Final
                                (assetURL
                                    ++ defaultModName
                                )
                            )
                        )
                    )
              , 3
              )
            , ( "From net"
              , Msg.ClickOn
                    (SetURL
                        Nothing
                    )
              , 3
              )
            ]
        , input
            ([ type_ "input"
             , placeholder "https://example.com/mod.json"
             , onInput
                (\x ->
                    ClickOn
                        (SetURL
                            (Just
                                (Temp
                                    x
                                )
                            )
                        )
                )
             , HtmlAttr.style
                "height"
                "3vh"
             , HtmlAttr.style
                "width"
                "20vw"
             , HtmlAttr.style
                "top"
                "80%"
             ]
                ++ setCenter
            )
            []
        ]


{-| This function returns `Html Msg` in load page by inputting `LoadInfo` as the message showing on the screen.
-}
loadHtmlMsg : LoadInfo -> Html Msg
loadHtmlMsg loadInfo =
    let
        ( text, url ) =
            case loadInfo of
                ShowMsg ( x, y ) ->
                    ( x, y )

                URL x ->
                    ( "", x )
    in
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
        ]
        [ p
            ([ HtmlAttr.style
                "height"
                "30vh"
             , HtmlAttr.style
                "overflow"
                "auto"
             , HtmlAttr.style
                "top"
                "15vh"
             , HtmlAttr.style
                "width"
                "70vw"
             ]
                ++ setCenter
            )
            [ Html.text
                text
            ]
        , showButtons
            ( 30, 10 )
            ( 50, 70 )
            [ ( "From local"
              , Msg.UploadFile
                    FileRequested
              , 3
              )
            , ( "Quick start"
              , Msg.ClickOn
                    (SetURL
                        (Just
                            (Final
                                (assetURL
                                    ++ defaultModName
                                )
                            )
                        )
                    )
              , 3
              )
            , ( "From net"
              , Msg.ClickOn
                    (SetURL
                        Nothing
                    )
              , 3
              )
            ]
        , input
            ([ type_ "input"
             , case url of
                Nothing ->
                    placeholder "https://example.com/mod.json"

                Just x ->
                    value x
             , onInput
                (\x ->
                    ClickOn
                        (SetURL
                            (Just
                                (Temp
                                    x
                                )
                            )
                        )
                )
             , HtmlAttr.style
                "height"
                "3vh"
             , HtmlAttr.style
                "width"
                "20vw"
             , HtmlAttr.style
                "top"
                "80%"
             ]
                ++ setCenter
            )
            []
        ]


{-| This function returns `Html Msg` in pause page by inputting `String` as the help message.
-}
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
            ([ HtmlAttr.style
                "top"
                "45%"
             , HtmlAttr.style
                "white-space"
                "pre-line"
             , HtmlAttr.style
                "width"
                "90vw"
             , HtmlAttr.style
                "color"
                "white"
             ]
                ++ setCenter
            )
            [ Html.text "Press Space to continue\nPress R to restart\n"
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
                      , Msg.ClickOn
                            Restart
                      , 3.5
                      )
                    , ( "download"
                      , Msg.ClickOn
                            Download
                      , 3.5
                      )
                    ]
                ]
            ]
        ]


{-| This function returns `Html Msg` in end page, showing text from `String`.
-}
endHtmlMsg : String -> Html Msg
endHtmlMsg st =
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
            ([ HtmlAttr.style
                "top"
                "45%"
             , HtmlAttr.style
                "white-space"
                "pre-line"
             , HtmlAttr.style
                "width"
                "90vw"
             , HtmlAttr.style
                "color"
                "white"
             ]
                ++ setCenter
            )
            [ Html.text st
            , p []
                [ showButtons
                    ( 80, 7 )
                    ( 50, 110 )
                    [ ( "restart"
                      , Msg.ClickOn
                            Restart
                      , 3.5
                      )
                    , ( "download"
                      , Msg.ClickOn
                            Download
                      , 3.5
                      )
                    ]
                ]
            ]
        ]


{-| This function returns `Html Msg` as story from `String`.
-}
storyShow : String -> Html Msg
storyShow story =
    div
        [ HtmlAttr.style
            "width"
            "27vw"
        , HtmlAttr.style
            "left"
            "70%"
        , HtmlAttr.style
            "top"
            "40%"
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
