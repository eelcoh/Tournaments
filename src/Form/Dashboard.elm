module Form.Dashboard exposing (view)

import Bets.Types exposing (Answer(..))
import Bets.Types.Answer.GroupMatch as GroupMatch
import Bets.Types.StringField as StringField
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
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

        -- Count filled group matches for progress text
        totalGroupMatches =
            List.length model.bet.answers.matches

        filledGroupMatches =
            model.bet.answers.matches
                |> List.map Tuple.second
                |> List.filter GroupMatch.isComplete
                |> List.length

        groupProgress =
            String.fromInt filledGroupMatches ++ "/" ++ String.fromInt totalGroupMatches

        -- Topscorer name for progress text
        topscorerProgress =
            case model.bet.answers.topscorer of
                Answer ( Just name, _ ) _ ->
                    name

                _ ->
                    ""

        -- Participant name for progress text
        participantProgress =
            let
                name =
                    StringField.value model.bet.participant.name
            in
            if String.trim name /= "" then
                name

            else
                ""

        indicator sectionIdx complete =
            if model.idx == sectionIdx then
                ( "[.]", Color.activeNav )

            else if complete then
                ( "[x]", Color.green )

            else
                ( "[ ]", Color.terminalBorder )

        sectionCard targetIdx name desc progress complete =
            let
                ( indText, indColor ) =
                    indicator targetIdx complete
            in
            Element.el
                [ Element.Events.onClick (NavigateTo targetIdx)
                , Element.pointer
                , Element.width Element.fill
                , Background.color Color.primaryDark
                , Border.color Color.terminalBorder
                , Border.width 1
                , Element.mouseOver
                    [ Border.color Color.activeNav
                    , Background.color (Element.rgb255 0x3A 0x3A 0x3A)
                    ]
                , Element.padding 13
                ]
                (Element.row
                    [ Element.width Element.fill
                    , Element.spacing 12
                    , UI.Font.mono
                    ]
                    [ -- Status indicator
                      Element.el
                        [ Font.color indColor
                        , Element.width (Element.px 28)
                        , Font.size 13
                        ]
                        (Element.text indText)

                    -- Name + description
                    , Element.column
                        [ Element.spacing 2
                        , Element.width Element.fill
                        ]
                        [ Element.el
                            [ Font.color Color.white
                            , Font.size 12
                            ]
                            (Element.text name)
                        , Element.el
                            [ Font.color Color.grey
                            , Font.size 10
                            ]
                            (Element.text desc)
                        ]

                    -- Progress text
                    , Element.el
                        [ Font.color Color.grey
                        , Font.size 10
                        , Element.alignRight
                        ]
                        (Element.text progress)

                    -- Arrow
                    , Element.el
                        [ Font.color Color.activeNav
                        , Font.size 12
                        ]
                        (Element.text ">")
                    ]
                )

        introBadge =
            Element.el
                [ Border.widthEach { left = 2, right = 0, top = 0, bottom = 0 }
                , Border.color Color.activeNav
                , Element.paddingEach { left = 14, right = 14, top = 10, bottom = 10 }
                , Background.color (Element.rgba255 0xF0 0xA0 0x30 0x0A)
                , Element.width Element.fill
                ]
                (Element.el
                    [ Font.color Color.grey
                    , Font.size 11
                    , UI.Font.mono
                    ]
                    (Element.text "Vul je voorspellingen in voor het WK 2026.\nJe kunt de onderdelen in elke volgorde invullen.")
                )

        allDoneBanner =
            if allComplete then
                Element.el
                    [ Border.color Color.green
                    , Border.width 1
                    , Background.color (Element.rgba255 0x7F 0x9F 0x7F 0x12)
                    , Element.width Element.fill
                    , Element.padding 12
                    ]
                    (Element.el
                        [ Font.color Color.green
                        , Font.size 11
                        , UI.Font.mono
                        , Element.centerX
                        ]
                        (Element.text "[ Alle onderdelen ingevuld — klaar om te verzenden ]")
                    )

            else
                Element.none
    in
    UI.Page.page "dashboard"
        [ UI.Text.displayHeader "overzicht"
        , introBadge
        , Element.column
            [ Element.width Element.fill
            , Element.spacing 6
            ]
            [ sectionCard groupIdx "Groepsfase" "36 wedstrijden in 12 groepen" groupProgress groupsComplete
            , sectionCard bracketIdx "Knock-out schema" "Van R32 naar wereldkampioen" "" bracketComplete
            , sectionCard topscorerIdx "Topscorer" "Wie scoort de meeste doelpunten?" topscorerProgress topscorerComplete
            , sectionCard participantIdx "Deelnemer" "Jouw naam en contactgegevens" participantProgress participantComplete
            ]
        , allDoneBanner
        ]


findCardIndex : (Card -> Bool) -> Model Msg -> Maybe Int
findCardIndex pred model =
    List.indexedMap Tuple.pair model.cards
        |> List.filter (Tuple.second >> pred)
        |> List.head
        |> Maybe.map Tuple.first
