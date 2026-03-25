module UI.Page exposing (container, page)

import Element exposing (fill, spacing, width)
import UI.Screen
import UI.Style


page : String -> List (Element.Element msg) -> Element.Element msg
page name elements =
    Element.column
        (UI.Style.page [ spacing 20, UI.Screen.className name, width fill ])
        elements


container : String -> List (Element.Element msg) -> Element.Element msg
container name elements =
    Element.column
        (UI.Style.page
            [ Element.spacing 24
            , UI.Screen.className name
            , Element.width Element.fill
            ]
        )
        elements
