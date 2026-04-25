module Form.SimpleBracket.Types exposing
    ( Msg(..)
    , State
    , canSelectTeam
    , countGroupInList
    , countGroupsWithThree
    , init
    , maxGroupsWithThree
    , nextRound
    , prevRound
    , roundLabel
    , roundRequired
    , teamsInRound
    )

import Bets.Types exposing (Group, Round(..), Team, TeamData)
import Bets.Types.Group as Group
import Bets.Types.SimpleBracket exposing (SimpleBracket)
import List.Extra
import UI.Screen as Screen


type alias State =
    { currentRound : Round
    , screen : Screen.Size
    }


type Msg
    = SelectTeam Round Team
    | DeselectTeam Round Team
    | GoNext
    | GoPrev
    | JumpToRound Round


init : Screen.Size -> State
init sz =
    { currentRound = R1
    , screen = sz
    }


nextRound : Round -> Round
nextRound round =
    case round of
        R1 ->
            R2

        R2 ->
            R3

        R3 ->
            R4

        R4 ->
            R5

        R5 ->
            R6

        R6 ->
            R6


prevRound : Round -> Round
prevRound round =
    case round of
        R1 ->
            R1

        R2 ->
            R1

        R3 ->
            R2

        R4 ->
            R3

        R5 ->
            R4

        R6 ->
            R5


roundRequired : Round -> Int
roundRequired round =
    case round of
        R1 ->
            32

        R2 ->
            16

        R3 ->
            8

        R4 ->
            4

        R5 ->
            2

        R6 ->
            1


roundLabel : Round -> String
roundLabel round =
    case round of
        R1 ->
            "R32"

        R2 ->
            "R16"

        R3 ->
            "KF"

        R4 ->
            "HF"

        R5 ->
            "F"

        R6 ->
            "\u{2605}"


teamsInRound : Round -> SimpleBracket -> List Team
teamsInRound round bracket =
    bracket
        |> List.filter (\e -> e.round == round)
        |> List.map .team


prevRoundOf : Round -> Maybe Round
prevRoundOf round =
    case round of
        R1 ->
            Nothing

        R2 ->
            Just R1

        R3 ->
            Just R2

        R4 ->
            Just R3

        R5 ->
            Just R4

        R6 ->
            Just R5


canSelectTeam : Round -> Team -> SimpleBracket -> TeamData -> Bool
canSelectTeam round team bracket teamData =
    let
        currentTeams =
            teamsInRound round bracket

        hasCapacity =
            List.length currentTeams < roundRequired round

        notAlreadyInRound =
            not (List.any (\t -> t.teamID == team.teamID) currentTeams)

        poolOk =
            case round of
                R1 ->
                    let
                        teamGroup =
                            List.head (List.filter (\td -> td.team.teamID == team.teamID) teamData)
                                |> Maybe.map .group
                    in
                    case teamGroup of
                        Just grp ->
                            let
                                groupCount =
                                    countGroupInList grp currentTeams teamData
                            in
                            if groupCount >= 3 then
                                False

                            else if groupCount == 2 then
                                countGroupsWithThree currentTeams teamData < maxGroupsWithThree teamData

                            else
                                True

                        Nothing ->
                            True

                _ ->
                    case prevRoundOf round of
                        Just prev ->
                            List.any (\t -> t.teamID == team.teamID) (teamsInRound prev bracket)

                        Nothing ->
                            True
    in
    hasCapacity && notAlreadyInRound && poolOk


countGroupInList : Group -> List Team -> TeamData -> Int
countGroupInList grp teams teamData =
    let
        inGroup t =
            List.any (\td -> td.team.teamID == t.teamID && td.group == grp) teamData
    in
    List.filter inGroup teams
        |> List.length


maxGroupsWithThree : TeamData -> Int
maxGroupsWithThree teamData =
    let
        numGroups =
            List.map .group teamData
                |> List.Extra.uniqueBy Group.toString
                |> List.length
    in
    roundRequired R1 - numGroups * 2


countGroupsWithThree : List Team -> TeamData -> Int
countGroupsWithThree teams teamData =
    let
        allGroups =
            List.map .group teamData
                |> List.Extra.uniqueBy Group.toString
    in
    List.filter (\grp -> countGroupInList grp teams teamData >= 3) allGroups
        |> List.length
