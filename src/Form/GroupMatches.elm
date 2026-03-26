module Form.GroupMatches exposing (isComplete, update, view)

import Bets.Bet exposing (setMatchScore)
import Bets.Types exposing (Answer(..), AnswerGroupMatch, Bet, Group(..), GroupMatch(..), MatchID, Score, Team)
import Bets.Types.Answer.GroupMatches as GroupMatches
import Bets.Types.Group as G
import Bets.Types.Match as M
import Bets.Types.Score as S
import Bets.Types.Team as T
import Element exposing (centerX, centerY, fill, height, padding, paddingXY, px, spacing, width)
import Element.Border as Border
import Element.Events
import Element.Font as Font
import Element.Input as Input
import Form.GroupMatches.Types exposing (ChangeCursor(..), Msg(..), State, updateCursor)
import Html.Attributes
import Html.Events
import Json.Decode
import List.Extra
import UI.Button.Score
import UI.Color as Color
import UI.Font
import UI.Page exposing (page)
import UI.Screen as Screen
import UI.Style
import UI.Text


isWide : Screen.Size -> Bool
isWide screen =
    screen.width >= 400


isComplete : Bet -> Bool
isComplete bet =
    GroupMatches.isComplete bet.answers.matches


update : Msg -> State -> Bet -> ( Bet, State, Cmd Msg )
update action state bet =
    let
        allMatchIDs =
            List.map Tuple.first bet.answers.matches
    in
    case action of
        UpdateHome matchID h ->
            ( setMatchScore bet matchID ( Just h, Nothing ), updateCursor state allMatchIDs Dont, Cmd.none )

        UpdateAway matchID a ->
            ( setMatchScore bet matchID ( Nothing, Just a ), updateCursor state allMatchIDs Implicit, Cmd.none )

        Update matchID h a ->
            let
                newBet =
                    setMatchScore bet matchID ( Just h, Just a )

                newState =
                    updateCursor { state | manualInputVisible = False } allMatchIDs Implicit
            in
            ( newBet, newState, Cmd.none )

        SelectMatch matchID ->
            ( bet, updateCursor state allMatchIDs (Explicit matchID), Cmd.none )

        ScrollDown ->
            ( bet, updateCursor state allMatchIDs Implicit, Cmd.none )

        ScrollUp ->
            let
                newCursor =
                    allMatchIDs
                        |> List.Extra.takeWhile (\mId -> mId /= state.cursor)
                        |> List.Extra.last
                        |> Maybe.withDefault state.cursor
            in
            ( bet, { state | cursor = newCursor }, Cmd.none )

        JumpToGroup grp ->
            let
                groupMatches =
                    GroupMatches.findGroupMatchAnswers grp bet.answers.matches

                firstIncomplete =
                    groupMatches
                        |> List.filter (\( _, agm ) -> not (isAnswerGroupMatchComplete agm))
                        |> List.head
                        |> Maybe.map Tuple.first

                firstMatch =
                    groupMatches
                        |> List.head
                        |> Maybe.map Tuple.first

                newCursor =
                    firstIncomplete
                        |> Maybe.withDefault (Maybe.withDefault state.cursor firstMatch)
            in
            ( bet, { state | cursor = newCursor }, Cmd.none )

        TouchStart y ->
            ( bet, { state | touchStartY = Just y }, Cmd.none )

        TouchEnd y ->
            let
                newState =
                    case state.touchStartY of
                        Just startY ->
                            let
                                delta =
                                    startY - y
                            in
                            if delta > 30 then
                                updateCursor { state | touchStartY = Nothing } allMatchIDs Implicit

                            else if delta < -30 then
                                let
                                    newCursor =
                                        allMatchIDs
                                            |> List.Extra.takeWhile (\mId -> mId /= state.cursor)
                                            |> List.Extra.last
                                            |> Maybe.withDefault state.cursor
                                in
                                { state | cursor = newCursor, touchStartY = Nothing }

                            else
                                { state | touchStartY = Nothing }

                        Nothing ->
                            state
            in
            ( bet, newState, Cmd.none )

        ShowManualInput ->
            ( bet, { state | manualInputVisible = True }, Cmd.none )

        HideManualInput ->
            ( bet, { state | manualInputVisible = False }, Cmd.none )

        NoOp ->
            ( bet, state, Cmd.none )


isAnswerGroupMatchComplete : AnswerGroupMatch -> Bool
isAnswerGroupMatchComplete (Answer (GroupMatch _ _ mScore) _) =
    case mScore of
        Just ( Just _, Just _ ) ->
            True

        _ ->
            False


groupOfMatch : ( MatchID, AnswerGroupMatch ) -> Group
groupOfMatch ( _, Answer (GroupMatch grp _ _) _ ) =
    grp


view : Screen.Size -> Bet -> State -> Element.Element Msg
view screen bet state =
    let
        allMatches =
            bet.answers.matches

        mCurrentMatch =
            List.filter (\( mId, _ ) -> mId == state.cursor) allMatches
                |> List.head
    in
    page "groupmatch"
        [ UI.Text.displayHeader "Wedstrijden"
        , viewGroupNav bet state
        , Element.column [ centerX, spacing 8 ]
            [ viewScrollWheel screen bet state
            , case mCurrentMatch of
                Just ( matchID, Answer (GroupMatch _ _ mScore) _ ) ->
                    let
                        andereScoreLink =
                            Element.el
                                (UI.Style.link [ centerX, UI.Font.mono, Font.size UI.Font.bodySize, Element.Events.onClick ShowManualInput ])
                                (Element.text "andere score")

                        terugLink =
                            Element.el
                                (UI.Style.link [ centerX, UI.Font.mono, Font.size UI.Font.bodySize, Element.Events.onClick HideManualInput ])
                                (Element.text "<- terug")
                    in
                    if state.manualInputVisible then
                        Element.column [ centerX, spacing 16 ]
                            [ viewScoreInputs matchID mScore
                            , terugLink
                            ]

                    else
                        Element.column [ centerX, spacing 8 ]
                            [ viewKeyboard matchID
                            , andereScoreLink
                            ]

                _ ->
                    Element.none
            ]
        , viewProgress bet
        ]



-- Scroll Wheel


type WindowLine
    = WLMatch ( MatchID, AnswerGroupMatch )
    | WLGroupLabel Group
    | WLPadding
    | WLEndMarker


buildScrollItems : List ( MatchID, AnswerGroupMatch ) -> List WindowLine
buildScrollItems matches =
    let
        go prevGroup remaining acc =
            case remaining of
                [] ->
                    List.reverse acc

                item :: rest ->
                    let
                        grp =
                            groupOfMatch item
                    in
                    if Just grp /= prevGroup then
                        go (Just grp) rest (WLMatch item :: WLGroupLabel grp :: acc)

                    else
                        go (Just grp) rest (WLMatch item :: acc)
    in
    go Nothing matches []


buildWindow : MatchID -> List ( MatchID, AnswerGroupMatch ) -> List WindowLine
buildWindow cursor allMatches =
    let
        -- Build the full flat sequence including group labels and end marker
        fullSequence =
            buildScrollItems allMatches ++ [ WLEndMarker ]

        -- Find the index of the cursor match in the full sequence
        cursorIdx =
            List.Extra.findIndex
                (\line ->
                    case line of
                        WLMatch ( mId, _ ) ->
                            mId == cursor

                        _ ->
                            False
                )
                fullSequence
                |> Maybe.withDefault 0

        -- Helper: get item at index, defaulting to WLPadding if out of bounds
        getLine i =
            List.Extra.getAt i fullSequence
                |> Maybe.withDefault WLPadding

        -- Extract 3 items above the active match (indices cursorIdx-3, -2, -1)
        above0 =
            getLine (cursorIdx - 3)

        above1 =
            getLine (cursorIdx - 2)

        above2 =
            getLine (cursorIdx - 1)

        -- Extract the active match entry
        activeEntry =
            getLine cursorIdx

        -- Extract 3 items below the active match (indices cursorIdx+1, +2, +3)
        below0 =
            getLine (cursorIdx + 1)

        below1 =
            getLine (cursorIdx + 2)

        below2 =
            getLine (cursorIdx + 3)

    in
    [ above0, above1, above2, activeEntry, below0, below1, below2 ]


viewScrollWheel : Screen.Size -> Bet -> State -> Element.Element Msg
viewScrollWheel screen bet state =
    let
        allMatches =
            bet.answers.matches

        windowLines =
            buildWindow state.cursor allMatches

        touchStartAttr =
            Element.htmlAttribute
                (Html.Events.on "touchstart"
                    (Json.Decode.map TouchStart
                        (Json.Decode.at [ "touches", "0", "clientY" ] Json.Decode.float)
                    )
                )

        touchEndAttr =
            Element.htmlAttribute
                (Html.Events.preventDefaultOn "touchend"
                    (Json.Decode.map
                        (\y ->
                            let
                                isSwipe =
                                    case state.touchStartY of
                                        Just startY ->
                                            abs (startY - y) > 30

                                        Nothing ->
                                            False
                            in
                            ( TouchEnd y, isSwipe )
                        )
                        (Json.Decode.at [ "changedTouches", "0", "clientY" ] Json.Decode.float)
                    )
                )
    in
    Element.column
        [ centerX, spacing 4, touchStartAttr, touchEndAttr, width fill ]
        (List.map (viewWindowLine screen state.cursor) windowLines)


viewWindowLine : Screen.Size -> MatchID -> WindowLine -> Element.Element Msg
viewWindowLine screen cursor line =
    case line of
        WLMatch matchData ->
            viewScrollLine screen cursor matchData

        WLGroupLabel grp ->
            viewGroupSeparator grp

        WLPadding ->
            Element.el [ Element.height (Element.px 36) ] Element.none

        WLEndMarker ->
            viewGroupSeparator_ "END"


viewScrollLine : Screen.Size -> MatchID -> ( MatchID, AnswerGroupMatch ) -> Element.Element Msg
viewScrollLine screen cursor ( answerId, Answer (GroupMatch _ match mScore) _ ) =
    let
        homeTeam =
            M.homeTeam match

        awayTeam =
            M.awayTeam match

        h =
            mScore |> Maybe.andThen S.homeScore |> Maybe.map String.fromInt |> Maybe.withDefault "_"

        a =
            mScore |> Maybe.andThen S.awayScore |> Maybe.map String.fromInt |> Maybe.withDefault "_"

        scoreStr =
            h ++ "-" ++ a

        isActive =
            cursor == answerId

        isCompleted =
            case mScore of
                Just ( Just _, Just _ ) ->
                    True

                _ ->
                    False

        textColor =
            if isActive then
                Color.white

            else if isCompleted then
                Color.green

            else
                Color.grey

        scoreColor =
            if isCompleted then
                Color.green

            else if isActive then
                Color.orange

            else
                Color.grey

        badgeWidth =
            if isWide screen then
                150

            else
                85

        flagImg team =
            Element.image
                [ Element.height (Element.px 20)
                , Element.width (Element.px 28)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }

        teamLabel team =
            if isWide screen then
                T.displayFull team

            else
                T.display team

        homeBadge team =
            Element.row
                [ Element.width (Element.px badgeWidth)
                , Element.height (Element.px 36)
                , spacing 8
                , centerY
                , Element.clipX
                ]
                [ Element.paragraph
                    [ UI.Font.mono, Font.color textColor, Font.size UI.Font.bodySize, Element.clipX, width fill, Font.alignRight ]
                    [ Element.text (teamLabel team) ]
                , flagImg team
                ]

        awayBadge team =
            Element.row
                [ Element.width (Element.px badgeWidth)
                , Element.height (Element.px 36)
                , spacing 8
                , centerY
                , Element.clipX
                ]
                [ flagImg team
                , Element.paragraph
                    [ UI.Font.mono, Font.color textColor, Font.size UI.Font.bodySize, Element.clipX, width fill ]
                    [ Element.text (teamLabel team) ]
                ]

        scoreEl =
            Element.el
                [ Element.width (Element.px 48)
                , Font.center
                , centerY
                , Font.color scoreColor
                , UI.Font.mono
                , Font.size UI.Font.bodySize
                ]
                (Element.text scoreStr)

        activeAttrs =
            if isActive then
                UI.Style.matchRowTile True
                    [ Element.Events.onClick (SelectMatch answerId)
                    , Element.pointer
                    , height (px 36)
                    , centerY
                    , centerX
                    ]

            else
                [ Element.Events.onClick (SelectMatch answerId)
                , Element.pointer
                , height (px 36)
                , centerY
                , centerX
                , width fill
                , paddingXY 8 0
                ]
    in
    Element.el activeAttrs
        (Element.row [ spacing 4, centerY, centerX ]
            [ homeBadge homeTeam
            , scoreEl
            , awayBadge awayTeam
            ]
        )



-- Group Separator


viewGroupSeparator : Group -> Element.Element Msg
viewGroupSeparator grp =
    viewGroupSeparator_ (G.toString grp)


viewGroupSeparator_ : String -> Element.Element Msg
viewGroupSeparator_ label =
    let
        gradientLine direction =
            Element.el
                [ width fill
                , Element.height (Element.px 1)
                , Element.htmlAttribute
                    (Html.Attributes.style "background"
                        ("linear-gradient(to " ++ direction ++ ", transparent, rgba(240,160,48,0.15))")
                    )
                ]
                Element.none
    in
    Element.row
        [ width fill
        , Element.height (Element.px 32)
        , spacing 10
        , centerY
        ]
        [ gradientLine "right"
        , Element.el
            [ Font.color Color.terminalAccentDim
            , UI.Font.mono
            , Font.size UI.Font.bodySize
            , Font.letterSpacing 2
            , centerY
            ]
            (Element.text label)
        , gradientLine "left"
        ]



-- Group Nav


viewGroupNav : Bet -> State -> Element.Element Msg
viewGroupNav bet state =
    let
        allGroups =
            [ A, B, C, D, E, F, G, H, I, J, K, L ]

        currentGroup =
            bet.answers.matches
                |> List.filter (\( mId, _ ) -> mId == state.cursor)
                |> List.head
                |> Maybe.map groupOfMatch

        viewGroupLetter grp =
            let
                isActive =
                    Just grp == currentGroup

                grpComplete =
                    GroupMatches.isCompleteGroup grp bet.answers.matches

                label =
                    if isActive then
                        G.toString grp ++ "*"

                    else
                        G.toString grp

                clr =
                    if isActive then
                        Color.orange

                    else if grpComplete then
                        Color.green

                    else
                        Color.grey
            in
            Element.el
                [ Element.Events.onClick (JumpToGroup grp)
                , Element.pointer
                , height (px 44)
                , paddingXY 8 0
                , centerY
                ]
                (Element.el
                    [ Font.color clr
                    , UI.Font.mono
                    , Font.size UI.Font.bodySize
                    , centerY
                    ]
                    (Element.text label)
                )
    in
    Element.wrappedRow [ centerX, spacing 8 ]
        (List.map viewGroupLetter allGroups)



-- Progress


viewProgress : Bet -> Element.Element Msg
viewProgress bet =
    let
        total =
            List.length bet.answers.matches

        completed =
            List.filter (\( _, agm ) -> isAnswerGroupMatchComplete agm) bet.answers.matches
                |> List.length
    in
    Element.el [ centerX, Font.color Color.grey, UI.Font.mono, Font.size UI.Font.bodySize ]
        (Element.text (String.fromInt completed ++ "/" ++ String.fromInt total))



-- Score Input


viewScoreInputs : MatchID -> Maybe Score -> Element.Element Msg
viewScoreInputs matchID mScore =
    let
        makeAction act val =
            case String.toInt val of
                Just v ->
                    act v

                Nothing ->
                    NoOp

        inputField v act =
            Input.text
                (UI.Style.scoreInput
                    [ width (px 60)
                    , Border.rounded 0
                    , Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")
                    ]
                )
                { onChange = makeAction act
                , text = v
                , label = Input.labelHidden ".."
                , placeholder = Just (Input.placeholder [] (Element.text v))
                }

        wrap fld =
            Element.el [ centerX, centerY ] fld

        extractScore extractor =
            mScore
                |> Maybe.andThen extractor
                |> Maybe.map String.fromInt
                |> Maybe.withDefault
                ""

        homeInput =
            inputField (extractScore S.homeScore) (UpdateHome matchID)
                |> wrap

        awayInput =
            inputField (extractScore S.awayScore) (UpdateAway matchID)
                |> wrap
    in
    Element.row [ centerX, paddingXY 4 8, spacing 8 ]
        [ homeInput
        , Element.el [ Font.color Color.grey, UI.Font.mono, centerY ] (Element.text "-")
        , awayInput
        ]


viewKeyboard : MatchID -> Element.Element Msg
viewKeyboard matchId =
    UI.Button.Score.viewKeyboard NoOp (Update matchId)
