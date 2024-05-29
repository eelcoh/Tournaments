module UI.Font exposing (asap, button, input, lora, maintxt, match, mono, scaled, score, team)

import Element
import Element.Font as Font


scaled : Int -> Int
scaled s =
    s
        |> Element.modular 16 1.25
        |> Basics.round


mono : Element.Attribute msg
mono =
    Font.family
        [ Font.typeface "Sometype Mono"
        ]


asap : Element.Attribute msg
asap =
    Font.family
        [ Font.typeface "Asap"
        ]


lora : Element.Attribute msg
lora =
    Font.family
        [ Font.typeface "Lora"
        ]


button : Element.Attribute msg
button =
    mono


score : Element.Attribute msg
score =
    mono


match : Element.Attribute msg
match =
    mono


team : Element.Attribute msg
team =
    mono


input : Element.Attribute msg
input =
    mono


maintxt : Element.Attribute msg
maintxt =
    mono
