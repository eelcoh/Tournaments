module Bets.Types.Match exposing
    ( awayTeam
    , decode
    , encode
    , getTime
    , group
    , homeTeam
    , id
      -- , unsetTeamMatch
    , isComplete
    , match
      -- , setTeamMatch
    , teamsInMatch
    )

import Bets.Types exposing (Date, Group, Match(..), MatchID, Stadium, Team, Time)
import Bets.Types.DateTime as DateTime
import Bets.Types.Group
import Bets.Types.Stadium
import Bets.Types.Team
import Json.Decode exposing (Decoder)
import Json.Encode
import Time


homeTeam : Match -> Team
homeTeam (Match _ _ d _ _ _) =
    d


awayTeam : Match -> Team
awayTeam (Match _ _ _ d _ _) =
    d


match : MatchID -> Group -> Team -> Team -> Date -> Time -> Stadium -> Match
match mID grp home away date time stadium =
    let
        dt =
            DateTime.toPosix date time
    in
    Match mID grp home away dt stadium


id : Match -> MatchID
id (Match mID _ _ _ _ _) =
    mID


group : Match -> Group
group (Match _ grp _ _ _ _) =
    grp


getTime : Match -> Time.Posix
getTime (Match _ _ _ _ t _) =
    t



{-
   Get the list of teams in a match.
-}


teamsInMatch : Match -> List Team
teamsInMatch (Match _ _ home away _ _) =
    [ home, away ]


isComplete : Match -> Maybe Team -> Bool
isComplete m mTeam =
    case mTeam of
        Just t ->
            let
                teams =
                    teamsInMatch m
            in
            (List.length teams == 2) && List.member t teams

        Nothing ->
            False



{-
   Sets the draw (slot) of a match if the drawId is the same.
-}
-- setTeamMatch : Match -> Draw -> Match
-- setTeamMatch (Match matchID home away dt stadium) ( drawId, mTeam ) =
--     let
--         updateDraw (( dId, _ ) as draw) =
--             if dId == drawId then
--                 ( drawId, mTeam )
--             else
--                 draw
--         newHome =
--             updateDraw home
--         newAway =
--             updateDraw away
--     in
--     Match matchID newHome newAway dt stadium
{-
   Takes a match, and a team, and removes the team if it is participant.
   Keeps everything else in tact.
-}
-- unsetTeamMatch : Match -> Team -> Match
-- unsetTeamMatch (Match matchID home away dt stadium) team =
--     let
--         cleanDraw (( drawId, mTeam ) as draw) =
--             case mTeam of
--                 Just t ->
--                     if team == t then
--                         ( drawId, Nothing )
--                     else
--                         draw
--                 _ ->
--                     draw
--         newHome =
--             cleanDraw home
--         newAway =
--             cleanDraw away
--     in
--     Match matchID newHome newAway dt stadium


encode : Match -> Json.Encode.Value
encode (Match mID grp home away dt stadium) =
    Json.Encode.object
        [ ( "matchID", Json.Encode.string mID )
        , ( "group", Bets.Types.Group.encode grp )
        , ( "home", Bets.Types.Team.encode home )
        , ( "away", Bets.Types.Team.encode away )
        , ( "time", DateTime.encode dt )
        , ( "stadium", Bets.Types.Stadium.encode stadium )
        ]


decode : Decoder Match
decode =
    Json.Decode.map6 Match
        (Json.Decode.field "matchID" Json.Decode.string)
        (Json.Decode.field "group" Bets.Types.Group.decode)
        (Json.Decode.field "home" Bets.Types.Team.decode)
        (Json.Decode.field "away" Bets.Types.Team.decode)
        (Json.Decode.field "time" DateTime.decode)
        (Json.Decode.field "stadium" Bets.Types.Stadium.decode)
