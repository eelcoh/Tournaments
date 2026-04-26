module API.Bets exposing
    ( createBet
    , createBetFlat
    , createBetSimple
    , createBetUnified
    , fetchBet
    , fetchBetFlat
    , fetchBetSimple
    , fetchBetUnified
    , placeBet
    , placeBetFlat
    , placeBetSimple
    , placeBetUnified
    , updateBet
    , updateBetFlat
    , updateBetSimple
    , updateBetUnified
    )

import Bets.Bet
import Bets.SimpleBet exposing (SimpleBet)
import Bets.Types exposing (Bet)
import Bets.UnifiedBet
import RemoteData exposing (RemoteData(..))
import RemoteData.Http as Http
import Types exposing (Msg(..), UUID)


placeBet : Bet -> Cmd Msg
placeBet bet =
    case bet.uuid of
        Just uuid ->
            updateBet bet uuid

        Nothing ->
            createBet bet


fetchBet : UUID -> Cmd Msg
fetchBet uuid =
    Http.get ("/bets/" ++ uuid) FetchedBet Bets.Bet.decode


createBet : Bet -> Cmd Msg
createBet bet =
    Http.post "/bets/" SubmittedBet Bets.Bet.decode (Bets.Bet.encode bet)


updateBet : Bet -> String -> Cmd Msg
updateBet bet uuid =
    Http.put ("/bets/" ++ uuid) SubmittedBet Bets.Bet.decode (Bets.Bet.encode bet)


placeBetFlat : Bet -> Cmd Msg
placeBetFlat bet =
    case bet.uuid of
        Just uuid ->
            updateBetFlat bet uuid

        Nothing ->
            createBetFlat bet


fetchBetFlat : UUID -> Cmd Msg
fetchBetFlat uuid =
    Http.get ("/bets/flat/" ++ uuid) FetchedBet Bets.Bet.decodeFlat


createBetFlat : Bet -> Cmd Msg
createBetFlat bet =
    Http.post "/bets/flat/" SubmittedBet Bets.Bet.decodeFlat (Bets.Bet.encodeFlat bet)


updateBetFlat : Bet -> String -> Cmd Msg
updateBetFlat bet uuid =
    Http.put ("/bets/flat/" ++ uuid) SubmittedBet Bets.Bet.decodeFlat (Bets.Bet.encodeFlat bet)



placeBetSimple : SimpleBet -> Cmd Msg
placeBetSimple bet =
    case bet.uuid of
        Just uuid ->
            updateBetSimple bet uuid

        Nothing ->
            createBetSimple bet


fetchBetSimple : UUID -> Cmd Msg
fetchBetSimple uuid =
    Http.get ("/bets/simple/" ++ uuid) FetchedSimpleBet Bets.SimpleBet.decode


createBetSimple : SimpleBet -> Cmd Msg
createBetSimple bet =
    Http.post "/bets/simple/" SubmittedSimpleBet Bets.SimpleBet.decode (Bets.SimpleBet.encode bet)


updateBetSimple : SimpleBet -> String -> Cmd Msg
updateBetSimple bet uuid =
    Http.put ("/bets/simple/" ++ uuid) SubmittedSimpleBet Bets.SimpleBet.decode (Bets.SimpleBet.encode bet)



placeBetUnified : SimpleBet -> Cmd Msg
placeBetUnified bet =
    case bet.uuid of
        Just uuid ->
            updateBetUnified bet uuid

        Nothing ->
            createBetUnified bet


fetchBetUnified : UUID -> Cmd Msg
fetchBetUnified uuid =
    Http.get ("/bets/" ++ uuid) FetchedSimpleBet Bets.UnifiedBet.decode


createBetUnified : SimpleBet -> Cmd Msg
createBetUnified bet =
    Http.post "/bets/" SubmittedSimpleBet Bets.UnifiedBet.decode (Bets.UnifiedBet.encode bet)


updateBetUnified : SimpleBet -> String -> Cmd Msg
updateBetUnified bet uuid =
    Http.put ("/bets/" ++ uuid) SubmittedSimpleBet Bets.UnifiedBet.decode (Bets.UnifiedBet.encode bet)
