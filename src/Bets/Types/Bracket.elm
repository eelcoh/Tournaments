module Bets.Types.Bracket exposing
    ( candidatesForSlot
    , candidatesForTeamNode
    , decode
    , decodeFlat
    , decodeUnifiedEntries
    , decodeWinner
    , display
    , encode
    , encodeFlat
    , encodeFlatList
    , get
    , getFreeSlots
    , getQualifiers
    , hasQualified
    , isComplete
    , isCompleteQualifiers
    , proceed
    , proceedAway
    , proceedHome
    , qualifier
    , set
    , setBulk
    , unsetQualifier
    , winner
    )

import Bets.Types exposing (Bracket(..), Candidate, CurrentSlot(..), Group, HasQualified(..), Qualifier, Round, Selection, Slot, Team, Winner(..))
import Bets.Types.Candidate as C
import Bets.Types.HasQualified as HasQualified
import Bets.Types.Round as R
import Bets.Types.Team as T
import Dict exposing (Dict)
import Json.Decode exposing (Decoder, fail, field, lazy, maybe)
import Json.Encode
import Maybe.Extra as M
import Set


hasQualified : Bracket -> HasQualified
hasQualified br =
    case br of
        MatchNode slot w home away rnd hasQ ->
            hasQ

        TeamNode slot pos qual hasQ ->
            hasQ


reset : Bracket -> Qualifier -> Bracket
reset newBracket prevWinner =
    case newBracket of
        MatchNode slot w home away rnd hasQ ->
            let
                currentWinner =
                    winner newBracket

                newWinner =
                    if currentWinner == prevWinner then
                        w

                    else
                        None
            in
            -- should really reassess hasQ, but not necessary now since it can only be TBD
            MatchNode slot newWinner home away rnd hasQ

        TeamNode slot pos qual hasQ ->
            TeamNode slot pos qual hasQ


proceedHome : Bracket -> Slot -> Bracket
proceedHome bracket slot =
    proceed bracket slot HomeTeam


proceedAway : Bracket -> Slot -> Bracket
proceedAway bracket slot =
    proceed bracket slot AwayTeam


proceed : Bracket -> Slot -> Winner -> Bracket
proceed bracket slot wnnr =
    case bracket of
        MatchNode s w home away rnd hasQ ->
            if s == slot then
                -- should really reassess hasQ, but not necessary now since it can only be TBD
                MatchNode slot wnnr home away rnd hasQ

            else
                let
                    newLeft =
                        proceed home slot wnnr

                    newRight =
                        proceed away slot wnnr

                    currentWinner =
                        winner bracket

                    -- should really reassess hasQ, but not necessary now since it can only be TBD
                    newBracket =
                        MatchNode s w newLeft newRight rnd hasQ
                in
                reset newBracket currentWinner

        _ ->
            bracket


winner : Bracket -> Qualifier
winner bracket =
    case bracket of
        MatchNode _ w home away _ _ ->
            case w of
                HomeTeam ->
                    winner home

                AwayTeam ->
                    winner away

                None ->
                    Nothing

        TeamNode _ _ qual _ ->
            qual


set : Bracket -> Slot -> Qualifier -> Bracket
set bracket slot qual =
    case bracket of
        MatchNode s w home away round hasQ ->
            let
                newHome =
                    set home slot qual

                newAway =
                    set away slot qual

                newBracket =
                    MatchNode s w newHome newAway round hasQ

                currentWinner =
                    winner bracket
            in
            reset newBracket currentWinner

        TeamNode s pos _ hasQ ->
            if s == slot then
                TeamNode slot pos qual hasQ

            else
                bracket


setBulk : Bracket -> List ( Slot, Qualifier ) -> Bracket
setBulk bracket slots =
    let
        newSet ( slot, qual ) brkt =
            set brkt slot qual
    in
    List.foldl newSet bracket slots


unsetQualifier : Bracket -> Qualifier -> Bracket
unsetQualifier bracket qual =
    case bracket of
        MatchNode s w home away round hasQ ->
            let
                newHome =
                    unsetQualifier home qual

                newAway =
                    unsetQualifier away qual

                newBracket =
                    MatchNode s w newHome newAway round hasQ

                currentWinner =
                    winner bracket
            in
            reset newBracket currentWinner

        TeamNode slot pos mt hasQ ->
            if mt == qual then
                TeamNode slot pos Nothing hasQ

            else
                bracket


qualifier : Bracket -> Qualifier
qualifier bracket =
    case bracket of
        MatchNode _ w home away _ _ ->
            case w of
                HomeTeam ->
                    qualifier home

                AwayTeam ->
                    qualifier away

                None ->
                    Nothing

        TeamNode _ _ q _ ->
            q


get : Bracket -> Slot -> Maybe Bracket
get brkt slot =
    case brkt of
        MatchNode s _ home away _ _ ->
            if s == slot then
                Just brkt

            else
                let
                    oneOf =
                        M.values >> List.head
                in
                oneOf [ get away slot, get home slot ]

        TeamNode s _ _ _ ->
            if s == slot then
                Just brkt

            else
                Nothing


getQualifiers : Bracket -> List ( Slot, Qualifier )
getQualifiers brkt =
    case brkt of
        MatchNode _ _ home away _ _ ->
            List.concat [ getQualifiers home, getQualifiers away ]

        TeamNode s _ q _ ->
            [ ( s, q ) ]


display : Bracket -> String
display bracket =
    T.mdisplay (qualifier bracket)


isComplete : Bracket -> Bool
isComplete brkt =
    case brkt of
        TeamNode _ _ qual _ ->
            M.isJust qual

        MatchNode _ w home away _ _ ->
            case w of
                None ->
                    False

                _ ->
                    isComplete home && isComplete away


isCompleteQualifiers : Bracket -> Bool
isCompleteQualifiers brkt =
    case brkt of
        TeamNode _ _ qual _ ->
            M.isJust qual

        MatchNode _ _ home away _ _ ->
            isCompleteQualifiers home && isCompleteQualifiers away


candidatesForTeamNode : Bracket -> Candidate -> Slot -> List Selection
candidatesForTeamNode brkt position slot =
    let
        candidates =
            C.get position

        -- returns Dict (TeamID, Slot)
        qualifiers =
            getQualifiers brkt
                |> List.map justify
                |> M.values
                |> Dict.fromList

        justify ( a, m ) =
            Maybe.map (\b -> ( b.teamID, a )) m

        -- case m of
        --     Just b ->
        --         Just ( b.teamID, a )
        --     Nothing ->
        --         Nothing
        assess : ( Group, Team ) -> Selection
        assess ( g, t ) =
            case Dict.get t.teamID qualifiers of
                Just s ->
                    if s == slot then
                        Selection ThisSlot g t

                    else
                        Selection (OtherSlot s) g t

                Nothing ->
                    Selection NoSlot g t
    in
    List.map assess candidates


candidatesForSlot : Bracket -> Slot -> Maybe Candidate
candidatesForSlot brkt slot =
    let
        fn : Bracket -> List (Maybe Candidate)
        fn b =
            case b of
                MatchNode _ _ h a _ _ ->
                    List.append (fn h) (fn a)

                TeamNode s q _ _ ->
                    if s == slot then
                        List.singleton <| Just q

                    else
                        List.singleton Nothing
    in
    fn brkt
        |> M.values
        |> List.head


getFreeSlots : Bracket -> List ( Slot, Candidate )
getFreeSlots bracket =
    M.values <| getFreeSlots_ bracket


getFreeSlots_ : Bracket -> List (Maybe ( Slot, Candidate ))
getFreeSlots_ bracket =
    case bracket of
        TeamNode s c q _ ->
            case q of
                Nothing ->
                    [ Just ( s, c ) ]

                Just _ ->
                    [ Nothing ]

        MatchNode _ _ home away _ _ ->
            getFreeSlots_ home ++ getFreeSlots_ away



-- JSON


encodeWinner : Winner -> Json.Encode.Value
encodeWinner wnnr =
    case wnnr of
        HomeTeam ->
            Json.Encode.string "HomeTeam"

        AwayTeam ->
            Json.Encode.string "AwayTeam"

        None ->
            Json.Encode.null


encode : Bracket -> Json.Encode.Value
encode bracket =
    case bracket of
        TeamNode slot pos qual hasQ ->
            Json.Encode.object
                [ ( "node", Json.Encode.string "team" )
                , ( "slot", Json.Encode.string slot )
                , ( "candidates", C.encode pos )
                , ( "qualifier", T.encodeMaybe qual )
                , ( "hasQualified", HasQualified.encode hasQ )
                ]

        MatchNode slot wnnr home away round hasQ ->
            Json.Encode.object
                [ ( "node", Json.Encode.string "match" )
                , ( "slot", Json.Encode.string slot )
                , ( "winner", encodeWinner wnnr )
                , ( "home", encode home )
                , ( "away", encode away )
                , ( "round", R.encode round )
                , ( "hasQualified", HasQualified.encode hasQ )
                ]


decode : Decoder Bracket
decode =
    field "node" Json.Decode.string
        |> Json.Decode.andThen
            (\node ->
                case node of
                    "team" ->
                        Json.Decode.map4 TeamNode
                            (field "slot" Json.Decode.string)
                            (field "candidates" C.decode)
                            (field "qualifier" (maybe T.decode))
                            (field "hasQualified" HasQualified.decode)

                    "match" ->
                        Json.Decode.map6 MatchNode
                            (field "slot" Json.Decode.string)
                            (field "winner" (maybe Json.Decode.string |> Json.Decode.andThen decodeWinner))
                            (field "home" (lazy (\_ -> decode)))
                            (field "away" (lazy (\_ -> decode)))
                            (field "round" R.decode)
                            (field "hasQualified" HasQualified.decode)

                    _ ->
                        fail (node ++ " is not a recognized node for brackets")
            )


decodeWinner : Maybe String -> Decoder Winner
decodeWinner w =
    let
        stringToWinner wnnr =
            case wnnr of
                "HomeTeam" ->
                    HomeTeam

                "AwayTeam" ->
                    AwayTeam

                _ ->
                    None
    in
    case w of
        Nothing ->
            Json.Decode.succeed None

        Just wnr ->
            Json.Decode.succeed (stringToWinner wnr)



-- FLAT JSON


nodeSlot : Bracket -> Slot
nodeSlot br =
    case br of
        TeamNode s _ _ _ ->
            s

        MatchNode s _ _ _ _ _ ->
            s


encodeFlat : Bracket -> Json.Encode.Value
encodeFlat bracket =
    Json.Encode.object
        [ ( "nodes", Json.Encode.list encodeFlatNode (flatten bracket) ) ]


encodeFlatList : Bracket -> Json.Encode.Value
encodeFlatList bracket =
    Json.Encode.list encodeFlatNode (flatten bracket)


decodeUnifiedEntries : Decoder Bracket
decodeUnifiedEntries =
    Json.Decode.field "entries" (Json.Decode.list decodeFlatNode)
        |> Json.Decode.andThen
            (\nodes ->
                case rebuildTree nodes of
                    Ok br ->
                        Json.Decode.succeed br

                    Err e ->
                        Json.Decode.fail e
            )


flatten : Bracket -> List Bracket
flatten bracket =
    case bracket of
        TeamNode _ _ _ _ ->
            [ bracket ]

        MatchNode _ _ home away _ _ ->
            bracket :: flatten home ++ flatten away


encodeFlatNode : Bracket -> Json.Encode.Value
encodeFlatNode bracket =
    case bracket of
        TeamNode slot cand qual hasQ ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "team" )
                , ( "slot", Json.Encode.string slot )
                , ( "candidate", C.encode cand )
                , ( "qualifier", T.encodeMaybe qual )
                , ( "hasQualified", HasQualified.encode hasQ )
                ]

        MatchNode slot wnnr home away round hasQ ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "match" )
                , ( "slot", Json.Encode.string slot )
                , ( "round", R.encode round )
                , ( "home", Json.Encode.string (nodeSlot home) )
                , ( "away", Json.Encode.string (nodeSlot away) )
                , ( "winner", encodeWinner wnnr )
                , ( "winningTeam", T.encodeMaybe (winner bracket) )
                , ( "hasQualified", HasQualified.encode hasQ )
                ]


type FlatNode
    = FlatTeam Slot Candidate Qualifier HasQualified
    | FlatMatch Slot Round Slot Slot Winner HasQualified


flatNodeSlot : FlatNode -> Slot
flatNodeSlot node =
    case node of
        FlatTeam s _ _ _ ->
            s

        FlatMatch s _ _ _ _ _ ->
            s


decodeFlat : Decoder Bracket
decodeFlat =
    field "nodes" (Json.Decode.list decodeFlatNode)
        |> Json.Decode.andThen
            (\nodes ->
                case rebuildTree nodes of
                    Ok br ->
                        Json.Decode.succeed br

                    Err e ->
                        fail e
            )


decodeFlatNode : Decoder FlatNode
decodeFlatNode =
    field "kind" Json.Decode.string
        |> Json.Decode.andThen
            (\kind ->
                case kind of
                    "team" ->
                        Json.Decode.map4 FlatTeam
                            (field "slot" Json.Decode.string)
                            (field "candidate" C.decode)
                            (field "qualifier" (maybe T.decode))
                            (field "hasQualified" HasQualified.decode)

                    "match" ->
                        Json.Decode.map6 FlatMatch
                            (field "slot" Json.Decode.string)
                            (field "round" R.decode)
                            (field "home" Json.Decode.string)
                            (field "away" Json.Decode.string)
                            (field "winner" (maybe Json.Decode.string |> Json.Decode.andThen decodeWinner))
                            (field "hasQualified" HasQualified.decode)

                    _ ->
                        fail (kind ++ " is not a recognized flat bracket node kind")
            )


rebuildTree : List FlatNode -> Result String Bracket
rebuildTree nodes =
    let
        bySlot : Dict Slot FlatNode
        bySlot =
            nodes
                |> List.map (\n -> ( flatNodeSlot n, n ))
                |> Dict.fromList

        childSlots =
            nodes
                |> List.concatMap
                    (\n ->
                        case n of
                            FlatMatch _ _ h a _ _ ->
                                [ h, a ]

                            FlatTeam _ _ _ _ ->
                                []
                    )
                |> Set.fromList

        roots =
            List.filter (\n -> not (Set.member (flatNodeSlot n) childSlots)) nodes
    in
    case roots of
        [ root ] ->
            buildFrom bySlot (flatNodeSlot root)

        [] ->
            Err "flat bracket has no root node"

        _ ->
            Err "flat bracket has multiple root nodes"


buildFrom : Dict Slot FlatNode -> Slot -> Result String Bracket
buildFrom bySlot slot =
    case Dict.get slot bySlot of
        Nothing ->
            Err ("flat bracket references unknown slot: " ++ slot)

        Just (FlatTeam s cand qual hasQ) ->
            Ok (TeamNode s cand qual hasQ)

        Just (FlatMatch s round homeSlot awaySlot wnnr hasQ) ->
            Result.map2
                (\h a -> MatchNode s wnnr h a round hasQ)
                (buildFrom bySlot homeSlot)
                (buildFrom bySlot awaySlot)
