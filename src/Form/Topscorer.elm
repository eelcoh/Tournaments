module Form.Topscorer exposing (isComplete, update, view)

import Bets.Bet exposing (getTopscorer, setTopscorer)
import Bets.Init exposing (teamData)
import Bets.Types exposing (Answer(..), Bet, Team, TeamDatum, Topscorer)
import Bets.Types.Answer.Topscorer
import Bets.Types.Team as T
import Bets.Types.Topscorer as TS
import Element exposing (centerX, fill, paddingXY, spacing, width)
import Element.Events
import Element.Font as Font
import Form.Topscorer.Types exposing (IsSelected(..), Msg(..))
import Html
import Html.Attributes
import Html.Events
import List.Extra
import UI.Color as Color
import UI.Font
import UI.Page exposing (page)
import UI.Style
import UI.Text


update : Msg -> Bet -> ( Bet, Cmd Msg )
update msg bet =
    case msg of
        SelectTeam team ->
            let
                newBet (Answer topscorer _) =
                    let
                        newTopscorer =
                            TS.setTeam topscorer team
                    in
                    setTopscorer bet newTopscorer
            in
            ( newBet bet.answers.topscorer, Cmd.none )

        SelectPlayer player ->
            let
                newBet (Answer topscorer _) =
                    let
                        newTopscorer =
                            TS.setPlayer topscorer player
                    in
                    setTopscorer bet newTopscorer
            in
            ( newBet bet.answers.topscorer, Cmd.none )

        UpdateSearch _ ->
            -- Card state (searchQuery) is updated in top-level update; bet is unchanged
            ( bet, Cmd.none )


view : String -> Bet -> Element.Element Msg
view searchQuery bet =
    viewTopscorer searchQuery (getTopscorer bet)


viewTopscorer : String -> Topscorer -> Element.Element Msg
viewTopscorer searchQuery topscorer =
    let
        groupWhile : (a -> a -> Bool) -> List a -> List (List a)
        groupWhile eq xs_ =
            case xs_ of
                [] ->
                    []

                x :: xs ->
                    let
                        ( ys, zs ) =
                            List.Extra.span (eq x) xs
                    in
                    (x :: ys) :: groupWhile eq zs

        groups : List (List ( TeamDatum, IsSelected ))
        groups =
            teamData
                |> List.map isSelected
                |> groupWhile (\x y -> .group (Tuple.first x) == .group (Tuple.first y))

        isSelected : TeamDatum -> ( TeamDatum, IsSelected )
        isSelected t =
            case TS.getTeam topscorer of
                Nothing ->
                    ( t, NotSelected )

                Just team ->
                    if .team t == team then
                        ( t, Selected )

                    else
                        ( t, NotSelected )

        forGroup teams =
            Element.column [ spacing 4, Element.width Element.fill ]
                (List.map (viewTeamRow SelectTeam) teams)

        headertext =
            UI.Text.displayHeader "Wie wordt de topscorer?"

        matchesSearch : TeamDatum -> Bool
        matchesSearch td =
            let
                q =
                    String.toLower searchQuery

                code =
                    String.toLower (T.display td.team)

                name =
                    String.toLower (T.displayFull td.team)
            in
            String.startsWith q code || String.startsWith q name

        filteredTeams : List ( TeamDatum, IsSelected )
        filteredTeams =
            teamData
                |> List.filter matchesSearch
                |> List.map isSelected
    in
    if String.isEmpty searchQuery then
        page "topscorer"
            ([ headertext
             , introduction
             , warning
             , viewSearchInput searchQuery
             , UI.Text.displayHeader "Kies een land"
             , viewSelectedTopscorer topscorer
             , viewPlayers topscorer
             ]
                ++ List.map forGroup groups
            )

    else if List.isEmpty filteredTeams then
        page "topscorer"
            [ headertext
            , viewSearchInput searchQuery
            , viewEmptyState searchQuery
            ]

    else
        page "topscorer"
            [ headertext
            , viewSearchInput searchQuery
            , viewSelectedTopscorer topscorer
            , Element.column [ spacing 4, Element.width Element.fill ]
                (List.map (viewTeamRow SelectTeam) filteredTeams)
            ]


viewSearchInput : String -> Element.Element Msg
viewSearchInput query =
    Element.row [ spacing 4, paddingXY 0 8, width fill ]
        [ Element.el [ Font.color Color.orange, UI.Font.mono ] (Element.text "> zoeken:")
        , Element.el [ width fill ]
            (Element.html
                (Html.input
                    [ Html.Attributes.value query
                    , Html.Events.onInput UpdateSearch
                    , Html.Attributes.style "background" "transparent"
                    , Html.Attributes.style "border" "none"
                    , Html.Attributes.style "border-bottom" "1px solid #6e6e6e"
                    , Html.Attributes.style "color" "#dcdccc"
                    , Html.Attributes.style "font-family" "inherit"
                    , Html.Attributes.style "outline" "none"
                    , Html.Attributes.style "width" "100%"
                    , Html.Attributes.style "padding" "2px 0"
                    ]
                    []
                )
            )
        ]


viewEmptyState : String -> Element.Element Msg
viewEmptyState query =
    Element.el [ UI.Font.mono, Font.color Color.grey, paddingXY 0 8 ]
        (Element.text ("geen landen gevonden voor \"" ++ query ++ "\""))


introduction : Element.Element Msg
introduction =
    Element.paragraph (UI.Style.introduction [])
        [ UI.Text.simpleText """
    Voorspel de topscorer. Kies eerst het land, dan de speler. 9 punten als je het goed hebt.
    Let op: dit zijn de voorlopige selecties.
  """ ]


warning : Element.Element Msg
warning =
    Element.paragraph (UI.Style.introduction [])
        [ UI.Text.boldText "Spelers kunnen nog afvallen, of al afgevallen zijn!"
        ]


viewSelectedTopscorer : Topscorer -> Element.Element Msg
viewSelectedTopscorer topscorer =
    case TS.getTeam topscorer of
        Nothing ->
            Element.none

        Just team ->
            let
                playerStr =
                    case TS.getPlayer topscorer of
                        Nothing ->
                            ""

                        Just p ->
                            " / " ++ p
            in
            Element.el
                [ Font.color Color.orange, UI.Font.mono, Element.paddingXY 0 8 ]
                (Element.text ("> " ++ T.display team ++ " (" ++ T.displayFull team ++ ")" ++ playerStr))


viewTeamRow : (Team -> Msg) -> ( TeamDatum, IsSelected ) -> Element.Element Msg
viewTeamRow act ( teamDatum, sel ) =
    let
        team =
            .team teamDatum

        prefix =
            case sel of
                Selected ->
                    "> "

                NotSelected ->
                    "  "

        textColor =
            case sel of
                Selected ->
                    Color.orange

                NotSelected ->
                    Color.primaryText

        flagImg =
            Element.image
                [ Element.height (Element.px 16)
                , Element.width (Element.px 16)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }
    in
    Element.el
        [ Element.Events.onClick (act team)
        , Element.pointer
        , Element.width Element.fill
        , Element.height (Element.px 44)
        ]
        (Element.row [ spacing 4, Element.centerY ]
            [ Element.el [ Font.color Color.orange, UI.Font.mono ] (Element.text prefix)
            , flagImg
            , Element.el [ Font.color textColor, UI.Font.mono ] (Element.text (T.display team))
            ]
        )


viewPlayerRow : (String -> Msg) -> ( String, IsSelected ) -> Element.Element Msg
viewPlayerRow act ( player, sel ) =
    let
        prefix =
            case sel of
                Selected ->
                    "> "

                NotSelected ->
                    "  "

        textColor =
            case sel of
                Selected ->
                    Color.orange

                NotSelected ->
                    Color.primaryText
    in
    Element.el
        [ Element.Events.onClick (act player)
        , Element.pointer
        , Element.width Element.fill
        , Element.height (Element.px 44)
        ]
        (Element.row [ spacing 4, Element.centerY ]
            [ Element.el [ Font.color Color.orange, UI.Font.mono ] (Element.text prefix)
            , Element.el [ Font.color textColor, UI.Font.mono ] (Element.text player)
            ]
        )


viewPlayers : Topscorer -> Element.Element Msg
viewPlayers topscorer =
    let
        isSelectedTeam teamDatum =
            case TS.getTeam topscorer of
                Just t ->
                    t == .team teamDatum

                Nothing ->
                    False

        selectedTeam =
            List.filter isSelectedTeam teamData
                |> List.head

        isSelected player =
            case TS.getPlayer topscorer of
                Nothing ->
                    ( player, NotSelected )

                Just p ->
                    if player == p then
                        ( player, Selected )

                    else
                        ( player, NotSelected )

        players teamWP =
            .players teamWP
                |> List.map isSelected
    in
    case selectedTeam of
        Nothing ->
            Element.none

        Just teamWP ->
            Element.column [ spacing 4, Element.width Element.fill, Element.paddingXY 0 8 ]
                [ UI.Text.displayHeader "Kies een speler"
                , Element.column [ spacing 0, Element.width Element.fill ]
                    (List.map (viewPlayerRow SelectPlayer) (players teamWP))
                ]


isComplete : Bet -> Bool
isComplete bet =
    Bets.Types.Answer.Topscorer.isComplete bet.answers.topscorer
