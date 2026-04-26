module TestData.Bet exposing (dummyGroupScores, dummyParticipant, dummySimpleBracket, dummyTopscorer)

import Bets.Types exposing (HasQualified(..), Participant, Round(..), StringField(..), Team, Topscorer)
import Bets.Types.SimpleBracket exposing (SimpleBracket, SimpleBracketEntry)
import Bets.Init.WorldCup2026.Tournament.Teams exposing (..)


dummySimpleBracket : SimpleBracket
dummySimpleBracket =
    -- R1: 32 teams (2 per group A-L + 8 best thirds from groups A-H)
    [ entry mexico.team R1
    , entry south_africa.team R1
    , entry south_korea.team R1
    , entry canada.team R1
    , entry bosnia.team R1
    , entry qatar.team R1
    , entry brazil.team R1
    , entry morocco.team R1
    , entry haiti.team R1
    , entry usa.team R1
    , entry paraguay.team R1
    , entry australia.team R1
    , entry germany.team R1
    , entry curacao.team R1
    , entry ivory_coast.team R1
    , entry netherlands.team R1
    , entry japan.team R1
    , entry sweden.team R1
    , entry belgium.team R1
    , entry egypt.team R1
    , entry iran.team R1
    , entry spain.team R1
    , entry cape_verde.team R1
    , entry saudi_arabia.team R1
    , entry france.team R1
    , entry senegal.team R1
    , entry argentina.team R1
    , entry algeria.team R1
    , entry portugal.team R1
    , entry dr_congo.team R1
    , entry england.team R1
    , entry croatia.team R1
    -- R2: 16 teams
    , entry france.team R2
    , entry argentina.team R2
    , entry germany.team R2
    , entry netherlands.team R2
    , entry spain.team R2
    , entry england.team R2
    , entry brazil.team R2
    , entry portugal.team R2
    , entry usa.team R2
    , entry canada.team R2
    , entry mexico.team R2
    , entry belgium.team R2
    , entry ivory_coast.team R2
    , entry senegal.team R2
    , entry australia.team R2
    , entry croatia.team R2
    -- R3: 8 teams (quarters)
    , entry france.team R3
    , entry argentina.team R3
    , entry germany.team R3
    , entry spain.team R3
    , entry england.team R3
    , entry brazil.team R3
    , entry portugal.team R3
    , entry netherlands.team R3
    -- R4: 4 teams (semis)
    , entry france.team R4
    , entry germany.team R4
    , entry spain.team R4
    , entry brazil.team R4
    -- R5: 2 teams (finalists)
    , entry france.team R5
    , entry brazil.team R5
    -- R6: champion
    , entry france.team R6
    ]


entry : Team -> Round -> SimpleBracketEntry
entry team round =
    { team = team, round = round, hasQualified = TBD }


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


dummyParticipant : Participant
dummyParticipant =
    { name = Changed "Test User"
    , address = Changed "Teststraat 1"
    , residence = Changed "Amsterdam"
    , phone = Changed "0612345678"
    , email = Changed "test@example.com"
    , howyouknowus = Changed "Internet"
    }
