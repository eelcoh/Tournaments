module UI.Screen exposing (Device(..), Size, className, device, elementId, maxWidth, size)

import Element
import Html.Attributes exposing (property)
import Json.Encode as Encode


type alias Size =
    { width : Float
    , height : Float
    }


type Device
    = Phone
    | Computer


size : Int -> Int -> Size
size w h =
    Size (toFloat w) (toFloat h)


maxWidth : Size -> Int
maxWidth screen =
    min 600 (round screen.width)


device : Size -> Device
device screen =
    if screen.width < 500 then
        Phone

    else
        Computer


elementId : String -> Element.Attribute msg
elementId identifier =
    Element.htmlAttribute <| property "id" (Encode.string identifier)


className : String -> Element.Attribute msg
className identifier =
    Element.htmlAttribute <| property "className" (Encode.string identifier)
