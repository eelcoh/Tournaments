module Bets.Init.Euro2020.Tournament exposing
    ( bracket
    , initTeamData
    , matches
    )

import Bets.Init.Euro2020.Tournament.Draw exposing (..)
import Bets.Init.Euro2020.Tournament.Teams exposing (..)
import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Tournament6x4, Winner(..))
import Bets.Types.DateTime exposing (date, time)
import Bets.Types.Group as Group
import Bets.Types.Match exposing (match)
import Stadium exposing (..)
import Time exposing (Month(..))


initTeamData : TeamData
initTeamData =
    Bets.Init.Euro2020.Tournament.Draw.initTeamData


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
            MatchNode "m37" None tnwa tnrc R2 TBD

        mn38 =
            MatchNode "m38" None tnra tnrb R2 TBD

        mn39 =
            MatchNode "m39" None tnwb tnt3 R2 TBD

        mn40 =
            MatchNode "m40" None tnwc tnt4 R2 TBD

        mn41 =
            MatchNode "m41" None tnwf tnt1 R2 TBD

        mn42 =
            MatchNode "m42" None tnrd tnre R2 TBD

        mn43 =
            MatchNode "m43" None tnwe tnt2 R2 TBD

        mn44 =
            MatchNode "m44" None tnwd tnrf R2 TBD

        -- quarter finals
        mn45 =
            MatchNode "m45" None mn41 mn42 R3 TBD

        mn46 =
            MatchNode "m46" None mn37 mn39 R3 TBD

        mn47 =
            MatchNode "m47" None mn38 mn40 R3 TBD

        mn48 =
            MatchNode "m48" None mn43 mn44 R3 TBD

        -- semi finals
        mn49 =
            MatchNode "m49" None mn45 mn46 R4 TBD

        mn50 =
            MatchNode "m50" None mn47 mn48 R4 TBD

        -- finals
        mn51 =
            MatchNode "m51" None mn49 mn50 R5 TBD
    in
    mn51



-- Matches


matches : List Bets.Types.Match
matches =
    [ match "m01" A a1.team a2.team (date 2020 Jun 12) (time 17 0) rome
    , match "m02" A a3.team a4.team (date 2020 Jun 13) (time 15 0) baku
    , match "m14" A a1.team a3.team (date 2020 Jun 17) (time 20 0) rome
    , match "m13" A a4.team a2.team (date 2020 Jun 17) (time 17 0) baku
    , match "m26" A a4.team a1.team (date 2020 Jun 21) (time 16 0) rome
    , match "m25" A a2.team a3.team (date 2020 Jun 21) (time 16 0) baku
    , match "m03" B b1.team b2.team (date 2020 Jun 13) (time 20 0) petersburg
    , match "m04" B b3.team b4.team (date 2020 Jun 13) (time 17 0) copenhagen
    , match "m15" B b1.team b3.team (date 2020 Jun 17) (time 14 0) petersburg
    , match "m16" B b4.team b2.team (date 2020 Jun 18) (time 20 0) copenhagen
    , match "m28" B b4.team b1.team (date 2020 Jun 22) (time 20 0) petersburg
    , match "m27" B b2.team b3.team (date 2020 Jun 22) (time 20 0) copenhagen
    , match "m05" C c1.team c2.team (date 2020 Jun 14) (time 12 0) amsterdam
    , match "m06" C c3.team c4.team (date 2020 Jun 14) (time 18 0) bucharest
    , match "m17" C c4.team c2.team (date 2020 Jun 18) (time 14 0) amsterdam
    , match "m18" C c1.team c3.team (date 2020 Jun 18) (time 17 0) bucharest
    , match "m29" C c4.team c1.team (date 2020 Jun 22) (time 16 0) amsterdam
    , match "m30" C c2.team c3.team (date 2020 Jun 22) (time 16 0) bucharest
    , match "m07" D d1.team d2.team (date 2020 Jun 14) (time 15 0) londen
    , match "m08" D d3.team d4.team (date 2020 Jun 15) (time 21 0) glasgow
    , match "m20" D d1.team d3.team (date 2020 Jun 19) (time 20 0) londen
    , match "m19" D d4.team d2.team (date 2020 Jun 19) (time 17 0) glasgow
    , match "m32" D d4.team d1.team (date 2020 Jun 23) (time 20 0) londen
    , match "m31" D d2.team d3.team (date 2020 Jun 23) (time 20 0) glasgow
    , match "m09" E e3.team e4.team (date 2020 Jun 15) (time 14 0) bilbao
    , match "m10" E e1.team e2.team (date 2020 Jun 15) (time 20 0) dublin
    , match "m21" E e1.team e3.team (date 2020 Jun 19) (time 14 0) dublin
    , match "m22" E e4.team e2.team (date 2020 Jun 20) (time 20 0) bilbao
    , match "m33" E e4.team e1.team (date 2020 Jun 24) (time 20 0) bilbao
    , match "m34" E e2.team e3.team (date 2020 Jun 24) (time 20 0) dublin
    , match "m11" F f3.team f4.team (date 2020 Jun 16) (time 14 0) bucharest
    , match "m12" F f1.team f2.team (date 2020 Jun 16) (time 17 0) munich
    , match "m24" F f4.team f2.team (date 2020 Jun 20) (time 17 0) munich
    , match "m23" F f1.team f3.team (date 2020 Jun 20) (time 20 0) bucharest
    , match "m35" F f2.team f3.team (date 2020 Jun 24) (time 16 0) bucharest
    , match "m36" F f4.team f1.team (date 2020 Jun 24) (time 16 0) munich
    ]
