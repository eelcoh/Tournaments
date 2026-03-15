module Form.Topscorer exposing (isComplete, update, view)

import Bets.Bet exposing (getTopscorer, setTopscorer)
import Bets.Init exposing (teamData)
import Bets.Types exposing (Answer(..), Bet, Team, Topscorer)
import Bets.Types.Answer.Topscorer
import Bets.Types.Team as T
import Bets.Types.Topscorer as TS
import Element exposing (fill, paddingXY, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font
import Form.Topscorer.Types exposing (IsSelected(..), Msg(..))
import Html
import Html.Attributes
import Html.Events
import UI.Color as Color
import UI.Font
import UI.Page exposing (page)
import UI.Style
import UI.Text


update : Msg -> Bet -> ( Bet, Cmd Msg )
update msg bet =
    case msg of
        SelectPlayer player ->
            let
                newBet (Answer topscorer _) =
                    let
                        currentPlayer =
                            TS.getPlayer topscorer

                        newTopscorer =
                            if currentPlayer == Just player then
                                -- Toggle off: clear both player and team
                                ( Nothing, Nothing )

                            else
                                -- Find team for player, set both directly
                                let
                                    maybeTeam =
                                        teamData
                                            |> List.filter (\td -> List.member player td.players)
                                            |> List.head
                                            |> Maybe.map .team
                                in
                                case maybeTeam of
                                    Just t ->
                                        ( Just player, Just t )

                                    Nothing ->
                                        topscorer
                    in
                    setTopscorer bet newTopscorer
            in
            ( newBet bet.answers.topscorer, Cmd.none )

        UpdateSearch _ ->
            -- Card state (searchQuery) is updated in top-level update; bet is unchanged
            ( bet, Cmd.none )

        SearchFocused _ ->
            -- Card state (searchFocused) is updated in top-level update; bet is unchanged
            ( bet, Cmd.none )


view : String -> Bool -> Bet -> Element.Element Msg
view searchQuery searchFocused bet =
    viewTopscorer searchQuery searchFocused (getTopscorer bet)


type alias PlayerEntry =
    { name : String
    , team : Team
    , teamCode : String
    }


allPlayers : List PlayerEntry
allPlayers =
    teamData
        |> List.concatMap
            (\td ->
                List.map
                    (\p ->
                        { name = p
                        , team = td.team
                        , teamCode = T.display td.team
                        }
                    )
                    td.players
            )


matchesSearch : String -> PlayerEntry -> Bool
matchesSearch query entry =
    if String.isEmpty query then
        False

    else
        let
            q =
                String.toLower query
        in
        String.contains q (String.toLower entry.name)
            || String.contains q (String.toLower entry.teamCode)


viewTopscorer : String -> Bool -> Topscorer -> Element.Element Msg
viewTopscorer searchQuery searchFocused topscorer =
    let
        selectedPlayer =
            TS.getPlayer topscorer

        filteredPlayers =
            if String.isEmpty searchQuery then
                []

            else
                List.filter (matchesSearch searchQuery) allPlayers

        headertext =
            UI.Text.displayHeader "Wie wordt de topscorer?"
    in
    if String.isEmpty searchQuery then
        -- Default state: show selected card if any, plus search bar
        let
            selectedCard =
                case selectedPlayer of
                    Nothing ->
                        Element.none

                    Just playerName ->
                        case List.filter (\e -> e.name == playerName) allPlayers |> List.head of
                            Nothing ->
                                Element.none

                            Just entry ->
                                viewPlayerCard topscorer entry
        in
        page "topscorer"
            [ headertext
            , introduction
            , warning
            , viewSearchInput searchQuery searchFocused
            , selectedCard
            ]

    else if List.isEmpty filteredPlayers then
        page "topscorer"
            [ headertext
            , viewSearchInput searchQuery searchFocused
            , viewEmptyState searchQuery
            ]

    else
        page "topscorer"
            [ headertext
            , viewSearchInput searchQuery searchFocused
            , Element.column [ Element.spacing 0, Element.width Element.fill ]
                (List.map (viewPlayerCard topscorer) filteredPlayers)
            ]


viewPlayerCard : Topscorer -> PlayerEntry -> Element.Element Msg
viewPlayerCard topscorer entry =
    let
        selectedPlayer =
            TS.getPlayer topscorer

        isSelected =
            selectedPlayer == Just entry.name

        borderColor =
            if isSelected then
                Color.activeNav

            else
                Element.rgba 0 0 0 0

        bgColor =
            if isSelected then
                Element.rgba 0.94 0.63 0.19 0.08

            else
                Element.rgba 0 0 0 0

        marker =
            if isSelected then
                Element.el
                    [ Font.color Color.activeNav
                    , UI.Font.mono
                    , Element.alignRight
                    ]
                    (Element.text "[x]")

            else
                Element.none

        flagImg =
            Element.image
                [ Element.height (Element.px 18)
                , Element.width (Element.px 24)
                ]
                { src = T.flagUrl (Just entry.team)
                , description = entry.teamCode
                }

        textBlock =
            Element.column [ Element.spacing 2 ]
                [ Element.el [ Font.color Color.white, UI.Font.mono, Font.size 12, Font.medium ]
                    (Element.text entry.name)
                , Element.el [ Font.color Color.grey, UI.Font.mono, Font.size 10 ]
                    (Element.text entry.teamCode)
                ]
    in
    Element.el
        [ Element.Events.onClick (SelectPlayer entry.name)
        , Element.pointer
        , Element.width Element.fill
        , Element.height (Element.px 44)
        , Element.paddingXY 12 10
        , Border.width 1
        , Border.color borderColor
        , Background.color bgColor
        , Element.mouseOver [ Border.color Color.orange ]
        ]
        (Element.row [ Element.spacing 10, Element.centerY, Element.width Element.fill ]
            [ flagImg
            , textBlock
            , marker
            ]
        )


viewSearchInput : String -> Bool -> Element.Element Msg
viewSearchInput query focused =
    let
        containerBorderColor =
            if focused then
                Color.activeNav

            else
                Color.terminalBorder
    in
    Element.row
        [ Element.spacing 0
        , Element.paddingXY 8 6
        , Element.width Element.fill
        , Border.width 1
        , Border.color containerBorderColor
        ]
        [ Element.el [ Font.color Color.orange, UI.Font.mono, Element.paddingXY 4 0 ]
            (Element.text ">")
        , Element.el [ Element.width Element.fill ]
            (Element.html
                (Html.input
                    [ Html.Attributes.value query
                    , Html.Attributes.placeholder "zoek op naam of land..."
                    , Html.Events.onInput UpdateSearch
                    , Html.Events.onFocus (SearchFocused True)
                    , Html.Events.onBlur (SearchFocused False)
                    , Html.Attributes.style "background" "transparent"
                    , Html.Attributes.style "border" "none"
                    , Html.Attributes.style "color" "#dcdccc"
                    , Html.Attributes.style "font-family" "inherit"
                    , Html.Attributes.style "outline" "none"
                    , Html.Attributes.style "width" "100%"
                    , Html.Attributes.style "padding" "2px 4px"
                    ]
                    []
                )
            )
        ]


viewEmptyState : String -> Element.Element Msg
viewEmptyState query =
    Element.el [ UI.Font.mono, Font.color Color.grey, Element.paddingXY 0 8 ]
        (Element.text ("Geen spelers gevonden voor '" ++ query ++ "'"))


introduction : Element.Element Msg
introduction =
    Element.paragraph (UI.Style.introduction [])
        [ Element.text "Voorspel de topscorer. Kies eerst het land, dan de speler. 9 punten als je het goed hebt. Let op: dit zijn de voorlopige selecties." ]


warning : Element.Element Msg
warning =
    Element.paragraph (UI.Style.introduction [])
        [ Element.text "Spelers kunnen nog afvallen, of al afgevallen zijn!" ]


isComplete : Bet -> Bool
isComplete bet =
    Bets.Types.Answer.Topscorer.isComplete bet.answers.topscorer
