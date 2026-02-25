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
import UI.Style
import UI.Text


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
            ( setMatchScore bet matchID ( Just h, Just a ), updateCursor state allMatchIDs Implicit, Cmd.none )

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


view : Bet -> State -> Element.Element Msg
view bet state =
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
        , viewScrollWheel bet state
        , case mCurrentMatch of
            Just ( matchID, Answer (GroupMatch _ match mScore) _ ) ->
                Element.column [ centerX, spacing 8 ]
                    [ viewInput state matchID (M.homeTeam match) (M.awayTeam match) mScore
                    , viewKeyboard matchID
                    ]

            _ ->
                Element.none
        , viewProgress bet
        ]



-- Scroll Wheel


type ScrollItem
    = MatchRow ( MatchID, AnswerGroupMatch )
    | GroupBoundary Group


buildScrollItems : List ( MatchID, AnswerGroupMatch ) -> List ScrollItem
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
                        go (Just grp) rest (MatchRow item :: GroupBoundary grp :: acc)

                    else
                        go (Just grp) rest (MatchRow item :: acc)
    in
    go Nothing matches []


viewScrollWheel : Bet -> State -> Element.Element Msg
viewScrollWheel bet state =
    let
        allMatches =
            bet.answers.matches

        allMatchIDs =
            List.map Tuple.first allMatches

        cursorIdx =
            List.Extra.findIndex (\mId -> mId == state.cursor) allMatchIDs
                |> Maybe.withDefault 0

        total =
            List.length allMatches

        startIdx =
            max 0 (cursorIdx - 2)

        endIdx =
            min (total - 1) (cursorIdx + 2)

        visibleMatches =
            List.indexedMap Tuple.pair allMatches
                |> List.filterMap
                    (\( i, m ) ->
                        if i >= startIdx && i <= endIdx then
                            Just m

                        else
                            Nothing
                    )

        scrollItems =
            buildScrollItems visibleMatches

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
                    (Json.Decode.map (\y -> ( TouchEnd y, True ))
                        (Json.Decode.at [ "changedTouches", "0", "clientY" ] Json.Decode.float)
                    )
                )
    in
    Element.column
        [ centerX, spacing 2, touchStartAttr, touchEndAttr ]
        (List.map (viewScrollItem state.cursor) scrollItems)


viewScrollItem : MatchID -> ScrollItem -> Element.Element Msg
viewScrollItem cursor item =
    case item of
        MatchRow matchData ->
            viewScrollLine cursor matchData

        GroupBoundary grp ->
            Element.el
                [ centerX, Font.color Color.grey, UI.Font.mono ]
                (Element.text ("-- " ++ G.toString grp ++ " --"))


viewScrollLine : MatchID -> ( MatchID, AnswerGroupMatch ) -> Element.Element Msg
viewScrollLine cursor ( answerId, Answer (GroupMatch _ match mScore) _ ) =
    let
        home =
            String.padRight 4 ' ' (M.homeTeam match |> T.display)

        away =
            String.padRight 4 ' ' (M.awayTeam match |> T.display)

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
            if isActive || isCompleted then
                Color.white

            else
                Color.grey

        scoreColor =
            if isCompleted then
                Color.green

            else if isActive then
                Color.orange

            else
                Color.grey

        prefixStr =
            if isActive then
                "  >  "

            else
                "     "

        prefixColor =
            if isActive then
                Color.orange

            else
                Color.grey

        suffixEl =
            if isActive then
                Element.el [ Font.color Color.orange, UI.Font.mono ] (Element.text "  <")

            else
                Element.none

        mkEl clr str =
            Element.el [ Font.color clr, UI.Font.mono ] (Element.text str)
    in
    Element.el
        [ Element.Events.onClick (SelectMatch answerId)
        , Element.pointer
        , height (px 44)
        , centerY
        ]
        (Element.row [ spacing 0, centerY ]
            [ mkEl prefixColor prefixStr
            , mkEl textColor home
            , mkEl Color.grey "  "
            , mkEl scoreColor scoreStr
            , mkEl Color.grey "  "
            , mkEl textColor away
            , suffixEl
            ]
        )



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
    Element.el [ centerX, Font.color Color.grey, UI.Font.mono ]
        (Element.text (String.fromInt completed ++ "/" ++ String.fromInt total))



-- Score Input


viewInput :
    a
    -> MatchID
    -> Team
    -> Team
    -> Maybe Score
    -> Element.Element Msg
viewInput _ matchID homeTeam awayTeam mScore =
    let
        makeAction act val =
            case String.toInt val of
                Just v ->
                    act v

                Nothing ->
                    NoOp

        inputField v act =
            let
                inp =
                    { onChange = makeAction act
                    , text = v
                    , label = Input.labelHidden ".."
                    , placeholder = Just (Input.placeholder [] (Element.text v))
                    }
            in
            Input.text
                (UI.Style.scoreInput
                    [ width (px 60)
                    , Border.rounded 0
                    , Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")
                    ]
                )
                inp

        wrap fld =
            Element.el (UI.Style.wrapper [ centerX, centerY ]) fld

        extractScore extractor =
            mScore
                |> Maybe.andThen extractor
                |> Maybe.map String.fromInt
                |> Maybe.withDefault ""

        homeInput =
            inputField (extractScore S.homeScore) (UpdateHome matchID)
                |> wrap

        awayInput =
            inputField (extractScore S.awayScore) (UpdateAway matchID)
                |> wrap

        homeBadge =
            Element.el [ Font.color Color.white, UI.Font.mono, Font.size (UI.Font.scaled 1), centerY ]
                (Element.text (T.display homeTeam))

        awayBadge =
            Element.el [ Font.color Color.white, UI.Font.mono, Font.size (UI.Font.scaled 1), centerY ]
                (Element.text (T.display awayTeam))
    in
    Element.row (UI.Style.activeMatch [ centerX, paddingXY 4 16, spacing 8 ])
        [ Element.el [ Font.color Color.orange, UI.Font.mono, centerY ] (Element.text ">")
        , homeBadge
        , homeInput
        , Element.el [ Font.color Color.grey, UI.Font.mono, centerY ] (Element.text "-")
        , awayInput
        , awayBadge
        ]


viewKeyboard : MatchID -> Element.Element Msg
viewKeyboard matchId =
    UI.Button.Score.viewKeyboard NoOp (Update matchId)
