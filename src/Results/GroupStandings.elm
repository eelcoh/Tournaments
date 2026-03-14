module Results.GroupStandings exposing (view)

import Bets.Types exposing (Group, Team)
import Bets.Types.Group
import Bets.Types.Team as T
import Dict exposing (Dict)
import Element exposing (Element)
import Element.Border as Border
import Element.Font as Font
import List.Extra
import RemoteData exposing (RemoteData(..))
import Types exposing (MatchResult, MatchResults, Model, Msg)
import UI.Color
import UI.Page
import UI.Style
import UI.Text


type alias TeamStanding =
    { team : Team
    , played : Int
    , won : Int
    , drawn : Int
    , lost : Int
    , goalsFor : Int
    , goalsAgainst : Int
    , points : Int
    }


initStanding : Team -> TeamStanding
initStanding team =
    { team = team
    , played = 0
    , won = 0
    , drawn = 0
    , lost = 0
    , goalsFor = 0
    , goalsAgainst = 0
    , points = 0
    }


computeStandings : List MatchResult -> List ( Group, List TeamStanding )
computeStandings results =
    let
        groups =
            List.Extra.groupWhile (\a b -> a.group == b.group) results
    in
    List.map computeGroupStandings groups


computeGroupStandings : ( MatchResult, List MatchResult ) -> ( Group, List TeamStanding )
computeGroupStandings ( first, rest ) =
    let
        grpMatches =
            first :: rest

        group =
            first.group

        -- Build initial standings dict from all teams in the group
        addTeam : Team -> Dict String TeamStanding -> Dict String TeamStanding
        addTeam team dict =
            if Dict.member team.teamID dict then
                dict

            else
                Dict.insert team.teamID (initStanding team) dict

        initialDict : Dict String TeamStanding
        initialDict =
            List.foldl
                (\match dict ->
                    dict
                        |> addTeam match.homeTeam
                        |> addTeam match.awayTeam
                )
                Dict.empty
                grpMatches

        -- Accumulate stats from played matches
        accumulateMatch : MatchResult -> Dict String TeamStanding -> Dict String TeamStanding
        accumulateMatch match dict =
            case match.score of
                Just ( Just homeGoals, Just awayGoals ) ->
                    let
                        homeID =
                            match.homeTeam.teamID

                        awayID =
                            match.awayTeam.teamID

                        updateHome s =
                            if homeGoals > awayGoals then
                                { s | played = s.played + 1, won = s.won + 1, goalsFor = s.goalsFor + homeGoals, goalsAgainst = s.goalsAgainst + awayGoals, points = s.points + 3 }

                            else if homeGoals == awayGoals then
                                { s | played = s.played + 1, drawn = s.drawn + 1, goalsFor = s.goalsFor + homeGoals, goalsAgainst = s.goalsAgainst + awayGoals, points = s.points + 1 }

                            else
                                { s | played = s.played + 1, lost = s.lost + 1, goalsFor = s.goalsFor + homeGoals, goalsAgainst = s.goalsAgainst + awayGoals }

                        updateAway s =
                            if awayGoals > homeGoals then
                                { s | played = s.played + 1, won = s.won + 1, goalsFor = s.goalsFor + awayGoals, goalsAgainst = s.goalsAgainst + homeGoals, points = s.points + 3 }

                            else if awayGoals == homeGoals then
                                { s | played = s.played + 1, drawn = s.drawn + 1, goalsFor = s.goalsFor + awayGoals, goalsAgainst = s.goalsAgainst + homeGoals, points = s.points + 1 }

                            else
                                { s | played = s.played + 1, lost = s.lost + 1, goalsFor = s.goalsFor + awayGoals, goalsAgainst = s.goalsAgainst + homeGoals }
                    in
                    dict
                        |> Dict.update homeID (Maybe.map updateHome)
                        |> Dict.update awayID (Maybe.map updateAway)

                _ ->
                    dict

        finalDict =
            List.foldl accumulateMatch initialDict grpMatches

        standings =
            Dict.values finalDict
                |> List.sortBy (\s -> -s.points)
    in
    ( group, standings )


positionColor : Int -> Element.Attribute msg
positionColor pos =
    case pos of
        1 ->
            Font.color UI.Color.green

        2 ->
            Font.color UI.Color.green

        3 ->
            Font.color UI.Color.orange

        _ ->
            Font.color UI.Color.white


viewStandingRow : Int -> TeamStanding -> Element Msg
viewStandingRow pos standing =
    Element.row
        [ Element.paddingXY 12 6
        , Element.width Element.fill
        , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
        , Border.color UI.Color.terminalBorder
        , positionColor pos
        ]
        [ Element.el [ Element.width (Element.px 20) ] (Element.text (String.fromInt pos))
        , Element.el [ Element.width (Element.px 60) ] (Element.text (T.display standing.team))
        , Element.el [ Element.width (Element.px 24) ] (Element.text (String.fromInt standing.played))
        , Element.el [ Element.width (Element.px 24) ] (Element.text (String.fromInt standing.won))
        , Element.el [ Element.width (Element.px 24) ] (Element.text (String.fromInt standing.drawn))
        , Element.el [ Element.width (Element.px 24) ] (Element.text (String.fromInt standing.lost))
        , Element.el [ Element.width (Element.px 24) ] (Element.text (String.fromInt standing.goalsFor))
        , Element.el [ Element.width (Element.px 24) ] (Element.text (String.fromInt standing.goalsAgainst))
        , Element.el [ Element.width (Element.px 28), Font.bold ] (Element.text (String.fromInt standing.points))
        ]


viewGroupStandings : ( Group, List TeamStanding ) -> Element Msg
viewGroupStandings ( grp, standings ) =
    let
        hdr =
            UI.Text.displayHeader ("Groep " ++ Bets.Types.Group.toString grp)

        rows =
            List.indexedMap (\i s -> viewStandingRow (i + 1) s) standings
    in
    Element.column
        (UI.Style.resultCard [ Element.spacing 0 ])
        (hdr :: rows)


view : Model Msg -> Element Msg
view model =
    let
        hdr =
            UI.Text.displayHeader "Groepsstand"

        mainView =
            case model.matchResults of
                Success results ->
                    let
                        groups =
                            computeStandings results.results
                    in
                    Element.column [ Element.spacing 16, Element.width Element.fill ]
                        (List.map viewGroupStandings groups)

                NotAsked ->
                    Element.text "nog niet opgevraagd"

                Loading ->
                    Element.text "aan het ophalen..."

                Failure _ ->
                    UI.Text.error "oei, oei, oei"
    in
    UI.Page.container model.screen "groepsstand"
        [ Element.column
            [ Element.paddingXY 0 8
            , Element.width Element.fill
            , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
            , Border.color UI.Color.terminalBorder
            ]
            [ hdr ]
        , mainView
        ]
