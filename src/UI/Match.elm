module UI.Match exposing (..)

-- import UI.Color as Color

import Bets.Types exposing (Match, Score)
import Bets.Types.Match as Match
import Element exposing (centerX, centerY, height, padding, paddingXY, px, spaceEvenly, spacing, width)
import Element.Border as Border
import Types exposing (Msg(..))
import UI.Button.Score exposing (displayScore)
import UI.Font
import UI.Style
import UI.Team


display : Match -> Maybe Score -> Element.Attribute msg -> UI.Style.ButtonSemantics -> Element.Element msg
display match_ mScore handler semantics =
    let
        home =
            UI.Team.viewTeamSmall (Match.homeTeam match_)

        away =
            UI.Team.viewTeamSmall (Match.awayTeam match_)

        sc =
            displayScore mScore

        style =
            UI.Style.matchRow semantics
                [ handler
                , UI.Font.button
                , Element.centerY
                , width (px 160)
                , height (px 100)
                ]
    in
    Element.row style
        [ home, sc, away ]


displayFullRow : Match -> Maybe Score -> Element.Attribute msg -> UI.Style.ButtonSemantics -> Element.Element msg
displayFullRow match_ mScore handler semantics =
    let
        home =
            UI.Team.viewTeamSmallHorizontal UI.Style.DLeft (Match.homeTeam match_)

        away =
            UI.Team.viewTeamSmallHorizontal UI.Style.DRight (Match.awayTeam match_)

        sc =
            displayScore mScore

        style =
            UI.Style.matchRow semantics
                [ handler
                , UI.Font.button
                , Element.centerY
                , width (px 300)
                , height (px 50)
                , spaceEvenly
                ]
    in
    Element.row style
        [ home, sc, away ]
