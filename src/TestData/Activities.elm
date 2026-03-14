module TestData.Activities exposing (dummyActivities)

import Time
import Types exposing (Activity(..), ActivityMeta)


dummyActivities : List Activity
dummyActivities =
    [ APost
        { date = Time.millisToPosix 1750000000000, active = True, uuid = "post-1" }
        "Admin"
        "WK 2026 begint!"
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    , AComment
        { date = Time.millisToPosix 1749900000000, active = True, uuid = "comment-1" }
        "Eelco"
        "Ik ga voor Nederland natuurlijk."
    , AComment
        { date = Time.millisToPosix 1749800000000, active = True, uuid = "comment-2" }
        "Pieter"
        "Nederland gaat het niet redden hoor."
    , ANewBet
        { date = Time.millisToPosix 1749700000000, active = True, uuid = "bet-1" }
        "Jan"
        "test-uuid-jan"
    , AComment
        { date = Time.millisToPosix 1749600000000, active = True, uuid = "comment-3" }
        "Sophie"
        "Dit wordt het beste WK ooit!"
    ]
