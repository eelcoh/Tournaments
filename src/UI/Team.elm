module UI.Team exposing (emptyTeamSmall, teamBoxVerySmall, teamNameVerySmall, viewTeam, viewTeamFull, viewTeamSmall, viewTeamSmallHorizontal, viewTeamVerySmall)

import Bets.Types exposing (Team)
import Bets.Types.Team as T
import Element exposing (Element, centerY, column, height, image, px, row, spacingXY, width)
import Element.Font as Font
import UI.Color as Color
import UI.Font
import UI.Style exposing (Direction(..))


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


viewTeamSmallHorizontal : Direction -> Team -> Element msg
viewTeamSmallHorizontal dir mTeam =
    let
        teamNameTxt =
            T.display mTeam

        teamNameView =
            viewTeamName mTeam

        -- Element.el [ height (px 20) ] (Element.text teamNameTxt)
        flagUrl =
            T.flagUrl (Just mTeam)

        img =
            { src = flagUrl
            , description =
                teamNameTxt
            }

        flag =
            image
                [ height (px 30)
                , width (px 30)
                ]
                img

        vw =
            case dir of
                DLeft ->
                    [ flag, teamNameView ]

                DRight ->
                    [ teamNameView, flag ]
    in
    row teamBoxSmallHorizontal vw


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


viewEmptyTeamSmallHorizontal : Direction -> Element msg
viewEmptyTeamSmallHorizontal dir =
    let
        teamNameTxt =
            "---"

        teamNameView =
            Element.el [ height (px 20) ] (Element.text teamNameTxt)

        flagUrl =
            T.flagUrl Nothing

        img =
            { src = flagUrl
            , description =
                teamNameTxt
            }

        flag =
            image
                [ height (px 30)
                , width (px 30)
                ]
                img

        vw =
            case dir of
                DLeft ->
                    [ teamNameView, flag ]

                DRight ->
                    [ flag, teamNameView ]
    in
    column teamBoxSmallHorizontal
        vw


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


teamBoxSmallHorizontal : List (Element.Attribute msg)
teamBoxSmallHorizontal =
    [ height (px 30)
    , width (px 80)
    , Font.color Color.primaryText
    , Font.size (UI.Font.scaled 1)
    , Font.center
    , Element.centerX
    , Element.spaceEvenly
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


viewTeamName : Team -> Element msg
viewTeamName t =
    let
        teamNameTxt =
            T.display t
    in
    Element.el [ width (px 40), centerY ] (Element.text teamNameTxt)
