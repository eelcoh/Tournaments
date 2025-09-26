module Bets.Types.Round exposing
    ( compare
    , decode
    , encode
    , fromInt
    , fromRoman
    , isSameOrANextRound
    , nextRound
    , toInt
    , toString
    )

import Bets.Types exposing (Round(..))
import Json.Decode exposing (Decoder)
import Json.Encode



-- MODEL


fromRoman : String -> Round
fromRoman r =
    case String.toUpper r of
        "R1" ->
            R1

        "R2" ->
            R2

        "R3" ->
            R3

        "R4" ->
            R4

        "R5" ->
            R5

        _ ->
            R6


toRoman : Round -> String
toRoman r =
    case r of
        R1 ->
            "R1"

        R2 ->
            "R2"

        R3 ->
            "R3"

        R4 ->
            "R4"

        R5 ->
            "R5"

        R6 ->
            "R6"


toInt : Round -> Int
toInt r =
    case r of
        R1 ->
            1

        R2 ->
            2

        R3 ->
            3

        R4 ->
            4

        R5 ->
            5

        R6 ->
            6


fromInt : Int -> Round
fromInt i =
    case i of
        1 ->
            R1

        2 ->
            R2

        3 ->
            R3

        4 ->
            R4

        5 ->
            R5

        _ ->
            R6


toString : Round -> String
toString =
    toInt >> String.fromInt


isSameOrANextRound : Round -> Round -> Bool
isSameOrANextRound r1 r2 =
    toInt r1 >= toInt r2


nextRound : Round -> Maybe Round
nextRound r =
    case r of
        R1 ->
            Just R2

        R2 ->
            Just R3

        R3 ->
            Just R4

        R4 ->
            Just R5

        R5 ->
            Just R6

        R6 ->
            Nothing


compare : Round -> Round -> Order
compare r1 r2 =
    Basics.compare (toInt r1) (toInt r2)


encode : Round -> Json.Encode.Value
encode r =
    Json.Encode.int (toInt r)



{-
   decodeRound : Int -> Decoder Round
   decodeRound i =
     succeed (toRound i)

   decode : Decoder Round
   decode =
     "round" := Json.Decode.int `andThen` decodeRound
-}


decode : Decoder Round
decode =
    Json.Decode.int
        |> Json.Decode.map fromInt
