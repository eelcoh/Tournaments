port module Ports exposing (onBeforeInstallPrompt, persistDismiss, triggerInstall)


-- Outgoing: command Elm sends to JS to trigger the native install prompt


port triggerInstall : () -> Cmd msg


-- Outgoing: command Elm sends to JS with dismiss count to persist


port persistDismiss : Int -> Cmd msg


-- Incoming: subscription Elm listens to when JS receives BeforeInstallPrompt
-- JS sends null, so we use Maybe () to handle null gracefully


port onBeforeInstallPrompt : (Maybe () -> msg) -> Sub msg
