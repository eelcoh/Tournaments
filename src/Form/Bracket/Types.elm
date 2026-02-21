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
    , currentActiveRound
    , emptyRoundSelections
    , init
    , initialKnockouts
    , isWizardComplete
    , removeTeamFromAll
    , roundRequired
    , roundTeams
    )

import Bets.Types exposing (Group, Team, TeamData)
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
    { selections : RoundSelections }


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
    | DeselectTeam Team
    | GoNext


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
    , bracketState = BracketWizard { selections = emptyRoundSelections }
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
            { champion = Just team
            , finalists = addUnique team sel.finalists
            , semis = addUnique team sel.semis
            , quarters = addUnique team sel.quarters
            , lastSixteen = addUnique team sel.lastSixteen
            , lastThirtyTwo = addUnique team sel.lastThirtyTwo
            }

        FinalistRound ->
            { sel
                | finalists = addUnique team sel.finalists
                , semis = addUnique team sel.semis
                , quarters = addUnique team sel.quarters
                , lastSixteen = addUnique team sel.lastSixteen
                , lastThirtyTwo = addUnique team sel.lastThirtyTwo
            }

        SemiRound ->
            { sel
                | semis = addUnique team sel.semis
                , quarters = addUnique team sel.quarters
                , lastSixteen = addUnique team sel.lastSixteen
                , lastThirtyTwo = addUnique team sel.lastThirtyTwo
            }

        QuarterRound ->
            { sel
                | quarters = addUnique team sel.quarters
                , lastSixteen = addUnique team sel.lastSixteen
                , lastThirtyTwo = addUnique team sel.lastThirtyTwo
            }

        LastSixteenRound ->
            { sel
                | lastSixteen = addUnique team sel.lastSixteen
                , lastThirtyTwo = addUnique team sel.lastThirtyTwo
            }

        LastThirtyTwoRound ->
            { sel | lastThirtyTwo = addUnique team sel.lastThirtyTwo }


removeTeamFromAll : Team -> RoundSelections -> RoundSelections
removeTeamFromAll team sel =
    let
        remove lst =
            List.filter (\t -> t.teamID /= team.teamID) lst
    in
    { champion =
        case sel.champion of
            Just c ->
                if c.teamID == team.teamID then
                    Nothing

                else
                    Just c

            Nothing ->
                Nothing
    , finalists = remove sel.finalists
    , semis = remove sel.semis
    , quarters = remove sel.quarters
    , lastSixteen = remove sel.lastSixteen
    , lastThirtyTwo = remove sel.lastThirtyTwo
    }


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

        groupConstraintOk =
            let
                alreadyInL32 =
                    List.any (\t -> t.teamID == team.teamID) sel.lastThirtyTwo

                teamGroup =
                    List.head (List.filter (\td -> td.team.teamID == team.teamID) teamData)
                        |> Maybe.map .group
            in
            case teamGroup of
                Just grp ->
                    alreadyInL32 || countGroupInList grp sel.lastThirtyTwo teamData < 3

                Nothing ->
                    True
    in
    hasCapacity && notAlreadyInRound && groupConstraintOk


currentActiveRound : RoundSelections -> SelectionRound
currentActiveRound sel =
    let
        championTeams =
            Maybe.map List.singleton sel.champion |> Maybe.withDefault []

        rounds =
            [ ( ChampionRound, championTeams, 1 )
            , ( FinalistRound, sel.finalists, 2 )
            , ( SemiRound, sel.semis, 4 )
            , ( QuarterRound, sel.quarters, 8 )
            , ( LastSixteenRound, sel.lastSixteen, 16 )
            , ( LastThirtyTwoRound, sel.lastThirtyTwo, 32 )
            ]

        isIncomplete ( _, teams, cap ) =
            List.length teams < cap
    in
    rounds
        |> List.filter isIncomplete
        |> List.head
        |> Maybe.map (\( r, _, _ ) -> r)
        |> Maybe.withDefault LastThirtyTwoRound


isWizardComplete : RoundSelections -> Bool
isWizardComplete sel =
    case sel.champion of
        Just _ ->
            List.length sel.lastThirtyTwo == 32

        Nothing ->
            False
