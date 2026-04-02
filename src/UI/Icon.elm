module UI.Icon exposing (close, hamburger)

import Element
import Svg
import Svg.Attributes as SvgA


hamburger : Int -> Element.Color -> Element.Element msg
hamburger size color =
    let
        colorStr =
            colorToString color
    in
    Element.html
        (Svg.svg
            [ SvgA.width (String.fromInt size)
            , SvgA.height (String.fromInt size)
            , SvgA.viewBox "0 0 16 16"
            , SvgA.fill "none"
            ]
            [ Svg.line [ SvgA.x1 "2", SvgA.y1 "4", SvgA.x2 "14", SvgA.y2 "4", SvgA.stroke colorStr, SvgA.strokeWidth "1.5", SvgA.strokeLinecap "round" ] []
            , Svg.line [ SvgA.x1 "2", SvgA.y1 "8", SvgA.x2 "14", SvgA.y2 "8", SvgA.stroke colorStr, SvgA.strokeWidth "1.5", SvgA.strokeLinecap "round" ] []
            , Svg.line [ SvgA.x1 "2", SvgA.y1 "12", SvgA.x2 "14", SvgA.y2 "12", SvgA.stroke colorStr, SvgA.strokeWidth "1.5", SvgA.strokeLinecap "round" ] []
            ]
        )


close : Int -> Element.Color -> Element.Element msg
close size color =
    let
        colorStr =
            colorToString color
    in
    Element.html
        (Svg.svg
            [ SvgA.width (String.fromInt size)
            , SvgA.height (String.fromInt size)
            , SvgA.viewBox "0 0 16 16"
            , SvgA.fill "none"
            ]
            [ Svg.line [ SvgA.x1 "3", SvgA.y1 "3", SvgA.x2 "13", SvgA.y2 "13", SvgA.stroke colorStr, SvgA.strokeWidth "1.5", SvgA.strokeLinecap "round" ] []
            , Svg.line [ SvgA.x1 "13", SvgA.y1 "3", SvgA.x2 "3", SvgA.y2 "13", SvgA.stroke colorStr, SvgA.strokeWidth "1.5", SvgA.strokeLinecap "round" ] []
            ]
        )


colorToString : Element.Color -> String
colorToString color =
    let
        { red, green, blue, alpha } =
            Element.toRgb color
    in
    "rgba("
        ++ String.fromInt (Basics.round (red * 255))
        ++ ","
        ++ String.fromInt (Basics.round (green * 255))
        ++ ","
        ++ String.fromInt (Basics.round (blue * 255))
        ++ ","
        ++ String.fromFloat alpha
        ++ ")"
