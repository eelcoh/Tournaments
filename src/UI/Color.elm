module UI.Color exposing
    ( activeNav
    , asHex
    , black
    , dark_blue
    , dark_red
    , green
    , grey
    , light_blue
    , orange
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

import Element exposing (Color, rgb255)
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


light_blue : Color
light_blue =
    rgb255 247 127 33


grey : Color
grey =
    rgb255 0x55 0x55 0x55


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
