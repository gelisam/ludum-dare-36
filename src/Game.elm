module Game exposing (..)

import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html
import Html.Events as Events
import String

import CommentSchedule
import Html.Extra as Html


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
button enabled msg symbol =
  Html.div
    [ Html.class (String.join " " [if enabled then "enabled" else "disabled", "button"])
    ]
  [ Html.img
      [ Html.src ("img/" ++ symbol ++ ".png")
      , Events.onClick msg
      ]
    []
  , Html.div []
    [ Html.text symbol
    ]
  ]


allSymbols : List String
allSymbols =
  [ "barht"
  , "barif"
  , "bilp"
  , "blagar"
  , "buleg"
  , "dulu"
  , "frisch"
  , "muliter"
  , "ono"
  , "ragrog"
  , "rahrt"
  , "ula"
  ]

grid : List String
grid =
  [ "*** *   * *** "
  , "*   **  * *  *"
  , "*** * * * *  *"
  , "*   *  ** *  *"
  , "*** *   * *** "
  ]

gridEnabledness : List (List Bool)
gridEnabledness =
  grid
    |> List.map String.toList
    |> List.map (List.map (\x -> x == '*'))

gridMessages : List (List Msg)
gridMessages =
  grid
    |> List.map String.toList
    |> List.map (List.map (\x -> IncreaseYellowCount))

gridSymbols : List (List String)
gridSymbols =
  grid
    |> List.map String.toList
    |> List.map (List.map2 (\x y -> x) ["barht", "barht", "barht", "blagar", "muliter", "muliter", "muliter", "muliter", "muliter", "dulu", "rahrt", "rahrt", "rahrt", "rahrt"])

gridButtons : List (List (Html Msg))
gridButtons =
  List.map3 (List.map3 button) gridEnabledness gridMessages gridSymbols

viewGrid : Html Msg
viewGrid =
  Html.grid [] gridButtons


rectangle : String -> Html msg
rectangle color =
  Html.div
    [ Html.class (String.join " " [color, "rectangle"])
    ]
  []

yellowRectangle : Html msg
yellowRectangle =
  rectangle "yellow"

purpleRectangle : Html msg
purpleRectangle =
  rectangle "purple"

blueRectangle : Html msg
blueRectangle =
  rectangle "blue"

blankRectangle : Html msg
blankRectangle =
  rectangle "blank"

blackRectangle : Html msg
blackRectangle =
  rectangle "black"

viewYellowRectangles : Model -> Html msg
viewYellowRectangles model =
  Html.horizontal []
  ( List.repeat model.yellowCount yellowRectangle
 ++ List.repeat (CommentSchedule.maxYellow - model.yellowCount - model.blackCount) blankRectangle
 ++ List.repeat model.blackCount blackRectangle
  )

viewPurpleRectangles : Model -> Html msg
viewPurpleRectangles model =
  Html.horizontal []
  ( List.repeat model.yellowMultiplier purpleRectangle
 ++ List.repeat (CommentSchedule.maxPurple - model.yellowMultiplier) blankRectangle
  )

viewBlueRectangles : Model -> Html msg
viewBlueRectangles model =
  Html.horizontal []
  ( List.repeat model.buttonCount blueRectangle
 ++ List.repeat (3 - model.buttonCount) blankRectangle
  )


view : Model -> Html Msg
view model =
  Html.div []
  [ button False NextLevel                "right"
  , button True  ResetLevel               "undo"
  , button True  IncreaseButtonCount      "ragrog"
  , button True  IncreaseYellowCount      "bilp"
  , button True  IncreaseYellowMultiplier "blagar"
  , button True  IncreaseBlackCount       "barif"
  , viewBlueRectangles model
  , viewPurpleRectangles model
  , viewYellowRectangles model
  , viewGrid
  ]


main : Program Never
main =
  App.beginnerProgram
  { model = init 1
  , view = view
  , update = update
  }
