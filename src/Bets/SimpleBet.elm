module Bets.SimpleBet exposing
    ( SimpleBet
    , SimpleAnswers
    , decode
    , decodeBet
    , encode
    , isComplete
    )

import Bets.Json.Encode exposing (mStrEnc)
import Bets.Types exposing (AnswerGroupMatches, AnswerTopscorer, Participant)
import Bets.Types.Answer.GroupMatches as GroupMatches
import Bets.Types.Answer.SimpleBracket as SBracket
import Bets.Types.Answer.Topscorer as Topscorer
import Bets.Types.Participant as Participant
import Bool.Extra as Bool
import Json.Decode exposing (Decoder, field, maybe)
import Json.Encode


type alias SimpleAnswers =
    { matches : AnswerGroupMatches
    , bracket : SBracket.AnswerSimpleBracket
    , topscorer : AnswerTopscorer
    }


type alias SimpleBet =
    { answers : SimpleAnswers
    , uuid : Maybe String
    , active : Bool
    , participant : Participant
    }


isComplete : SimpleBet -> Bool
isComplete bet =
    Bool.all
        [ GroupMatches.isComplete bet.answers.matches
        , Topscorer.isComplete bet.answers.topscorer
        , SBracket.isComplete bet.answers.bracket
        , Participant.isComplete bet.participant
        ]


encode : SimpleBet -> Json.Encode.Value
encode bet =
    let
        answersJson =
            Json.Encode.object
                [ ( "matches", GroupMatches.encode bet.answers.matches )
                , ( "bracket", SBracket.encode bet.answers.bracket )
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
        (field "bracket" SBracket.decode)
        (field "topscorer" Topscorer.decode)
