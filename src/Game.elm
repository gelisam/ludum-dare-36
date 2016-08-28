module Game exposing (..)

import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html
import Html.Events as Events
import String


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


button : Bool -> msg -> String -> Html msg
button enabled msg text =
  Html.div
    [ Html.class (String.join " " [if enabled then "enabled" else "disabled", "button"])
    ]
  [ Html.img
      [ Html.src ("img/" ++ text ++ ".png")
      , Events.onClick msg
      ]
    []
  , Html.div []
    [ Html.text text
    ]
  ]

view : Model -> Html Msg
view model =
  Html.div []
  [ button False NextLevel                "right"
  , button True  ResetLevel               "undo"
  , button True  IncreaseButtonCount      "ragrog"
  , button True  IncreaseYellowCount      "bilp"
  , button True  IncreaseYellowMultiplier "blagar"
  , button True  IncreaseBlackCount       "barif"
  ]


main : Program Never
main =
  App.beginnerProgram
  { model = init 1
  , view = view
  , update = update
  }
