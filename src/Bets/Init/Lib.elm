module Bets.Init.Lib exposing (answerBracket, answerGroupMatch, answerTopscorer, groupFirstMatches, groupsAndFirstMatch)

import Bets.Types exposing (Answer(..), AnswerGroupMatches, Bracket, DrawID, Group, GroupMatch(..), Match, MatchID, Points, Topscorer)
import Bets.Types.Answer.GroupMatch
import List.Extra exposing (span)
import Tuple exposing (pair)


answer : a -> Points -> Answer a
answer val points =
    Answer val points


answerBracket : Bracket -> Answer Bracket
answerBracket bracket =
    answer bracket Nothing


answerTopscorer : Answer Topscorer
answerTopscorer =
    answer ( Nothing, Nothing ) Nothing


answerGroupMatch : DrawID -> Group -> Match -> ( DrawID, Answer GroupMatch )
answerGroupMatch drawID group match =
    let
        points =
            Nothing

        score =
            Nothing

        m =
            GroupMatch group match score

        question =
            answer m points
    in
    pair drawID question



-- Some functions to help construct a list of (Group, MatchID),
-- used in the toplevel Types.elm to construct a list of Cards.
--
--
-- (a -> b) -> List a -> List (b, (List a))
-- (a -> b) -> [a] -> [(b, [a])]
-- groupOnKey _ []     = []
-- groupOnKey f (x:xs) = (fx, x:yes) : groupOnKey f no
--     where
--         fx = f x
--         (yes, no) = span (\y -> fx == f y) xs
-- groupOnKey :: Eq k => (a -> k) -> [a] -> [(k, [a])]


groupOnKey : (a -> k) -> List a -> List ( k, List a )
groupOnKey f l =
    case l of
        [] ->
            []

        x :: xs ->
            let
                fx =
                    f x

                ( yes, no ) =
                    span (\y -> fx == f y) xs
            in
            ( fx, yes ) :: groupOnKey f no


groupFirstMatches : List Group -> AnswerGroupMatches -> List ( Group, MatchID )
groupFirstMatches grps answerGroupMatches =
    let
        f answerGM =
            Bets.Types.Answer.GroupMatch.getGroup answerGM
    in
    case answerGroupMatches of
        ( mID, answerGM ) :: xs ->
            let
                g =
                    f answerGM
            in
            if List.member g grps then
                groupFirstMatches grps xs

            else
                ( g, mID ) :: groupFirstMatches (g :: grps) xs

        [] ->
            []


answerGroupMatchesByGroup : AnswerGroupMatches -> List ( Group, AnswerGroupMatches )
answerGroupMatchesByGroup answerGroupMatches =
    let
        f ( mID, answerGM ) =
            Bets.Types.Answer.GroupMatch.getGroup answerGM
    in
    groupOnKey f answerGroupMatches


groupsAndFirstMatch : AnswerGroupMatches -> List ( Group, Bets.Types.MatchID )
groupsAndFirstMatch answerGroupMatches =
    let
        toMaybeTuple ( g, maybeMatchId ) =
            Maybe.map (\m -> ( g, m )) maybeMatchId
    in
    answerGroupMatchesByGroup answerGroupMatches
        |> Debug.log "in flight"
        |> List.map (\( g, l ) -> ( g, List.head l ))
        |> List.map (\( g, m ) -> ( g, Maybe.map Tuple.first m ))
        |> List.filterMap toMaybeTuple
