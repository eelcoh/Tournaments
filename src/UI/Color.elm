module UI.Color exposing
    ( asHex
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
    rgb255 0x3F 0x3F 0x3F


dark_red : Color
dark_red =
    rgb255 28 28 28


dark_blue : Color
dark_blue =
    rgb255 20 20 20


light_blue : Color
light_blue =
    rgb255 247 127 33


grey : Color
grey =
    rgb255 110 110 110


shadow : Color
shadow =
    rgb255 13 13 13


potential : Color
potential =
    white



-- browngrey : Color
-- browngrey =
--     rgb255 215 204 200


white : Color
white =
    rgb255 0xDC 0xDC 0xCC


orange : Color
orange =
    rgb255 0xF0 0xDF 0xAF


green : Color
green =
    rgb255 0x42 0x9F 0x59


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
    rgb255 0x2A 0x2A 0x2A


primaryDark : Color
primaryDark =
    rgb255 0x35 0x35 0x35


primaryLight : Color
primaryLight =
    rgb255 0x55 0x55 0x55


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



-- rgb255 0x4E 0x34 0x2E
-- rgb255 0 150 136


panel : Color
panel =
    rgb255 0x3A 0x3A 0x3A


terminalBorder : Color
terminalBorder =
    rgb255 0x4F 0x4F 0x4F


terminalAccentDim : Color
terminalAccentDim =
    rgb255 0xCC 0x99 0x66
