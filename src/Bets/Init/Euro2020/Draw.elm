module Bets.Init.Euro2020.Draw exposing (..)

import Bets.Init.Euro2020.Teams exposing (..)
import Bets.Types exposing (TeamData, TeamDatum)



-- Group A: Turkey, Italy, Wales, Switzerland.
-- Group B: Denmark, Finland, Belgium, Russia.
-- Group C: Netherlands, Ukraine, Austria, North Macedonia.
-- Group D: England, Croatia, Scotland, Czech Republic.
-- Group E: Spain, Sweden, Poland, Slovakia.
-- Group F: Hungary, Portugal, France, Germany.


initTeamData : TeamData
initTeamData =
    [ a1
    , a2
    , a3
    , a4
    , b1
    , b2
    , b3
    , b4
    , c1
    , c2
    , c3
    , c4
    , d1
    , d2
    , d3
    , d4
    , e1
    , e2
    , e3
    , e4
    , f1
    , f2
    , f3
    , f4
    ]


a1 : TeamDatum
a1 =
    turkey


a2 : TeamDatum
a2 =
    italy


a3 : TeamDatum
a3 =
    wales


a4 : TeamDatum
a4 =
    switzerland



-- Group B (Copenhagen/St Petersburg): Denmark (hosts), Finland, Belgium, Russia (hosts)


b1 : TeamDatum
b1 =
    denmark


b2 : TeamDatum
b2 =
    finland


b3 : TeamDatum
b3 =
    belgium


b4 : TeamDatum
b4 =
    russia



-- Group C (Amsterdam/Bucharest): Netherlands (hosts), Ukraine, Austria, Play-off winner D or A


c1 : TeamDatum
c1 =
    netherlands


c2 : TeamDatum
c2 =
    ukraine


c3 : TeamDatum
c3 =
    austria


c4 : TeamDatum
c4 =
    north_macedonia



-- Group D (London/Glasgow): England (hosts), Croatia, Play-off winner C, Czech Republic


d1 : TeamDatum
d1 =
    england


d2 : TeamDatum
d2 =
    croatia


d3 : TeamDatum
d3 =
    scotland


d4 : TeamDatum
d4 =
    czechia



-- Group E (Bilbao/Dublin): Spain (hosts), Sweden, Poland, Play-off winner B


e1 : TeamDatum
e1 =
    spain


e2 : TeamDatum
e2 =
    sweden


e3 : TeamDatum
e3 =
    poland


e4 : TeamDatum
e4 =
    slovakia



-- Group F (Munich/Budapest): Play-off winner A or D, Portugal (holders), France, Germany (hosts)


f1 : TeamDatum
f1 =
    hungary


f2 : TeamDatum
f2 =
    portugal


f3 : TeamDatum
f3 =
    france


f4 : TeamDatum
f4 =
    germany
