module UI.Page exposing (container, page)

import Element exposing (centerX, fill, paddingXY, spacing, width)
import UI.Screen
import UI.Style


page : String -> List (Element.Element msg) -> Element.Element msg
page name elements =
    Element.column
        (UI.Style.page [ centerX, spacing 20, paddingXY 20 0, UI.Screen.className name, width fill ])
        elements


container : UI.Screen.Size -> String -> List (Element.Element msg) -> Element.Element msg
container screen name elements =
    Element.column
        (UI.Style.page
            [ Element.centerX
            , Element.spacing 24
            , UI.Screen.className name
            , Element.width
                (Element.fill |> Element.maximum (UI.Screen.maxWidth screen))
            ]
        )
        elements
