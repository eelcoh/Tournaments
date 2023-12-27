module Bets.Init.WorldCup2022.Tournament exposing
    ( bracket
    , matches
    )

import Bets.Init.WorldCup2022.Draw exposing (..)
import Bets.Init.WorldCup2022.Teams exposing (..)
import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Tournament8x4, Winner(..))
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

        tnwg =
            firstPlace G

        tnwh =
            firstPlace H

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

        tnrg =
            secondPlace G

        tnrh =
            secondPlace H

        -- tnt1 =
        --     bestThird 1 [ A, B, C ]
        -- tnt2 =
        --     bestThird 2 [ A, B, C, D ]
        -- tnt3 =
        --     bestThird 3 [ A, D, E, F ]
        -- tnt4 =
        --     bestThird 4 [ D, E, F ]
        -- Second round matches
        mn49 =
            MatchNode "m49" None tnwa tnrb II TBD

        mn50 =
            MatchNode "m50" None tnwc tnrd II TBD

        mn51 =
            MatchNode "m51" None tnwb tnra II TBD

        mn52 =
            MatchNode "m52" None tnwd tnrc II TBD

        mn53 =
            MatchNode "m53" None tnwe tnrf II TBD

        mn54 =
            MatchNode "m54" None tnwg tnrh II TBD

        mn55 =
            MatchNode "m55" None tnwf tnre II TBD

        mn56 =
            MatchNode "m56" None tnwh tnrg II TBD

        -- quarter finals
        mn57 =
            MatchNode "m57" None mn49 mn50 III TBD

        mn58 =
            MatchNode "m58" None mn53 mn54 III TBD

        mn59 =
            MatchNode "m59" None mn51 mn52 III TBD

        mn60 =
            MatchNode "m60" None mn55 mn56 III TBD

        -- semi finals
        mn61 =
            MatchNode "m61" None mn57 mn58 IV TBD

        mn62 =
            MatchNode "m62" None mn59 mn60 IV TBD

        -- finals
        mn64 =
            MatchNode "m64" None mn61 mn62 V TBD
    in
    mn64



-- Matches


matches =
    { -- Group A
      -- - qatar
      -- - ecuador
      -- - senegal
      -- - netherlands
      m01 = match "m01" a1.team a2.team (date 2022 Nov 21) (time 17 0) rome
    , m02 = match "m02" a3.team a4.team (date 2022 Nov 21) (time 15 0) baku
    , m18 = match "m18" a1.team a3.team (date 2022 Nov 25) (time 20 0) rome
    , m19 = match "m19" a4.team a2.team (date 2022 Nov 25) (time 17 0) baku
    , m36 = match "m36" a4.team a1.team (date 2022 Nov 29) (time 16 0) rome
    , m35 = match "m35" a2.team a3.team (date 2022 Nov 29) (time 16 0) baku

    -- Group B
    -- - england
    -- - iran
    -- - usa
    -- - wales
    , m03 = match "m03" b1.team b2.team (date 2022 Nov 21) (time 20 0) petersburg
    , m04 = match "m04" b3.team b4.team (date 2022 Nov 21) (time 17 0) copenhagen
    , m20 = match "m20" b1.team b3.team (date 2022 Nov 25) (time 14 0) petersburg
    , m17 = match "m17" b4.team b2.team (date 2022 Nov 25) (time 20 0) copenhagen
    , m34 = match "m34" b4.team b1.team (date 2022 Nov 29) (time 20 0) petersburg
    , m33 = match "m33" b2.team b3.team (date 2022 Nov 29) (time 20 0) copenhagen

    -- Group C
    -- - argentina
    -- - saoudi_arabia
    -- - mexico
    -- - poland
    , m08 = match "m08" c1.team c2.team (date 2022 Nov 22) (time 12 0) amsterdam
    , m07 = match "m07" c3.team c4.team (date 2022 Nov 22) (time 18 0) bucharest
    , m22 = match "m22" c4.team c2.team (date 2022 Nov 26) (time 14 0) amsterdam
    , m24 = match "m24" c1.team c3.team (date 2022 Nov 26) (time 17 0) bucharest
    , m39 = match "m39" c4.team c1.team (date 2022 Nov 30) (time 16 0) amsterdam
    , m40 = match "m40" c2.team c3.team (date 2022 Nov 30) (time 16 0) bucharest

    -- Group D
    -- - france
    -- - australia
    -- - denmark
    -- - tunisia
    , m05 = match "m05" d1.team d2.team (date 2022 Nov 22) (time 15 0) londen
    , m06 = match "m06" d3.team d4.team (date 2022 Nov 22) (time 21 0) glasgow
    , m21 = match "m21" d4.team d2.team (date 2022 Nov 26) (time 17 0) glasgow
    , m23 = match "m23" d1.team d3.team (date 2022 Nov 26) (time 20 0) londen
    , m37 = match "m37" d2.team d3.team (date 2022 Nov 30) (time 20 0) glasgow
    , m38 = match "m38" d4.team d1.team (date 2022 Nov 30) (time 20 0) londen

    -- Group E
    -- - spain
    -- - costa_rica
    -- - germany
    -- - japan
    , m10 = match "m10" e1.team e2.team (date 2022 Nov 22) (time 14 0) bilbao
    , m11 = match "m11" e3.team e4.team (date 2022 Nov 22) (time 20 0) dublin
    , m25 = match "m25" e4.team e2.team (date 2022 Nov 26) (time 14 0) dublin
    , m28 = match "m28" e1.team e3.team (date 2022 Nov 26) (time 20 0) bilbao
    , m43 = match "m43" e2.team e3.team (date 2022 Nov 30) (time 20 0) bilbao
    , m44 = match "m44" e4.team e1.team (date 2022 Nov 30) (time 20 0) dublin

    -- Group F
    -- belgium
    -- canada
    -- morocco
    -- croatia
    , m12 = match "m12" f3.team f4.team (date 2022 Nov 23) (time 14 0) bucharest
    , m09 = match "m09" f1.team f2.team (date 2022 Nov 23) (time 17 0) munich
    , m27 = match "m27" f4.team f2.team (date 2022 Nov 27) (time 17 0) munich
    , m26 = match "m26" f1.team f3.team (date 2022 Nov 27) (time 20 0) bucharest
    , m42 = match "m42" f2.team f3.team (date 2022 Dec 1) (time 16 0) bucharest
    , m41 = match "m41" f4.team f1.team (date 2022 Dec 1) (time 16 0) munich

    -- Group G
    -- - brazil
    -- - serbia
    -- - switzerland
    -- - cameroon
    , m13 = match "m13" g3.team g4.team (date 2022 Nov 24) (time 14 0) bucharest
    , m16 = match "m16" g1.team g2.team (date 2022 Nov 24) (time 17 0) munich
    , m29 = match "m29" g4.team g2.team (date 2022 Nov 28) (time 17 0) munich
    , m31 = match "m31" g1.team g3.team (date 2022 Nov 28) (time 20 0) bucharest
    , m47 = match "m47" g2.team g3.team (date 2022 Dec 2) (time 16 0) bucharest
    , m48 = match "m48" g4.team g1.team (date 2022 Dec 2) (time 16 0) munich

    -- Group H
    -- - portugal
    -- - ghana
    -- - uruguay
    -- - south_korea
    , m14 = match "m14" h3.team h4.team (date 2022 Nov 24) (time 14 0) bucharest
    , m15 = match "m15" h1.team h2.team (date 2022 Nov 24) (time 17 0) munich
    , m30 = match "m30" h4.team h2.team (date 2022 Nov 28) (time 17 0) munich
    , m32 = match "m32" h1.team h3.team (date 2022 Nov 28) (time 20 0) bucharest
    , m45 = match "m45" h2.team h3.team (date 2022 Dec 2) (time 16 0) bucharest
    , m46 = match "m46" h4.team h1.team (date 2022 Dec 2) (time 16 0) munich
    }
