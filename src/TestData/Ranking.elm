module TestData.Ranking exposing (dummyRankingSummary)

import Time
import Types exposing (RankingGroup, RankingSummary, RankingSummaryLine, RoundScore)


dummyRankingSummary : RankingSummary
dummyRankingSummary =
    { summary =
        [ { pos = 1
          , bets =
                [ { name = "Jan"
                  , rounds = [ { round = "group", points = 18 } ]
                  , topscorer = 5
                  , total = 23
                  , uuid = "dummy-jan"
                  }
                ]
          , total = 23
          }
        , { pos = 2
          , bets =
                [ { name = "Pieter"
                  , rounds = [ { round = "group", points = 15 } ]
                  , topscorer = 0
                  , total = 15
                  , uuid = "dummy-pieter"
                  }
                , { name = "Sophie"
                  , rounds = [ { round = "group", points = 15 } ]
                  , topscorer = 0
                  , total = 15
                  , uuid = "dummy-sophie"
                  }
                ]
          , total = 15
          }
        , { pos = 3
          , bets =
                [ { name = "Eelco"
                  , rounds = [ { round = "group", points = 12 } ]
                  , topscorer = 0
                  , total = 12
                  , uuid = "dummy-eelco"
                  }
                ]
          , total = 12
          }
        ]
    , time = Time.millisToPosix 1750000000000
    }
