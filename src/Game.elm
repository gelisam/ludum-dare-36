module Game exposing (..)

import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html
import Html.Events as Events


type alias Model =
  { level : Int
  , buttonCount : Int
  , yellowCount : Int
  , yellowMultiplier : Int
  , blackCount : Int
  }

type Msg
  = NextLevel
  | ResetLevel
  | IncreaseButtonCount
  | IncreaseYellowCount
  | IncreaseYellowMultiplier
  | IncreaseBlackCount


init : Int -> Model
init level =
  { level = level
  , buttonCount = 1
  , yellowCount = 0
  , yellowMultiplier = 1
  , blackCount = 0
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    NextLevel ->
      { model | level = model.level + 1 }
    ResetLevel ->
      init model.level
    IncreaseButtonCount ->
      { model | buttonCount = model.buttonCount + 1 }
    IncreaseYellowCount ->
      { model | yellowCount = model.yellowCount + model.yellowMultiplier }
    IncreaseYellowMultiplier ->
      { model | yellowMultiplier = model.yellowMultiplier + 1 }
    IncreaseBlackCount ->
      { model | blackCount = model.blackCount + 1 }


button : msg -> String -> Html msg
button msg text =
  Html.button [Events.onClick msg] [Html.text text]

view : Model -> Html Msg
view model =
  Html.div []
  [ button NextLevel                "Next Level"
  , button ResetLevel               "Reset Level"
  , Html.img
      [ Html.class "enabled button"
      , Html.src "img/ragrog.png"
      , Events.onClick IncreaseButtonCount
      ]
    []
  , button IncreaseYellowCount      "Yellow +N"
  , button IncreaseYellowMultiplier "N +1"
  , button IncreaseBlackCount       "Black +1"
  ]


main : Program Never
main =
  App.beginnerProgram
  { model = init 1
  , view = view
  , update = update
  }
