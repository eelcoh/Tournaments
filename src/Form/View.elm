module Form.View exposing (cardLabel, view)

import Bets.SimpleBet
import Bets.Types exposing (Round(..))
import Element exposing (padding, spacing)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font
import Html.Attributes
import Form.Bracket
import Form.Bracket.Types as BracketTypes
import Form.Dashboard
import Form.GroupMatches
import Form.Info
import Form.Participant
import Form.SimpleBracket
import Form.SimpleBracket.Types as SimpleBracketTypes
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
    Element.row [ Element.width Element.fill, Screen.className "card" ]
        [ viewCardChrome model card model.idx ]


viewCard : Model Msg -> Int -> Card -> Element.Element Msg
viewCard model idx card =
    case card of
        DashboardCard ->
            Form.Dashboard.view model

        IntroCard intro ->
            Element.map InfoMsg (Form.Info.view intro)

        GroupMatchesCard groupMatchesState ->
            Element.map GroupMatchMsg (Form.GroupMatches.view model.screen model.bet groupMatchesState)

        BracketCard _ ->
            Element.none

        SimpleBracketCard simpleBracketState ->
            let
                next =
                    Basics.min (idx + 1) (List.length model.cards - 1)

                prev =
                    Basics.max (idx - 1) 0

                mapSimpleBracketMsg msg =
                    case msg of
                        SimpleBracketTypes.GoNext ->
                            if simpleBracketState.currentRound == R6 then
                                NavigateTo next

                            else
                                SimpleBracketMsg SimpleBracketTypes.GoNext

                        SimpleBracketTypes.GoPrev ->
                            if simpleBracketState.currentRound == R1 then
                                NavigateTo prev

                            else
                                SimpleBracketMsg SimpleBracketTypes.GoPrev

                        other ->
                            SimpleBracketMsg other
            in
            Element.map mapSimpleBracketMsg (Form.SimpleBracket.view model.bet simpleBracketState)

        TopscorerCard { searchQuery, searchFocused } ->
            Element.map TopscorerMsg (Form.Topscorer.view searchQuery searchFocused model.bet)

        ParticipantCard state ->
            Element.map ParticipantMsg (Form.Participant.view state model.bet)

        SubmitCard ->
            let
                submittable =
                    Bets.SimpleBet.isComplete model.bet
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
        DashboardCard ->
            IntroSection

        IntroCard _ ->
            IntroSection

        GroupMatchesCard _ ->
            GroupSection

        BracketCard _ ->
            BracketSection

        SimpleBracketCard _ ->
            BracketSection

        TopscorerCard _ ->
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


viewProgressRail : Model Msg -> Int -> Element.Element Msg
viewProgressRail model currentIdx =
    let
        viewSegment i card =
            let
                isCurrent =
                    i == currentIdx

                isPast =
                    i < currentIdx

                barColor =
                    if isCurrent then
                        Color.activeNav

                    else if isPast then
                        Color.green

                    else
                        Color.futureStep

                labelColor =
                    if isCurrent then
                        Color.activeNav

                    else if isPast then
                        Color.green

                    else
                        Color.dimText

                barHeight =
                    if isCurrent then
                        4

                    else if isPast then
                        3

                    else
                        3

                glowAttr =
                    if isCurrent then
                        [ Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 0 8px rgba(240,160,48,0.5), 0 0 2px rgba(240,160,48,0.3)") ]

                    else
                        []

                labelWeight =
                    if isCurrent then
                        Font.bold

                    else
                        Font.regular

                barAttrs =
                    [ Element.width Element.fill
                    , Element.height (Element.px barHeight)
                    , Background.color barColor
                    , Border.rounded 2
                    , Element.Events.onClick (NavigateTo i)
                    , Element.pointer
                    ]
                        ++ glowAttr

                labelAttrs =
                    [ Element.width Element.fill
                    , Font.size UI.Font.captionSize
                    , Font.letterSpacing 0.12
                    , Font.center
                    , Font.color labelColor
                    , UI.Font.mono
                    , labelWeight
                    , Element.Events.onClick (NavigateTo i)
                    , Element.pointer
                    , Element.paddingEach { bottom = 4, top = 0, left = 0, right = 0 }
                    ]
            in
            Element.column
                [ Element.width (Element.fillPortion 1) ]
                [ Element.el labelAttrs (Element.text (cardLabel card))
                , Element.el barAttrs Element.none
                ]
    in
    Element.row
        [ Element.width Element.fill
        , Element.spacing 3
        , Element.paddingXY 0 6
        ]
        (List.indexedMap viewSegment model.cards)



cardLabel : Card -> String
cardLabel card =
    case card of
        DashboardCard ->
            "overzicht"

        IntroCard _ ->
            "intro"

        GroupMatchesCard _ ->
            "groepen"

        BracketCard _ ->
            "schema"

        SimpleBracketCard _ ->
            "schema"

        TopscorerCard _ ->
            "topscorer"

        ParticipantCard _ ->
            "gegevens"

        SubmitCard ->
            "inzenden"




viewCardChrome : Model Msg -> Element.Element Msg -> Int -> Element.Element Msg
viewCardChrome model card i =
    let
        railArea =
            viewProgressRail model i

        columnAttrs =
            [ padding 0
            , spacing 30
            , Element.width Element.fill
            , Element.paddingEach { top = 0, right = 0, bottom = 72, left = 0 }
            ]
    in
    Element.column columnAttrs [ railArea, card ]
