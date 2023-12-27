module UI.Team exposing (emptyTeamSmall, teamBoxVerySmall, teamNameVerySmall, viewTeam, viewTeamFull, viewTeamSmall, viewTeamVerySmall)

import Bets.Types exposing (Team)
import Bets.Types.Team as T
import Element exposing (Element, column, height, image, px, row, spacingXY, width)
import Element.Font as Font
import UI.Color as Color
import UI.Font


viewTeam : Team -> Element msg
viewTeam mTeam =
    let
        teamNameTxt =
            T.display mTeam

        flagUrl =
            T.flagUrl (Just mTeam)

        img =
            { src = flagUrl
            , description =
                teamNameTxt
            }
    in
    column teamBox
        [ row [ Element.centerX ]
            [ image
                [ height (px 40)
                , width (px 40)
                ]
                img
            ]
        , row teamName
            [ Element.el [ height (px 20) ] (Element.text teamNameTxt) ]
        ]


viewTeamSmall : Team -> Element msg
viewTeamSmall mTeam =
    let
        teamNameTxt =
            T.display mTeam

        flagUrl =
            T.flagUrl (Just mTeam)

        img =
            { src = flagUrl
            , description =
                teamNameTxt
            }
    in
    column teamBoxSmall
        [ row [ Element.centerX ]
            [ image
                [ height (px 30)
                , width (px 30)
                ]
                img
            ]
        , row teamName
            [ Element.el [ height (px 20) ] (Element.text teamNameTxt) ]
        ]


emptyTeamSmall : Element msg
emptyTeamSmall =
    let
        teamNameTxt =
            "---"

        flagUrl =
            T.flagUrl Nothing

        img =
            { src = flagUrl
            , description =
                teamNameTxt
            }
    in
    column teamBoxSmall
        [ row [ Element.centerX ]
            [ image
                [ height (px 30)
                , width (px 30)
                ]
                img
            ]
        , row teamName
            [ Element.el [ height (px 20) ] (Element.text teamNameTxt) ]
        ]


viewTeamVerySmall : Team -> Element msg
viewTeamVerySmall mTeam =
    let
        teamNameTxt =
            T.display mTeam

        flagUrl =
            T.flagUrl (Just mTeam)

        img =
            { src = flagUrl
            , description =
                teamNameTxt
            }
    in
    column teamBoxVerySmall
        [ row [ Element.centerX, spacingXY 0 4 ]
            [ image
                [ height (px 15)
                , width (px 15)
                ]
                img
            ]
        , row teamNameVerySmall
            [ Element.el [ height (px 14) ] (Element.text teamNameTxt) ]
        ]


viewTeamFull : Team -> Element msg
viewTeamFull team =
    let
        teamNameTxt =
            T.displayFull team

        img =
            { src = T.flagUrl (Just team)
            , description =
                teamNameTxt
            }
    in
    column (width (px 85) :: teamBox)
        [ row [ Element.centerX ]
            [ image
                [ height (px 40)
                , width (px 40)
                ]
                img
            ]
        , row teamName
            [ Element.text teamNameTxt ]
        ]


teamBox : List (Element.Attribute msg)
teamBox =
    [ height (px 70)
    , Font.color Color.primaryText
    , Font.size (UI.Font.scaled 1)
    , Font.center
    , Element.centerX
    , Element.spacingXY 0 20
    ]


teamBoxSmall : List (Element.Attribute msg)
teamBoxSmall =
    [ height (px 70)
    , width (px 30)
    , Font.color Color.primaryText
    , Font.size (UI.Font.scaled 1)
    , Font.center
    , Element.centerX
    , Element.spacingXY 0 20
    ]


teamBoxVerySmall : List (Element.Attribute msg)
teamBoxVerySmall =
    [ Font.color Color.primaryText
    , Font.center
    , Element.centerX
    , Element.spacingXY 0 5
    ]


teamName : List (Element.Attribute msg)
teamName =
    [ Element.centerX
    , Element.centerY
    , Element.spacing 20
    , Font.size (UI.Font.scaled 1)
    , Font.center
    ]


teamNameVerySmall : List (Element.Attribute msg)
teamNameVerySmall =
    [ Element.centerX
    , Element.centerY
    , Element.spacing 2
    , Font.size 12
    , Font.center
    ]
