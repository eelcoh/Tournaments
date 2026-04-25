module Form.SimpleBracket.View exposing (view)

import Bets.Init
import Bets.SimpleBet as SimpleBet exposing (SimpleBet)
import Bets.Types exposing (Group(..), Round(..), Team, TeamData)
import Bets.Types.Group as Group
import Bets.Types.SimpleBracket exposing (SimpleBracket)
import Bets.Types.Team as T
import Element exposing (Element, centerX, paddingXY, spacing)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font
import Form.SimpleBracket.Types
    exposing
        ( Msg(..)
        , State
        , canSelectTeam
        , roundLabel
        , roundRequired
        , teamsInRound
        )
import List.Extra
import UI.Color as Color
import UI.Font
import UI.Page exposing (page)
import UI.Screen as Screen
import UI.Style
import UI.Text


view : SimpleBet -> State -> Element Msg
view bet state =
    let
        bracket =
            SimpleBet.getSimpleBracket bet

        teamData_ =
            Bets.Init.teamData

        allGroups =
            [ A, B, C, D, E, F, G, H, I, J, K, L ]

        activeRound =
            state.currentRound

        dev =
            Screen.device state.screen

        introduction =
            Element.paragraph (UI.Style.introduction [])
                [ Element.text (roundDescription activeRound) ]

        section =
            viewRoundSection activeRound bracket allGroups teamData_ dev (round state.screen.width)

        extroduction =
            Element.column (UI.Style.introduction [ spacing 16, Element.width Element.fill ])
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
        , viewStepper activeRound bracket
        , section
        , extroduction
        ]


viewRoundSection : Round -> SimpleBracket -> List Group -> TeamData -> Screen.Device -> Int -> Element Msg
viewRoundSection activeRound bracket allGroups teamData_ dev screenWidth =
    let
        teams =
            teamsInRound activeRound bracket

        n =
            List.length teams

        cap =
            roundRequired activeRound

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
        , viewActiveGrid activeRound bracket allGroups teamData_ dev screenWidth
        ]


viewStepper : Round -> SimpleBracket -> Element Msg
viewStepper activeRound bracket =
    let
        allRounds =
            [ R1, R2, R3, R4, R5, R6 ]

        isRoundComplete r =
            List.length (teamsInRound r bracket) >= roundRequired r

        dotColor r =
            if isRoundComplete r then
                Color.green

            else if r == activeRound then
                Color.orange

            else
                Color.grey

        dotBg r =
            if isRoundComplete r || r == activeRound then
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

        viewNode r =
            let
                lbl =
                    roundLabel r
            in
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
                    (Element.text lbl)
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


viewActiveGrid : Round -> SimpleBracket -> List Group -> TeamData -> Screen.Device -> Int -> Element Msg
viewActiveGrid activeRound bracket allGroups teamData_ dev screenWidth =
    case dev of
        Screen.Phone ->
            case activeRound of
                R1 ->
                    viewR32Grid activeRound bracket allGroups teamData_

                _ ->
                    viewFlatGrid activeRound bracket teamData_ screenWidth

        Screen.Computer ->
            case activeRound of
                R1 ->
                    Element.column [ spacing 12, centerX ]
                        (List.map (viewGroup activeRound bracket (teamsInRound activeRound bracket) teamData_) allGroups)

                _ ->
                    viewFlatGrid activeRound bracket teamData_ screenWidth


viewR32Grid : Round -> SimpleBracket -> List Group -> TeamData -> Element Msg
viewR32Grid activeRound bracket allGroups teamData_ =
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
                    List.map (viewCompactBadge activeRound bracket teamData_) members

                badgeGrid =
                    Element.wrappedRow [ spacing 6, Element.width Element.fill ] teamCells
            in
            Element.row [ spacing 6, Element.width Element.fill ] [ groupLabel, badgeGrid ]
    in
    Element.column [ spacing 10, centerX ] (List.map viewGroupSection allGroups)


viewFlatGrid : Round -> SimpleBracket -> TeamData -> Int -> Element Msg
viewFlatGrid activeRound bracket teamData_ screenWidth =
    let
        cols =
            case activeRound of
                R2 ->
                    4

                R6 ->
                    1

                _ ->
                    2

        hPad =
            if screenWidth < 500 then
                8

            else
                24

        containerWidth =
            min 600 screenWidth - 2 * hPad

        gapBudget =
            (cols - 1) * 12

        badgeWidth =
            max 150 ((containerWidth - gapBudget) // cols)

        badgeFn =
            case activeRound of
                R2 ->
                    viewCompactBadge activeRound bracket teamData_

                _ ->
                    viewWideBadge badgeWidth activeRound bracket teamData_

        plausible =
            case activeRound of
                R1 ->
                    []

                R2 ->
                    List.sortBy .teamID (teamsInRound R1 bracket)

                R3 ->
                    List.sortBy .teamName (teamsInRound R2 bracket)

                R4 ->
                    List.sortBy .teamName (teamsInRound R3 bracket)

                R5 ->
                    List.sortBy .teamName (teamsInRound R4 bracket)

                R6 ->
                    List.sortBy .teamName (teamsInRound R5 bracket)

        cells =
            List.map badgeFn plausible

        rowSpacing =
            case activeRound of
                R2 ->
                    6

                _ ->
                    12

        rows =
            List.Extra.greedyGroupsOf cols cells
                |> List.map (\chunk -> Element.row [ spacing rowSpacing, Element.width Element.fill ] chunk)
    in
    Element.column [ spacing 8, centerX ] rows


viewCompactBadge : Round -> SimpleBracket -> TeamData -> Team -> Element Msg
viewCompactBadge activeRound bracket _ team =
    let
        isInRound =
            List.any (\t -> t.teamID == team.teamID) (teamsInRound activeRound bracket)

        canSelect =
            canSelectTeam activeRound team bracket Bets.Init.teamData

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
                ++ [ Element.Events.onClick (DeselectTeam activeRound team)
                   , Element.pointer
                   ]
            )
            content

    else if canSelect then
        Element.el
            (baseAttrs
                ++ [ Element.Events.onClick (SelectTeam activeRound team)
                   , Element.pointer
                   , Element.mouseOver [ Border.color Color.orange ]
                   ]
            )
            content

    else
        Element.el baseAttrs content


viewWideBadge : Int -> Round -> SimpleBracket -> TeamData -> Team -> Element Msg
viewWideBadge badgeWidth activeRound bracket _ team =
    let
        isInRound =
            List.any (\t -> t.teamID == team.teamID) (teamsInRound activeRound bracket)

        canSelect =
            canSelectTeam activeRound team bracket Bets.Init.teamData

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
            [ Element.width (Element.px badgeWidth)
            , Element.height (Element.px 44)
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
                ++ [ Element.Events.onClick (DeselectTeam activeRound team)
                   , Element.pointer
                   ]
            )
            content

    else if canSelect then
        Element.el
            (baseAttrs
                ++ [ Element.Events.onClick (SelectTeam activeRound team)
                   , Element.pointer
                   , Element.mouseOver [ Border.color Color.orange ]
                   ]
            )
            content

    else
        Element.el baseAttrs content


viewGroup : Round -> SimpleBracket -> List Team -> TeamData -> Group -> Element Msg
viewGroup activeRound bracket placed teamData_ grp =
    let
        allTeams =
            Bets.Init.groupMembers grp

        isPlaced t =
            List.any (\p -> p.teamID == t.teamID) placed

        viewTeamOrBlank t =
            if isPlaced t then
                viewCompactBadge activeRound bracket teamData_ t

            else
                viewTeamBadge activeRound bracket teamData_ t

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


viewTeamBadge : Round -> SimpleBracket -> TeamData -> Team -> Element Msg
viewTeamBadge activeRound bracket teamData_ team =
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
    if canSelectTeam activeRound team bracket teamData_ then
        Element.el
            [ Element.Events.onClick (SelectTeam activeRound team)
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


roundTitle : Round -> String
roundTitle activeRound =
    case activeRound of
        R6 ->
            "Kampioen"

        R5 ->
            "Finalisten"

        R4 ->
            "Halve finale"

        R3 ->
            "Kwartfinale"

        R2 ->
            "Ronde van 16"

        R1 ->
            "Ronde van 32"


roundDescription : Round -> String
roundDescription activeRound =
    case activeRound of
        R1 ->
            "Kies 2 landen per groep die doorgaan naar de tweede ronde"

        R2 ->
            "Kies 16 landen voor de achtste finale"

        R3 ->
            "Kies 8 kwartfinalisten"

        R4 ->
            "Kies 4 halvefinalisten"

        R5 ->
            "Kies de 2 finalisten"

        R6 ->
            "Kies de wereldkampioen"
