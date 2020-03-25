module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Debug
import Html
import Sthenauth.Login exposing (Login)
import Sthenauth.Types.Config exposing (Config)
import Url exposing (Url)


type alias Model =
    { login : Login
    , config : Config
    }


type Msg
    = Noop
    | LoginMsg Sthenauth.Login.Msg


init : () -> Url -> Key -> ( Model, Cmd Msg )
init () url key =
    let
        cfg =
            Sthenauth.Types.Config.default key

        res =
            Sthenauth.Login.init cfg Nothing
    in
    ( { login = Tuple.first res
      , config = cfg
      }
    , Cmd.map LoginMsg (Tuple.second res)
    )


view : Model -> Document Msg
view model =
    { title = "Elm Demo - Sthenauth"
    , body =
        [ Html.map LoginMsg (Sthenauth.Login.view model.login)
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        LoginMsg m ->
            let
                res =
                    Sthenauth.Login.update m model.login
            in
            ( { model | login = Tuple.first res }
            , Cmd.map LoginMsg (Tuple.second res)
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


onUrlRequest : UrlRequest -> Msg
onUrlRequest _ =
    Noop


onUrlChange : Url -> Msg
onUrlChange _ =
    Noop


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }
