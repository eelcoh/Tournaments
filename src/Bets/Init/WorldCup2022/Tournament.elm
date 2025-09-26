module Bets.Init.WorldCup2022.Tournament exposing
    ( bracket
    , initTeamData
    , matches
    )

import Bets.Init.WorldCup2022.Tournament.Draw exposing (..)
import Bets.Init.WorldCup2022.Tournament.Teams exposing (..)
import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Tournament8x4, Winner(..))
import Bets.Types.DateTime exposing (date, time)
import Bets.Types.Group as Group
import Bets.Types.Match exposing (match)
import Stadium exposing (..)
import Time exposing (Month(..))


initTeamData : TeamData
initTeamData =
    Bets.Init.WorldCup2022.Tournament.Draw.initTeamData


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
            MatchNode "m49" None tnwa tnrb R2 TBD

        mn50 =
            MatchNode "m50" None tnwc tnrd R2 TBD

        mn51 =
            MatchNode "m51" None tnwb tnra R2 TBD

        mn52 =
            MatchNode "m52" None tnwd tnrc R2 TBD

        mn53 =
            MatchNode "m53" None tnwe tnrf R2 TBD

        mn54 =
            MatchNode "m54" None tnwg tnrh R2 TBD

        mn55 =
            MatchNode "m55" None tnwf tnre R2 TBD

        mn56 =
            MatchNode "m56" None tnwh tnrg R2 TBD

        -- quarter finals
        mn57 =
            MatchNode "m57" None mn49 mn50 R3 TBD

        mn58 =
            MatchNode "m58" None mn53 mn54 R3 TBD

        mn59 =
            MatchNode "m59" None mn51 mn52 R3 TBD

        mn60 =
            MatchNode "m60" None mn55 mn56 R3 TBD

        -- semi finals
        mn61 =
            MatchNode "m61" None mn57 mn58 R4 TBD

        mn62 =
            MatchNode "m62" None mn59 mn60 R4 TBD

        -- finals
        mn64 =
            MatchNode "m64" None mn61 mn62 R5 TBD
    in
    mn64



-- Matches


matches =
    [ -- Group A
      -- - qatar
      -- - ecuador
      -- - senegal
      -- - netherlands
      match "m01" A a1.team a2.team (date 2022 Nov 21) (time 17 0) rome
    , match "m02" A a3.team a4.team (date 2022 Nov 21) (time 15 0) baku
    , match "m18" A a1.team a3.team (date 2022 Nov 25) (time 20 0) rome
    , match "m19" A a4.team a2.team (date 2022 Nov 25) (time 17 0) baku
    , match "m36" A a4.team a1.team (date 2022 Nov 29) (time 16 0) rome
    , match "m35" A a2.team a3.team (date 2022 Nov 29) (time 16 0) baku

    -- Group B
    -- - england
    -- - iran
    -- - usa
    -- - wales
    , match "m03" B b1.team b2.team (date 2022 Nov 21) (time 20 0) petersburg
    , match "m04" B b3.team b4.team (date 2022 Nov 21) (time 17 0) copenhagen
    , match "m20" B b1.team b3.team (date 2022 Nov 25) (time 14 0) petersburg
    , match "m17" B b4.team b2.team (date 2022 Nov 25) (time 20 0) copenhagen
    , match "m34" B b4.team b1.team (date 2022 Nov 29) (time 20 0) petersburg
    , match "m33" B b2.team b3.team (date 2022 Nov 29) (time 20 0) copenhagen

    -- Group C
    -- - argentina
    -- - saoudi_arabia
    -- - mexico
    -- - poland
    , match "m08" C c1.team c2.team (date 2022 Nov 22) (time 12 0) amsterdam
    , match "m07" C c3.team c4.team (date 2022 Nov 22) (time 18 0) bucharest
    , match "m22" C c4.team c2.team (date 2022 Nov 26) (time 14 0) amsterdam
    , match "m24" C c1.team c3.team (date 2022 Nov 26) (time 17 0) bucharest
    , match "m39" C c4.team c1.team (date 2022 Nov 30) (time 16 0) amsterdam
    , match "m40" C c2.team c3.team (date 2022 Nov 30) (time 16 0) bucharest

    -- Group D
    -- - france
    -- - australia
    -- - denmark
    -- - tunisia
    , match "m05" D d1.team d2.team (date 2022 Nov 22) (time 15 0) londen
    , match "m06" D d3.team d4.team (date 2022 Nov 22) (time 21 0) glasgow
    , match "m21" D d4.team d2.team (date 2022 Nov 26) (time 17 0) glasgow
    , match "m23" D d1.team d3.team (date 2022 Nov 26) (time 20 0) londen
    , match "m37" D d2.team d3.team (date 2022 Nov 30) (time 20 0) glasgow
    , match "m38" D d4.team d1.team (date 2022 Nov 30) (time 20 0) londen

    -- Group E
    -- - spain
    -- - costa_rica
    -- - germany
    -- - japan
    , match "m10" E e1.team e2.team (date 2022 Nov 22) (time 14 0) bilbao
    , match "m11" E e3.team e4.team (date 2022 Nov 22) (time 20 0) dublin
    , match "m25" E e4.team e2.team (date 2022 Nov 26) (time 14 0) dublin
    , match "m28" E e1.team e3.team (date 2022 Nov 26) (time 20 0) bilbao
    , match "m43" E e2.team e3.team (date 2022 Nov 30) (time 20 0) bilbao
    , match "m44" E e4.team e1.team (date 2022 Nov 30) (time 20 0) dublin

    -- Group F
    -- belgium
    -- canada
    -- morocco
    -- croatia
    , match "m12" F f3.team f4.team (date 2022 Nov 23) (time 14 0) bucharest
    , match "m09" F f1.team f2.team (date 2022 Nov 23) (time 17 0) munich
    , match "m27" F f4.team f2.team (date 2022 Nov 27) (time 17 0) munich
    , match "m26" F f1.team f3.team (date 2022 Nov 27) (time 20 0) bucharest
    , match "m42" F f2.team f3.team (date 2022 Dec 1) (time 16 0) bucharest
    , match "m41" F f4.team f1.team (date 2022 Dec 1) (time 16 0) munich

    -- Group G
    -- - brazil
    -- - serbia
    -- - switzerland
    -- - cameroon
    , match "m13" G g3.team g4.team (date 2022 Nov 24) (time 14 0) bucharest
    , match "m16" G g1.team g2.team (date 2022 Nov 24) (time 17 0) munich
    , match "m29" G g4.team g2.team (date 2022 Nov 28) (time 17 0) munich
    , match "m31" G g1.team g3.team (date 2022 Nov 28) (time 20 0) bucharest
    , match "m47" G g2.team g3.team (date 2022 Dec 2) (time 16 0) bucharest
    , match "m48" G g4.team g1.team (date 2022 Dec 2) (time 16 0) munich

    -- Group H
    -- - portugal
    -- - ghana
    -- - uruguay
    -- - south_korea
    , match "m14" H h3.team h4.team (date 2022 Nov 24) (time 14 0) bucharest
    , match "m15" H h1.team h2.team (date 2022 Nov 24) (time 17 0) munich
    , match "m30" H h4.team h2.team (date 2022 Nov 28) (time 17 0) munich
    , match "m32" H h1.team h3.team (date 2022 Nov 28) (time 20 0) bucharest
    , match "m45" H h2.team h3.team (date 2022 Dec 2) (time 16 0) bucharest
    , match "m46" H h4.team h1.team (date 2022 Dec 2) (time 16 0) munich
    ]
