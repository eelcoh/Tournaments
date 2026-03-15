module TestData.MatchResults exposing (dummyKnockoutsResults, dummyMatchResults)

import Bets.Init
import Bets.Types exposing (HasQualified(..), Round(..))
import Bets.Types.Match as M
import Types exposing (KnockoutsResults, MatchResult, MatchResults, TeamRounds)


dummyMatchResults : MatchResults
dummyMatchResults =
    let
        matchToResult m =
            { match = M.id m
            , group = M.group m
            , homeTeam = M.homeTeam m
            , awayTeam = M.awayTeam m
            , score = Nothing
            }

        patchScore matchId h a mr =
            if mr.match == matchId then
                { mr | score = Just ( Just h, Just a ) }

            else
                mr

        withScores =
            List.map matchToResult Bets.Init.matches
                |> List.map (patchScore "m01" 3 1)
                |> List.map (patchScore "m02" 2 2)
                |> List.map (patchScore "m03" 1 0)
                |> List.map (patchScore "m04" 2 1)
                |> List.map (patchScore "m05" 0 1)
                |> List.map (patchScore "m06" 3 0)
                |> List.map (patchScore "m07" 1 1)
                |> List.map (patchScore "m08" 2 0)
                |> List.map (patchScore "m09" 1 2)
                |> List.map (patchScore "m10" 0 0)
                |> List.map (patchScore "m11" 4 1)
                |> List.map (patchScore "m12" 1 0)
    in
    { results = withScores }


dummyKnockoutsResults : KnockoutsResults
dummyKnockoutsResults =
    let
        knockoutRounds =
            [ R1, R2, R3, R4, R5, R6 ]

        mkTeamRounds t =
            { team = t
            , roundsQualified = List.map (\r -> ( r, TBD )) knockoutRounds
            }

        teamEntry td =
            ( td.team.teamID, mkTeamRounds td.team )
    in
    { teams = List.map teamEntry Bets.Init.teamData }
