module Form.Bracket.Types exposing
    ( BracketState(..)
    , IsWinner(..)
    , Msg(..)
    , RoundSelections
    , SelectionRound(..)
    , State
    , WizardState
    , addTeamToRound
    , canSelectTeam
    , countGroupInList
    , emptyRoundSelections
    , init
    , initialKnockouts
    , isWizardComplete
    , nextRound
    , prevRound
    , removeTeamFromRoundAndAbove
    , roundRequired
    , roundTeams
    )

import Bets.Types exposing (Group, Team, TeamData)
import Bets.Types.Group as Group
import List.Extra
import UI.Screen as Screen


type SelectionRound
    = ChampionRound
    | FinalistRound
    | SemiRound
    | QuarterRound
    | LastSixteenRound
    | LastThirtyTwoRound


type alias RoundSelections =
    { champion : Maybe Team
    , finalists : List Team
    , semis : List Team
    , quarters : List Team
    , lastSixteen : List Team
    , lastThirtyTwo : List Team
    }


type alias WizardState =
    { selections : RoundSelections
    , currentPage : SelectionRound
    }


type BracketState
    = BracketWizard WizardState


type alias State =
    { screen : Screen.Size
    , bracketState : BracketState
    }


-- IsWinner is kept for backward compatibility with Bets.View.Bracket
type IsWinner
    = Yes
    | No
    | Undecided


type Msg
    = SelectTeam SelectionRound Team
    | DeselectTeam SelectionRound Team
    | GoNext
    | GoPrev
    | JumpToRound SelectionRound


emptyRoundSelections : RoundSelections
emptyRoundSelections =
    { champion = Nothing
    , finalists = []
    , semis = []
    , quarters = []
    , lastSixteen = []
    , lastThirtyTwo = []
    }


init : Screen.Size -> State
init sz =
    { screen = sz
    , bracketState = BracketWizard { selections = emptyRoundSelections, currentPage = LastThirtyTwoRound }
    }


initialKnockouts : Screen.Size -> State
initialKnockouts sz =
    init sz


roundRequired : SelectionRound -> Int
roundRequired round =
    case round of
        ChampionRound ->
            1

        FinalistRound ->
            2

        SemiRound ->
            4

        QuarterRound ->
            8

        LastSixteenRound ->
            16

        LastThirtyTwoRound ->
            32


roundTeams : SelectionRound -> RoundSelections -> List Team
roundTeams round sel =
    case round of
        ChampionRound ->
            Maybe.map List.singleton sel.champion |> Maybe.withDefault []

        FinalistRound ->
            sel.finalists

        SemiRound ->
            sel.semis

        QuarterRound ->
            sel.quarters

        LastSixteenRound ->
            sel.lastSixteen

        LastThirtyTwoRound ->
            sel.lastThirtyTwo


nextRound : SelectionRound -> SelectionRound
nextRound round =
    case round of
        LastThirtyTwoRound ->
            LastSixteenRound

        LastSixteenRound ->
            QuarterRound

        QuarterRound ->
            SemiRound

        SemiRound ->
            FinalistRound

        FinalistRound ->
            ChampionRound

        ChampionRound ->
            ChampionRound


prevRound : SelectionRound -> SelectionRound
prevRound round =
    case round of
        LastThirtyTwoRound ->
            LastThirtyTwoRound

        LastSixteenRound ->
            LastThirtyTwoRound

        QuarterRound ->
            LastSixteenRound

        SemiRound ->
            QuarterRound

        FinalistRound ->
            SemiRound

        ChampionRound ->
            FinalistRound


addTeamToRound : SelectionRound -> Team -> RoundSelections -> RoundSelections
addTeamToRound round team sel =
    let
        addUnique t lst =
            if List.any (\x -> x.teamID == t.teamID) lst then
                lst

            else
                lst ++ [ t ]
    in
    case round of
        ChampionRound ->
            { sel | champion = Just team }

        FinalistRound ->
            { sel | finalists = addUnique team sel.finalists }

        SemiRound ->
            { sel | semis = addUnique team sel.semis }

        QuarterRound ->
            { sel | quarters = addUnique team sel.quarters }

        LastSixteenRound ->
            { sel | lastSixteen = addUnique team sel.lastSixteen }

        LastThirtyTwoRound ->
            { sel | lastThirtyTwo = addUnique team sel.lastThirtyTwo }


removeTeamFromRoundAndAbove : SelectionRound -> Team -> RoundSelections -> RoundSelections
removeTeamFromRoundAndAbove round team sel =
    let
        remove lst =
            List.filter (\t -> t.teamID /= team.teamID) lst

        removeChampion =
            case sel.champion of
                Just c ->
                    if c.teamID == team.teamID then
                        Nothing

                    else
                        Just c

                Nothing ->
                    Nothing
    in
    case round of
        ChampionRound ->
            { sel | champion = removeChampion }

        FinalistRound ->
            { sel | champion = removeChampion, finalists = remove sel.finalists }

        SemiRound ->
            { sel | champion = removeChampion, finalists = remove sel.finalists, semis = remove sel.semis }

        QuarterRound ->
            { sel | champion = removeChampion, finalists = remove sel.finalists, semis = remove sel.semis, quarters = remove sel.quarters }

        LastSixteenRound ->
            { sel | champion = removeChampion, finalists = remove sel.finalists, semis = remove sel.semis, quarters = remove sel.quarters, lastSixteen = remove sel.lastSixteen }

        LastThirtyTwoRound ->
            { sel | champion = removeChampion, finalists = remove sel.finalists, semis = remove sel.semis, quarters = remove sel.quarters, lastSixteen = remove sel.lastSixteen, lastThirtyTwo = remove sel.lastThirtyTwo }


countGroupInList : Group -> List Team -> TeamData -> Int
countGroupInList grp teams teamData =
    let
        inGroup t =
            List.any (\td -> td.team.teamID == t.teamID && td.group == grp) teamData
    in
    List.filter inGroup teams
        |> List.length


canSelectTeam : SelectionRound -> Team -> RoundSelections -> TeamData -> Bool
canSelectTeam round team sel teamData =
    let
        currentTeams =
            roundTeams round sel

        capacity =
            roundRequired round

        hasCapacity =
            List.length currentTeams < capacity

        notAlreadyInRound =
            not (List.any (\t -> t.teamID == team.teamID) currentTeams)

        poolOk =
            case round of
                LastThirtyTwoRound ->
                    let
                        teamGroup =
                            List.head (List.filter (\td -> td.team.teamID == team.teamID) teamData)
                                |> Maybe.map .group
                    in
                    case teamGroup of
                        Just grp ->
                            let
                                groupCount =
                                    countGroupInList grp sel.lastThirtyTwo teamData
                            in
                            if groupCount >= 3 then
                                False

                            else if groupCount == 2 then
                                countGroupsWithThree sel.lastThirtyTwo teamData < maxGroupsWithThree teamData

                            else
                                True

                        Nothing ->
                            True

                LastSixteenRound ->
                    List.any (\t -> t.teamID == team.teamID) sel.lastThirtyTwo

                QuarterRound ->
                    List.any (\t -> t.teamID == team.teamID) sel.lastSixteen

                SemiRound ->
                    List.any (\t -> t.teamID == team.teamID) sel.quarters

                FinalistRound ->
                    List.any (\t -> t.teamID == team.teamID) sel.semis

                ChampionRound ->
                    List.any (\t -> t.teamID == team.teamID) sel.finalists
    in
    hasCapacity && notAlreadyInRound && poolOk


maxGroupsWithThree : TeamData -> Int
maxGroupsWithThree teamData =
    let
        numGroups =
            List.map .group teamData
                |> List.Extra.uniqueBy Group.toString
                |> List.length
    in
    roundRequired LastThirtyTwoRound - numGroups * 2


countGroupsWithThree : List Team -> TeamData -> Int
countGroupsWithThree teams teamData =
    let
        allGroups =
            List.map .group teamData
                |> List.Extra.uniqueBy Group.toString
    in
    List.filter (\grp -> countGroupInList grp teams teamData >= 3) allGroups
        |> List.length


isWizardComplete : RoundSelections -> Bool
isWizardComplete sel =
    let
        uniqueCount toId lst =
            List.Extra.uniqueBy toId lst |> List.length
    in
    uniqueCount .teamID sel.lastThirtyTwo == 32
        && uniqueCount .teamID sel.lastSixteen == 16
        && uniqueCount .teamID sel.quarters == 8
        && uniqueCount .teamID sel.semis == 4
        && uniqueCount .teamID sel.finalists == 2
        && (sel.champion /= Nothing)
