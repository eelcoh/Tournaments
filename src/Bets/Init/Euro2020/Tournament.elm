module Bets.Init.Euro2020.Tournament exposing
    ( bracket
    , matches
    )

import Bets.Init.Euro2020.Draw exposing (..)
import Bets.Init.Euro2020.Teams exposing (..)
import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Tournament6x4, Winner(..))
import Bets.Types.DateTime exposing (date, time)
import Bets.Types.Group as Group
import Bets.Types.Match exposing (match)
import Stadium exposing (..)
import Time exposing (Month(..))


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
            bestThird 1 [ A, B, C ]

        tnt2 =
            bestThird 2 [ A, B, C, D ]

        tnt3 =
            bestThird 3 [ A, D, E, F ]

        tnt4 =
            bestThird 4 [ D, E, F ]

        -- Second round matches
        mn37 =
            MatchNode "m37" None tnwa tnrc II TBD

        mn38 =
            MatchNode "m38" None tnra tnrb II TBD

        mn39 =
            MatchNode "m39" None tnwb tnt3 II TBD

        mn40 =
            MatchNode "m40" None tnwc tnt4 II TBD

        mn41 =
            MatchNode "m41" None tnwf tnt1 II TBD

        mn42 =
            MatchNode "m42" None tnrd tnre II TBD

        mn43 =
            MatchNode "m43" None tnwe tnt2 II TBD

        mn44 =
            MatchNode "m44" None tnwd tnrf II TBD

        -- quarter finals
        mn45 =
            MatchNode "m45" None mn41 mn42 III TBD

        mn46 =
            MatchNode "m46" None mn37 mn39 III TBD

        mn47 =
            MatchNode "m47" None mn38 mn40 III TBD

        mn48 =
            MatchNode "m48" None mn43 mn44 III TBD

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
      m01 = match "m01" a1.team a2.team (date 2020 Jun 12) (time 17 0) rome
    , m02 = match "m02" a3.team a4.team (date 2020 Jun 13) (time 15 0) baku
    , m14 = match "m14" a1.team a3.team (date 2020 Jun 17) (time 20 0) rome
    , m13 = match "m13" a4.team a2.team (date 2020 Jun 17) (time 17 0) baku
    , m26 = match "m26" a4.team a1.team (date 2020 Jun 21) (time 16 0) rome
    , m25 = match "m25" a2.team a3.team (date 2020 Jun 21) (time 16 0) baku

    -- Group B
    , m03 = match "m03" b1.team b2.team (date 2020 Jun 13) (time 20 0) petersburg
    , m04 = match "m04" b3.team b4.team (date 2020 Jun 13) (time 17 0) copenhagen
    , m15 = match "m15" b1.team b3.team (date 2020 Jun 17) (time 14 0) petersburg
    , m16 = match "m16" b4.team b2.team (date 2020 Jun 18) (time 20 0) copenhagen
    , m28 = match "m28" b4.team b1.team (date 2020 Jun 22) (time 20 0) petersburg
    , m27 = match "m27" b2.team b3.team (date 2020 Jun 22) (time 20 0) copenhagen

    -- Group C
    , m05 = match "m05" c1.team c2.team (date 2020 Jun 14) (time 12 0) amsterdam
    , m06 = match "m06" c3.team c4.team (date 2020 Jun 14) (time 18 0) bucharest
    , m17 = match "m17" c4.team c2.team (date 2020 Jun 18) (time 14 0) amsterdam
    , m18 = match "m18" c1.team c3.team (date 2020 Jun 18) (time 17 0) bucharest
    , m29 = match "m29" c4.team c1.team (date 2020 Jun 22) (time 16 0) amsterdam
    , m30 = match "m30" c2.team c3.team (date 2020 Jun 22) (time 16 0) bucharest

    -- Group D
    , m07 = match "m07" d1.team d2.team (date 2020 Jun 14) (time 15 0) londen
    , m08 = match "m08" d3.team d4.team (date 2020 Jun 15) (time 21 0) glasgow
    , m20 = match "m20" d1.team d3.team (date 2020 Jun 19) (time 20 0) londen
    , m19 = match "m19" d4.team d2.team (date 2020 Jun 19) (time 17 0) glasgow
    , m32 = match "m32" d4.team d1.team (date 2020 Jun 23) (time 20 0) londen
    , m31 = match "m31" d2.team d3.team (date 2020 Jun 23) (time 20 0) glasgow

    -- Group E
    , m09 = match "m09" e3.team e4.team (date 2020 Jun 15) (time 14 0) bilbao
    , m10 = match "m10" e1.team e2.team (date 2020 Jun 15) (time 20 0) dublin
    , m21 = match "m21" e1.team e3.team (date 2020 Jun 19) (time 14 0) dublin
    , m22 = match "m22" e4.team e2.team (date 2020 Jun 20) (time 20 0) bilbao
    , m33 = match "m33" e4.team e1.team (date 2020 Jun 24) (time 20 0) bilbao
    , m34 = match "m34" e2.team e3.team (date 2020 Jun 24) (time 20 0) dublin

    -- Group F
    , m11 = match "m11" f3.team f4.team (date 2020 Jun 16) (time 14 0) bucharest
    , m12 = match "m12" f1.team f2.team (date 2020 Jun 16) (time 17 0) munich
    , m24 = match "m24" f4.team f2.team (date 2020 Jun 20) (time 17 0) munich
    , m23 = match "m23" f1.team f3.team (date 2020 Jun 20) (time 20 0) bucharest
    , m35 = match "m35" f2.team f3.team (date 2020 Jun 24) (time 16 0) bucharest
    , m36 = match "m36" f4.team f1.team (date 2020 Jun 24) (time 16 0) munich
    }
