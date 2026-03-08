module Form.Dashboard exposing (view)

import Element exposing (Element)
import Element.Events
import Element.Font as Font
import Form.Bracket
import Form.GroupMatches
import Form.Participant
import Form.Topscorer
import Types exposing (Card(..), Model, Msg(..))
import UI.Color as Color
import UI.Font
import UI.Page
import UI.Text


view : Model Msg -> Element Msg
view model =
    let
        groupIdx =
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

        bracketIdx =
            findCardIndex
                (\c ->
                    case c of
                        BracketCard _ ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 2

        topscorerIdx =
            findCardIndex
                (\c ->
                    case c of
                        TopscorerCard ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 3

        participantIdx =
            findCardIndex
                (\c ->
                    case c of
                        ParticipantCard _ ->
                            True

                        _ ->
                            False
                )
                model
                |> Maybe.withDefault 4

        groupsComplete =
            Form.GroupMatches.isComplete model.bet

        bracketComplete =
            Form.Bracket.isCompleteQualifiers model.bet

        topscorerComplete =
            Form.Topscorer.isComplete model.bet

        participantComplete =
            Form.Participant.isComplete model.bet

        allComplete =
            groupsComplete && bracketComplete && topscorerComplete && participantComplete

        indicator sectionIdx complete =
            if model.idx == sectionIdx then
                "[.]"

            else if complete then
                "[x]"

            else
                "[ ]"

        sectionRow targetIdx ind label =
            Element.el
                [ Element.Events.onClick (NavigateTo targetIdx)
                , Element.pointer
                , Element.height (Element.px 44)
                , Element.width Element.fill
                ]
                (Element.row
                    [ Element.spacing 12
                    , Element.centerY
                    , Font.color Color.orange
                    , UI.Font.mono
                    ]
                    [ Element.el [ Element.width (Element.px 14) ] (Element.text ">")
                    , Element.el [ Element.width (Element.px 100) ] (Element.text label)
                    , Element.el [] (Element.text ind)
                    ]
                )

        klaarLine =
            if allComplete then
                Element.el
                    [ Font.color Color.green
                    , UI.Font.mono
                    , Element.paddingEach { top = 8, right = 0, bottom = 0, left = 0 }
                    ]
                    (Element.text "  klaar om in te zenden")

            else
                Element.none
    in
    UI.Page.page "dashboard"
        [ UI.Text.displayHeader "overzicht"
        , Element.column
            [ Element.width Element.fill
            , Element.spacing 0
            ]
            [ sectionRow groupIdx (indicator groupIdx groupsComplete) "groepen"
            , sectionRow bracketIdx (indicator bracketIdx bracketComplete) "schema"
            , sectionRow topscorerIdx (indicator topscorerIdx topscorerComplete) "topscorer"
            , sectionRow participantIdx (indicator participantIdx participantComplete) "inzenden"
            , klaarLine
            ]
        ]


findCardIndex : (Card -> Bool) -> Model Msg -> Maybe Int
findCardIndex pred model =
    List.indexedMap Tuple.pair model.cards
        |> List.filter (Tuple.second >> pred)
        |> List.head
        |> Maybe.map Tuple.first
