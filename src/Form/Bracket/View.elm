module Form.Bracket.View exposing (view)

import Bets.Init
import Bets.Types exposing (Bet, Group(..), Team, TeamData)
import Bets.Types.Group as Group
import Bets.Types.Team as T
import Element exposing (Element, centerX, paddingXY, spacing)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font
import List.Extra
import UI.Color as Color
import UI.Font
import UI.Screen as Screen
import Form.Bracket.Types
    exposing
        ( BracketState(..)
        , Msg(..)
        , RoundSelections
        , SelectionRound(..)
        , State
        , canSelectTeam
        , roundRequired
        , roundTeams
        )
import UI.Page exposing (page)
import UI.Style
import UI.Text


view : Bet -> State -> Element Msg
view _ state =
    let
        teamData_ =
            Bets.Init.teamData

        (BracketWizard wizardState) =
            state.bracketState

        dev =
            Screen.device state.screen

        activeRound =
            wizardState.currentPage

        sel =
            wizardState.selections

        allGroups =
            [ A, B, C, D, E, F, G, H, I, J, K, L ]

        introduction =
            Element.paragraph (UI.Style.introduction [])
                [ Element.text (roundDescription activeRound) ]

        section =
            viewRoundSection activeRound sel allGroups teamData_ dev (round state.screen.width)

        extroduction =
            Element.column (UI.Style.introduction [ spacing 16 ])
                [ UI.Text.bulletText "1 punt voor ieder juist land in de tweede ronde. "
                , UI.Text.bulletText "4 punten per kwartfinalist. "
                , UI.Text.bulletText "7 punten per halve finalist. "
                , UI.Text.bulletText "10 punten per finalist. "
                , UI.Text.bulletText "13 punten voor de kampioen. "
                ]

    in
    page "bracket"
        [ UI.Text.displayHeader (roundTitle activeRound)
        , introduction
        , viewStepper activeRound sel
        , section
        , extroduction
        ]



viewRoundSection : SelectionRound -> RoundSelections -> List Group -> TeamData -> Screen.Device -> Int -> Element Msg
viewRoundSection round sel allGroups teamData_ dev screenWidth =
    let
        teams =
            roundTeams round sel

        n =
            List.length teams

        cap =
            roundRequired round

        isComplete =
            n >= cap

        counterText =
            if isComplete then
                String.fromInt n ++ "/" ++ String.fromInt cap ++ " geselecteerd \u{2713}"

            else
                String.fromInt n ++ "/" ++ String.fromInt cap ++ " geselecteerd"
    in
    Element.column [ spacing 12, Element.width Element.fill ]
        [ Element.el
            [ Font.color Color.grey
            , UI.Font.mono
            , Font.size UI.Font.captionSize
            , centerX
            ]
            (Element.text counterText)
        , viewActiveGrid round sel allGroups teamData_ dev screenWidth
        ]


viewStepper : SelectionRound -> RoundSelections -> Element Msg
viewStepper activeRound sel =
    let
        allRounds =
            [ ( LastThirtyTwoRound, "R32" )
            , ( LastSixteenRound, "R16" )
            , ( QuarterRound, "KF" )
            , ( SemiRound, "HF" )
            , ( FinalistRound, "F" )
            , ( ChampionRound, "\u{2605}" )
            ]

        isComplete r =
            List.length (roundTeams r sel) >= roundRequired r

        dotColor r =
            if isComplete r then
                Color.green

            else if r == activeRound then
                Color.orange

            else
                Color.grey

        dotBg r =
            if isComplete r || r == activeRound then
                Background.color (dotColor r)

            else
                Border.color Color.terminalBorder

        dot r =
            Element.el
                [ Element.width (Element.px 9)
                , Element.height (Element.px 9)
                , Border.rounded 50
                , Border.width 1
                , dotBg r
                , Element.Events.onClick (JumpToRound r)
                , Element.pointer
                ]
                Element.none

        viewNode ( r, label ) =
            Element.column
                [ Element.spacing 3
                , Element.Events.onClick (JumpToRound r)
                , Element.pointer
                , Element.paddingXY 8 6
                , Element.height (Element.px 44)
                ]
                [ Element.el [ Element.centerX ] (dot r)
                , Element.el
                    [ Font.color (dotColor r)
                    , UI.Font.mono
                    , Font.size UI.Font.captionSize
                    , Element.centerX
                    ]
                    (Element.text label)
                ]

        connector =
            Element.el
                [ Element.width (Element.px 12)
                , Element.height (Element.px 1)
                , Background.color Color.terminalBorder
                , Element.centerY
                ]
                Element.none
    in
    Element.row [ spacing 0, centerX ]
        (List.intersperse connector (List.map viewNode allRounds))


viewActiveGrid : SelectionRound -> RoundSelections -> List Group -> TeamData -> Screen.Device -> Int -> Element Msg
viewActiveGrid round sel allGroups teamData_ dev screenWidth =
    case dev of
        Screen.Phone ->
            case round of
                LastThirtyTwoRound ->
                    viewR32Grid round sel allGroups teamData_

                _ ->
                    viewFlatGrid round sel teamData_ screenWidth

        Screen.Computer ->
            case round of
                LastThirtyTwoRound ->
                    Element.column [ spacing 12, centerX ]
                        (List.map (viewGroup round sel (roundTeams round sel) teamData_) allGroups)

                _ ->
                    viewFlatGrid round sel teamData_ screenWidth


viewR32Grid : SelectionRound -> RoundSelections -> List Group -> TeamData -> Element Msg
viewR32Grid round sel allGroups teamData_ =
    let
        viewGroupSection grp =
            let
                members =
                    Bets.Init.groupMembers grp

                groupLabel =
                    Element.el
                        [ Font.color Color.terminalAccentDim
                        , UI.Font.mono
                        , Font.size UI.Font.captionSize
                        , Element.width (Element.px 18)
                        , Element.centerY
                        ]
                        (UI.Text.allCenteredText (Group.toString grp))

                teamCells =
                    List.map (viewCompactBadge round sel teamData_) members

                badgeGrid =
                    Element.wrappedRow [ spacing 6, Element.width Element.fill ] teamCells
            in
            Element.row [ spacing 6, Element.width Element.fill ] [ groupLabel, badgeGrid ]
    in
    Element.column [ spacing 10, centerX ] (List.map viewGroupSection allGroups)


viewFlatGrid : SelectionRound -> RoundSelections -> TeamData -> Int -> Element Msg
viewFlatGrid round sel teamData_ screenWidth =
    let
        cols =
            case round of
                LastSixteenRound ->
                    4

                _ ->
                    2

        hPad =
            if screenWidth < 500 then
                8

            else
                24

        containerWidth =
            min 600 screenWidth - 2 * hPad

        badgeMaxWidth =
            (containerWidth - 32) // 2

        badgeFn =
            case round of
                LastSixteenRound ->
                    viewCompactBadge round sel teamData_

                _ ->
                    viewWideBadge badgeMaxWidth round sel teamData_

        plausible =
            case round of
                LastThirtyTwoRound ->
                    []

                LastSixteenRound ->
                    List.sortBy .teamID sel.lastThirtyTwo

                QuarterRound ->
                    List.sortBy .teamName sel.lastSixteen

                SemiRound ->
                    List.sortBy .teamName sel.quarters

                FinalistRound ->
                    List.sortBy .teamName sel.semis

                ChampionRound ->
                    List.sortBy .teamName sel.finalists

        cells =
            List.map badgeFn plausible

        rowSpacing =
            case round of
                LastSixteenRound ->
                    6

                _ ->
                    12

        rows =
            List.Extra.greedyGroupsOf cols cells
                |> List.map (\chunk -> Element.row [ spacing rowSpacing, Element.width Element.fill ] chunk)
    in
    Element.column [ spacing 8, centerX ] rows


viewSelectableTeam : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewSelectableTeam round sel teamData_ team =
    let
        placed =
            roundTeams round sel

        isPlaced =
            List.any (\t -> t.teamID == team.teamID) placed

        canSelect =
            canSelectTeam round team sel teamData_

        flagImg =
            Element.image
                [ Element.height (Element.px 20)
                , Element.width (Element.px 28)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }

        innerRow cellColor subColor =
            Element.row
                [ spacing 8
                , Element.centerX
                , Element.centerY
                ]
                [ flagImg
                , Element.column [ spacing 2 ]
                    [ Element.el
                        [ UI.Font.mono
                        , Font.color cellColor
                        , Font.size UI.Font.bodySize
                        , Font.medium
                        ]
                        (Element.text (T.display team))
                    , Element.el
                        [ UI.Font.mono
                        , Font.color subColor
                        , Font.size UI.Font.captionSize
                        ]
                        (Element.text (String.toLower (T.display team)))
                    ]
                ]
    in
    if isPlaced then
        -- Orange border + tinted bg + orange text, tappable to deselect
        Element.el
            [ Element.Events.onClick (DeselectTeam round team)
            , Element.pointer
            , Element.width Element.shrink
            , Element.height (Element.px 44)
            , Background.color Color.orangeOverlay12
            , Border.width 1
            , Border.rounded 2
            , Border.color Color.orange
            , paddingXY 12 10
            ]
            (innerRow Color.orange Color.activeNav)

    else if canSelect then
        -- Grey border, hover to orange, tappable to select
        Element.el
            [ Element.Events.onClick (SelectTeam round team)
            , Element.pointer
            , Element.width Element.shrink
            , Element.height (Element.px 44)
            , Background.color Color.primaryDark
            , Border.width 1
            , Border.rounded 2
            , Border.color Color.terminalBorder
            , paddingXY 12 10
            , Element.mouseOver [ Border.color Color.orange ]
            ]
            (innerRow Color.primaryText Color.grey)

    else
        -- Grey border, grey text, not tappable
        Element.el
            [ Element.width Element.shrink
            , Element.height (Element.px 44)
            , Background.color Color.primaryDark
            , Border.width 1
            , Border.rounded 2
            , Border.color Color.terminalBorder
            , paddingXY 12 10
            ]
            (innerRow Color.grey Color.grey)


viewCompactBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewCompactBadge round sel _ team =
    let
        isInRound =
            List.any (\t -> t.teamID == team.teamID) (roundTeams round sel)

        canSelect =
            canSelectTeam round team sel Bets.Init.teamData

        flagImg =
            Element.image
                [ Element.height (Element.px 15)
                , Element.width (Element.px 20)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }

        textColor =
            if isInRound then
                Color.orange

            else if not canSelect then
                Color.grey

            else
                Color.primaryText

        content =
            Element.row
                [ spacing 4, Element.centerX, Element.centerY ]
                [ flagImg
                , Element.el
                    [ UI.Font.mono
                    , Font.color textColor
                    , Font.size UI.Font.captionSize
                    ]
                    (Element.text (T.display team))
                ]

        borderColor =
            if isInRound then
                Color.green

            else
                Color.terminalBorder

        baseAttrs =
            [ Element.width (Element.px 68)
            , Element.height (Element.px 34)
            , Background.color Color.primaryDark
            , Border.width 1
            , Border.rounded 2
            , Border.color borderColor
            , paddingXY 6 4
            ]
    in
    if isInRound then
        Element.el
            (baseAttrs
                ++ [ Element.Events.onClick (DeselectTeam round team)
                   , Element.pointer
                   ]
            )
            content

    else if canSelect then
        Element.el
            (baseAttrs
                ++ [ Element.Events.onClick (SelectTeam round team)
                   , Element.pointer
                   , Element.mouseOver [ Border.color Color.orange ]
                   ]
            )
            content

    else
        Element.el baseAttrs content


viewWideBadge : Int -> SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewWideBadge maxWidth round sel _ team =
    let
        isInRound =
            List.any (\t -> t.teamID == team.teamID) (roundTeams round sel)

        canSelect =
            canSelectTeam round team sel Bets.Init.teamData

        flagImg =
            Element.image
                [ Element.height (Element.px 20)
                , Element.width (Element.px 28)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }

        nameColor =
            if isInRound then
                Color.orange

            else if not canSelect then
                Color.grey

            else
                Color.primaryText

        codeColor =
            if isInRound then
                Color.activeNav

            else
                Color.grey

        content =
            Element.row
                [ spacing 8
                , Element.centerY
                , Element.width Element.fill
                ]
                [ flagImg
                , Element.column
                    [ spacing 2, Element.width Element.fill ]
                    [ Element.paragraph
                        [ UI.Font.mono
                        , Font.color nameColor
                        , Font.size UI.Font.bodySize
                        , Font.medium
                        , Element.width Element.fill
                        ]
                        [ Element.text (T.displayFull team) ]
                    , Element.el
                        [ UI.Font.mono
                        , Font.color codeColor
                        , Font.size UI.Font.captionSize
                        ]
                        (Element.text (String.toLower (T.display team)))
                    ]
                ]

        borderColor =
            if isInRound then
                Color.green

            else
                Color.terminalBorder

        baseAttrs =
            [ Element.width (Element.fill |> Element.maximum maxWidth)
            , Background.color Color.primaryDark
            , Border.width 1
            , Border.rounded 2
            , Border.color borderColor
            , paddingXY 8 8
            ]
    in
    if isInRound then
        Element.el
            (baseAttrs
                ++ [ Element.Events.onClick (DeselectTeam round team)
                   , Element.pointer
                   ]
            )
            content

    else if canSelect then
        Element.el
            (baseAttrs
                ++ [ Element.Events.onClick (SelectTeam round team)
                   , Element.pointer
                   , Element.mouseOver [ Border.color Color.orange ]
                   ]
            )
            content

    else
        Element.el baseAttrs content


roundTitle : SelectionRound -> String
roundTitle round =
    case round of
        ChampionRound ->
            "Kampioen"

        FinalistRound ->
            "Finalisten"

        SemiRound ->
            "Halve finale"

        QuarterRound ->
            "Kwartfinale"

        LastSixteenRound ->
            "Ronde van 16"

        LastThirtyTwoRound ->
            "Ronde van 32"


roundDescription : SelectionRound -> String
roundDescription round =
    case round of
        LastThirtyTwoRound ->
            "Kies 2 landen per groep die doorgaan naar de tweede ronde"

        LastSixteenRound ->
            "Kies 16 landen voor de achtste finale"

        QuarterRound ->
            "Kies 8 kwartfinalisten"

        SemiRound ->
            "Kies 4 halvefinalisten"

        FinalistRound ->
            "Kies de 2 finalisten"

        ChampionRound ->
            "Kies de wereldkampioen"


viewGroup : SelectionRound -> RoundSelections -> List Team -> TeamData -> Group -> Element Msg
viewGroup round selections placed teamData_ grp =
    let
        allTeams =
            Bets.Init.groupMembers grp

        isPlaced t =
            List.any (\p -> p.teamID == t.teamID) placed

        viewTeamOrBlank t =
            if isPlaced t then
                viewCompactBadge round selections teamData_ t

            else
                viewTeamBadge round selections teamData_ t

        label =
            Element.el
                [ Font.color Color.terminalAccentDim
                , UI.Font.mono
                , Font.size UI.Font.captionSize
                , Element.width (Element.px 18)
                , Element.height (Element.px 34)
                ]
                (UI.Text.allCenteredText (Group.toString grp))

        teamCodes =
            List.map viewTeamOrBlank allTeams
    in
    Element.row [ spacing 6, centerX ]
        (label :: teamCodes)


viewTeamBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewTeamBadge round selections teamData_ team =
    let
        flagImg =
            Element.image
                [ Element.height (Element.px 15)
                , Element.width (Element.px 20)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }

        codeEl cellColor =
            Element.el
                [ UI.Font.mono
                , Font.color cellColor
                , Font.size UI.Font.captionSize
                , Font.medium
                ]
                (Element.text (T.display team))

        innerRow cellColor =
            Element.row
                [ spacing 4, Element.centerX, Element.centerY ]
                [ flagImg, codeEl cellColor ]
    in
    if canSelectTeam round team selections teamData_ then
        Element.el
            [ Element.Events.onClick (SelectTeam round team)
            , Element.pointer
            , Element.width (Element.px 68)
            , Element.height (Element.px 34)
            , Element.centerY
            , Background.color Color.primaryDark
            , Border.width 1
            , Border.rounded 2
            , Border.color Color.terminalBorder
            , paddingXY 6 4
            , Element.mouseOver [ Border.color Color.orange ]
            ]
            (innerRow Color.primaryText)

    else
        Element.el
            [ Element.width (Element.px 68)
            , Element.height (Element.px 34)
            , Element.centerY
            , Background.color Color.primaryDark
            , Border.width 1
            , Border.rounded 2
            , Border.color Color.terminalBorder
            , paddingXY 6 4
            ]
            (innerRow Color.grey)
