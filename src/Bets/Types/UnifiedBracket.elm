module Bets.Types.UnifiedBracket exposing
    ( AnswerUnifiedBracket
    , BracketContent(..)
    , decode
    , encode
    , fromAnswerBracket
    , fromAnswerSimpleBracket
    )

import Bets.Types exposing (Answer(..), AnswerBracket, Bracket)
import Bets.Types.Bracket as Bracket
import Bets.Types.HasQualified as HasQualified
import Bets.Types.Points
import Bets.Types.Round as Round
import Bets.Types.SimpleBracket as SimpleBracket exposing (SimpleBracket, SimpleBracketEntry)
import Bets.Types.Team as Team
import Json.Decode as Decode exposing (Decoder)
import Json.Encode


type BracketContent
    = BracketSimple SimpleBracket
    | BracketNested Bracket


type alias AnswerUnifiedBracket =
    Answer BracketContent


fromAnswerSimpleBracket : Answer SimpleBracket -> AnswerUnifiedBracket
fromAnswerSimpleBracket (Answer sb points) =
    Answer (BracketSimple sb) points


fromAnswerBracket : AnswerBracket -> AnswerUnifiedBracket
fromAnswerBracket (Answer br points) =
    Answer (BracketNested br) points


encode : AnswerUnifiedBracket -> Json.Encode.Value
encode (Answer content points) =
    let
        ( bracketType, entries ) =
            case content of
                BracketSimple sb ->
                    ( "simple", Json.Encode.list encodeSimpleEntry sb )

                BracketNested bracket ->
                    ( "nested", Bracket.encodeFlatList bracket )
    in
    Json.Encode.object
        [ ( "bracketType", Json.Encode.string bracketType )
        , ( "points", Bets.Types.Points.encode points )
        , ( "entries", entries )
        ]


encodeSimpleEntry : SimpleBracketEntry -> Json.Encode.Value
encodeSimpleEntry entry =
    Json.Encode.object
        [ ( "kind", Json.Encode.string "team" )
        , ( "team", Team.encode entry.team )
        , ( "round", Round.encode entry.round )
        , ( "hasQualified", HasQualified.encode entry.hasQualified )
        ]


decode : Decoder AnswerUnifiedBracket
decode =
    Decode.field "bracketType" Decode.string
        |> Decode.andThen decodeBracketContent


decodeBracketContent : String -> Decoder AnswerUnifiedBracket
decodeBracketContent bracketType =
    case bracketType of
        "simple" ->
            Decode.map2 Answer
                (Decode.map BracketSimple SimpleBracket.decode)
                (Decode.field "points" Bets.Types.Points.decode)

        "nested" ->
            Decode.map2 Answer
                (Decode.map BracketNested Bracket.decodeUnifiedEntries)
                (Decode.field "points" Bets.Types.Points.decode)

        _ ->
            Decode.fail ("Unknown bracketType: " ++ bracketType)
