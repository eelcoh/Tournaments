module View exposing (..)

import Activities
import Authentication
import Bets.Types.Answer.GroupMatch as GroupMatch
import Bets.View
import Browser
import Element exposing (paddingXY, spacing)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font exposing (Font)
import Html.Attributes
import Form.Bracket
import Form.Bracket.Types as BracketTypes
import Form.GroupMatches
import Form.Participant
import Form.Topscorer
import Form.View
import RemoteData exposing (RemoteData(..))
import Results.Bets
import Results.GroupStandings
import Results.Knockouts as Knockouts
import Results.Matches as Matches
import Results.Ranking as Ranking
import Results.Topscorers
import Task
import Types exposing (App(..), Card(..), Credentials(..), DataStatus(..), Flags, InputState(..), InstallBannerState(..), Model, Msg(..), Token(..))
import UI.Button
import UI.Color as Color
import UI.Font
import UI.Screen as Screen
import UI.Style
import UI.Text
import Url
import Uuid.Barebones as Uuid


view : Model Msg -> Browser.Document Msg
view model =
    let
        contents =
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

                GroupStandings ->
                    Results.GroupStandings.view model

        title =
            "Voetbalpool"

        appToNavItem app =
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

                GroupStandings ->
                    ( "#groepsstand", "groepsstand" )

                _ ->
                    ( "#home", "home" )

        link app =
            let
                semantics =
                    if app == model.app then
                        UI.Style.Active

                    else
                        UI.Style.Potential

                ( linkUrl, linkText ) =
                    appToNavItem app
            in
            Element.el [] <| UI.Button.navlink semantics linkUrl linkText

        linkList =
            if model.testMode then
                [ Home, Form, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]

            else
                case model.token of
                    RemoteData.Success (Token _) ->
                        [ Home, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]

                    _ ->
                        [ Home, Ranking, Form ]

        menuLink app =
            let
                isActive =
                    app == model.app

                prefix =
                    if isActive then
                        "> "

                    else
                        "  "

                ( linkUrl, linkText ) =
                    appToNavItem app

                fontColor =
                    if isActive then
                        Color.activeNav

                    else
                        Color.inactiveNav
            in
            Element.link
                [ UI.Font.mono
                , Font.color fontColor
                , Font.size (UI.Font.scaled 1)
                , Element.paddingXY 8 10
                , Element.width Element.fill
                , Element.pointer
                , Element.mouseOver [ Font.color Color.orange ]
                ]
                { url = linkUrl
                , label = Element.text (prefix ++ linkText)
                }

        hamburgerButton =
            Element.el
                [ Element.Events.onClick ToggleMenu
                , Element.pointer
                , Element.alignRight
                , Element.centerY
                , UI.Font.mono
                , Font.color Color.inactiveNav
                , Font.size (UI.Font.scaled 1)
                , Element.paddingXY 8 0
                , Element.mouseOver [ Font.color Color.orange ]
                ]
                (Element.text
                    (if model.menuOpen then
                        "[x]"

                     else
                        "[=]"
                    )
                )

        mobileMenu =
            if model.menuOpen then
                Element.column
                    [ Element.width Element.fill
                    , Element.paddingXY 0 4
                    , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
                    , Border.color Color.orangeOverlay10
                    ]
                    (List.map menuLink linkList)

            else
                Element.none

        titleBar =
            Element.row
                [ Element.width Element.fill
                , Element.height (Element.px 44)
                ]
                [ Element.el
                    [ Element.Events.onClick TitleTap
                    , Element.pointer
                    , Font.color Color.orange
                    , UI.Font.mono
                    , Font.size UI.Font.bodySize
                    , Font.letterSpacing 1.0
                    , Font.bold
                    , Element.paddingXY 0 8
                    ]
                    (Element.text "Voetbalpool")
                , case Screen.device model.screen of
                    Screen.Phone ->
                        hamburgerButton

                    Screen.Computer ->
                        Element.none
                ]

        links =
            Element.column
                [ Element.width Element.fill
                , Element.htmlAttribute (Html.Attributes.style "background" "linear-gradient(180deg, #16171e 0%, #12131a 100%)")
                , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
                , Border.color Color.orangeOverlay10
                ]
                (case Screen.device model.screen of
                    Screen.Phone ->
                        [ titleBar
                        , mobileMenu
                        ]

                    Screen.Computer ->
                        [ titleBar
                        , Element.wrappedRow [ Element.paddingXY 0 8, Element.spacing 2 ]
                            (List.map link linkList)
                        ]
                )

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
                , Element.width (Element.fill |> Element.maximum (Screen.maxWidth model.screen))
                ]
                [ links
                , contents
                ]

        body =
            Element.layout
                (UI.Style.body
                    [ Element.inFront
                        (Element.column
                            [ Element.alignBottom, Element.width Element.fill ]
                            [ viewFormNavBar model
                            , viewInstallBanner model
                            , viewStatusBar model
                            ]
                        )
                    ]
                )
                page
    in
    { title = title, body = [ body ] }


bannerRow : List (Element.Element Msg) -> Element.Element Msg
bannerRow children =
    Element.row
        [ Element.width Element.fill
        , Element.paddingXY 12 6
        , Element.spacing 8
        , Background.color Color.black
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color Color.terminalBorder
        ]
        children


dismissButton : Element.Element Msg
dismissButton =
    Element.el
        [ Element.alignRight
        , Element.Events.onClick DismissInstallBanner
        , Element.pointer
        , Font.color Color.grey
        , UI.Font.mono
        , Font.size (UI.Font.scaled 0)
        ]
        (Element.text "[x]")


viewInstallBanner : Model Msg -> Element.Element Msg
viewInstallBanner model =
    case model.installBanner of
        BannerHidden ->
            Element.none

        BannerShowingIOS ->
            bannerRow
                [ Element.el
                    [ Font.color Color.white
                    , UI.Font.mono
                    , Font.size (UI.Font.scaled 0)
                    ]
                    (Element.text "[ add to home screen ] -- tap \u{2197} then \"Add to Home Screen\"")
                , dismissButton
                ]

        BannerShowingAndroid ->
            bannerRow
                [ Element.el
                    [ Element.Events.onClick TriggerAndroidInstall
                    , Element.pointer
                    , Font.color Color.orange
                    , UI.Font.mono
                    , Font.size (UI.Font.scaled 0)
                    ]
                    (Element.text "[ Installeer App ]")
                , dismissButton
                ]


cardLabel : Model Msg -> String
cardLabel model =
    List.drop model.idx model.cards
        |> List.head
        |> Maybe.map Form.View.cardLabel
        |> Maybe.withDefault ""


cardStatusSuffix : Model Msg -> String
cardStatusSuffix model =
    let
        currentCard =
            List.drop model.idx model.cards
                |> List.head
    in
    case currentCard of
        Just (GroupMatchesCard _) ->
            let
                openCount =
                    List.filter (\( _, gm ) -> not (GroupMatch.isComplete gm)) model.bet.answers.matches
                        |> List.length
            in
            if openCount > 0 then
                String.fromInt openCount ++ " open"

            else
                "klaar"

        Just (BracketCard { bracketState }) ->
            case bracketState of
                BracketTypes.BracketWizard { selections } ->
                    let
                        rounds =
                            [ ( BracketTypes.ChampionRound, 1 )
                            , ( BracketTypes.FinalistRound, 2 )
                            , ( BracketTypes.SemiRound, 4 )
                            , ( BracketTypes.QuarterRound, 8 )
                            , ( BracketTypes.LastSixteenRound, 16 )
                            , ( BracketTypes.LastThirtyTwoRound, 32 )
                            ]

                        openRounds =
                            List.filter
                                (\( r, cap ) ->
                                    List.length (BracketTypes.roundTeams r selections) < cap
                                )
                                rounds
                                |> List.length
                    in
                    if openRounds == 0 then
                        "klaar"

                    else
                        String.fromInt openRounds ++ " ronden open"

        Just (TopscorerCard _) ->
            if Form.Topscorer.isComplete model.bet then
                "klaar"

            else
                "1 open"

        Just (ParticipantCard _) ->
            if Form.Participant.isComplete model.bet then
                "klaar"

            else
                "gegevens open"

        _ ->
            "stap " ++ String.fromInt (model.idx + 1) ++ "/" ++ String.fromInt (List.length model.cards)


viewFormNavBar : Model Msg -> Element.Element Msg
viewFormNavBar model =
    case model.app of
        Form ->
            let
                isFirst =
                    model.idx == 0

                isLast =
                    model.idx == List.length model.cards - 1

                prev =
                    Basics.max (model.idx - 1) 0

                next =
                    Basics.min (model.idx + 1) (List.length model.cards - 1)

                prevButton =
                    Element.el
                        [ Element.height (Element.px 50)
                        , Element.centerY
                        , Font.color Color.mutedText
                        , UI.Font.mono
                        , Font.size UI.Font.bodySize
                        ]
                        (UI.Text.allCenteredText "< vorige")

                nextButton =
                    Element.el
                        [ Element.height (Element.px 50)
                        , Element.centerY
                        , Font.color Color.mutedText
                        , UI.Font.mono
                        , Font.size UI.Font.bodySize
                        ]
                        (UI.Text.allCenteredText "volgende >")

                activePrevButton =
                    Element.el
                        [ Element.Events.onClick (NavigateTo prev)
                        , Element.pointer
                        , Element.height (Element.px 50)
                        , Element.centerY
                        , Font.color Color.orange
                        , UI.Font.mono
                        , Font.size UI.Font.bodySize
                        , Element.mouseOver [ Font.color Color.white ]
                        ]
                        (UI.Text.allCenteredText "< vorige")

                activeNextButton =
                    Element.el
                        [ Element.Events.onClick (NavigateTo next)
                        , Element.pointer
                        , Element.height (Element.px 50)
                        , Element.centerY
                        , Font.color Color.orange
                        , UI.Font.mono
                        , Font.size UI.Font.bodySize
                        , Element.mouseOver [ Font.color Color.white ]
                        ]
                        (UI.Text.allCenteredText "volgende >")

            in
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY 16 0
                , Element.height (Element.px 50)
                , Element.htmlAttribute (Html.Attributes.style "background" "linear-gradient(180deg, #12131a, #0f1017)")
                , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
                , Border.color Color.orangeOverlay08
                ]
                [ Element.el
                    [ Element.width (Element.fillPortion 1)
                    , Element.height (Element.px 50)
                    , Element.centerY
                    ]
                    (if isFirst then prevButton else activePrevButton)
                , Element.el
                    [ Element.width (Element.fillPortion 2)
                    , Element.centerX
                    , UI.Font.mono
                    ]
                    (Element.row [ Element.centerX, Element.centerY, Element.spacing 6 ]
                        [ Element.el [ Font.color Color.activeNav, Font.size UI.Font.bodySize ] (Element.text (cardLabel model))
                        , Element.el [ Font.color Color.grey, Font.size UI.Font.captionSize ] (Element.text ("· " ++ cardStatusSuffix model))
                        ]
                    )
                , Element.el
                    [ Element.width (Element.fillPortion 1)
                    , Element.height (Element.px 50)
                    , Element.centerY
                    , Element.alignRight
                    ]
                    (if isLast then nextButton else activeNextButton)
                ]

        _ ->
            Element.none


viewStatusBar : Model Msg -> Element.Element Msg
viewStatusBar model =
    let
        currentCard =
            List.drop model.idx model.cards
                |> List.head

        sectionLabel card =
            case card of
                Just DashboardCard ->
                    "overzicht"

                Just (IntroCard _) ->
                    "intro"

                Just (GroupMatchesCard _) ->
                    "groepen"

                Just (BracketCard _) ->
                    "schema"

                Just (TopscorerCard _) ->
                    "topscorer"

                Just (ParticipantCard _) ->
                    "gegevens"

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

                GroupStandings ->
                    "groepsstand"
    in
    Element.row
        [ Element.width Element.fill
        , Element.paddingXY 16 5
        , Background.color Color.dark_red
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color Color.borderDim
        ]
        [ Element.el [ Font.color Color.mutedText, UI.Font.mono, Font.size (UI.Font.scaled 0) ]
            (Element.text statusText)
        , Element.el
            [ Element.alignRight
            , Font.color
                (if model.testMode then
                    Color.orange

                 else
                    Color.mutedText
                )
            , UI.Font.mono
            , Font.size (UI.Font.scaled 0)
            ]
            (Element.text
                (if model.testMode then
                    "[TEST MODE]  v2026"

                 else
                    "v2026"
                )
            )
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

                "groepsstand" :: _ ->
                    ( GroupStandings, RefreshResults )

                "login" :: _ ->
                    ( Login, NoOp )

                "test" :: _ ->
                    ( Home, ActivateTestMode )

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
        , Element.width Element.fill
        , Screen.className "hallo"
        ]
        [ UI.Text.displayHeader "Chat"
        , Activities.viewCommentInput model.activities
        , Activities.view model
        ]


viewBlog : Model Msg -> Element.Element Msg
viewBlog model =
    Element.column
        [ paddingXY 0 20
        , spacing 30
        , Element.width Element.fill
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
