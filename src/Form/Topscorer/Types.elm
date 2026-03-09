module Form.Topscorer.Types exposing (IsSelected(..), Msg(..))


type Msg
    = SelectPlayer String
    | UpdateSearch String
    | SearchFocused Bool


type IsSelected
    = Selected
    | NotSelected
