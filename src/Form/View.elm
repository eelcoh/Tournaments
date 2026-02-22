module Form.View exposing (view)

import Bets.Bet
import Bets.Types exposing (Group(..))
import Bets.Types.Group as Group
import Element exposing (padding, paddingXY, px, spacing, width)
import Element.Events
import Element.Font as Font
import Form.Bracket
import Form.Bracket.Types as BracketTypes
import Form.GroupMatches
import Form.Info
import Form.Participant
import Form.Submit
import Form.Topscorer
import Types exposing (Card(..), Model, Msg(..))
import UI.Button
import UI.Color as Color
import UI.Font
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

        ParticipantCard state ->
            Element.map ParticipantMsg (Form.Participant.view state model.bet)

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

        ParticipantCard _ ->
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


viewTopCheckboxes : Model Msg -> Int -> Element.Element Msg
viewTopCheckboxes model currentIdx =
    let
        currentSection =
            List.drop currentIdx model.cards
                |> List.head
                |> Maybe.map sectionOf
                |> Maybe.withDefault IntroSection

        indicator section complete =
            if section == currentSection then
                "[.]"

            else if complete then
                "[x]"

            else
                "[ ]"

        bracketIdx =
            findCardIndex
                (\c ->
                    case c of
                        BracketCard _ ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 13

        topscorerIdx =
            findCardIndex
                (\c ->
                    case c of
                        TopscorerCard ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 14

        participantIdx =
            findCardIndex
                (\c ->
                    case c of
                        ParticipantCard _ ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 15

        submitIdx =
            findCardIndex
                (\c ->
                    case c of
                        SubmitCard ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 16

        submitTarget =
            if Form.Participant.isComplete model.bet then
                submitIdx

            else
                participantIdx

        stepNum =
            currentIdx + 1

        totalSteps =
            List.length model.cards

        stepCounter =
            "stap " ++ String.fromInt stepNum ++ "/" ++ String.fromInt totalSteps

        clickableCheck ind msg label =
            Element.el
                [ Element.Events.onClick msg
                , Element.pointer
                , Font.color Color.orange
                , UI.Font.mono
                ]
                (Element.text (ind ++ " " ++ label))
    in
    Element.row [ Element.width Element.fill, Element.paddingXY 0 4 ]
        [ Element.wrappedRow [ Element.spacing 16 ]
            [ clickableCheck (indicator IntroSection True) (NavigateTo 0) "intro"
            , clickableCheck (indicator GroupSection (allGroupsComplete model)) (NavigateTo (groupSectionTargetIndex model)) "groepen"
            , clickableCheck (indicator BracketSection (Form.Bracket.isCompleteQualifiers model.bet)) (NavigateTo bracketIdx) "schema"
            , clickableCheck (indicator TopscorerSection (Form.Topscorer.isComplete model.bet)) (NavigateTo topscorerIdx) "topscorer"
            , clickableCheck (indicator SubmitSection False) (NavigateTo submitTarget) "inzenden"
            ]
        , Element.el [ Element.alignRight, Font.color Color.grey, UI.Font.mono ]
            (Element.text stepCounter)
        ]


viewGroupSubIndicators : Model Msg -> Int -> Element.Element Msg
viewGroupSubIndicators model currentIdx =
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

        viewGroupLetter ( cardIdx, card ) =
            case card of
                GroupMatchesCard state ->
                    let
                        isActive =
                            cardIdx == currentIdx

                        isComplete =
                            Form.GroupMatches.isComplete state.group model.bet

                        label =
                            if isActive then
                                Group.toString state.group ++ "*"

                            else
                                Group.toString state.group

                        clr =
                            if isActive then
                                Color.orange

                            else if isComplete then
                                Color.green

                            else
                                Color.grey
                    in
                    Element.el
                        [ Element.Events.onClick (NavigateTo cardIdx)
                        , Element.pointer
                        , Font.color clr
                        , UI.Font.mono
                        ]
                        (Element.text label)

                _ ->
                    Element.none
    in
    if isInGroupSection then
        Element.wrappedRow [ Element.spacing 8 ]
            (List.map viewGroupLetter groupCardsWithIndex)

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
            UI.Button.pill UI.Style.Focus (NavigateTo prev) "< vorige"

        nextPill =
            UI.Button.pill UI.Style.Focus (NavigateTo next) "volgende >"

        nav =
            Element.row [ Element.spacing 20, Element.centerX ] [ prevPill, nextPill ]

        checkboxArea =
            Element.column [ Element.spacing 4, Element.width Element.fill ]
                [ viewTopCheckboxes model i
                , viewGroupSubIndicators model i
                ]

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
                [ UI.Button.pillSmall UI.Style.Focus (NavigateTo prev) "< groep"
                , UI.Button.pillSmall UI.Style.Focus (NavigateTo next) "groep >"
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
        Element.column columnAttrs [ checkboxArea, card, groupNav ]

    else
        Element.column columnAttrs [ checkboxArea, nav, card ]
