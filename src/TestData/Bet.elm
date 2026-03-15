module TestData.Bet exposing (dummyGroupScores, dummyRoundSelections, dummyTopscorer)

import Bets.Types exposing (Team, Topscorer)
import Bets.Init.WorldCup2026.Tournament.Teams exposing (..)
import Form.Bracket.Types exposing (RoundSelections, SelectionRound(..), addTeamToRound, emptyRoundSelections)


-- dummyRoundSelections : RoundSelections
--
-- lastThirtyTwo: 2 from each of 12 groups (24 teams) + 8 third-place teams from groups A-H
--
-- Group thirds: A=south_korea, B=qatar, C=haiti, D=australia, E=ivory_coast, F=team_f3, G=iran, H=saudi_arabia
--
-- Top-2 per group:
--   A: mexico, south_africa
--   B: canada, team_b2
--   C: brazil, morocco
--   D: usa, paraguay
--   E: germany, curacao
--   F: netherlands, japan
--   G: belgium, egypt
--   H: spain, cape_verde
--   I: france, senegal
--   J: argentina, algeria
--   K: portugal, team_k2
--   L: england, croatia


dummyRoundSelections : RoundSelections
dummyRoundSelections =
    emptyRoundSelections
        -- lastThirtyTwo: Group A top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound mexico.team
        |> addTeamToRound LastThirtyTwoRound south_africa.team
        |> addTeamToRound LastThirtyTwoRound south_korea.team
        -- Group B top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound canada.team
        |> addTeamToRound LastThirtyTwoRound team_b2.team
        |> addTeamToRound LastThirtyTwoRound qatar.team
        -- Group C top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound brazil.team
        |> addTeamToRound LastThirtyTwoRound morocco.team
        |> addTeamToRound LastThirtyTwoRound haiti.team
        -- Group D top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound usa.team
        |> addTeamToRound LastThirtyTwoRound paraguay.team
        |> addTeamToRound LastThirtyTwoRound australia.team
        -- Group E top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound germany.team
        |> addTeamToRound LastThirtyTwoRound curacao.team
        |> addTeamToRound LastThirtyTwoRound ivory_coast.team
        -- Group F top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound netherlands.team
        |> addTeamToRound LastThirtyTwoRound japan.team
        |> addTeamToRound LastThirtyTwoRound team_f3.team
        -- Group G top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound belgium.team
        |> addTeamToRound LastThirtyTwoRound egypt.team
        |> addTeamToRound LastThirtyTwoRound iran.team
        -- Group H top 2 + 3rd
        |> addTeamToRound LastThirtyTwoRound spain.team
        |> addTeamToRound LastThirtyTwoRound cape_verde.team
        |> addTeamToRound LastThirtyTwoRound saudi_arabia.team
        -- Group I top 2 (no 3rd — only A-H supply thirds)
        |> addTeamToRound LastThirtyTwoRound france.team
        |> addTeamToRound LastThirtyTwoRound senegal.team
        -- Group J top 2
        |> addTeamToRound LastThirtyTwoRound argentina.team
        |> addTeamToRound LastThirtyTwoRound algeria.team
        -- Group K top 2
        |> addTeamToRound LastThirtyTwoRound portugal.team
        |> addTeamToRound LastThirtyTwoRound team_k2.team
        -- Group L top 2
        |> addTeamToRound LastThirtyTwoRound england.team
        |> addTeamToRound LastThirtyTwoRound croatia.team
        -- lastSixteen: 16 teams that advance from R32
        |> addTeamToRound LastSixteenRound france.team
        |> addTeamToRound LastSixteenRound argentina.team
        |> addTeamToRound LastSixteenRound germany.team
        |> addTeamToRound LastSixteenRound netherlands.team
        |> addTeamToRound LastSixteenRound spain.team
        |> addTeamToRound LastSixteenRound england.team
        |> addTeamToRound LastSixteenRound brazil.team
        |> addTeamToRound LastSixteenRound portugal.team
        |> addTeamToRound LastSixteenRound usa.team
        |> addTeamToRound LastSixteenRound canada.team
        |> addTeamToRound LastSixteenRound mexico.team
        |> addTeamToRound LastSixteenRound belgium.team
        |> addTeamToRound LastSixteenRound ivory_coast.team
        |> addTeamToRound LastSixteenRound senegal.team
        |> addTeamToRound LastSixteenRound australia.team
        |> addTeamToRound LastSixteenRound croatia.team
        -- quarters: 8 teams
        |> addTeamToRound QuarterRound france.team
        |> addTeamToRound QuarterRound argentina.team
        |> addTeamToRound QuarterRound germany.team
        |> addTeamToRound QuarterRound spain.team
        |> addTeamToRound QuarterRound england.team
        |> addTeamToRound QuarterRound brazil.team
        |> addTeamToRound QuarterRound portugal.team
        |> addTeamToRound QuarterRound netherlands.team
        -- semis: 4 teams
        |> addTeamToRound SemiRound france.team
        |> addTeamToRound SemiRound germany.team
        |> addTeamToRound SemiRound spain.team
        |> addTeamToRound SemiRound brazil.team
        -- finalists: 2 teams
        |> addTeamToRound FinalistRound france.team
        |> addTeamToRound FinalistRound brazil.team
        -- champion
        |> addTeamToRound ChampionRound france.team


dummyGroupScores : List ( String, ( Maybe Int, Maybe Int ) )
dummyGroupScores =
    [ ( "m01", ( Just 2, Just 1 ) )
    , ( "m03", ( Just 1, Just 1 ) )
    , ( "m04", ( Just 3, Just 0 ) )
    , ( "m07", ( Just 2, Just 0 ) )
    , ( "m10", ( Just 2, Just 1 ) )
    , ( "m11", ( Just 3, Just 1 ) )
    , ( "m14", ( Just 1, Just 0 ) )
    , ( "m16", ( Just 2, Just 2 ) )
    , ( "m17", ( Just 2, Just 0 ) )
    , ( "m19", ( Just 3, Just 1 ) )
    , ( "m21", ( Just 2, Just 0 ) )
    , ( "m24", ( Just 2, Just 1 ) )
    , ( "m26", ( Just 1, Just 0 ) )
    , ( "m28", ( Just 1, Just 2 ) )
    , ( "m30", ( Just 0, Just 1 ) )
    , ( "m32", ( Just 2, Just 0 ) )
    , ( "m33", ( Just 3, Just 0 ) )
    , ( "m35", ( Just 2, Just 1 ) )
    , ( "m37", ( Just 2, Just 0 ) )
    , ( "m40", ( Just 1, Just 1 ) )
    , ( "m41", ( Just 3, Just 1 ) )
    , ( "m44", ( Just 2, Just 0 ) )
    , ( "m45", ( Just 1, Just 0 ) )
    , ( "m47", ( Just 3, Just 0 ) )
    , ( "m49", ( Just 2, Just 1 ) )
    , ( "m51", ( Just 0, Just 2 ) )
    , ( "m53", ( Just 2, Just 0 ) )
    , ( "m55", ( Just 1, Just 0 ) )
    , ( "m58", ( Just 2, Just 2 ) )
    , ( "m60", ( Just 1, Just 1 ) )
    , ( "m61", ( Just 2, Just 0 ) )
    , ( "m64", ( Just 0, Just 1 ) )
    , ( "m66", ( Just 2, Just 0 ) )
    , ( "m68", ( Just 3, Just 1 ) )
    , ( "m70", ( Just 2, Just 1 ) )
    , ( "m71", ( Just 1, Just 0 ) )
    ]


dummyTopscorer : Topscorer
dummyTopscorer =
    ( Just "Kylian Mbappé", Just france.team )
