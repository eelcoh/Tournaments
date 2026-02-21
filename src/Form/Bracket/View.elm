module Form.Bracket.View exposing (view)

import Bets.Init
import Bets.Types exposing (Bet, Group(..), Team, TeamData)
import Bets.Types.Group as Group
import Element exposing (Element, centerX, spacing)
import Element.Events
import Element.Font as Font
import List.Extra
import UI.Color as Color
import Form.Bracket.Types
    exposing
        ( BracketState(..)
        , Msg(..)
        , RoundSelections
        , SelectionRound(..)
        , State
        , canSelectTeam
        , currentActiveRound
        , isWizardComplete
        , roundRequired
        , roundTeams
        )
import UI.Button
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

        activeRound =
            currentActiveRound wizardState.selections

        sel =
            wizardState.selections

        stepper =
            viewRoundStepper activeRound sel

        allGroups =
            [ A, B, C, D, E, F, G, H, I, J, K, L ]

        allRounds =
            [ ChampionRound, FinalistRound, SemiRound, QuarterRound, LastSixteenRound, LastThirtyTwoRound ]

        sections =
            List.map (viewRoundSection activeRound sel allGroups teamData_) allRounds

        extroduction =
            Element.column (UI.Style.introduction [ spacing 16 ])
                [ UI.Text.bulletText "1 punt voor ieder juist land in de tweede ronde. "
                , UI.Text.bulletText "4 punten per kwartfinalist. "
                , UI.Text.bulletText "7 punten per halve finalist. "
                , UI.Text.bulletText "10 punten per finalist. "
                , UI.Text.bulletText "13 punten voor de kampioen. "
                ]

        completionButton =
            viewCompletionButton sel
    in
    page "bracket"
        ([ stepper ] ++ sections ++ [ extroduction, completionButton ])


viewRoundStepper : SelectionRound -> RoundSelections -> Element Msg
viewRoundStepper activeRound sel =
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

        stepStyle r =
            if isComplete r then
                UI.Style.PillA

            else if r == activeRound then
                UI.Style.PillB

            else
                UI.Style.Pill

        viewStep ( r, label ) =
            Element.el
                (UI.Style.button (stepStyle r) [ Element.paddingXY 8 4 ])
                (Element.text label)
    in
    Element.row [ spacing 8, centerX ]
        (List.map viewStep allRounds)


viewRoundSection : SelectionRound -> RoundSelections -> List Group -> TeamData -> SelectionRound -> Element Msg
viewRoundSection activeRound sel allGroups teamData_ round =
    let
        teams =
            roundTeams round sel

        n =
            List.length teams

        cap =
            roundRequired round

        isActive =
            round == activeRound

        isComplete =
            n >= cap

        counterText =
            if isComplete then
                " \u{2713}"

            else
                " (" ++ String.fromInt n ++ "/" ++ String.fromInt cap ++ ")"

        header =
            Element.row [ spacing 8 ]
                [ UI.Text.displayHeader (roundTitle round)
                , Element.text counterText
                ]

        remaining =
            cap - n

        remainingEl =
            if remaining > 0 then
                [ Element.el
                    (UI.Style.button UI.Style.Potential [ Element.paddingXY 6 4 ])
                    (Element.text ("+" ++ String.fromInt remaining))
                ]

            else
                []

        badges =
            let
                items =
                    List.map viewPlacedBadge teams ++ remainingEl

                rows =
                    List.Extra.greedyGroupsOf 8 items
                        |> List.map (\chunk -> Element.row [ spacing 4 ] chunk)
            in
            if List.isEmpty items then
                Element.none

            else
                Element.column [ spacing 4 ] rows

        grid =
            if isActive then
                Element.column [ spacing 8, centerX ]
                    (List.map (viewGroup round sel teams teamData_) allGroups)

            else
                Element.none
    in
    Element.column [ spacing 8 ]
        [ header
        , badges
        , grid
        ]


viewCompletionButton : RoundSelections -> Element Msg
viewCompletionButton sel =
    if isWizardComplete sel then
        Element.column [ centerX, spacing 8 ]
            [ Element.paragraph (UI.Style.introduction [])
                [ Element.text "Je bracket is ingevuld!" ]
            , UI.Button.pill UI.Style.Focus GoNext "Ga verder \u{2192}"
            ]

    else
        Element.none


roundTitle : SelectionRound -> String
roundTitle round =
    case round of
        ChampionRound ->
            "Wie wordt kampioen?"

        FinalistRound ->
            "Wie halen de finale?"

        SemiRound ->
            "Wie halen de halve finale?"

        QuarterRound ->
            "Wie halen de kwartfinale?"

        LastSixteenRound ->
            "Wie halen de ronde van 16?"

        LastThirtyTwoRound ->
            "Wie halen de ronde van 32?"


viewGroup : SelectionRound -> RoundSelections -> List Team -> TeamData -> Group -> Element Msg
viewGroup round selections placed teamData_ grp =
    let
        allTeams =
            Bets.Init.groupMembers grp

        isPlaced t =
            List.any (\p -> p.teamID == t.teamID) placed

        blank =
            Element.el [ Element.width (Element.px 32), Element.height (Element.px 38) ] Element.none

        viewBadgeOrBlank t =
            if isPlaced t then
                blank

            else
                viewTeamBadge round selections teamData_ t

        label =
            Element.el [ Element.width (Element.px 64), Element.paddingEach { top = 0, bottom = 0, left = 0, right = 12 }, Font.color Color.primaryText ]
                (Element.text ("Groep " ++ Group.toString grp))

        badges =
            List.map viewBadgeOrBlank allTeams
    in
    if List.all isPlaced allTeams then
        Element.none

    else
        Element.row [ spacing 4, centerX ]
            (label :: badges)


viewTeamBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewTeamBadge round selections teamData_ team =
    if canSelectTeam round team selections teamData_ then
        Element.el
            [ Element.Events.onClick (SelectTeam round team)
            , Element.pointer
            ]
            (UI.Button.teamBadgeVerySmall UI.Style.Potential team)

    else
        UI.Button.teamBadgeVerySmall UI.Style.Irrelevant team


viewPlacedBadge : Team -> Element Msg
viewPlacedBadge team =
    Element.el
        [ Element.Events.onClick (DeselectTeam team)
        , Element.pointer
        ]
        (UI.Button.teamBadgeVerySmall UI.Style.Selected team)


