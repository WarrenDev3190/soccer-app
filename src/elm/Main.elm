module Main exposing (..)

import Html exposing (..)


type alias Model =
    { footBallAPiKey : String
    }


update : msg -> Model -> ( Model, Cmd msg )
update msg model =
    model ! []


init : String -> ( Model, Cmd msg )
init footBallAPiKey =
    Model footBallAPiKey ! []


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html msg
view model =
    div []
        [ h2 [] [ text model.footBallAPiKey ]
        ]


main : Program String Model msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
