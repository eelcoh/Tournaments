module Form.View exposing (view)

import Bets.Bet
import Element exposing (padding, spacing)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font
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

        TopscorerCard { searchQuery } ->
            Element.map TopscorerMsg (Form.Topscorer.view searchQuery model.bet)

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
        viewSegment i _ =
            let
                color =
                    if i == currentIdx then
                        Color.orange

                    else if i < currentIdx then
                        Color.green

                    else
                        Color.grey

                attrs =
                    [ Element.width (Element.fillPortion 1)
                    , Element.height (Element.px 3)
                    , Background.color color
                    , Element.Events.onClick (NavigateTo i)
                    , Element.pointer
                    ]
                        ++ (if i > currentIdx then
                                [ Element.alpha 0.35 ]

                            else
                                []
                           )
            in
            Element.el attrs Element.none
    in
    Element.row
        [ Element.width Element.fill
        , Element.spacing 2
        , Element.paddingXY 0 4
        ]
        (List.indexedMap viewSegment model.cards)



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
            , Element.paddingEach { top = 0, right = 0, bottom = 64, left = 0 }
            ]
    in
    Element.column columnAttrs [ railArea, card ]
