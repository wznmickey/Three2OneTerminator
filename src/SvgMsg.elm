module SvgMsg exposing (button)

{-| It is the module that contain simple svg elements.


# Element

@docs button

-}

import Msg exposing (Msg(..))
import Svg
    exposing
        ( Svg
        , text
        )
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent exposing (onClick)


{-| This function give a button based on the inputs.

`String` is the showing text of the button.

`Msg` is what to deliver after clicking.

Three `Float`s show x, y and size.

-}
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
                    (6.5 + y)
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
