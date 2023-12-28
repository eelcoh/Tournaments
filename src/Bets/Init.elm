module Bets.Init exposing (answers, bet, groupMembers, groupsAndFirstMatch, teamData)

-- To add a tournament: add a Bets.Init.<yourtournament>.Tournament module
-- and have it expose the three functions (bracket, initTeamData, matches)
-- and have it imported - there can only be one imported tournament at the time
-- see for example:
-- import Bets.Init.Euro2020.Tournament exposing (bracket, initTeamData, matches)
-- import Bets.Init.WorldCup2022.Tournament exposing (bracket, initTeamData, matches)
-- import Bets.Init.Euro2024.Tournament exposing (bracket, initTeamData, matches)

import Bets.Init.Euro2024.Tournament exposing (bracket, initTeamData, matches)
import Bets.Init.Lib as Init
import Bets.Types exposing (Answer(..), AnswerGroupMatches, Answers, Bet, Group(..), GroupMatch(..), Team)
import Bets.Types.Match as Match
import Bets.Types.Participant as Participant


answers : Answers
answers =
    { matches = initMatches
    , bracket = Init.answerBracket bracket
    , topscorer = Init.answerTopscorer
    }


initMatches : AnswerGroupMatches
initMatches =
    let
        mkMatchAnswer m =
            Init.answerGroupMatch (Match.id m) (Match.group m) m
    in
    List.map mkMatchAnswer matches


bet : Bet
bet =
    { answers = answers
    , betId = Nothing
    , uuid = Nothing
    , active = True
    , participant = Participant.init
    }


teamData : Bets.Types.TeamData
teamData =
    initTeamData


groupMembers : Group -> List Team
groupMembers grp =
    let
        inGroup td =
            td.group == grp
    in
    List.filter inGroup initTeamData
        |> List.map .team


groupsAndFirstMatch : List ( Group, Bets.Types.MatchID )
groupsAndFirstMatch =
    Init.groupFirstMatches [] answers.matches
