module Bets.Init exposing (bet, groupMembers, initTeamData, teams)

import Bets.Init.Euro2024.Bet exposing (answers)
import Bets.Init.Euro2024.Draw
import Bets.Types exposing (Bet, Group, Team)
import Bets.Types.Participant as Participant


bet : Bet
bet =
    { answers = answers
    , betId = Nothing
    , uuid = Nothing
    , active = True
    , participant = Participant.init
    }


initTeamData : Bets.Types.TeamData
initTeamData =
    Bets.Init.Euro2024.Draw.initTeamData


teams : List Team
teams =
    List.map .team initTeamData


groupMembers : Group -> List Team
groupMembers grp =
    let
        inGroup td =
            td.group == grp
    in
    List.filter inGroup initTeamData
        |> List.map .team
