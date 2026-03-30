module UI.Color exposing
    ( activeNav
    , amberOverlay04
    , asHex
    , black
    , borderDim
    , dark_blue
    , dark_red
    , dimText
    , futureStep
    , green
    , greenOverlay04
    , greenOverlay07
    , grey
    , hoverBg
    , inactiveNav
    , amber
    , mutedText
    , orange
    , orangeOverlay05
    , orangeOverlay06
    , orangeOverlay08
    , orangeOverlay10
    , orangeOverlay12
    , orangeOverlay30
    , panel
    , potential
    , primary
    , primaryDark
    , primaryLight
    , primaryText
    , red
    , right
    , secondary
    , secondaryDark
    , secondaryLight
    , secondaryText
    , selected
    , shadow
    , terminalAccentDim
    , terminalBorder
    , white
    , wrong
    , zenGreen
    )

import Element exposing (Color, rgb255, rgba255)
import Hex


asHex : Color -> String
asHex clr =
    let
        color =
            Element.toRgb clr

        to255 f =
            (255 * f)
                |> Basics.round
                |> Basics.modBy 255
                |> Hex.toString

        r =
            to255 color.red

        g =
            to255 color.green

        b =
            to255 color.blue

        a =
            to255 color.alpha
    in
    "#" ++ r ++ g ++ b


red : Color
red =
    rgb255 200 0 0


black : Color
black =
    rgb255 0x0F 0x11 0x17


dark_red : Color
dark_red =
    rgb255 0x0C 0x0D 0x12


dark_blue : Color
dark_blue =
    rgb255 0x0A 0x0B 0x10


amber : Color
amber =
    rgb255 247 127 33


grey : Color
grey =
    rgb255 0x88 0x88 0x88


shadow : Color
shadow =
    rgb255 8 8 12


potential : Color
potential =
    white


white : Color
white =
    rgb255 0xDC 0xDC 0xCC


orange : Color
orange =
    rgb255 0xF0 0xDF 0xAF


activeNav : Color
activeNav =
    rgb255 0xF0 0xA0 0x30


green : Color
green =
    rgb255 0x42 0x9F 0x59


zenGreen : Color
zenGreen =
    rgb255 0x7F 0x9F 0x7F


right : Color
right =
    green


wrong : Color
wrong =
    red


selected : Color
selected =
    black


primary : Color
primary =
    rgb255 0x14 0x15 0x1C


primaryDark : Color
primaryDark =
    rgb255 0x12 0x13 0x1A


primaryLight : Color
primaryLight =
    rgb255 0x22 0x23 0x2A


secondary : Color
secondary =
    rgb255 0xB0 0xBE 0xC5


secondaryDark : Color
secondaryDark =
    rgb255 0x80 0x8E 0x95


secondaryLight : Color
secondaryLight =
    orange


primaryText : Color
primaryText =
    white


secondaryText : Color
secondaryText =
    orange


panel : Color
panel =
    rgb255 0x1A 0x1A 0x20


terminalBorder : Color
terminalBorder =
    rgb255 0x2A 0x2A 0x32


terminalAccentDim : Color
terminalAccentDim =
    rgb255 0xCC 0x99 0x66



-- Semantic greys


inactiveNav : Color
inactiveNav =
    rgb255 0x9A 0x9A 0x90


dimText : Color
dimText =
    rgb255 0x66 0x66 0x66


mutedText : Color
mutedText =
    rgb255 0x8A 0x8A 0x80


hoverBg : Color
hoverBg =
    rgb255 0x3A 0x3A 0x3A


futureStep : Color
futureStep =
    rgb255 0x22 0x22 0x22


borderDim : Color
borderDim =
    rgba255 0x4F 0x4F 0x4F 0.3



-- Orange overlays


orangeOverlay05 : Color
orangeOverlay05 =
    rgba255 0xF0 0xA0 0x30 0.05


orangeOverlay06 : Color
orangeOverlay06 =
    rgba255 0xF0 0xA0 0x30 0.06


orangeOverlay08 : Color
orangeOverlay08 =
    rgba255 0xF0 0xA0 0x30 0.08


orangeOverlay10 : Color
orangeOverlay10 =
    rgba255 0xF0 0xA0 0x30 0.1


orangeOverlay12 : Color
orangeOverlay12 =
    rgba255 0xF0 0xA0 0x30 0.12


orangeOverlay30 : Color
orangeOverlay30 =
    rgba255 0xF0 0xA0 0x30 0.3



-- Green overlays


greenOverlay04 : Color
greenOverlay04 =
    rgba255 0x7F 0x9F 0x7F 0.04


greenOverlay07 : Color
greenOverlay07 =
    rgba255 0x7F 0x9F 0x7F 0.07



-- Amber overlays


amberOverlay04 : Color
amberOverlay04 =
    rgba255 0xF0 0xDF 0xAF 0.04
