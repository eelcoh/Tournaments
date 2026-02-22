module Form.Bracket.View exposing (view)

import Bets.Init
import Bets.Types exposing (Bet, Group(..), Team, TeamData)
import Bets.Types.Group as Group
import Bets.Types.Team as T
import Element exposing (Element, centerX, spacing)
import Element.Events
import Element.Font as Font
import List.Extra
import UI.Color as Color
import UI.Font
import Form.Bracket.Types
    exposing
        ( BracketState(..)
        , Msg(..)
        , RoundSelections
        , SelectionRound(..)
        , State
        , canSelectTeam
        , countGroupInList
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
            viewCompletionButton sel allGroups teamData_
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

        labelColor r =
            if isComplete r || r == activeRound then
                Color.orange

            else
                Color.grey

        dotChar r =
            if isComplete r then
                "x"

            else
                "."

        dotColor r =
            if isComplete r then
                Color.green

            else if r == activeRound then
                Color.orange

            else
                Color.grey

        viewStep ( r, label ) =
            Element.column [ Element.spacing 2, Element.width (Element.px 32) ]
                [ Element.el [ Font.color (labelColor r), UI.Font.mono, Element.centerX ]
                    (Element.text label)
                , Element.el [ Font.color (dotColor r), UI.Font.mono, Element.centerX ]
                    (Element.text (dotChar r))
                ]

        connector =
            Element.column [ Element.spacing 2 ]
                [ Element.el [ Font.color Color.grey, UI.Font.mono ]
                    (Element.text " --- ")
                , Element.el [ Font.color Color.grey, UI.Font.mono ]
                    (Element.text "     ")
                ]
    in
    Element.row [ spacing 0, centerX ]
        (List.intersperse connector (List.map viewStep allRounds))


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
                    [ Font.color Color.grey, UI.Font.mono ]
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
                        |> List.map (\chunk -> Element.row [ spacing 8 ] chunk)
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


viewCompletionButton : RoundSelections -> List Group -> TeamData -> Element Msg
viewCompletionButton sel allGroups teamData_ =
    let
        allGroupsCovered =
            List.all (\grp -> countGroupInList grp sel.lastThirtyTwo teamData_ >= 2) allGroups
    in
    if isWizardComplete sel && allGroupsCovered then
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

        viewTeamOrBlank t =
            if isPlaced t then
                Element.el [ Font.color Color.grey, UI.Font.mono ] (Element.text "---")

            else
                viewTeamBadge round selections teamData_ t

        label =
            Element.el
                [ Font.color Color.primaryText
                , UI.Font.mono
                , Element.paddingEach { top = 0, bottom = 0, left = 0, right = 8 }
                ]
                (Element.text (Group.toString grp ++ ":"))

        teamCodes =
            List.map viewTeamOrBlank allTeams
    in
    if List.all isPlaced allTeams then
        Element.none

    else
        Element.row [ spacing 8, centerX ]
            (label :: teamCodes)


viewTeamBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewTeamBadge round selections teamData_ team =
    if canSelectTeam round team selections teamData_ then
        Element.el
            [ Element.Events.onClick (SelectTeam round team)
            , Element.pointer
            , Font.color Color.primaryText
            , UI.Font.mono
            ]
            (Element.text (T.display team))

    else
        Element.el
            [ Font.color Color.grey
            , UI.Font.mono
            ]
            (Element.text (T.display team))


viewPlacedBadge : Team -> Element Msg
viewPlacedBadge team =
    Element.el
        [ Element.Events.onClick (DeselectTeam team)
        , Element.pointer
        , Font.color Color.green
        , UI.Font.mono
        ]
        (Element.text (T.display team))


