module Form.View exposing (view)

import Bets.Bet
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

        TopscorerCard { searchQuery, searchFocused } ->
            Element.map TopscorerMsg (Form.Topscorer.view searchQuery searchFocused model.bet)

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
        DashboardCard ->
            IntroSection

        IntroCard _ ->
            IntroSection

        GroupMatchesCard _ ->
            GroupSection

        BracketCard _ ->
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
                barColor =
                    if i == currentIdx then
                        Color.activeNav

                    else if i < currentIdx then
                        Color.green

                    else
                        Color.grey

                labelColor =
                    if i == currentIdx then
                        Color.activeNav

                    else if i < currentIdx then
                        Color.green

                    else
                        Color.grey

                alphaAttrs =
                    if i > currentIdx then
                        [ Element.alpha 0.35 ]

                    else
                        []

                barAttrs =
                    [ Element.width Element.fill
                    , Element.height (Element.px 2)
                    , Background.color barColor
                    , Element.Events.onClick (NavigateTo i)
                    , Element.pointer
                    ]
                        ++ alphaAttrs

                labelAttrs =
                    [ Element.width Element.fill
                    , Font.size 8
                    , Font.letterSpacing 0.12
                    , Font.center
                    , Font.color labelColor
                    , UI.Font.mono
                    , Element.Events.onClick (NavigateTo i)
                    , Element.pointer
                    , Element.paddingEach { bottom = 3, top = 0, left = 0, right = 0 }
                    ]
                        ++ alphaAttrs
            in
            Element.column
                [ Element.width (Element.fillPortion 1) ]
                [ Element.el labelAttrs (Element.text (cardLabel card))
                , Element.el barAttrs Element.none
                ]
    in
    Element.row
        [ Element.width Element.fill
        , Element.spacing 2
        , Element.paddingXY 0 4
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

        TopscorerCard _ ->
            "topscorer"

        ParticipantCard _ ->
            "gegevens"

        SubmitCard ->
            "inzenden"


incompleteIndicator : Model Msg -> Card -> String
incompleteIndicator model card =
    case card of
        GroupMatchesCard _ ->
            if allGroupsComplete model then
                ""

            else
                " [!]"

        BracketCard _ ->
            if Form.Bracket.isCompleteQualifiers model.bet then
                ""

            else
                " [!]"

        TopscorerCard _ ->
            if Form.Topscorer.isComplete model.bet then
                ""

            else
                " [!]"

        ParticipantCard _ ->
            if Form.Participant.isComplete model.bet then
                ""

            else
                " [!]"

        _ ->
            ""


viewBottomNav : Model Msg -> Int -> Element.Element Msg
viewBottomNav model currentIdx =
    let
        totalCards =
            List.length model.cards

        lastIdx =
            totalCards - 1

        currentCard =
            List.drop currentIdx model.cards
                |> List.head
                |> Maybe.withDefault DashboardCard

        disabledAttrs =
            [ Element.alpha 0.35
            , Element.htmlAttribute (Html.Attributes.style "cursor" "not-allowed")
            ]

        activeAttrs target =
            [ Element.pointer
            , Element.Events.onClick (NavigateTo target)
            , Element.mouseOver [ Font.color Color.activeNav ]
            ]

        prevButton =
            if currentIdx == 0 then
                Element.el
                    ([ Font.color Color.grey, UI.Font.mono, Font.size 12 ] ++ disabledAttrs)
                    (Element.text "< vorige")

            else
                Element.el
                    ([ Font.color Color.orange, UI.Font.mono, Font.size 12 ] ++ activeAttrs (currentIdx - 1))
                    (Element.text "< vorige")

        nextButton =
            if currentIdx == lastIdx then
                Element.el
                    ([ Font.color Color.grey, UI.Font.mono, Font.size 12, Element.alignRight ] ++ disabledAttrs)
                    (Element.text "volgende >")

            else
                Element.el
                    ([ Font.color Color.orange, UI.Font.mono, Font.size 12, Element.alignRight ] ++ activeAttrs (currentIdx + 1))
                    (Element.text "volgende >")

        centerLabel =
            Element.el
                [ Element.centerX, UI.Font.mono, Font.color Color.orange, Font.size 12 ]
                (Element.text (cardLabel currentCard ++ incompleteIndicator model currentCard))
    in
    Element.el
        [ Element.width Element.fill
        , Element.alignBottom
        , Background.color (Element.rgb255 0x2B 0x2B 0x2B)
        , Element.paddingXY 16 0
        , Element.height (Element.px 56)
        , Border.color Color.terminalBorder
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        ]
        (Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.centerY
            ]
            [ prevButton, centerLabel, nextButton ]
        )


viewCardChrome : Model Msg -> Element.Element Msg -> Int -> Element.Element Msg
viewCardChrome model card i =
    let
        railArea =
            viewProgressRail model i

        columnAttrs =
            [ padding 0
            , spacing 30
            , Element.centerX
            , Element.width
                (Element.fill
                    |> Element.maximum (Screen.maxWidth model.screen)
                )
            , Element.paddingEach { top = 0, right = 0, bottom = 72, left = 0 }
            , Element.inFront (viewBottomNav model i)
            ]
    in
    Element.column columnAttrs [ railArea, card ]
