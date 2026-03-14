module Results.Matches exposing (..)

import Authentication
import Bets.Init
import Bets.Types exposing (Match, Score)
import Bets.Types.Group
import Bets.Types.Match as M
import Bets.Types.Score as S
import Bets.Types.Team
import Element exposing (centerX, height, padding, paddingXY, px, spacing, spacingXY, width)
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Http
import Json.Decode exposing (Decoder, andThen, field, maybe)
import Json.Encode
import List.Extra
import RemoteData exposing (RemoteData(..))
import RemoteData.Http as Web exposing (defaultConfig)
import Types exposing (Access(..), Activity(..), MatchResult, MatchResults, Model, Msg(..), Token(..))
import UI.Button
import UI.Button.Score
import UI.Color
import UI.Font
import UI.Page
import UI.Style exposing (ButtonSemantics(..), Direction(..))
import UI.Team
import UI.Text


fetchMatchResults : Cmd Msg
fetchMatchResults =
    Web.get "/bets/results/matches/" FetchedMatchResults decode


updateMatchResults : Token -> MatchResult -> Cmd Msg
updateMatchResults (Token token) match =
    let
        bearer =
            "Bearer " ++ token

        header =
            Http.header "Authorization" bearer

        config =
            { defaultConfig | headers = [ header ] }

        url =
            "/bets/results/matches/" ++ match.match

        json =
            encodeMatchResult match
    in
    Web.putWithConfig config url StoredMatchResult decode json


initialise : Token -> Cmd Msg
initialise (Token token) =
    -- Web.post "/bets/ranking/initial/" FetchedRanking decode Json.Encode.null
    let
        bearer =
            "Bearer " ++ token

        header =
            Http.header "Authorization" bearer

        config =
            { defaultConfig | headers = [ header ] }

        matchResults =
            initialMatchesToResults Bets.Init.matches
                |> encodeMatchResults
    in
    Web.postWithConfig config "/bets/results/matches/initial/" FetchedMatchResults decode matchResults


view : Model Msg -> Element.Element Msg
view model =
    let
        access =
            Authentication.isAuthorised model

        hdr =
            UI.Text.displayHeader "Resultaten Wedstrijden"

        mainView =
            case model.matchResults of
                Success results ->
                    displayMatches access results.results

                NotAsked ->
                    Element.text "nog niet opgevraagd"

                Loading ->
                    Element.text "aan het ophalen..."

                Failure e ->
                    Element.column
                        []
                        [ UI.Text.error "oei, oei, oei, daar ging iets niet helemaal goed"
                        ]

        initialiseButton =
            case access of
                Authorised ->
                    UI.Button.pill Wrong InitialiseMatchResults "initialiseer"

                Unauthorised ->
                    Element.none
    in
    UI.Page.container model.screen "matches"
        [ Element.column
            [ Element.paddingXY 0 8
            , Element.width Element.fill
            , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
            , Border.color UI.Color.terminalBorder
            ]
            [ hdr ]
        , mainView
        , initialiseButton
        ]


displayMatches : Access -> List MatchResult -> Element.Element Msg
displayMatches access matches =
    let
        groups =
            List.Extra.groupWhile (\a b -> a.group == b.group) matches

        viewSection ( first, rest ) =
            let
                grpMatches =
                    first :: rest

                hdr =
                    UI.Text.displayHeader ("Groep " ++ Bets.Types.Group.toString first.group)

                rows =
                    List.map (displayMatch access) grpMatches
            in
            Element.column
                (UI.Style.resultCard [ Element.spacing 0 ])
                (hdr :: rows)
    in
    Element.column
        [ Element.spacing 16, Element.width Element.fill ]
        (List.map viewSection groups)


displayMatch : Access -> MatchResult -> Element.Element Msg
displayMatch access match =
    let
        handler =
            case access of
                Authorised ->
                    Events.onClick (EditMatch match)

                Unauthorised ->
                    Events.onClick NoOp

        home =
            UI.Team.viewTeamSmallHorizontal DLeft match.homeTeam

        away =
            UI.Team.viewTeamSmallHorizontal DRight match.awayTeam

        sc =
            displayScore match.score
    in
    Element.row
        [ Element.paddingXY 12 8
        , Element.width Element.fill
        , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
        , Border.color UI.Color.terminalBorder
        , handler
        , Element.pointer
        ]
        [ Element.el [ Element.width Element.fill ] home
        , sc
        , Element.el [ Element.width Element.fill, Element.alignRight ] away
        ]



-- edit


edit : Model Msg -> Element.Element Msg
edit model =
    let
        access =
            Authentication.isAuthorised model

        items =
            case ( access, model.matchResult ) of
                ( Authorised, Success match ) ->
                    [ displayMatch Unauthorised match
                    , viewKeyboard match
                    , UI.Button.pill UI.Style.Active (CancelMatchResult match) "Wissen"
                    ]

                ( Authorised, Failure e ) ->
                    [ UI.Text.error "(Basics.toString e)"
                    ]

                ( Authorised, NotAsked ) ->
                    [ UI.Text.error "geen wedstrijd geselecteerd" ]

                _ ->
                    [ UI.Text.error "dit is niet de bedoeling" ]
    in
    UI.Page.container model.screen "match-edit" items


viewKeyboard : MatchResult -> Element.Element Msg
viewKeyboard match =
    let
        toMsg h a =
            Types.UpdateMatchResult { match | score = score_ h a }

        score_ home away =
            mkScore home away
    in
    UI.Button.Score.viewKeyboard NoOp toMsg


mkScore h a =
    Just ( Just h, Just a )


initialMatchesToResults : List Match -> MatchResults
initialMatchesToResults ms =
    let
        matchToResult m =
            { match = M.id m
            , group = M.group m
            , homeTeam = M.homeTeam m
            , awayTeam = M.awayTeam m
            , score = Nothing
            }
    in
    List.map matchToResult ms
        |> (\mr -> { results = mr })



-- json


encodeMatchResults : MatchResults -> Json.Encode.Value
encodeMatchResults mrs =
    Json.Encode.object
        [ ( "results", Json.Encode.list encodeMatchResult mrs.results ) ]


encodeMatchResult : MatchResult -> Json.Encode.Value
encodeMatchResult match =
    let
        ( homeScore, awayScore, isSet ) =
            case match.score of
                Just ( Just h, Just a ) ->
                    ( h, a, True )

                Just ( Just h, Nothing ) ->
                    ( h, 0, False )

                Just ( Nothing, Just a ) ->
                    ( 0, a, False )

                Just ( Nothing, Nothing ) ->
                    ( 0, 0, False )

                Nothing ->
                    ( 0, 0, False )
    in
    Json.Encode.object
        [ ( "match", Json.Encode.string match.match )
        , ( "group", Bets.Types.Group.encode match.group )
        , ( "homeTeam", Bets.Types.Team.encode match.homeTeam )
        , ( "awayTeam", Bets.Types.Team.encode match.awayTeam )
        , ( "homeScore", Json.Encode.int homeScore )
        , ( "awayScore", Json.Encode.int awayScore )
        , ( "isSet", Json.Encode.bool isSet )
        ]


decode : Decoder MatchResults
decode =
    Json.Decode.map MatchResults
        (field "results" (Json.Decode.list decodeMatchResult))


decodeMatchResult : Decoder MatchResult
decodeMatchResult =
    field "isSet" Json.Decode.bool
        |> andThen decodeScore
        |> andThen decodeRest


decodeScore : Bool -> Decoder (Maybe ( Maybe Int, Maybe Int ))
decodeScore isSet =
    if isSet then
        Json.Decode.map2 mkScore
            (field "homeScore" Json.Decode.int)
            (field "awayScore" Json.Decode.int)

    else
        Json.Decode.map2 (\_ _ -> Nothing)
            (field "homeScore" Json.Decode.int)
            (field "awayScore" Json.Decode.int)


decodeRest : Maybe Bets.Types.Score -> Decoder MatchResult
decodeRest score =
    Json.Decode.map4 (\m g h a -> MatchResult m g h a score)
        (field "match" Json.Decode.string)
        (field "group" Bets.Types.Group.decode)
        (field "homeTeam" Bets.Types.Team.decode)
        (field "awayTeam" Bets.Types.Team.decode)



--


displayScore : Maybe Score -> Element.Element Msg
displayScore mScore =
    case mScore of
        Just score ->
            Element.el
                [ Font.color UI.Color.orange
                , Element.width (Element.px 50)
                , Element.centerX
                , Font.center
                ]
                (Element.text (S.asString score))

        Nothing ->
            Element.el
                [ Font.color UI.Color.grey
                , Element.width (Element.px 50)
                , Element.centerX
                , Font.center
                ]
                (Element.text "_-_")
