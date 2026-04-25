module Form.SimpleBracket exposing (isComplete, update, view)

import Bets.SimpleBet as SimpleBet exposing (SimpleBet)
import Bets.Types exposing (HasQualified(..), Round(..), Team)
import Bets.Types.Answer.SimpleBracket as SBracket
import Bets.Types.SimpleBracket exposing (SimpleBracket, SimpleBracketEntry)
import Element
import Form.SimpleBracket.Types exposing (Msg(..), State, nextRound, prevRound)
import Form.SimpleBracket.View


isComplete : SimpleBet -> Bool
isComplete bet =
    SBracket.isComplete bet.answers.bracket


update : Msg -> SimpleBet -> State -> ( SimpleBet, State, Cmd Msg )
update msg bet state =
    case msg of
        SelectTeam round team ->
            let
                currentBracket =
                    SimpleBet.getSimpleBracket bet

                newBracket =
                    addEntry round team currentBracket

                newBet =
                    SimpleBet.updateSimpleBracket bet newBracket
            in
            ( newBet, state, Cmd.none )

        DeselectTeam round team ->
            let
                currentBracket =
                    SimpleBet.getSimpleBracket bet

                newBracket =
                    removeEntryAndAbove round team currentBracket

                newBet =
                    SimpleBet.updateSimpleBracket bet newBracket
            in
            ( newBet, state, Cmd.none )

        GoNext ->
            ( bet, { state | currentRound = nextRound state.currentRound }, Cmd.none )

        GoPrev ->
            ( bet, { state | currentRound = prevRound state.currentRound }, Cmd.none )

        JumpToRound round ->
            ( bet, { state | currentRound = round }, Cmd.none )


view : SimpleBet -> State -> Element.Element Msg
view bet state =
    Form.SimpleBracket.View.view bet state



-- Helpers


roundInt : Round -> Int
roundInt round =
    case round of
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


addEntry : Round -> Team -> SimpleBracket -> SimpleBracket
addEntry round team bracket =
    if List.any (\e -> e.team.teamID == team.teamID && e.round == round) bracket then
        bracket

    else
        bracket ++ [ { team = team, round = round, hasQualified = TBD } ]


removeEntryAndAbove : Round -> Team -> SimpleBracket -> SimpleBracket
removeEntryAndAbove round team bracket =
    List.filter
        (\e ->
            not (e.team.teamID == team.teamID && roundInt e.round >= roundInt round)
        )
        bracket
