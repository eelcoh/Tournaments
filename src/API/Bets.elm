module API.Bets exposing
    ( createBet
    , createBetFlat
    , fetchBet
    , fetchBetFlat
    , placeBet
    , placeBetFlat
    , updateBet
    , updateBetFlat
    )

import Bets.Bet
import Bets.Types exposing (Bet)
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



-- retrieveBet : String -> (WebData Bet -> msg) -> Cmd msg
-- retrieveBet uuid handlerMsg =
--     let
--         url =
--             "/bets/" ++ uuid
--     in
--         Http.get url RetrievedBet Bets.Bet.decode
