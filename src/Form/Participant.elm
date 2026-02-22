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
            [ "Naam", "Adres", "Woonplaats", "Email", "Telefoonnummer", "Waar ken je ons van?" ]

        values p =
            [ p.name, p.address, p.residence, p.email, p.phone, p.howyouknowus ]

        inputField tag ( k, ( lbl, sf ) ) =
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
                    , placeholder = Nothing
                    }
            in
            Element.column [ Element.spacing 4, width fill ]
                [ Element.row [ Element.spacing 8 ]
                    [ Element.el
                        [ Element.width (px 16)
                        , Font.color promptColor
                        , UI.Font.mono
                        ]
                        (Element.text promptChar)
                    , Element.el
                        [ Font.color promptColor
                        , UI.Font.mono
                        , Font.size (UI.Font.scaled 1)
                        ]
                        (Element.text lbl)
                    ]
                , Element.el
                    [ paddingEach { left = 24, top = 0, bottom = 0, right = 0 } ]
                    (Element.Input.text
                        (UI.Style.terminalInput hasError
                            [ width fill
                            , Element.htmlAttribute (Html.Events.onFocus (FocusField tag))
                            , Element.htmlAttribute (Html.Events.onBlur BlurField)
                            ]
                        )
                        inp
                    )
                ]

        lines =
            values bet.participant
                |> List.map2 Tuple.pair labels
                |> List.map2 Tuple.pair keys
                |> List.map2 (\tag ( k, ( lbl, sf ) ) -> inputField tag ( k, ( lbl, sf ) )) fieldTags

        header =
            UI.Text.displayHeader "Wie ben jij"

        introduction =
            Element.paragraph (UI.Style.introduction [ width fill, spacing 7 ])
                [ UI.Text.simpleText """Graag volledig invullen, zodat wij je goed kunnen bereiken als je gewonnen hebt."""
                ]
    in
    page "participant"
        (header :: introduction :: lines)


isComplete : Bet -> Bool
isComplete bet =
    Bets.Types.Participant.isComplete bet.participant
