module Form.Participant exposing
    ( isComplete
    , update
    , view
    )

import Bets.Bet exposing (setParticipant)
import Bets.Types exposing (Bet, StringField(..))
import Bets.Types.Participant
import Bets.Types.StringField as StringField
import Element exposing (centerX, fill, height, paddingEach, paddingXY, px, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Email
import Form.Participant.Types exposing (Attr(..), FieldTag(..), Msg(..), State)
import Html.Events
import UI.Color as Color
import UI.Font
import UI.Page exposing (page)
import UI.Screen as Screen
import UI.Style
import UI.Text


update : Msg -> State -> Bet -> ( Bet, State, Cmd Msg )
update msg state bet =
    let
        toStringField s =
            if s == "" then
                Error s

            else
                Changed s

        toStringEmailField s =
            if Email.isValid s then
                Changed s

            else
                Error s

        newParticipant attr participant =
            case attr of
                Name n ->
                    { participant | name = toStringField n }

                Postal a ->
                    { participant | address = toStringField a }

                Residence e ->
                    { participant | residence = toStringField e }

                Email e ->
                    { participant | email = toStringEmailField e }

                Phone p ->
                    { participant | phone = toStringField p }

                Knows h ->
                    { participant | howyouknowus = toStringField h }

        newBet attr participant =
            newParticipant attr participant
                |> setParticipant bet
    in
    case msg of
        Set attr ->
            let
                newNewBet =
                    newBet attr bet.participant
            in
            ( newNewBet, state, Cmd.none )

        FocusField tag ->
            ( bet, { state | activeField = Just tag }, Cmd.none )

        BlurField ->
            ( bet, { state | activeField = Nothing }, Cmd.none )


view : State -> Bet -> Element.Element Msg
view state bet =
    let
        keys =
            [ Name, Postal, Residence, Email, Phone, Knows ]

        fieldTags =
            [ NameTag, PostalTag, ResidenceTag, EmailTag, PhoneTag, KnowsTag ]

        labels =
            [ "Naam", "Adres", "Woonplaats", "Email", "Telefoonnummer", "Hoe ken je ons?" ]

        placeholders =
            [ "jouw naam", "adres", "woonplaats", "naam@voorbeeld.nl", "+31 6 ...", "hoe ken je ons?" ]

        values p =
            [ p.name, p.address, p.residence, p.email, p.phone, p.howyouknowus ]

        inputField tag ( k, ( ( lbl, placeholder ), sf ) ) =
            let
                ( stringVal, hasError ) =
                    case sf of
                        Initial s ->
                            ( s, False )

                        Changed s ->
                            ( s, False )

                        Error s ->
                            ( s, True )

                isActive =
                    state.activeField == Just tag

                borderColor =
                    if hasError then
                        Color.red

                    else if isActive then
                        Color.orange

                    else
                        Color.terminalBorder

                promptChar =
                    if hasError then
                        "!"

                    else if isActive then
                        ">"

                    else
                        "-"

                promptColor =
                    if hasError then
                        Color.red

                    else if isActive then
                        Color.orange

                    else
                        Color.grey

                inp =
                    { onChange = \val -> Set (k val)
                    , text = stringVal
                    , label = Element.Input.labelHidden lbl
                    , placeholder = Just (Element.Input.placeholder [ Font.color Color.grey, UI.Font.mono ] (Element.text placeholder))
                    }

                labelEl =
                    Element.el
                        [ Font.size 9
                        , Font.color Color.grey
                        , Font.letterSpacing 0.14
                        , UI.Font.mono
                        ]
                        (Element.text (String.toUpper lbl))

                borderedContainer =
                    Element.row
                        [ Border.width 1
                        , Border.color borderColor
                        , Element.padding 8
                        , width fill
                        , Element.spacing 8
                        , Background.color Color.black
                        ]
                        [ Element.el
                            [ Font.color promptColor
                            , UI.Font.mono
                            , Element.width (px 12)
                            ]
                            (Element.text promptChar)
                        , Element.Input.text
                            (UI.Style.terminalInput hasError
                                [ width fill
                                , Element.htmlAttribute (Html.Events.onFocus (FocusField tag))
                                , Element.htmlAttribute (Html.Events.onBlur BlurField)
                                ]
                            )
                            inp
                        ]
            in
            Element.column [ Element.spacing 4, width fill ]
                [ labelEl
                , borderedContainer
                ]

        lines =
            values bet.participant
                |> List.map2 Tuple.pair placeholders
                |> List.map2 Tuple.pair labels
                |> List.map2 Tuple.pair keys
                |> List.map2 (\tag ( k, ( lbl, ( placeholder, sf ) ) ) -> inputField tag ( k, ( ( lbl, placeholder ), sf ) )) fieldTags

        header =
            UI.Text.displayHeader "Wie ben jij"

        introduction =
            Element.paragraph (UI.Style.introduction [ width fill, spacing 7 ])
                [ UI.Text.simpleText """Graag volledig invullen, zodat wij je goed kunnen bereiken als je gewonnen hebt."""
                ]
    in
    page "participant"
        (header :: introduction :: [ Element.column [ Element.spacing 12, width fill ] lines ])


isComplete : Bet -> Bool
isComplete bet =
    Bets.Types.Participant.isComplete bet.participant
