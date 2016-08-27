module UI exposing (..)

import Debug
import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html

import CommentSchedule
import Game


type alias Model =
  { game : Game.Model
  , comments : List String
  }

type Msg
  = Game Game.Msg


init : Model
init =
  let
    game = Game.init 1
  in
    { game = game
    , comments = [toString game]
    }

update : Msg -> Model -> Model
update msg model =
  case msg of
    Game gameMsg ->
      let
        game' = Game.update gameMsg model.game
      in
        { game = game'
        , comments = [toString game']
        }

view : Model -> Html Msg
view model =
  Html.div
    [ Html.style
      [ ("margin", "1ex")
      ]
    ]
  [ Html.div
      [ Html.style
        [ ("border", "2px solid #888898")
        , ("background-color", "#A9A9B9")
        , ("padding", "1em")
        ]
      ]
    [ App.map Game <| Game.view model.game
    ]
  , Html.div
      [ Html.style
        [ ("margin", "1em")
        ]
      ]
    <| List.map Html.text model.comments
  ]


main : Program Never
main =
  App.beginnerProgram
  { model = init
  , view = view
  , update = update
  }
