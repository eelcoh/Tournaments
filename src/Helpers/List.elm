module Helpers.List exposing (addToGrouped)


addToGrouped : ( Int, a ) -> List ( Int, List a ) -> List ( Int, List a )
addToGrouped ( r, el ) groups =
    case groups of
        ( rr, els ) :: t ->
            if r == rr then
                ( rr, List.append els [ el ] ) :: t
                -- append instead of cons: ( rr, el :: els ) :: t
                -- as cons flips the order, somehow

            else
                ( rr, els ) :: addToGrouped ( r, el ) t

        [] ->
            [ ( r, [ el ] ) ]
