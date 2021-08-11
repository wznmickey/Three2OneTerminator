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
import Html exposing (Html, div, img, p)
import Html.Attributes as HtmlAttr exposing (..)
import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), State(..))
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent exposing (onClick)
import SvgMsg exposing (button)


assetURL : String
assetURL =
    "asset/"


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
                    ++ String.fromInt (List.length x * 25 + 10)
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
        [ img
            [ HtmlAttr.src (assetURL ++ "game.png")
            , HtmlAttr.style
                "height"
                "20vh"
            , HtmlAttr.style
                "transform"
                "translate(-50%,-50%)"
            , HtmlAttr.style
                "top"
                "15%"
            , HtmlAttr.style
                "left"
                "50%"
            , HtmlAttr.style
                "position"
                "absolute"
            ]
            []
        , img
            [ HtmlAttr.src (assetURL ++ "logo.svg")
            , HtmlAttr.style
                "height"
                "30vh"
            , HtmlAttr.style
                "transform"
                "translate(-50%,-50%)"
            , HtmlAttr.style
                "top"
                "45%"
            , HtmlAttr.style
                "left"
                "50%"
            , HtmlAttr.style
                "position"
                "absolute"
            ]
            []
        , showButtons
            ( 20, 10 )
            ( 50, 70 )
            [ ( "From Mod/Save"
              , Msg.UploadFile
                    FileRequested
              , 2.4
              )
            , ( "Quick start"
              , Msg.Clickon
                    LoadDefault
              , 2.4
              )
            ]
        ]


{-| This function returns `Html Msg` in load page.
-}
loadHtmlMsg : String -> Html Msg
loadHtmlMsg loadInfo =
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
        [ Html.text
            loadInfo
        , showButtons
            ( 20, 10 )
            ( 50, 70 )
            [ ( "From Mod/Save"
              , Msg.UploadFile
                    FileRequested
              , 2.4
              )
            , ( "Quick start"
              , Msg.Clickon
                    LoadDefault
              , 2.4
              )
            ]
        ]


{-| This function returns `Html Msg` in pause page.
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
            [ HtmlAttr.style
                "top"
                "45%"
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
                "90vw"
            , HtmlAttr.style
                "color"
                "white"
            ]
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
            [ HtmlAttr.style
                "top"
                "45%"
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
                "90vw"
            , HtmlAttr.style
                "color"
                "white"
            ]
            [ Html.text st
            , p []
                [ showButtons
                    ( 80, 7 )
                    ( 50, 110 )
                    [ ( "restart"
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
