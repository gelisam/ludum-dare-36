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
  { game = Game.init 1
  , comments = []
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    Game gameMsg ->
      { model | game = Game.update gameMsg model.game }

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

  -- DEBUG
  , Html.hr [] []
  , Html.text (toString model)
  ]


main : Program Never
main =
  App.beginnerProgram
  { model = init
  , view = view
  , update = update
  }
