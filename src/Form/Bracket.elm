module Form.Bracket exposing (isComplete, isCompleteQualifiers, update, view)

import Bets.Bet
import Bets.Init
import Bets.Types exposing (Answer(..), Bet, Bracket(..), Candidate(..), Group(..), HasQualified(..), Team, Winner(..))
import Bets.Types.Answer.Bracket
import Bets.Types.Bracket as B
import Bets.Types.Group as Group
import Element
import Form.Bracket.Types
    exposing
        ( BracketState(..)
        , Msg(..)
        , RoundSelections
        , SelectionRound(..)
        , State
        , addTeamToRound
        , currentActiveRound
        , removeTeamFromAll
        )
import Form.Bracket.View
import List.Extra as Extra


isComplete : Bet -> Bool
isComplete bet =
    Bets.Types.Answer.Bracket.isComplete bet.answers.bracket


isCompleteQualifiers : Bet -> Bool
isCompleteQualifiers bet =
    Bets.Types.Answer.Bracket.isCompleteQualifiers bet.answers.bracket


update : Msg -> Bet -> State -> ( Bet, State, Cmd Msg )
update msg bet state =
    let
        (BracketWizard wizardState) =
            state.bracketState
    in
    case msg of
        SelectTeam round team ->
            let
                newSelections =
                    addTeamToRound round team wizardState.selections

                newState =
                    { state | bracketState = BracketWizard { selections = newSelections } }

                newBracket =
                    rebuildBracket newSelections Bets.Init.teamData

                newBet =
                    updateBracket bet newBracket
            in
            ( newBet, newState, Cmd.none )

        DeselectTeam team ->
            let
                newSelections =
                    removeTeamFromAll team wizardState.selections

                newState =
                    { state | bracketState = BracketWizard { selections = newSelections } }

                newBracket =
                    rebuildBracket newSelections Bets.Init.teamData

                newBet =
                    updateBracket bet newBracket
            in
            ( newBet, newState, Cmd.none )

        GoNext ->
            ( bet, state, Cmd.none )


view : Bet -> State -> Element.Element Msg
view bet state =
    Form.Bracket.View.view bet state



-- Helpers


updateBracket : Bet -> Bracket -> Bet
updateBracket bet newBracket =
    let
        newAnswers answers =
            case answers.bracket of
                Answer _ points ->
                    { answers | bracket = Answer newBracket points }
    in
    { bet | answers = newAnswers bet.answers }


rebuildBracket : RoundSelections -> Bets.Types.TeamData -> Bracket
rebuildBracket selections teamData =
    let
        emptyBracket =
            Bets.Init.bet |> Bets.Bet.getBracket

        -- Filter teams from lastThirtyTwo by group (preserving insertion order)
        teamsInGroup : Group -> List Team
        teamsInGroup grp =
            List.filter
                (\t -> List.any (\td -> td.team.teamID == t.teamID && td.group == grp) teamData)
                selections.lastThirtyTwo

        groups =
            [ A, B, C, D, E, F, G, H, I, J, K, L ]

        -- First and second place slot assignments
        firstSecondAssignments : List ( String, Maybe Team )
        firstSecondAssignments =
            let
                forGroup grp =
                    let
                        teams =
                            teamsInGroup grp

                        grpStr =
                            Group.toString grp
                    in
                    [ ( "W" ++ grpStr, List.head teams )
                    , ( "R" ++ grpStr, teams |> List.drop 1 |> List.head )
                    ]
            in
            List.concatMap forGroup groups

        -- Third-place teams (3rd in each group's lastThirtyTwo selection)
        thirdPlaceTeams : List ( Group, Team )
        thirdPlaceTeams =
            let
                forGroup grp =
                    teamsInGroup grp
                        |> List.drop 2
                        |> List.head
                        |> Maybe.map (\t -> ( grp, t ))
            in
            List.filterMap forGroup groups

        -- Extract BestThird slot definitions from the initial empty bracket
        bestThirdSlotDefs : List ( String, List Group )
        bestThirdSlotDefs =
            extractBestThirdSlots emptyBracket

        -- Greedily assign third-place teams to T slots
        bestThirdAssignments : List ( String, Maybe Team )
        bestThirdAssignments =
            assignBestThirds thirdPlaceTeams bestThirdSlotDefs

        -- Step 1: fill all team slots
        bracketWithTeams =
            B.setBulk emptyBracket (firstSecondAssignments ++ bestThirdAssignments)

        -- Match slot IDs by round
        r1Slots =
            [ "m73", "m74", "m75", "m76", "m77", "m78", "m79", "m80"
            , "m81", "m82", "m83", "m84", "m85", "m86", "m87", "m88"
            ]

        r2Slots =
            [ "m89", "m90", "m91", "m92", "m93", "m94", "m95", "m96" ]

        r3Slots =
            [ "m97", "m98", "m99", "m100" ]

        r4Slots =
            [ "m101", "m102" ]

        r5Slots =
            [ "m104" ]

        championList =
            selections.champion
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        -- Steps 2-6: propagate winners through the bracket
        bracketR1 =
            setRoundWinners r1Slots selections.lastSixteen bracketWithTeams

        bracketR2 =
            setRoundWinners r2Slots selections.quarters bracketR1

        bracketR3 =
            setRoundWinners r3Slots selections.semis bracketR2

        bracketR4 =
            setRoundWinners r4Slots selections.finalists bracketR3

        bracketR5 =
            setRoundWinners r5Slots championList bracketR4
    in
    bracketR5


extractBestThirdSlots : Bracket -> List ( String, List Group )
extractBestThirdSlots bracket =
    case bracket of
        TeamNode slot (BestThirdFrom grps) _ _ ->
            [ ( slot, grps ) ]

        TeamNode _ _ _ _ ->
            []

        MatchNode _ _ home away _ _ ->
            extractBestThirdSlots home ++ extractBestThirdSlots away


assignBestThirds : List ( Group, Team ) -> List ( String, List Group ) -> List ( String, Maybe Team )
assignBestThirds thirdTeams tSlots =
    let
        go remaining available acc =
            case remaining of
                [] ->
                    List.map (\( s, _ ) -> ( s, Nothing )) available ++ acc

                ( grp, team ) :: rest ->
                    case Extra.findIndex (\( _, grps ) -> List.member grp grps) available of
                        Just idx ->
                            case Extra.getAt idx available of
                                Just ( slot, _ ) ->
                                    go rest (Extra.removeAt idx available) (( slot, Just team ) :: acc)

                                Nothing ->
                                    go rest available acc

                        Nothing ->
                            go rest available acc
    in
    go thirdTeams tSlots []


setRoundWinners : List String -> List Team -> Bracket -> Bracket
setRoundWinners slots nextRoundTeams bracket =
    let
        inNext t =
            List.any (\nt -> nt.teamID == t.teamID) nextRoundTeams

        setWinner slot br =
            case B.get br slot of
                Just (MatchNode _ _ home away _ _) ->
                    let
                        homeTeam_ =
                            B.winner home

                        awayTeam_ =
                            B.winner away
                    in
                    case ( homeTeam_, awayTeam_ ) of
                        ( Just ht, _ ) ->
                            if inNext ht then
                                B.proceed br slot HomeTeam

                            else
                                case awayTeam_ of
                                    Just at ->
                                        if inNext at then
                                            B.proceed br slot AwayTeam

                                        else
                                            br

                                    Nothing ->
                                        br

                        ( Nothing, Just at ) ->
                            if inNext at then
                                B.proceed br slot AwayTeam

                            else
                                br

                        _ ->
                            br

                _ ->
                    br
    in
    List.foldl setWinner bracket slots
