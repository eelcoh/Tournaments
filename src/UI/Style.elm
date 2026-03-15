module UI.Style exposing
    ( ButtonSemantics(..)
    , Direction(..)
    , activeMatch
    , attribution
    , body
    , bullet
    , button
    , buttonActive
    , buttonInactive
    , buttonIrrelevant
    , buttonPerhaps
    , buttonPill
    , buttonPillA
    , buttonPotential
    , buttonRight
    , buttonSelected
    , buttonWrong
    , darkBox
    , emphasis
    , error
    , flag
    , flagImage
    , groupBadge
    , groupPosition
    , groupPositions
    , header1
    , header2
    , introduction
    , kopje
    , link
    , matchRow
    , matchRowTile
    , matchRowVerySmall
    , matches
    , menu
    , none
    , normalBox
    , page
    , resultCard
    , score
    , scoreButton
    , scoreButtonSBPotential
    , scoreButtonSBSelected
    , scoreColumn
    , scoreInput
    , scoreRow
    , terminalInput
    , secondaryText
    , teamBadge
    , teamBadgeVerySmall
    , teamButton
    , teamButtonTBPotential
    , teamButtonTBSelected
    , teamName
    , text
    , textInput
    , wrapper
    )

import Element exposing (fill, mouseOver, padding, paddingEach, paddingXY, px, rgb, transparent, width)
import Element.Background as Background exposing (image, tiledX, tiledY)
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Svg exposing (font)
import Svg.Attributes exposing (color,  fontFamily, fontSize, y)
import UI.Color as Color exposing (dark_blue, right, terminalBorder, white)
import UI.Font exposing (mono, scaled)
import UI.Screen as Screen
import Url.Parser exposing (top)


type ButtonSemantics
    = Active
    | Inactive
    | Wrong
    | Right
    | Perhaps
    | Irrelevant
    | Potential
    | Selected
    | Focus
    | Pill
    | PillA
    | PillB


type Direction
    = DLeft
    | DRight


scoreButton : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
scoreButton semantics attrs =
    case semantics of
        Potential ->
            scoreButtonSBPotential ++ attrs

        Selected ->
            scoreButtonSBSelected ++ attrs

        _ ->
            buttonWrong ++ attrs


teamButton : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
teamButton semantics attrs =
    case semantics of
        Potential ->
            teamButtonTBPotential ++ attrs

        Selected ->
            teamButtonTBSelected ++ attrs

        _ ->
            buttonWrong ++ attrs


button : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
button semantics attrs =
    case semantics of
        Active ->
            buttonActive ++ attrs

        Inactive ->
            buttonInactive ++ attrs

        Wrong ->
            buttonWrong ++ attrs

        Right ->
            buttonRight ++ attrs

        Perhaps ->
            buttonPerhaps ++ attrs

        Irrelevant ->
            buttonIrrelevant ++ attrs

        Potential ->
            buttonPotential ++ attrs

        Selected ->
            buttonSelected ++ attrs

        Focus ->
            buttonFocus ++ attrs

        Pill ->
            buttonPill ++ attrs

        PillA ->
            buttonPillA ++ attrs

        PillB ->
            buttonPillB ++ attrs


header1 : List (Element.Attribute msg) -> List (Element.Attribute msg)
header1 attrs =
    attrs
        ++ [ Font.size (scaled 3)
           , Font.color Color.orange
           , UI.Font.mono
           , Font.extraBold
           , Element.paddingXY 0 16
           , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
           , Border.color Color.terminalBorder
           ]


header2 : List (Element.Attribute msg) -> List (Element.Attribute msg)
header2 attrs =
    attrs
        ++ [ UI.Font.mono
           , Font.size 10
           , Font.color Color.orange
           , Element.paddingXY 0 10
           , Font.letterSpacing 1.8
           ]


body : List (Element.Attribute msg) -> List (Element.Attribute msg)
body attrs =
    attrs
        ++ [ Background.color Color.black
           ]


menu : List (Element.Attribute msg) -> List (Element.Attribute msg)
menu attrs =
    attrs
        ++ [ Font.size (scaled 1)
           , Font.color Color.primaryText
           , UI.Font.mono
           ]


text : List (Element.Attribute msg) -> List (Element.Attribute msg)
text attrs =
    attrs
        ++ textBase
            [ Font.hairline
            , Font.color Color.primaryText
            , Element.spacing 16
            ]


secondaryText : List (Element.Attribute msg) -> List (Element.Attribute msg)
secondaryText attrs =
    attrs
        ++ textBase
            [ Font.hairline
            , Font.color Color.secondaryText
            , Element.spacing 16
            ]


textBase : List (Element.Attribute msg) -> List (Element.Attribute msg)
textBase attrs =
    attrs
        ++ [ UI.Font.mono
           , Font.letterSpacing 1.4
           , Font.size (scaled 1)
           ]


introduction : List (Element.Attribute msg) -> List (Element.Attribute msg)
introduction attrs =
    attrs
        ++ [ UI.Font.mono
           , Font.size 11
           , Font.color Color.grey
           , Element.spacing 12
           , Element.paddingEach { top = 10, bottom = 10, left = 14, right = 14 }
           , Border.widthEach { bottom = 0, top = 0, left = 2, right = 0 }
           , Border.color Color.activeNav
           , Background.color (Element.rgba255 0xF0 0xA0 0x30 0.04)
           ]


attribution : List (Element.Attribute msg) -> List (Element.Attribute msg)
attribution attrs =
    attrs
        ++ [ UI.Font.mono
           , Font.letterSpacing 1.4
           , Font.size (scaled 1)
           , Font.hairline
           , Font.color Color.secondaryLight
           , Element.spacing 10
           , Element.paddingXY 0 8
           ]


normalBox : List (Element.Attribute msg) -> List (Element.Attribute msg)
normalBox attrs =
    attrs
        ++ [ padding 20
           , width fill
           , Border.rounded 0
           ]


darkBox : List (Element.Attribute msg) -> List (Element.Attribute msg)
darkBox attrs =
    attrs
        ++ [ padding 20
           , width fill
           , Background.color Color.primaryDark
           , Border.rounded 0
           , Border.width 1
           , Border.color Color.terminalBorder
           ]


resultCard : List (Element.Attribute msg) -> List (Element.Attribute msg)
resultCard attrs =
    attrs
        ++ [ Element.paddingXY 0 0
           , Element.width Element.fill
           , Background.color Color.primaryDark
           , Border.width 1
           , Border.color Color.terminalBorder
           ]



-- [ UI.Font.slab
--    , Font.hairline
--    , Font.letterSpacing 1.4
--    , Font.size (scaled 3)
--    , Element.spacing 2
--    , Font.color Color.primaryText
--    ]


error : List (Element.Attribute msg) -> List (Element.Attribute msg)
error attrs =
    attrs
        ++ [ Background.color Color.black
           , Border.width 1
           , Border.color Color.red
           , Font.color Color.red
           , Font.size (scaled 1)
           , Element.spacing 2
           , UI.Font.mono
           ]


page : List (Element.Attribute msg) -> List (Element.Attribute msg)
page attrs =
    attrs
        ++ []


buttonActive : List (Element.Attribute msg)
buttonActive =
    [ Background.color Color.light_blue
    , paddingXY 20 8
    , Font.size (scaled 2)
    , Border.rounded 0
    , Font.color Color.primary
    , Border.width 1
    , Border.color Color.light_blue
    , Element.pointer
    , Element.mouseOver
        [ Background.color Color.light_blue
        , Font.color Color.primary
        ]
    , UI.Font.button
    , Element.centerY
    ]


buttonInactive : List (Element.Attribute msg)
buttonInactive =
    [ Background.color Color.primary
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Font.color Color.grey
    , Border.width 1
    , Border.color Color.terminalBorder
    , Element.htmlAttribute <| Html.Attributes.style "cursor" "not-allowed"
    , UI.Font.button
    , Element.centerY
    ]


buttonWrong : List (Element.Attribute msg)
buttonWrong =
    [ Background.color Color.wrong
    , Font.color Color.panel
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Border.width 1
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


buttonRight : List (Element.Attribute msg)
buttonRight =
    [ Background.color Color.right
    , Font.color Color.panel
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Border.width 1
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


buttonPerhaps : List (Element.Attribute msg)
buttonPerhaps =
    [ Background.color Color.panel
    , Font.color Color.secondaryText
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Border.width 1
    , Border.color Color.terminalBorder
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


buttonIrrelevant : List (Element.Attribute msg)
buttonIrrelevant =
    [ Border.color Color.terminalBorder
    , Border.width 1
    , Font.color Color.secondaryText
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


buttonPotential : List (Element.Attribute msg)
buttonPotential =
    [ Background.color Color.panel
    , Font.color Color.primaryText
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Border.width 1
    , Border.color Color.terminalBorder
    , Element.pointer
    , Element.mouseOver
        [ Background.color Color.primaryLight
        , Font.color Color.orange
        ]
    , UI.Font.button
    , Element.centerY
    ]


buttonSelected : List (Element.Attribute msg)
buttonSelected =
    [ Background.color Color.panel
    , Font.color Color.orange
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Border.width 1
    , Border.color Color.orange
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


buttonFocus : List (Element.Attribute msg)
buttonFocus =
    [ Background.color Color.light_blue
    , Font.color Color.primary
    , Border.width 1
    , paddingXY 20 5
    , Element.height (px 34)
    , Font.size (scaled 2)
    , Border.rounded 0
    , Element.mouseOver
        [ Font.color Color.primary
        ]
    , Border.color Color.light_blue
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


scoreButtonSBPotential : List (Element.Attribute msg)
scoreButtonSBPotential =
    [ Background.color Color.black
    , Border.rounded 0
    , Border.width 0
    , Font.size 14
    , Font.color Color.white
    , Font.center
    , mouseOver
        [ Font.color Color.orange
        ]
    , Element.pointer
    , UI.Font.button
    , Element.centerX
    ]


scoreButtonSBSelected : List (Element.Attribute msg)
scoreButtonSBSelected =
    [ Background.color Color.orange
    , Font.color Color.primary
    , Font.size 15
    , paddingXY 15 5
    , Element.height (px 34)
    , Font.size (scaled 1)
    , Border.rounded 0
    , Border.width 0
    , Element.spacing 10
    , Font.center
    , Element.pointer
    , UI.Font.button
    ]


teamBadge : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
teamBadge semantics attrs =
    let
        borderColor =
            case semantics of
                Selected ->
                    Color.right

                Perhaps ->
                    Color.orange

                _ ->
                    Color.terminalBorder
    in
    [ Background.color Color.panel
    , Font.color Color.primaryText
    , Border.color borderColor
    , Border.width 1
    , Element.spacing 10
    , Element.padding 10
    , Border.rounded 0
    , Font.center
    , Font.size (scaled 1)
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    , Screen.className "teamBadge"
    ]
        ++ attrs


teamBadgeVerySmall : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
teamBadgeVerySmall semantics attrs =
    let
        borderColor =
            case semantics of
                Selected ->
                    Color.right

                Perhaps ->
                    Color.orange

                _ ->
                    Color.terminalBorder
    in
    [ Background.color Color.panel
    , Font.color Color.primaryText
    , Border.color borderColor
    , Border.width 1
    , Element.spacing 3
    , Element.padding 3
    , Border.rounded 0
    , Font.center
    , Font.size 8
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]
        ++ attrs


teamButtonTBPotential : List (Element.Attribute msg)
teamButtonTBPotential =
    [ Background.color Color.panel
    , Font.color Color.primaryText
    , Border.width 1
    , Border.color Color.terminalBorder
    , Element.spacing 10
    , Element.padding 10
    , Border.rounded 0
    , Font.center
    , Font.size (scaled 1)
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


teamButtonTBSelected : List (Element.Attribute msg)
teamButtonTBSelected =
    [ Background.color Color.panel
    , Font.color Color.primaryText
    , Border.width 1
    , Border.color Color.right
    , Element.spacing 10
    , Element.padding 10
    , Border.rounded 0
    , Font.center
    , Font.size (scaled 1)
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


flag : List (Element.Attribute msg) -> List (Element.Attribute msg)
flag attrs =
    attrs
        ++ []


flagImage : List (Element.Attribute msg) -> List (Element.Attribute msg)
flagImage attrs =
    attrs
        ++ []


teamName : List (Element.Attribute msg) -> List (Element.Attribute msg)
teamName attrs =
    attrs
        ++ [ Font.center
           ]


scoreRow : List (Element.Attribute msg) -> List (Element.Attribute msg)
scoreRow attrs =
    attrs
        ++ []


scoreColumn : List (Element.Attribute msg) -> List (Element.Attribute msg)
scoreColumn attrs =
    attrs
        ++ []


scoreInput : List (Element.Attribute msg) -> List (Element.Attribute msg)
scoreInput attrs =
    attrs
        ++ [ Border.width 1
           , Border.color Color.terminalBorder
           , Background.color Color.primaryDark
           , Font.color Color.orange
           , Font.center
           , Border.rounded 0
           , UI.Font.score
           , Element.focused [ Border.color Color.orange, Font.color Color.activeNav ]
           ]


terminalInput : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)
terminalInput hasError attrs =
    let
        borderColor =
            if hasError then
                Color.red

            else
                Color.terminalBorder
    in
    attrs
        ++ [ Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
           , Border.color borderColor
           , Border.rounded 0
           , Background.color Color.primaryDark
           , Font.color Color.white
           , UI.Font.input
           , Element.paddingXY 4 8
           , Element.focused [ Border.color Color.orange ]
           ]


score : List (Element.Attribute msg) -> List (Element.Attribute msg)
score attrs =
    attrs
        ++ [ Font.center
           , UI.Font.score
           ]


matches : List (Element.Attribute msg) -> List (Element.Attribute msg)
matches attrs =
    attrs
        ++ []


activeMatch : List (Element.Attribute msg) -> List (Element.Attribute msg)
activeMatch attrs =
    attrs
        ++ []


matchRow : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
matchRow semantics attrs =
    let
        styles =
            [ Background.color Color.panel
            , Font.color Color.primaryText
            , Font.size (scaled 1)
            , Font.center
            , Element.pointer
            , UI.Font.match
            , Border.color border
            , Border.width 1
            , Border.rounded 0
            ]

        border =
            case semantics of
                Active ->
                    Color.orange

                Right ->
                    Color.green

                Wrong ->
                    Color.red

                _ ->
                    Color.panel
    in
    attrs ++ styles


matchRowVerySmall : ButtonSemantics -> List (Element.Attribute msg) -> List (Element.Attribute msg)
matchRowVerySmall semantics attrs =
    let
        styles =
            [ Background.color Color.panel
            , Font.color Color.primaryText
            , Font.size 8
            , Font.center
            , Element.pointer
            , UI.Font.match
            , Border.color border
            , Border.width 1
            , Border.rounded 0
            ]

        border =
            case semantics of
                Active ->
                    Color.orange

                Right ->
                    Color.green

                Wrong ->
                    Color.red

                _ ->
                    Color.panel
    in
    attrs ++ styles


matchRowTile : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)
matchRowTile isActive attrs =
    let
        borderColor =
            if isActive then
                Color.orange

            else
                Color.terminalBorder
    in
    attrs
        ++ [ Border.width 1
           , Border.color borderColor
           , Background.color Color.primaryDark
           , Element.width Element.fill
           , Element.paddingXY 8 0
           ]


kopje : List (Element.Attribute msg) -> List (Element.Attribute msg)
kopje attrs =
    attrs
        ++ textBase
            [ Font.color Color.orange
            , Font.bold
            , Font.size (scaled 1)
            , Border.widthEach { bottom = 0, top = 0, left = 2, right = 0 }
            , Border.color Color.orange
            , paddingEach { top = 0, bottom = 0, left = 8, right = 0 }
            ]


emphasis : List (Element.Attribute msg) -> List (Element.Attribute msg)
emphasis attrs =
    attrs
        ++ textBase
            [ Font.color Color.orange
            , UI.Font.mono
            , Font.extraBold
            , Element.spacing 10
            , Font.size 16
            , Font.size (scaled 1)
            ]


buttonPill : List (Element.Attribute msg)
buttonPill =
    [ Background.color Color.panel
    , Font.color Color.primaryText
    , Border.rounded 0
    , Border.width 1
    , Border.color Color.terminalBorder
    , paddingXY 20 5
    , Element.pointer
    , Element.mouseOver
        [ Font.color Color.orange
        ]
    , UI.Font.button
    , Element.centerY
    ]


buttonPillA : List (Element.Attribute msg)
buttonPillA =
    [ Background.color Color.panel
    , Font.color Color.orange
    , Border.rounded 0
    , Border.color Color.orange
    , paddingXY 20 5
    , Border.width 1
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


buttonPillB : List (Element.Attribute msg)
buttonPillB =
    [ Background.color Color.orange
    , Font.color Color.primary
    , Border.rounded 0
    , paddingXY 20 5
    , Border.color Color.orange
    , Border.width 1
    , Element.pointer
    , UI.Font.button
    , Element.centerY
    ]


wrapper : List (Element.Attribute msg) -> List (Element.Attribute msg)
wrapper attrs =
    attrs


groupBadge : List (Element.Attribute msg) -> List (Element.Attribute msg)
groupBadge attrs =
    attrs


groupPosition : List (Element.Attribute msg) -> List (Element.Attribute msg)
groupPosition attrs =
    attrs


groupPositions : List (Element.Attribute msg) -> List (Element.Attribute msg)
groupPositions attrs =
    attrs


none : List (Element.Attribute msg) -> List (Element.Attribute msg)
none attrs =
    attrs


bullet : List (Element.Attribute msg) -> List (Element.Attribute msg)
bullet attrs =
    textBase attrs


textInput : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)
textInput hasError attrs =
    let
        borderColor =
            if hasError then
                Color.red

            else
                Color.terminalBorder
    in
    attrs
        ++ [ Border.width 1
           , Border.rounded 0
           , Border.color borderColor
           , Font.color Color.primaryDark
           , UI.Font.input
           , Element.height (px 50)
           ]


link : List (Element.Attribute msg) -> List (Element.Attribute msg)
link attrs =
    attrs
        ++ [ Font.color Color.orange
           , Element.pointer
           ]
