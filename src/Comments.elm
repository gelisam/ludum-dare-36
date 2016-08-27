module Comments exposing (..)

import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html

import CommentSchedule exposing (CommentSchedule, Event)


type Model
  = Stopped
  | Waiting (Maybe String) Event CommentSchedule
  | ParallelWaiting (Maybe String) (List CommentSchedule) CommentSchedule
  | Parallel (List Model) CommentSchedule
  | Choosing (Maybe String) (List (Event, CommentSchedule)) CommentSchedule


init : Model
init = initWith Nothing CommentSchedule.commentSchedule

initWith : Maybe String -> CommentSchedule -> Model
initWith comment schedule =
  case schedule of
    CommentSchedule.Stop ->
      Stopped
    CommentSchedule.Comment newComment cc ->
      initWith (Just newComment) cc
    CommentSchedule.WaitFor event cc ->
      Waiting comment event cc
    CommentSchedule.Parallel schedules cc ->
      ParallelWaiting comment schedules cc
    CommentSchedule.Choice schedules cc ->
      Choosing comment schedules cc


update : (Event -> Bool) -> Model -> Model
update detectEvent model =
  -- TODO
  model


comments : Model -> List String
comments model =
  -- TODO
  [ "hello" ]

view : Model -> Html msg
view model =
  model
    |> comments
    |> List.map Html.text
    |> Html.div
         [ Html.style
           [ ("margin", "1em")
           ]
         ]
