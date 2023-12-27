module Bets.Init.Euro2024.Tournament exposing
    ( bracket
    , initTeamData
    , matches
    )

import Bets.Init.Euro2024.Draw exposing (..)
import Bets.Init.Euro2024.Teams exposing (..)
import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Winner(..))
import Bets.Types.DateTime exposing (date, time)
import Bets.Types.Group as Group
import Bets.Types.Match exposing (match)
import Stadium exposing (..)
import Time exposing (Month(..))
import Tuple exposing (pair)


bracket : Bracket
bracket =
    let
        firstPlace grp =
            let
                code =
                    "W" ++ Group.toString grp
            in
            TeamNode code (FirstPlace grp) Nothing TBD

        secondPlace grp =
            let
                code =
                    "R" ++ Group.toString grp
            in
            TeamNode code (SecondPlace grp) Nothing TBD

        bestThird idx grps =
            let
                code =
                    "T" ++ String.fromInt idx
            in
            TeamNode code (BestThirdFrom grps) Nothing TBD

        tnwa =
            firstPlace A

        tnwb =
            firstPlace B

        tnwc =
            firstPlace C

        tnwd =
            firstPlace D

        tnwe =
            firstPlace E

        tnwf =
            firstPlace F

        tnra =
            secondPlace A

        tnrb =
            secondPlace B

        tnrc =
            secondPlace C

        tnrd =
            secondPlace D

        tnre =
            secondPlace E

        tnrf =
            secondPlace F

        tnt1 =
            bestThird 1 [ A, D, E, F ]

        tnt2 =
            bestThird 2 [ D, E, F ]

        tnt3 =
            bestThird 3 [ A, B, C, D ]

        tnt4 =
            bestThird 4 [ A, B, C ]

        -- Second round matches
        mn37 =
            MatchNode "m37" None tnwa tnrc II TBD

        mn38 =
            MatchNode "m38" None tnra tnrb II TBD

        mn39 =
            MatchNode "m39" None tnwb tnt1 II TBD

        mn40 =
            MatchNode "m40" None tnwc tnt2 II TBD

        mn41 =
            MatchNode "m41" None tnwf tnt4 II TBD

        mn42 =
            MatchNode "m42" None tnrd tnre II TBD

        mn43 =
            MatchNode "m43" None tnwe tnt3 II TBD

        mn44 =
            MatchNode "m44" None tnwd tnrf II TBD

        -- quarter finals
        mn45 =
            MatchNode "m45" None mn39 mn37 III TBD

        mn46 =
            MatchNode "m46" None mn41 mn42 III TBD

        mn47 =
            MatchNode "m47" None mn43 mn44 III TBD

        mn48 =
            MatchNode "m48" None mn40 mn38 III TBD

        -- semi finals
        mn49 =
            MatchNode "m49" None mn45 mn46 IV TBD

        mn50 =
            MatchNode "m50" None mn47 mn48 IV TBD

        -- finals
        mn51 =
            MatchNode "m51" None mn49 mn50 V TBD
    in
    mn51



-- Matches


matches =
    { -- Group A
      m01 = match "m01" a1.team a2.team (date 2024 Jun 14) (time 21 0) munich
    , m02 = match "m02" a3.team a4.team (date 2024 Jun 15) (time 15 0) cologne
    , m14 = match "m14" a1.team a3.team (date 2024 Jun 19) (time 18 0) stuttgart
    , m13 = match "m13" a2.team a4.team (date 2024 Jun 19) (time 21 0) cologne
    , m25 = match "m25" a4.team a1.team (date 2024 Jun 23) (time 21 0) frankfurt
    , m26 = match "m26" a2.team a3.team (date 2024 Jun 23) (time 21 0) stuttgart

    -- Group B
    , m03 = match "m03" b1.team b2.team (date 2024 Jun 15) (time 18 0) berlin
    , m04 = match "m04" b3.team b4.team (date 2024 Jun 15) (time 21 0) dortmund
    , m15 = match "m15" b2.team b4.team (date 2024 Jun 19) (time 15 0) hamburg
    , m16 = match "m16" b1.team b3.team (date 2024 Jun 20) (time 21 0) gelsenkirchen
    , m27 = match "m27" b4.team b1.team (date 2024 Jun 24) (time 21 0) dusseldorf
    , m28 = match "m28" b2.team b3.team (date 2024 Jun 24) (time 21 0) leipzig

    -- Group C
    , m05 = match "m05" c1.team c2.team (date 2024 Jun 16) (time 18 0) stuttgart
    , m06 = match "m06" c3.team c4.team (date 2024 Jun 16) (time 21 0) gelsenkirchen
    , m18 = match "m18" c1.team c3.team (date 2024 Jun 20) (time 15 0) munich
    , m17 = match "m17" c2.team c4.team (date 2024 Jun 20) (time 18 0) frankfurt
    , m29 = match "m29" c4.team c1.team (date 2024 Jun 25) (time 21 0) cologne
    , m30 = match "m30" c2.team c3.team (date 2024 Jun 25) (time 21 0) munich

    -- Group D
    , m07 = match "m07" d1.team d2.team (date 2024 Jun 16) (time 15 0) hamburg
    , m08 = match "m08" d3.team d4.team (date 2024 Jun 17) (time 21 0) dusseldorf
    , m19 = match "m19" d1.team d3.team (date 2024 Jun 21) (time 18 0) berlin
    , m20 = match "m20" d2.team d4.team (date 2024 Jun 21) (time 21 0) leipzig
    , m31 = match "m31" d2.team d3.team (date 2024 Jun 25) (time 18 0) berlin
    , m32 = match "m32" d4.team d1.team (date 2024 Jun 25) (time 18 0) dortmund

    -- Group E: Belgium, Slovakia, Romania, PlayoffB
    , m10 = match "m10" e3.team e4.team (date 2024 Jun 17) (time 15 0) munich
    , m09 = match "m09" e1.team e2.team (date 2024 Jun 17) (time 18 0) frankfurt
    , m21 = match "m21" e2.team e4.team (date 2024 Jun 21) (time 15 0) dusseldorf
    , m22 = match "m22" e1.team e3.team (date 2024 Jun 22) (time 21 0) cologne
    , m33 = match "m33" e2.team e3.team (date 2024 Jun 26) (time 18 0) frankfurt
    , m34 = match "m34" e4.team e1.team (date 2024 Jun 26) (time 18 0) stuttgart

    -- Group F: Turkey, PlayoffC, Portugal, Czechia
    , m11 = match "m11" f1.team f2.team (date 2024 Jun 18) (time 18 0) dortmund
    , m12 = match "m12" f3.team f4.team (date 2024 Jun 18) (time 21 0) leipzig
    , m24 = match "m24" f2.team f4.team (date 2024 Jun 22) (time 15 0) hamburg
    , m23 = match "m23" f1.team f3.team (date 2024 Jun 22) (time 18 0) dortmund
    , m35 = match "m35" f2.team f3.team (date 2024 Jun 26) (time 21 0) gelsenkirchen
    , m36 = match "m36" f4.team f1.team (date 2024 Jun 26) (time 21 0) hamburg
    }


initTeamData : List { a | group : Group, team : b }
initTeamData =
    Debug.todo "TODO"
