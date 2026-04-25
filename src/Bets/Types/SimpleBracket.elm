module Bets.Types.SimpleBracket exposing
    ( SimpleBracket
    , SimpleBracketEntry
    , decode
    , encode
    , isComplete
    )

import Bets.Types exposing (HasQualified(..), Round(..), Team)
import Bets.Types.HasQualified as HasQualified
import Bets.Types.Round as Round
import Bets.Types.Team as Team
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode
import List.Extra


type alias SimpleBracketEntry =
    { team : Team
    , round : Round
    , hasQualified : HasQualified
    }


type alias SimpleBracket =
    List SimpleBracketEntry


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


allRounds : List Round
allRounds =
    [ R1, R2, R3, R4, R5, R6 ]


teamsInRound : Round -> SimpleBracket -> List Team
teamsInRound round bracket =
    bracket
        |> List.filter (\e -> e.round == round)
        |> List.map .team


isComplete : SimpleBracket -> Bool
isComplete bracket =
    let
        roundComplete round =
            let
                teams =
                    List.Extra.uniqueBy .teamID (teamsInRound round bracket)
            in
            List.length teams == roundRequired round

        progressionOk round =
            let
                roundInt =
                    Round.toInt round
            in
            if roundInt == 1 then
                True

            else
                let
                    teamsHere =
                        List.Extra.uniqueBy .teamID (teamsInRound round bracket)

                    prevTeams =
                        teamsInRound (Round.fromInt (roundInt - 1)) bracket
                in
                List.all (\t -> List.any (\pt -> pt.teamID == t.teamID) prevTeams) teamsHere
    in
    List.all (\r -> roundComplete r && progressionOk r) allRounds



-- JSON


encode : SimpleBracket -> Json.Encode.Value
encode bracket =
    Json.Encode.object
        [ ( "entries", Json.Encode.list encodeEntry bracket ) ]


encodeEntry : SimpleBracketEntry -> Json.Encode.Value
encodeEntry entry =
    Json.Encode.object
        [ ( "team", Team.encode entry.team )
        , ( "round", Round.encode entry.round )
        , ( "hasQualified", HasQualified.encode entry.hasQualified )
        ]


decode : Decoder SimpleBracket
decode =
    Json.Decode.field "entries" (Json.Decode.list decodeEntry)


decodeEntry : Decoder SimpleBracketEntry
decodeEntry =
    Json.Decode.succeed SimpleBracketEntry
        |> required "team" Team.decode
        |> required "round" Round.decode
        |> required "hasQualified" HasQualified.decode
