module Bets.Types.Answer.SimpleBracket exposing
    ( AnswerSimpleBracket
    , decode
    , encode
    , isComplete
    )

import Bets.Types exposing (Answer(..))
import Bets.Types.Points
import Bets.Types.SimpleBracket as SB
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode


type alias AnswerSimpleBracket =
    Answer SB.SimpleBracket


isComplete : AnswerSimpleBracket -> Bool
isComplete (Answer bracket _) =
    SB.isComplete bracket


encode : AnswerSimpleBracket -> Json.Encode.Value
encode (Answer bracket points) =
    Json.Encode.object
        [ ( "bracket", SB.encode bracket )
        , ( "points", Bets.Types.Points.encode points )
        ]


decode : Decoder AnswerSimpleBracket
decode =
    Decode.succeed Answer
        |> required "bracket" SB.decode
        |> required "points" Bets.Types.Points.decode
