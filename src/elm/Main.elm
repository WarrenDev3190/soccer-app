module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Http exposing (..)
import LeagueTable exposing (..)


type alias Config =
    { footBallAPiKey : String
    , footBallApiBaseUrl : String
    }


type alias Model =
    { footBallAPiKey : String
    , footBallApiBaseUrl : String
    , leagueTable : Maybe LeagueTable
    }


type Msg
    = RequestLeagueData
    | ReceiveLeagueData (Result Error LeagueTable)


requestLeagueData : Model -> String -> Cmd Msg
requestLeagueData model pathURI =
    let
        url =
            model.footBallApiBaseUrl ++ pathURI

        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "X-Auth-Token" model.footBallAPiKey
                    ]
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson leagueDataDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        send ReceiveLeagueData request


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestLeagueData ->
            ( model, requestLeagueData model "/competitions/398/leagueTable" )

        ReceiveLeagueData (Err err) ->
            let
                _ =
                    Debug.log "Error" (toString err)
            in
                model ! []

        ReceiveLeagueData (Ok leagueTable) ->
            let
                _ =
                    Debug.log "Standings" leagueTable
            in
                { model
                    | leagueTable = Just leagueTable
                }
                    ! []


init : Config -> ( Model, Cmd Msg )
init config =
    let
        model =
            Model config.footBallAPiKey config.footBallApiBaseUrl Nothing
    in
        ( model, requestLeagueData model "/competitions/398/leagueTable" )


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    let
        leagueData =
            case model.leagueTable of
                Just data ->
                    data

                Nothing ->
                    { standings = []
                    }

        standingsCard =
            List.map
                (\s ->
                    li []
                        [ div []
                            [ img [ Attrs.src s.crestURI, Attrs.style [ ( "width", "100px" ) ] ] []
                            , p [] [ text s.teamName ]
                            , p [] [ text (toString s.wins) ]
                            ]
                        ]
                )
                leagueData.standings
    in
        div []
            [ h2 [] [ text model.footBallAPiKey ]
            , ul [] standingsCard
            ]


main : Program Config Model Msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
