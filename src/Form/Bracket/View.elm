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
import UI.Screen as Screen
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

        dev =
            Screen.device state.screen

        -- viewingRound overrides currentActiveRound when user has tapped a completed step
        activeRound =
            Maybe.withDefault (currentActiveRound wizardState.selections) wizardState.viewingRound

        sel =
            wizardState.selections

        stepper =
            viewRoundStepper activeRound sel dev

        allGroups =
            [ A, B, C, D, E, F, G, H, I, J, K, L ]

        allRounds =
            [ ChampionRound, FinalistRound, SemiRound, QuarterRound, LastSixteenRound, LastThirtyTwoRound ]

        sections =
            List.map (viewRoundSection activeRound sel allGroups teamData_ dev) allRounds

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


viewRoundStepper : SelectionRound -> RoundSelections -> Screen.Device -> Element Msg
viewRoundStepper activeRound sel dev =
    case dev of
        Screen.Phone ->
            viewRoundStepperCompact activeRound sel

        Screen.Computer ->
            viewRoundStepperFull activeRound sel


viewRoundStepperFull : SelectionRound -> RoundSelections -> Element Msg
viewRoundStepperFull activeRound sel =
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


viewRoundStepperCompact : SelectionRound -> RoundSelections -> Element Msg
viewRoundStepperCompact activeRound sel =
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

        -- Build the 3-step window
        idx =
            List.Extra.findIndex (\( r, _ ) -> r == activeRound) allRounds
                |> Maybe.withDefault 0

        windowStart =
            Basics.max 0 (idx - 1)

        windowEnd =
            Basics.min (List.length allRounds) (idx + 2)

        windowItems =
            allRounds |> List.drop windowStart |> List.take (windowEnd - windowStart)

        prefix r =
            if r == activeRound then
                "> "

            else if isComplete r then
                "[x] "

            else
                "[ ] "

        textColor r =
            if r == activeRound || isComplete r then
                Color.orange

            else
                Color.grey

        viewCompactStep ( r, label ) =
            let
                stepEl =
                    Element.el
                        [ Font.color (textColor r)
                        , UI.Font.mono
                        , Element.centerX
                        ]
                        (Element.text (prefix r ++ label))
            in
            if isComplete r && r /= activeRound then
                -- Tappable: completed non-active step
                Element.el
                    [ Element.Events.onClick (JumpToRound r)
                    , Element.pointer
                    , Element.paddingXY 4 8
                    ]
                    stepEl

            else
                Element.el
                    [ Element.paddingXY 4 8 ]
                    stepEl

        connector =
            Element.el [ Font.color Color.grey, UI.Font.mono ]
                (Element.text " -- ")
    in
    Element.row [ spacing 0, centerX ]
        (List.intersperse connector (List.map viewCompactStep windowItems))


viewRoundSection : SelectionRound -> RoundSelections -> List Group -> TeamData -> Screen.Device -> SelectionRound -> Element Msg
viewRoundSection activeRound sel allGroups teamData_ dev round =
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
                columns =
                    case dev of
                        Screen.Phone ->
                            4

                        Screen.Computer ->
                            8

                items =
                    List.map viewPlacedBadge teams ++ remainingEl

                rows =
                    List.Extra.greedyGroupsOf columns items
                        |> List.map (\chunk -> Element.row [ spacing 12 ] chunk)
            in
            if List.isEmpty items then
                Element.none

            else
                Element.column [ spacing 8 ] rows

        grid =
            if isActive then
                viewActiveGrid round sel allGroups teamData_ dev

            else
                Element.none
    in
    Element.column [ spacing 12 ]
        [ header
        , badges
        , grid
        ]


viewActiveGrid : SelectionRound -> RoundSelections -> List Group -> TeamData -> Screen.Device -> Element Msg
viewActiveGrid round sel allGroups teamData_ dev =
    case dev of
        Screen.Phone ->
            -- All rounds use the group-based grid on Phone (top-down flow: champion picked first,
            -- so no pre-filtered pool is available for higher rounds)
            viewR32Grid round sel allGroups teamData_

        Screen.Computer ->
            -- Existing behavior: one row per group
            Element.column [ spacing 12, centerX ]
                (List.map (viewGroup round sel (roundTeams round sel) teamData_) allGroups)


viewR32Grid : SelectionRound -> RoundSelections -> List Group -> TeamData -> Element Msg
viewR32Grid round sel allGroups teamData_ =
    let
        viewGroupSection grp =
            let
                members =
                    Bets.Init.groupMembers grp

                -- Hide group if all members already placed
                allPlaced =
                    List.all (\t -> List.any (\p -> p.teamID == t.teamID) (roundTeams round sel)) members
            in
            if allPlaced then
                Element.none

            else
                let
                    separator =
                        Element.el
                            [ Font.color Color.grey
                            , UI.Font.mono
                            ]
                            (Element.text ("-- " ++ Group.toString grp ++ " --"))

                    teamCells =
                        List.map (viewSelectableTeam round sel teamData_) members

                    rows =
                        List.Extra.greedyGroupsOf 4 teamCells
                            |> List.map (\chunk -> Element.row [ spacing 12 ] chunk)
                in
                Element.column [ spacing 8 ] (separator :: rows)
    in
    Element.column [ spacing 16 ] (List.map viewGroupSection allGroups)


viewFlatGrid : SelectionRound -> RoundSelections -> TeamData -> Element Msg
viewFlatGrid round sel teamData_ =
    let
        plausible =
            case round of
                LastThirtyTwoRound ->
                    []

                LastSixteenRound ->
                    sel.lastThirtyTwo

                QuarterRound ->
                    sel.lastSixteen

                SemiRound ->
                    sel.quarters

                FinalistRound ->
                    sel.semis

                ChampionRound ->
                    sel.finalists

        cells =
            List.map (viewSelectableTeam round sel teamData_) plausible

        rows =
            List.Extra.greedyGroupsOf 4 cells
                |> List.map (\chunk -> Element.row [ spacing 8 ] chunk)
    in
    Element.column [ spacing 8 ] rows


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
                [ Element.height (Element.px 16)
                , Element.width (Element.px 16)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }

        teamLabel cellColor prefix_ =
            Element.row
                [ spacing 4
                , Element.centerX
                , Element.centerY
                ]
                [ flagImg
                , Element.el
                    [ UI.Font.mono
                    , Font.color cellColor
                    ]
                    (Element.text (prefix_ ++ T.display team))
                ]
    in
    if isPlaced then
        -- Orange [x] + flag + NED, tappable to deselect
        Element.el
            [ Element.Events.onClick (DeselectTeam team)
            , Element.pointer
            , Element.width Element.fill
            , Element.height (Element.px 44)
            ]
            (teamLabel Color.orange "")

    else if canSelect then
        -- Flag + NED in primary text color, tappable to select
        Element.el
            [ Element.Events.onClick (SelectTeam round team)
            , Element.pointer
            , Element.width Element.fill
            , Element.height (Element.px 44)
            ]
            (teamLabel Color.primaryText "")

    else
        -- Grey flag + NED, not tappable (capacity full but team not placed)
        Element.el
            [ Element.width Element.fill
            , Element.height (Element.px 44)
            ]
            (teamLabel Color.grey "")


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
        Element.row [ spacing 12, centerX ]
            (label :: teamCodes)


viewTeamBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewTeamBadge round selections teamData_ team =
    let
        flagImg =
            Element.image
                [ Element.height (Element.px 16)
                , Element.width (Element.px 16)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }
    in
    if canSelectTeam round team selections teamData_ then
        Element.el
            [ Element.Events.onClick (SelectTeam round team)
            , Element.pointer
            , Element.width (Element.px 60)
            , Element.height (Element.px 44)
            , Element.centerY
            ]
            (Element.row
                [ spacing 4
                , Element.centerX
                , Element.centerY
                ]
                [ flagImg
                , Element.el
                    [ Font.color Color.primaryText
                    , UI.Font.mono
                    ]
                    (Element.text (T.display team))
                ]
            )

    else
        Element.el
            [ Element.width (Element.px 60)
            , Element.height (Element.px 44)
            , Element.centerY
            ]
            (Element.row
                [ spacing 4
                , Element.centerX
                , Element.centerY
                ]
                [ flagImg
                , Element.el
                    [ Font.color Color.grey
                    , UI.Font.mono
                    ]
                    (Element.text (T.display team))
                ]
            )


viewPlacedBadge : Team -> Element Msg
viewPlacedBadge team =
    Element.el
        [ Element.Events.onClick (DeselectTeam team)
        , Element.pointer
        , Element.width Element.fill
        , Element.height (Element.px 44)
        , Element.centerY
        ]
        (Element.row
            [ spacing 4
            , Element.centerX
            , Element.centerY
            ]
            [ Element.image
                [ Element.height (Element.px 16)
                , Element.width (Element.px 16)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }
            , Element.el
                [ Font.color Color.green
                , UI.Font.mono
                ]
                (Element.text (T.display team))
            ]
        )
