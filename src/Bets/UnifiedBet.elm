module Bets.UnifiedBet exposing
    ( decode
    , encode
    )

{-| Unified wire format for `/bets/` endpoint.

Encodes/decodes SimpleBet using the unified bracket format, which the backend
stores as a flat table and can serve both simple and nested bracket types.
-}

import Bets.Json.Encode exposing (mStrEnc)
import Bets.SimpleBet exposing (SimpleBet, SimpleAnswers)
import Bets.Types exposing (Answer(..))
import Bets.Types.Answer.GroupMatches as GroupMatches
import Bets.Types.Answer.SimpleBracket as SBracket
import Bets.Types.Answer.Topscorer as Topscorer
import Bets.Types.Participant as Participant
import Bets.Types.UnifiedBracket as UnifiedBracket
import Json.Decode exposing (Decoder, field, maybe)
import Json.Encode


encode : SimpleBet -> Json.Encode.Value
encode bet =
    let
        answersJson =
            Json.Encode.object
                [ ( "matches", GroupMatches.encode bet.answers.matches )
                , ( "bracket", UnifiedBracket.encode (UnifiedBracket.fromAnswerSimpleBracket bet.answers.bracket) )
                , ( "topscorer", Topscorer.encode bet.answers.topscorer )
                ]

        betObject =
            Json.Encode.object
                [ ( "answers", answersJson )
                , ( "uuid", mStrEnc bet.uuid )
                , ( "active", Json.Encode.bool bet.active )
                , ( "participant", Participant.encode bet.participant )
                ]
    in
    Json.Encode.object
        [ ( "bet", betObject ) ]


decode : Decoder SimpleBet
decode =
    field "bet" decodeBet


decodeBet : Decoder SimpleBet
decodeBet =
    Json.Decode.map4 SimpleBet
        (field "answers" decodeAnswers)
        (field "uuid" (maybe Json.Decode.string))
        (field "active" Json.Decode.bool)
        (field "participant" Participant.decode)


decodeAnswers : Decoder SimpleAnswers
decodeAnswers =
    Json.Decode.map3 SimpleAnswers
        (field "matches" GroupMatches.decode)
        (field "bracket" decodeAnswerSimpleBracket)
        (field "topscorer" Topscorer.decode)


decodeAnswerSimpleBracket : Decoder SBracket.AnswerSimpleBracket
decodeAnswerSimpleBracket =
    UnifiedBracket.decode
        |> Json.Decode.andThen
            (\(Answer content points) ->
                case content of
                    UnifiedBracket.BracketSimple sb ->
                        Json.Decode.succeed (Answer sb points)

                    UnifiedBracket.BracketNested _ ->
                        Json.Decode.fail "Expected simple bracket but received nested bracket"
            )
