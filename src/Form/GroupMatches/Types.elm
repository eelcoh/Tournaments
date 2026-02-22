module Form.GroupMatches.Types exposing
    ( ChangeCursor(..)
    , Msg(..)
    , State
    , init
    , updateCursor
    )

import Bets.Types exposing (Group, MatchID)
import List.Extra exposing (dropWhile)


type Msg
    = UpdateHome MatchID Int
    | UpdateAway MatchID Int
    | Update MatchID Int Int
    | SelectMatch MatchID
    | ScrollUp
    | ScrollDown
    | JumpToGroup Group
    | TouchStart Float
    | TouchEnd Float
    | NoOp


type alias State =
    { cursor : MatchID
    , touchStartY : Maybe Float
    }


init : MatchID -> State
init cursor =
    { cursor = cursor
    , touchStartY = Nothing
    }


type ChangeCursor
    = Explicit MatchID
    | Implicit
    | Dont


nextMatch : MatchID -> List MatchID -> MatchID
nextMatch matchID matches =
    let
        isNotCurrentMatch mId =
            mId /= matchID

        findNext =
            dropWhile isNotCurrentMatch matches
                |> List.tail
    in
    Maybe.withDefault matchID (findNext |> Maybe.andThen List.head)


updateCursor : State -> List MatchID -> ChangeCursor -> State
updateCursor model allMatchIDs changeCursor =
    let
        newCursor =
            case changeCursor of
                Implicit ->
                    nextMatch model.cursor allMatchIDs

                Explicit newCur ->
                    newCur

                Dont ->
                    model.cursor
    in
    { model | cursor = newCursor }
