module Bets.Types.Team exposing
    ( decode
    , display
    , displayFull
    , encode
    , encodeMaybe
    , equal
    , flagUrl
    , isComplete
    , log
    , mdisplay
    , mdisplayFull
    , mdisplayID
    , team
    )

import Bets.Types exposing (Group(..), Team, TeamID)
import Json.Decode exposing (Decoder)
import Json.Encode
import Maybe.Extra as M


team : TeamID -> String -> Team
team teamID teamName =
    Team teamID teamName


display : Team -> String
display t =
    t.teamID


displayFull : Team -> String
displayFull t =
    t.teamName


equal : Team -> Team -> Bool
equal t1 t2 =
    (t1.teamID == t2.teamID) && (t1.teamName == t2.teamName)


mdisplayFull : Maybe Team -> String
mdisplayFull mteam =
    Maybe.map displayFull mteam
        |> Maybe.withDefault ""


mdisplay : Maybe Team -> String
mdisplay mteam =
    Maybe.map display mteam
        |> Maybe.withDefault ""


mdisplayID : Maybe Team -> String
mdisplayID mteam =
    Maybe.map .teamID mteam
        |> Maybe.withDefault "..."


log : Team -> String
log t =
    t.teamName



-- flag : Maybe Team -> Html msg
-- flag mteam =
--     let
-- --         uri t =
--             flagUri 2 ++ t.teamID ++ ".png"
--         default =
--             team "xyz" ""
--     in
--     case mteam of
--         Nothing ->
--             img [ src (uri default) ] []
--         Just t ->
--             img [ src (uri t) ] []


flagUrlRound : String -> String
flagUrlRound teamID =
    let
        mkflagurl ctry =
            "assets/svg/" ++ ctry
    in
    case teamID of
        "ALB" ->
            mkflagurl "099-albania.svg"

        "ARG" ->
            mkflagurl "198-argentina.svg"

        "AUS" ->
            mkflagurl "234-australia.svg"

        "AUT" ->
            mkflagurl "003-austria.svg"

        "BEL" ->
            mkflagurl "165-belgium.svg"

        "BRA" ->
            mkflagurl "255-brazil.svg"

        "BOS" ->
            mkflagurl "132-bosnia-and-herzegovina.svg"

        "CAM" ->
            mkflagurl "105-cameroon.svg"

        "CAN" ->
            mkflagurl "243-canada.svg"

        "CRC" ->
            mkflagurl "156-costa-rica.svg"

        "CRO" ->
            mkflagurl "164-croatia.svg"

        "CZE" ->
            mkflagurl "149-czech-republic.svg"

        "DEN" ->
            mkflagurl "174-denmark.svg"

        "ECU" ->
            mkflagurl "104-ecuador.svg"

        "ENG" ->
            mkflagurl "216-england.svg"

        "ESP" ->
            mkflagurl "128-spain.svg"

        "EST" ->
            mkflagurl "008-estonia.svg"

        "FRA" ->
            mkflagurl "195-france.svg"

        "FIN" ->
            mkflagurl "125-finland.svg"

        "GER" ->
            mkflagurl "162-germany.svg"

        "GEO" ->
            mkflagurl "256-georgia.svg"

        "GHA" ->
            mkflagurl "053-ghana.svg"

        "GRE" ->
            mkflagurl "170-greece.svg"

        "HUN" ->
            mkflagurl "115-hungary.svg"

        "ICE" ->
            mkflagurl "080-iceland.svg"

        "IRN" ->
            mkflagurl "136-iran.svg"

        "ISR" ->
            mkflagurl "155-israel.svg"

        "ITA" ->
            mkflagurl "013-italy.svg"

        "JPN" ->
            mkflagurl "063-japan.svg"

        "KAZ" ->
            mkflagurl "074-kazakhstan.svg"

        "KOR" ->
            mkflagurl "094-south-korea.svg"

        "KSA" ->
            mkflagurl "133-saudi-arabia.svg"

        "LUX" ->
            mkflagurl "035-luxembourg.svg"

        "MAC" ->
            mkflagurl "236-republic-of-macedonia.svg"

        "MAR" ->
            mkflagurl "166-morocco.svg"

        "MEX" ->
            mkflagurl "252-mexico.svg"

        "NED" ->
            mkflagurl "237-netherlands.svg"

        "POL" ->
            mkflagurl "211-poland.svg"

        "POR" ->
            mkflagurl "224-portugal.svg"

        "QAT" ->
            mkflagurl "026-qatar.svg"

        "ROM" ->
            mkflagurl "109-romania.svg"

        "RUS" ->
            mkflagurl "248-russia.svg"

        "SCO" ->
            mkflagurl "055-scotland.svg"

        "SEN" ->
            mkflagurl "227-senegal.svg"

        "SLO" ->
            mkflagurl "010-slovenia.svg"

        "SRB" ->
            mkflagurl "071-serbia.svg"

        "SUI" ->
            mkflagurl "205-switzerland.svg"

        "SVK" ->
            mkflagurl "091-slovakia.svg"

        "TUN" ->
            mkflagurl "049-tunisia.svg"

        "TUR" ->
            mkflagurl "218-turkey.svg"

        "UKR" ->
            mkflagurl "145-ukraine.svg"

        "URU" ->
            mkflagurl "088-uruguay.svg"

        "USA" ->
            mkflagurl "226-united-states.svg"

        "WAL" ->
            mkflagurl "014-wales.svg"

        _ ->
            "assets/svg/404.svg"


flagUrl : Maybe Team -> String
flagUrl mteam =
    let
        uri t =
            flagUrlRound t.teamID

        default =
            team "xyz" ""
    in
    case mteam of
        Nothing ->
            uri default

        Just t ->
            uri t



-- flagUri : Int -> String
-- flagUri size =
--     if (size > 5) || (size < 0) then
--         "http://img.fifa.com/images/flags/3/"
--     else
--         "http://img.fifa.com/images/flags/" ++ String.fromInt size ++ "/"


isComplete : Maybe Team -> Bool
isComplete mTeam =
    M.isJust mTeam


decode : Decoder Team
decode =
    Json.Decode.map2 Team
        (Json.Decode.field "teamID" Json.Decode.string)
        (Json.Decode.field "teamName" Json.Decode.string)


encodeMaybe : Maybe Team -> Json.Encode.Value
encodeMaybe mTeam =
    case mTeam of
        Just t ->
            encode t

        Nothing ->
            Json.Encode.null


encode : Team -> Json.Encode.Value
encode t =
    Json.Encode.object
        [ ( "teamID", Json.Encode.string t.teamID )
        , ( "teamName", Json.Encode.string t.teamName )
        ]
