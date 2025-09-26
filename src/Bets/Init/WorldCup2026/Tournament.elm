module Bets.Init.WorldCup2026.Tournament exposing
    ( bracket
    , initTeamData
    , matches
    )

import Bets.Init.WorldCup2026.Tournament.Draw exposing (..)
import Bets.Init.WorldCup2026.Tournament.Teams exposing (..)
import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Tournament8x4, Winner(..))
import Bets.Types.DateTime exposing (date, time)
import Bets.Types.Group as Group
import Bets.Types.Match exposing (match)
import Stadium exposing (..)
import Time exposing (Month(..))


initTeamData : TeamData
initTeamData =
    Bets.Init.WorldCup2026.Tournament.Draw.initTeamData


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

        tnwa = firstPlace A
        tnwb = firstPlace B
        tnwc = firstPlace C
        tnwd = firstPlace D
        tnwe = firstPlace E
        tnwf = firstPlace F
        tnwg = firstPlace G
        tnwh = firstPlace H
        tnwi = firstPlace I
        tnwj = firstPlace J
        tnwk = firstPlace K
        tnwl = firstPlace L

        tnra = secondPlace A
        tnrb = secondPlace B
        tnrc = secondPlace C
        tnrd = secondPlace D
        tnre = secondPlace E
        tnrf = secondPlace F
        tnrg = secondPlace G
        tnrh = secondPlace H
        tnri = secondPlace I
        tnrj = secondPlace J
        tnrk = secondPlace K
        tnrl = secondPlace L

        tnt1 = bestThird 1 [ A, B, C, D ]
        tnt2 = bestThird 2 [ E, F, G, H ]
        tnt3 = bestThird 3 [ I, J, K, L ]
        tnt4 = bestThird 4 [ A, B, C, D ]
        tnt5 = bestThird 5 [ E, F, G, H ]
        tnt6 = bestThird 6 [ I, J, K, L ]
        tnt7 = bestThird 7 [ A, B, C, D, E, F ]
        tnt8 = bestThird 8 [ G, H, I, J, K, L ]

        -- Round of 32
        m65 = MatchNode "m65" None tnwa tnrb R1 TBD
        m66 = MatchNode "m66" None tnwc tnrd R1 TBD
        m67 = MatchNode "m67" None tnwe tnrf R1 TBD
        m68 = MatchNode "m68" None tnwg tnrh R1 TBD
        m69 = MatchNode "m69" None tnwi tnrj R1 TBD
        m70 = MatchNode "m70" None tnwk tnrl R1 TBD
        m71 = MatchNode "m71" None tnwb tnra R1 TBD
        m72 = MatchNode "m72" None tnwd tnrc R1 TBD
        m73 = MatchNode "m73" None tnwf tnre R1 TBD
        m74 = MatchNode "m74" None tnwh tnrg R1 TBD
        m75 = MatchNode "m75" None tnrj tnri R1 TBD
        m76 = MatchNode "m76" None tnrl tnwk R1 TBD
        m77 = MatchNode "m77" None tnt1 tnt2 R1 TBD
        m78 = MatchNode "m78" None tnt3 tnt4 R1 TBD
        m79 = MatchNode "m79" None tnt5 tnt6 R1 TBD
        m80 = MatchNode "m80" None tnt7 tnt8 R1 TBD

        -- Round of 16
        m81 = MatchNode "m81" None m65 m66 R2 TBD
        m82 = MatchNode "m82" None m67 m68 R2 TBD
        m83 = MatchNode "m83" None m69 m70 R2 TBD
        m84 = MatchNode "m84" None m71 m72 R2 TBD
        m85 = MatchNode "m85" None m73 m74 R2 TBD
        m86 = MatchNode "m86" None m75 m76 R2 TBD
        m87 = MatchNode "m87" None m77 m78 R2 TBD
        m88 = MatchNode "m88" None m79 m80 R2 TBD

        -- Quarter-finals
        m89 = MatchNode "m89" None m81 m82 R3 TBD
        m90 = MatchNode "m90" None m83 m84 R3 TBD
        m91 = MatchNode "m91" None m85 m86 R3 TBD
        m92 = MatchNode "m92" None m87 m88 R3 TBD

        -- Semi-finals
        m93 = MatchNode "m93" None m89 m90 R4 TBD
        m94 = MatchNode "m94" None m91 m92 R4 TBD

        -- Final
        m95 = MatchNode "m95" None m93 m94 R5 TBD
    in
    m95



-- Matches


matches =
    [ -- Group A
      -- - qatar
      -- - ecuador
      -- - senegal
      -- - netherlands
      match "m01" A a1.team a2.team (date 2026 Nov 21) (time 17 0) rome
    , match "m02" A a3.team a4.team (date 2026 Nov 21) (time 15 0) baku
    , match "m18" A a1.team a3.team (date 2026 Nov 25) (time 20 0) rome
    , match "m19" A a4.team a2.team (date 2026 Nov 25) (time 17 0) baku
    , match "m36" A a4.team a1.team (date 2026 Nov 29) (time 16 0) rome
    , match "m35" A a2.team a3.team (date 2026 Nov 29) (time 16 0) baku

    -- Group B
    -- - england
    -- - iran
    -- - usa
    -- - wales
    , match "m03" B b1.team b2.team (date 2026 Nov 21) (time 20 0) petersburg
    , match "m04" B b3.team b4.team (date 2026 Nov 21) (time 17 0) copenhagen
    , match "m20" B b1.team b3.team (date 2026 Nov 25) (time 14 0) petersburg
    , match "m17" B b4.team b2.team (date 2026 Nov 25) (time 20 0) copenhagen
    , match "m34" B b4.team b1.team (date 2026 Nov 29) (time 20 0) petersburg
    , match "m33" B b2.team b3.team (date 2026 Nov 29) (time 20 0) copenhagen

    -- Group C
    -- - argentina
    -- - saoudi_arabia
    -- - mexico
    -- - poland
    , match "m08" C c1.team c2.team (date 2026 Nov 22) (time 12 0) amsterdam
    , match "m07" C c3.team c4.team (date 2026 Nov 22) (time 18 0) bucharest
    , match "m22" C c4.team c2.team (date 2026 Nov 26) (time 14 0) amsterdam
    , match "m24" C c1.team c3.team (date 2026 Nov 26) (time 17 0) bucharest
    , match "m39" C c4.team c1.team (date 2026 Nov 30) (time 16 0) amsterdam
    , match "m40" C c2.team c3.team (date 2026 Nov 30) (time 16 0) bucharest

    -- Group D
    -- - france
    -- - australia
    -- - denmark
    -- - tunisia
    , match "m05" D d1.team d2.team (date 2026 Nov 22) (time 15 0) londen
    , match "m06" D d3.team d4.team (date 2026 Nov 22) (time 21 0) glasgow
    , match "m21" D d4.team d2.team (date 2026 Nov 26) (time 17 0) glasgow
    , match "m23" D d1.team d3.team (date 2026 Nov 26) (time 20 0) londen
    , match "m37" D d2.team d3.team (date 2026 Nov 30) (time 20 0) glasgow
    , match "m38" D d4.team d1.team (date 2026 Nov 30) (time 20 0) londen

    -- Group E
    -- - spain
    -- - costa_rica
    -- - germany
    -- - japan
    , match "m10" E e1.team e2.team (date 2026 Nov 22) (time 14 0) bilbao
    , match "m11" E e3.team e4.team (date 2026 Nov 22) (time 20 0) dublin
    , match "m25" E e4.team e2.team (date 2026 Nov 26) (time 14 0) dublin
    , match "m28" E e1.team e3.team (date 2026 Nov 26) (time 20 0) bilbao
    , match "m43" E e2.team e3.team (date 2026 Nov 30) (time 20 0) bilbao
    , match "m44" E e4.team e1.team (date 2026 Nov 30) (time 20 0) dublin

    -- Group F
    -- belgium
    -- canada
    -- morocco
    -- croatia
    , match "m12" F f3.team f4.team (date 2026 Nov 23) (time 14 0) bucharest
    , match "m09" F f1.team f2.team (date 2026 Nov 23) (time 17 0) munich
    , match "m27" F f4.team f2.team (date 2026 Nov 27) (time 17 0) munich
    , match "m26" F f1.team f3.team (date 2026 Nov 27) (time 20 0) bucharest
    , match "m42" F f2.team f3.team (date 2026 Dec 1) (time 16 0) bucharest
    , match "m41" F f4.team f1.team (date 2026 Dec 1) (time 16 0) munich

    -- Group G
    -- - brazil
    -- - serbia
    -- - switzerland
    -- - cameroon
    , match "m13" G g1.team g2.team (date 2026 Nov 24) (time 14 0) bucharest
    , match "m16" G g3.team g4.team (date 2026 Nov 24) (time 17 0) munich
    , match "m29" G g4.team g2.team (date 2026 Nov 28) (time 17 0) munich
    , match "m31" G g1.team g3.team (date 2026 Nov 28) (time 20 0) bucharest
    , match "m47" G g2.team g3.team (date 2026 Dec 2) (time 16 0) bucharest
    , match "m48" G g4.team g1.team (date 2026 Dec 2) (time 16 0) munich

    -- Group H
    -- - portugal
    -- - ghana
    -- - uruguay
    -- - south_korea
    , match "m14" H h1.team h2.team (date 2026 Nov 24) (time 14 0) bucharest
    , match "m15" H h3.team h4.team (date 2026 Nov 24) (time 17 0) munich
    , match "m30" H h4.team h2.team (date 2026 Nov 28) (time 17 0) munich
    , match "m32" H h1.team h3.team (date 2026 Nov 28) (time 20 0) bucharest
    , match "m45" H h2.team h3.team (date 2026 Dec 2) (time 16 0) bucharest
    , match "m46" H h4.team h1.team (date 2026 Dec 2) (time 16 0) munich

    -- Group I
    , match "m49" I i1.team i2.team (date 2026 Nov 23) (time 14 0) rome
    , match "m50" I i3.team i4.team (date 2026 Nov 23) (time 17 0) rome
    , match "m51" I i1.team i3.team (date 2026 Nov 27) (time 17 0) rome
    , match "m52" I i4.team i2.team (date 2026 Nov 27) (time 20 0) rome
    , match "m53" I i2.team i3.team (date 2026 Dec 1) (time 16 0) rome
    , match "m54" I i4.team i1.team (date 2026 Dec 1) (time 16 0) rome

    -- Group J
    , match "m55" J j1.team j2.team (date 2026 Nov 23) (time 14 0) baku
    , match "m56" J j3.team j4.team (date 2026 Nov 23) (time 17 0) baku
    , match "m57" J j1.team j3.team (date 2026 Nov 27) (time 17 0) baku
    , match "m58" J j4.team j2.team (date 2026 Nov 27) (time 20 0) baku
    , match "m59" J j2.team j3.team (date 2026 Dec 1) (time 16 0) baku
    , match "m60" J j4.team j1.team (date 2026 Dec 1) (time 16 0) baku

    -- Group K
    , match "m61" K k1.team k2.team (date 2026 Nov 24) (time 14 0) petersburg
    , match "m62" K k3.team k4.team (date 2026 Nov 24) (time 17 0) petersburg
    , match "m63" K k1.team k3.team (date 2026 Nov 28) (time 17 0) petersburg
    , match "m64" K k4.team k2.team (date 2026 Nov 28) (time 20 0) petersburg
    , match "m65" K k2.team k3.team (date 2026 Dec 2) (time 16 0) petersburg
    , match "m66" K k4.team k1.team (date 2026 Dec 2) (time 16 0) petersburg

    -- Group L
    , match "m67" L l1.team l2.team (date 2026 Nov 24) (time 14 0) copenhagen
    , match "m68" L l3.team l4.team (date 2026 Nov 24) (time 17 0) copenhagen
    , match "m69" L l1.team l3.team (date 2026 Nov 28) (time 17 0) copenhagen
    , match "m70" L l4.team l2.team (date 2026 Nov 28) (time 20 0) copenhagen
    , match "m71" L l2.team l3.team (date 2026 Dec 2) (time 16 0) copenhagen
    , match "m72" L l4.team l1.team (date 2026 Dec 2) (time 16 0) copenhagen
    ]