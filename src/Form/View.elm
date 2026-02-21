module Form.View exposing (view)

import Bets.Bet
import Bets.Types exposing (Group(..))
import Bets.Types.Group as Group
import Element exposing (padding, paddingXY, px, spacing, width)
import Form.Bracket
import Form.Bracket.Types as BracketTypes
import Form.GroupMatches
import Form.Info
import Form.Participant
import Form.Submit
import Form.Topscorer
import Types exposing (Card(..), Model, Msg(..))
import UI.Button
import UI.Screen as Screen
import UI.Style



-- View


view : Model Msg -> Element.Element Msg
view model =
    let
        getCard =
            List.drop model.idx model.cards
                |> List.head

        makeCard mCard =
            case mCard of
                Just card_ ->
                    viewCard model model.idx card_

                Nothing ->
                    Element.none

        card =
            getCard
                |> makeCard
    in
    Element.row [ Element.centerX, Screen.className "card" ]
        [ viewCardChrome model card model.idx ]


viewCard : Model Msg -> Int -> Card -> Element.Element Msg
viewCard model idx card =
    case card of
        IntroCard intro ->
            Element.map InfoMsg (Form.Info.view intro)

        GroupMatchesCard groupMatchesState ->
            Element.map (GroupMatchMsg groupMatchesState.group) (Form.GroupMatches.view model.bet groupMatchesState)

        BracketCard bracketState ->
            let
                next =
                    Basics.min (idx + 1) (List.length model.cards - 1)

                mapBracketMsg msg =
                    case msg of
                        BracketTypes.GoNext ->
                            NavigateTo next

                        other ->
                            BracketMsg other
            in
            Element.map mapBracketMsg (Form.Bracket.view model.bet bracketState)

        TopscorerCard ->
            Element.map TopscorerMsg (Form.Topscorer.view model.bet)

        ParticipantCard ->
            Element.map ParticipantMsg (Form.Participant.view model.bet)

        SubmitCard ->
            let
                submittable =
                    Bets.Bet.isComplete model.bet
            in
            Form.Submit.view model submittable


type Section
    = IntroSection
    | GroupSection
    | BracketSection
    | TopscorerSection
    | SubmitSection


sectionOf : Card -> Section
sectionOf card =
    case card of
        IntroCard _ ->
            IntroSection

        GroupMatchesCard _ ->
            GroupSection

        BracketCard _ ->
            BracketSection

        TopscorerCard ->
            TopscorerSection

        ParticipantCard ->
            SubmitSection

        SubmitCard ->
            SubmitSection


findCardIndex : (Card -> Bool) -> Model Msg -> Maybe Int
findCardIndex pred model =
    List.indexedMap Tuple.pair model.cards
        |> List.filter (Tuple.second >> pred)
        |> List.head
        |> Maybe.map Tuple.first


allGroupsComplete : Model Msg -> Bool
allGroupsComplete model =
    model.cards
        |> List.filterMap
            (\card ->
                case card of
                    GroupMatchesCard state ->
                        Just state.group

                    _ ->
                        Nothing
            )
        |> List.all (\grp -> Form.GroupMatches.isComplete grp model.bet)


groupSectionTargetIndex : Model Msg -> Int
groupSectionTargetIndex model =
    let
        groupCardsWithIndex =
            List.indexedMap Tuple.pair model.cards
                |> List.filter
                    (\( _, c ) ->
                        case c of
                            GroupMatchesCard _ ->
                                True

                            _ ->
                                False
                    )

        firstIncomplete =
            groupCardsWithIndex
                |> List.filter
                    (\( _, c ) ->
                        case c of
                            GroupMatchesCard state ->
                                not (Form.GroupMatches.isComplete state.group model.bet)

                            _ ->
                                False
                    )
                |> List.head
                |> Maybe.map Tuple.first
    in
    firstIncomplete
        |> Maybe.withDefault
            (groupCardsWithIndex
                |> List.head
                |> Maybe.map Tuple.first
                |> Maybe.withDefault 1
            )


viewTopPills : Model Msg -> Int -> Element.Element Msg
viewTopPills model currentIdx =
    let
        currentSection =
            List.drop currentIdx model.cards
                |> List.head
                |> Maybe.map sectionOf
                |> Maybe.withDefault IntroSection

        mkSemantics section complete =
            if section == currentSection then
                UI.Style.PillB

            else if complete then
                UI.Style.PillA

            else
                UI.Style.Pill

        bracketIdx =
            findCardIndex (\c -> case c of
                BracketCard _ -> True
                _ -> False) model
                |> Maybe.withDefault 13

        topscorerIdx =
            findCardIndex (\c -> case c of
                TopscorerCard -> True
                _ -> False) model
                |> Maybe.withDefault 14

        participantIdx =
            findCardIndex (\c -> case c of
                ParticipantCard -> True
                _ -> False) model
                |> Maybe.withDefault 15

        submitIdx =
            findCardIndex (\c -> case c of
                SubmitCard -> True
                _ -> False) model
                |> Maybe.withDefault 16

        submitTarget =
            if Form.Participant.isComplete model.bet then
                submitIdx

            else
                participantIdx
    in
    Element.row [ Element.spacing 8, Element.centerX ]
        [ UI.Button.pill (mkSemantics IntroSection True) (NavigateTo 0) "intro"
        , UI.Button.pill (mkSemantics GroupSection (allGroupsComplete model)) (NavigateTo (groupSectionTargetIndex model)) "groepen"
        , UI.Button.pill (mkSemantics BracketSection (Form.Bracket.isCompleteQualifiers model.bet)) (NavigateTo bracketIdx) "schema"
        , UI.Button.pill (mkSemantics TopscorerSection (Form.Topscorer.isComplete model.bet)) (NavigateTo topscorerIdx) "topscorer"
        , UI.Button.pill (mkSemantics SubmitSection False) (NavigateTo submitTarget) "inzenden"
        ]


viewGroupSubPills : Model Msg -> Int -> Element.Element Msg
viewGroupSubPills model currentIdx =
    let
        groupCardsWithIndex =
            List.indexedMap Tuple.pair model.cards
                |> List.filter
                    (\( _, c ) ->
                        case c of
                            GroupMatchesCard _ ->
                                True

                            _ ->
                                False
                    )

        isInGroupSection =
            List.any (\( idx, _ ) -> idx == currentIdx) groupCardsWithIndex

        viewSubPill ( cardIdx, card ) =
            case card of
                GroupMatchesCard state ->
                    let
                        semantics =
                            if cardIdx == currentIdx then
                                UI.Style.PillB

                            else if Form.GroupMatches.isComplete state.group model.bet then
                                UI.Style.PillA

                            else
                                UI.Style.Pill
                    in
                    UI.Button.pill semantics (NavigateTo cardIdx) (Group.toString state.group)

                _ ->
                    Element.none
    in
    if isInGroupSection then
        Element.wrappedRow [ Element.spacing 4, Element.centerX ]
            (List.map viewSubPill groupCardsWithIndex)

    else
        Element.none


viewCardChrome : Model Msg -> Element.Element Msg -> Int -> Element.Element Msg
viewCardChrome model card i =
    let
        next =
            Basics.min (i + 1) (List.length model.cards - 1)

        prev =
            Basics.max (i - 1) 0

        prevPill =
            UI.Button.pill UI.Style.Focus (NavigateTo prev) "vorige"

        nextPill =
            UI.Button.pill UI.Style.Focus (NavigateTo next) "volgende"

        nav =
            Element.row [ Element.spacing 20, Element.centerX ] [ prevPill, nextPill ]

        topPills =
            viewTopPills model i

        subPills =
            viewGroupSubPills model i

        pillsArea =
            Element.column [ Element.spacing 4, Element.centerX ]
                [ topPills, subPills ]

        isGroupCard =
            List.drop i model.cards
                |> List.head
                |> Maybe.map
                    (\c ->
                        case c of
                            GroupMatchesCard _ ->
                                True

                            _ ->
                                False
                    )
                |> Maybe.withDefault False

        groupNav =
            Element.row [ Element.spacing 20, Element.centerX ]
                [ UI.Button.pillSmall UI.Style.Focus (NavigateTo prev) "vorige groep"
                , UI.Button.pillSmall UI.Style.Focus (NavigateTo next) "volgende groep"
                ]

        columnAttrs =
            [ padding 0
            , spacing 30
            , Element.centerX
            , Element.width
                (Element.fill
                    |> Element.maximum (Screen.maxWidth model.screen)
                )
            ]
    in
    if isGroupCard then
        Element.column columnAttrs [ pillsArea, card, groupNav ]

    else
        Element.column columnAttrs [ pillsArea, nav, card ]
