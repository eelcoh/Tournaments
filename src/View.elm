module View exposing (..)

import Activities
import Authentication
import Bets.View
import Browser
import Element exposing (paddingXY, spacing)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (Font)
import Form.View
import RemoteData exposing (RemoteData(..))
import Results.Bets
import Results.Knockouts as Knockouts
import Results.Matches as Matches
import Results.Ranking as Ranking
import Results.Topscorers
import Task
import Types exposing (App(..), Card(..), Credentials(..), DataStatus(..), Flags, InputState(..), Model, Msg(..), Token(..))
import UI.Button
import UI.Color as Color
import UI.Font
import UI.Screen as Screen
import UI.Style
import Url
import Uuid.Barebones as Uuid


view : Model Msg -> Browser.Document Msg
view model =
    let
        contents =
            let
                contents_ =
                    case model.app of
                        Home ->
                            viewHome model

                        Form ->
                            Form.View.view model

                        BetsDetailsView ->
                            Bets.View.view model

                        Blog ->
                            viewBlog model

                        Login ->
                            Authentication.view model

                        Bets ->
                            Results.Bets.view model

                        Ranking ->
                            Ranking.view model

                        RankingDetailsView ->
                            Ranking.viewDetails model

                        Results ->
                            Matches.view model

                        EditMatchResult ->
                            Matches.edit model

                        KOResults ->
                            Knockouts.view model

                        TSResults ->
                            Results.Topscorers.view model
                contentPadding =
                    case Screen.device model.screen of
                        Screen.Phone ->
                            Element.padding 8

                        Screen.Computer ->
                            Element.padding 24
            in
            Element.el [ contentPadding ] contents_

        title =
            "Voetbalpool"

        link app =
            let
                isActive =
                    app == model.app

                semantics =
                    if isActive then
                        UI.Style.Active

                    else
                        UI.Style.Potential

                prefix =
                    if isActive then
                        "> "

                    else
                        "  "

                ( linkUrl, linkText ) =
                    case app of
                        Home ->
                            ( "#home", "home" )

                        Blog ->
                            ( "#blog", "blog" )

                        BetsDetailsView ->
                            ( "#inzendingen", "inzendingen" )

                        Bets ->
                            ( "#inzendingen", "inzendingen" )

                        Form ->
                            ( "#formulier", "formulier" )

                        Ranking ->
                            ( "#stand", "stand" )

                        Results ->
                            ( "#wedstrijden", "wedstrijden" )

                        KOResults ->
                            ( "#knockouts", "knockouts" )

                        TSResults ->
                            ( "#topscorer", "topscorer" )

                        _ ->
                            ( "#home", "home" )
            in
            -- Element.el [] wrapper for wrapperrow alignment misbehaviour
            Element.el [] <| UI.Button.navlink semantics linkUrl (prefix ++ linkText)

        linkList =
            case model.token of
                RemoteData.Success (Token _) ->
                    [ Home, Ranking, Results, KOResults, TSResults, Blog, Bets ]

                _ ->
                    [ Home, Ranking, Form ]

        links =
            Element.column
                [ Element.width Element.fill ]
                [ Element.wrappedRow [ Element.paddingXY 0 8, Element.spacing 4 ]
                    (List.map link linkList)
                , Element.el
                    [ Element.width Element.fill
                    , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
                    , Border.color Color.terminalBorder
                    ]
                    Element.none
                ]

        page =
            let
                hPad =
                    case Screen.device model.screen of
                        Screen.Phone ->
                            8

                        Screen.Computer ->
                            24
            in
            Element.column
                [ Element.paddingEach { top = 24, right = hPad, bottom = 40, left = hPad }
                , Element.spacing 24
                , Element.centerX
                ]
                [ links
                , contents
                , viewVersion
                ]

        body =
            Element.layout
                (UI.Style.body
                    [ Element.inFront
                        (Element.el
                            [ Element.alignBottom, Element.width Element.fill ]
                            (viewStatusBar model)
                        )
                    ]
                )
                page
    in
    { title = title, body = [ body ] }


viewStatusBar : Model Msg -> Element.Element Msg
viewStatusBar model =
    let
        currentCard =
            List.drop model.idx model.cards
                |> List.head

        sectionLabel card =
            case card of
                Just (IntroCard _) ->
                    "intro"

                Just (GroupMatchesCard _) ->
                    "groepen"

                Just (BracketCard _) ->
                    "schema"

                Just TopscorerCard ->
                    "topscorer"

                Just (ParticipantCard _) ->
                    "inzenden"

                Just SubmitCard ->
                    "inzenden"

                Nothing ->
                    ""

        statusText =
            case model.app of
                Form ->
                    let
                        section =
                            sectionLabel currentCard

                        stepInfo =
                            "stap "
                                ++ String.fromInt (model.idx + 1)
                                ++ "/"
                                ++ String.fromInt (List.length model.cards)
                    in
                    "formulier > " ++ section ++ "  " ++ stepInfo

                Home ->
                    "home"

                Ranking ->
                    "stand"

                RankingDetailsView ->
                    "stand > detail"

                Results ->
                    "wedstrijden"

                EditMatchResult ->
                    "wedstrijden > bewerk"

                KOResults ->
                    "knockouts"

                TSResults ->
                    "topscorer"

                Blog ->
                    "blog"

                Bets ->
                    "inzendingen"

                BetsDetailsView ->
                    "inzending"

                Login ->
                    "login"
    in
    Element.row
        [ Element.width Element.fill
        , Element.paddingXY 12 6
        , Background.color Color.black
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color Color.terminalBorder
        ]
        [ Element.el [ Font.color Color.grey, UI.Font.mono, Font.size (UI.Font.scaled 0) ]
            (Element.text statusText)
        , Element.el [ Element.alignRight, Font.color Color.grey, UI.Font.mono, Font.size (UI.Font.scaled 0) ]
            (Element.text "v2026")
        ]


getApp : Url.Url -> ( App, Cmd Msg )
getApp url =
    let
        -- emptyFunc =
        --     \_ -> Cmd.none
        ( app, msg ) =
            Maybe.map inspect url.fragment
                |> Maybe.withDefault ( Home, RefreshActivities )

        inspect hash =
            let
                fragment =
                    String.split "/" hash
            in
            case fragment of
                "home" :: _ ->
                    ( Home, RefreshActivities )

                "blog" :: _ ->
                    ( Blog, RefreshActivities )

                "formulier" :: _ ->
                    ( Form, NoOp )

                "inzendingen" :: uuid :: _ ->
                    if Uuid.isValidUuid uuid then
                        ( BetsDetailsView, BetSelected uuid )

                    else
                        ( Ranking, RefreshRanking )

                "inzendingen" :: _ ->
                    ( Bets, FetchBets )

                "stand" :: uuid :: _ ->
                    if Uuid.isValidUuid uuid then
                        ( RankingDetailsView, RetrieveRankingDetails uuid )

                    else
                        ( Ranking, RefreshRanking )

                "stand" :: _ ->
                    ( Ranking, RefreshRanking )

                "wedstrijden" :: "wedstrijd" :: _ ->
                    ( EditMatchResult, NoOp )

                "wedstrijden" :: [] ->
                    ( Results, RefreshResults )

                "knockouts" :: [] ->
                    ( KOResults, RefreshKnockoutsResults )

                "topscorer" :: [] ->
                    ( TSResults, RefreshTopscorerResults )

                "login" :: _ ->
                    ( Login, NoOp )

                _ ->
                    ( Home, RefreshActivities )

        cmd =
            Task.succeed msg
                |> Task.perform identity
    in
    ( app, cmd )


viewHome : Model Msg -> Element.Element Msg
viewHome model =
    Element.column
        [ paddingXY 0 20
        , spacing 30
        , Screen.width model.screen
        , Screen.className "hallo"
        ]
        [ Activities.viewCommentInput model.activities
        , Activities.view model
        ]


viewBlog : Model Msg -> Element.Element Msg
viewBlog model =
    Element.column
        [ paddingXY 0 20
        , spacing 30
        , Screen.width model.screen
        , Screen.className "blog"
        ]
        [ Activities.viewPostInput model.activities
        , Activities.view model
        ]


viewVersion : Element.Element Msg
viewVersion =
    Element.column
        [ Element.spacing 8
        , Element.paddingXY 0 20
        , Element.width Element.fill
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color Color.terminalBorder
        ]
        [ Element.el [ Font.color Color.grey, UI.Font.mono, Font.size (UI.Font.scaled 0) ]
            (Element.text "v2026")
        , Element.link
            [ Font.color Color.orange, UI.Font.mono, Font.size (UI.Font.scaled 0) ]
            { url = "https://claude.ai/code", label = Element.text "Built with Claude Code" }
        ]
