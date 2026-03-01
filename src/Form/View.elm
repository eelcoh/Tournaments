module Form.View exposing (view)

import Bets.Bet
import Element exposing (padding, spacing)
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
import UI.Color as Color
import UI.Font
import UI.Screen as Screen



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
            Element.map GroupMatchMsg (Form.GroupMatches.view model.bet groupMatchesState)

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
    Form.GroupMatches.isComplete model.bet


groupSectionTargetIndex : Model Msg -> Int
groupSectionTargetIndex model =
    findCardIndex
        (\c ->
            case c of
                GroupMatchesCard _ ->
                    True

                _ ->
                    False
        )
        model
        |> Maybe.withDefault 1


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
                |> Maybe.withDefault 2

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
                |> Maybe.withDefault 3

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
                |> Maybe.withDefault 4

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
                |> Maybe.withDefault 5

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
                , Element.height (Element.px 44)
                , Element.centerY
                ]
                (Element.el
                    [ Font.color Color.orange
                    , UI.Font.mono
                    , Element.centerY
                    ]
                    (Element.text (ind ++ " " ++ label))
                )
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



viewCardChrome : Model Msg -> Element.Element Msg -> Int -> Element.Element Msg
viewCardChrome model card i =
    let
        checkboxArea =
            Element.column [ Element.spacing 4, Element.width Element.fill ]
                [ viewTopCheckboxes model i
                ]

        columnAttrs =
            [ padding 0
            , spacing 30
            , Element.centerX
            , Element.width
                (Element.fill
                    |> Element.maximum (Screen.maxWidth model.screen)
                )
            , Element.paddingEach { top = 0, right = 0, bottom = 64, left = 0 }
            ]
    in
    Element.column columnAttrs [ checkboxArea, card ]
