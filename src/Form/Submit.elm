module Form.Submit exposing (view)

import Bets.Types exposing (Answer(..), Bet, StringField(..))
import Bets.Types.Answer.GroupMatch as GroupMatch
import Element exposing (centerX, fill, paddingXY, px, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Form.Bracket
import Form.GroupMatches
import Form.Participant
import Form.Topscorer
import Html.Attributes
import RemoteData exposing (RemoteData(..))
import Types exposing (Card(..), Info(..), InputState(..), Model, Msg(..))
import UI.Color as Color
import UI.Font
import UI.Page exposing (page)
import UI.Screen as Screen
import UI.Style exposing (ButtonSemantics(..))


view : Model Msg -> Bool -> Element.Element Msg
view model submittable =
    let
        btn =
            viewSubmitButton submittable model.savedBet model.betState

        extraContent =
            case ( submittable, model.savedBet, model.betState ) of
                ( _, Success _, Clean ) ->
                    [ introSubmitted ]

                ( _, Failure _, _ ) ->
                    [ introSubmittedErr ]

                ( _, Loading, _ ) ->
                    [ introSubmitting ]

                _ ->
                    []
    in
    page "submit"
        ([ viewSummaryBox model.bet
         , btn
         , viewIncompleteNote submittable model.savedBet
         ]
            ++ extraContent
        )


viewSummaryBox : Bet -> Element.Element Msg
viewSummaryBox bet =
    let
        -- Groepswedstrijden
        filledMatches =
            bet.answers.matches
                |> List.filter (\( _, gm ) -> GroupMatch.isComplete gm)
                |> List.length

        gmValue =
            String.fromInt filledMatches ++ "/48"

        gmColor =
            if Form.GroupMatches.isComplete bet then
                Color.green

            else
                Color.red

        -- Knock-out schema
        bracketComplete =
            Form.Bracket.isCompleteQualifiers bet

        bracketValue =
            if bracketComplete then
                "volledig"

            else
                "onvolledig"

        bracketColor =
            if bracketComplete then
                Color.green

            else
                Color.red

        -- Topscorer
        topscorerComplete =
            Form.Topscorer.isComplete bet

        topscorerValue =
            case bet.answers.topscorer of
                Answer topscorer _ ->
                    case topscorer of
                        ( Just name, _ ) ->
                            name

                        _ ->
                            "\u{2014}"

        topscorerColor =
            if topscorerComplete then
                Color.green

            else
                Color.red

        -- Naam
        naamValue =
            case bet.participant.name of
                Initial s ->
                    if s == "" then
                        "\u{2014}"

                    else
                        s

                Changed s ->
                    s

                Error s ->
                    s

        naamColor =
            case bet.participant.name of
                Changed _ ->
                    Color.green

                _ ->
                    Color.red

        -- E-mail
        emailValue =
            case bet.participant.email of
                Initial s ->
                    if s == "" then
                        "\u{2014}"

                    else
                        s

                Changed s ->
                    s

                Error s ->
                    s

        emailColor =
            case bet.participant.email of
                Changed _ ->
                    Color.green

                _ ->
                    Color.red

        -- Row builder
        summaryRow : String -> String -> Element.Color -> Element.Element Msg
        summaryRow lbl val clr =
            Element.row
                [ width fill
                , Element.paddingXY 0 8
                , Element.spacing 8
                ]
                [ Element.el
                    [ Font.color Color.grey
                    , UI.Font.mono
                    , Font.size 11
                    ]
                    (Element.text lbl)
                , Element.el
                    [ Font.color clr
                    , UI.Font.mono
                    , Font.size 11
                    , Element.alignRight
                    ]
                    (Element.text val)
                ]

        rows =
            [ summaryRow "groepswedstrijden" gmValue gmColor
            , summaryRow "knock-out schema" bracketValue bracketColor
            , summaryRow "topscorer" topscorerValue topscorerColor
            , summaryRow "naam" naamValue naamColor
            , summaryRow "e-mail" emailValue emailColor
            ]

        divider =
            Element.el
                [ width fill
                , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
                , Border.color Color.terminalBorder
                , Element.height (px 1)
                ]
                Element.none

        rowsWithDividers =
            List.intersperse divider rows
    in
    Element.column
        [ Border.width 1
        , Border.color Color.terminalBorder
        , Background.color Color.black
        , width fill
        , Element.padding 12
        ]
        rowsWithDividers


viewSubmitButton : Bool -> RemoteData.WebData Bet -> InputState -> Element.Element Msg
viewSubmitButton submittable savedBet betState =
    case ( submittable, savedBet, betState ) of
        ( _, Success _, Clean ) ->
            -- Submitted state: green restart button
            Element.Input.button
                [ width fill
                , paddingXY 0 15
                , Background.color Color.green
                , Font.color Color.black
                , Font.size 13
                , UI.Font.mono
                , Font.letterSpacing 0.14
                ]
                { onPress = Just Restart
                , label = Element.el [ centerX ] (Element.text "[ VERZONDEN ]")
                }

        ( _, Success _, Dirty ) ->
            -- Saved but modified: amber submit button
            Element.Input.button
                [ width fill
                , paddingXY 0 15
                , Background.color Color.activeNav
                , Font.color Color.black
                , Font.size 13
                , UI.Font.mono
                , Font.letterSpacing 0.14
                , Element.mouseOver [ Background.color Color.orange ]
                ]
                { onPress = Just SubmitMsg
                , label = Element.el [ centerX ] (Element.text "[ INZENDEN ]")
                }

        ( _, Loading, _ ) ->
            -- Loading: inactive grey button
            Element.Input.button
                [ width fill
                , paddingXY 0 15
                , Background.color Color.terminalBorder
                , Font.color Color.grey
                , Font.size 13
                , UI.Font.mono
                , Font.letterSpacing 0.14
                , Element.htmlAttribute (Html.Attributes.style "cursor" "not-allowed")
                ]
                { onPress = Nothing
                , label = Element.el [ centerX ] (Element.text "[ VERZENDEN... ]")
                }

        ( True, _, Dirty ) ->
            -- Submittable: amber active button
            Element.Input.button
                [ width fill
                , paddingXY 0 15
                , Background.color Color.activeNav
                , Font.color Color.black
                , Font.size 13
                , UI.Font.mono
                , Font.letterSpacing 0.14
                , Element.mouseOver [ Background.color Color.orange ]
                ]
                { onPress = Just SubmitMsg
                , label = Element.el [ centerX ] (Element.text "[ INZENDEN ]")
                }

        _ ->
            -- Not submittable: inactive grey button
            Element.Input.button
                [ width fill
                , paddingXY 0 15
                , Background.color Color.terminalBorder
                , Font.color Color.grey
                , Font.size 13
                , UI.Font.mono
                , Font.letterSpacing 0.14
                , Element.htmlAttribute (Html.Attributes.style "cursor" "not-allowed")
                ]
                { onPress = Nothing
                , label = Element.el [ centerX ] (Element.text "[ INZENDEN ]")
                }


viewIncompleteNote : Bool -> RemoteData.WebData Bet -> Element.Element Msg
viewIncompleteNote submittable savedBet =
    case savedBet of
        Success _ ->
            Element.none

        _ ->
            if submittable then
                Element.none

            else
                Element.el
                    [ Font.size 10
                    , Font.color Color.grey
                    , UI.Font.mono
                    , centerX
                    ]
                    (Element.text "Vul alle verplichte onderdelen in om te verzenden.")


introSubmitting : Element.Element Msg
introSubmitting =
    Element.paragraph (UI.Style.introduction []) [ Element.text "Het formulier is compleet. Klik op inzenden om het in te sturen. Verzenden...." ]


introSubmitted : Element.Element Msg
introSubmitted =
    Element.paragraph (UI.Style.introduction [])
        [ Element.text "Dank voor het meedoen! Neem contact op met Arnaud of Eelco over het overmaken dan wel inleveren van de 5 euro inlegkosten."
        , Element.text "Misschien wil je nog een keer meedoen? Vul dan gewoon het "
        , Element.link (UI.Style.introduction []) { url = "/voetbalpool/formulier", label = Element.text "formulier" }
        , Element.text " opnieuw in."
        ]


introSubmittedErr : Element.Element Msg
introSubmittedErr =
    Element.paragraph (UI.Style.introduction []) [ Element.text "Whoops! Daar ging iets niet goed. " ]
