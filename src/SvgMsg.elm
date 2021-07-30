module SvgMsg exposing (..)

import Msg exposing (Element(..), FileStatus(..), KeyInfo(..), Msg(..), OnMovingCR, State(..), init_onMovingCR)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent


button : String -> Msg -> Float -> Float -> Float -> Svg Msg
button showText msg x y size =
    Svg.g
        [ SvgEvent.onClick
            msg
        , SvgAttr.viewBox
            "0 0 20 10"
        ]
        [ Svg.rect
            [ SvgAttr.x
                (String.fromFloat
                    (0 + x)
                )
            , SvgAttr.y
                (String.fromFloat
                    (0 + y)
                )
            , SvgAttr.width
                "20"
            , SvgAttr.height
                "10"
            , SvgAttr.fill
                "transparent"
            , SvgAttr.stroke
                "black"
            ]
            []
        , Svg.text_
            [ SvgAttr.x
                (String.fromFloat
                    (10 + x)
                )
            , SvgAttr.y
                (String.fromFloat
                    (7 + y)
                )
            , SvgAttr.fontSize
                (String.fromFloat
                    size
                )
            , SvgAttr.textAnchor
                "middle"
            ]
            [ text
                showText
            ]
        ]
