module Form.Participant.Types exposing (Attr(..), FieldTag(..), Msg(..), State)


type alias State =
    { activeField : Maybe FieldTag }


type FieldTag
    = NameTag
    | PostalTag
    | ResidenceTag
    | EmailTag
    | PhoneTag
    | KnowsTag


type Msg
    = Set Attr
    | FocusField FieldTag
    | BlurField


type Attr
    = Name String
    | Postal String
    | Residence String
    | Email String
    | Phone String
    | Knows String
