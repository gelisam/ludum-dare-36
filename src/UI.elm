module UI exposing (..)

import Debug
import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html

import Comments
import CommentSchedule exposing (Event)
import Game
import PrettyPrint


type alias Model =
  { game : Game.Model
  , comments : Comments.Model
  }

type Msg
  = Game Game.Msg


init : Model
init =
  { game = Game.init 1
  , comments = Comments.init
  }


update : Msg -> Model -> Model
update msg model =
  case msg of
    Game gameMsg ->
      let
        game = model.game
        game' = Game.update gameMsg game
      in
        { model
        | game = game'
        , comments = Comments.update (detectEvent game game') model.comments
        }

detectEvent : Game.Model -> Game.Model -> Event -> Bool
detectEvent _ _ _ =
  -- TODO
  False


view : Model -> Html Msg
view model =
  Html.div
    [ Html.style
      [ ("margin", "1ex")
      ]
    ]
  [ Html.h1 []
    [ Html.text "Dusty Tech Tree"
    ]
  , Html.div
      [ Html.style
        [ ("border", "2px solid #888898")
        , ("background-color", "#A9A9B9")
        , ("padding", "1em")
        ]
      ]
    [ App.map Game <| Game.view model.game
    ]
  , Comments.view model.comments

  -- DEBUG
  , Html.hr [] []
  , PrettyPrint.view model
  ]


main : Program Never
main =
  App.beginnerProgram
  { model = init
  , view = view
  , update = update
  }
