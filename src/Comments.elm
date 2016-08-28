module Comments exposing (..)

import Html exposing (Html)
import Html.App as App
import Html.Attributes as Html

import CommentSchedule exposing (CommentSchedule, Event)


type Model
  = Stopped (Maybe String)
  | Cleared
  | Waiting (Maybe String) Event CommentSchedule
  | Parallel (Maybe String) (List Model) CommentSchedule
  | Choosing (Maybe String) (List (Event, CommentSchedule)) CommentSchedule
  | Sequencing Model CommentSchedule

sequence : Model -> CommentSchedule -> Model
sequence model cc =
  case model of
    Stopped comment ->
      initWith comment cc
    Cleared ->
      initWith Nothing cc
    _ ->
      Sequencing model cc


init : Model
init = initWith Nothing CommentSchedule.commentSchedule

initWith : Maybe String -> CommentSchedule -> Model
initWith comment schedule =
  case schedule of
    CommentSchedule.Stop ->
      Stopped comment
    CommentSchedule.Clear ->
      Cleared
    CommentSchedule.Comment newComment cc ->
      initWith (Just newComment) cc
    CommentSchedule.WaitFor event cc ->
      Waiting comment event cc
    CommentSchedule.Parallel schedules cc ->
      Parallel comment (List.map (initWith Nothing) schedules) cc
    CommentSchedule.Choice schedules cc ->
      Choosing comment schedules cc


update : (Event -> Bool) -> Model -> Model
update detectEvent model =
  case model of
    Stopped comment ->
      Stopped comment
    Cleared ->
      Cleared
    Waiting comment event cc ->
      if detectEvent event then initWith comment cc else model
    Parallel comment models cc ->
      let
        models' =
          models
            |> List.map (update detectEvent)
            |> List.filter (\x -> x /= Cleared)
        comments' =
          List.concatMap comments models'
      in
        case (models', comments') of
          ([], _) -> initWith Nothing cc
          (_, []) -> Parallel comment models' cc
          _ -> Parallel Nothing models' cc
    Choosing comment choices cc ->
      let
        validateChoice : (Event, CommentSchedule) -> Maybe CommentSchedule
        validateChoice (event, schedule) =
          if detectEvent event then Just schedule else Nothing
        activeChoice =
          choices
            |> List.filterMap validateChoice
            |> List.head
      in
        case activeChoice of
          Just schedule -> sequence (initWith comment schedule) cc
          Nothing -> model
    Sequencing model cc ->
      sequence (update detectEvent model) cc


maybeComment : Maybe String -> List String
maybeComment maybe =
  case maybe of
    Just comment -> [comment]
    Nothing -> []

comments : Model -> List String
comments model =
  case model of
    Stopped comment ->
      maybeComment comment
    Cleared ->
      []
    Waiting comment _ _ ->
      maybeComment comment
    Parallel comment models _ ->
      case List.concatMap comments models of
        [] -> maybeComment comment
        comments -> comments
    Choosing comment _ _ ->
      maybeComment comment
    Sequencing model _ ->
      comments model

viewComment : String -> Html msg
viewComment comment =
  Html.div []
  [ Html.text comment
  ]

view : Model -> Html msg
view model =
  model
    |> comments
    |> List.map viewComment
    |> Html.div
         [ Html.style
           [ ("width", "500px")
           , ("margin-left", "auto")
           , ("margin-right", "auto")
           , ("margin-top", "1ex")
           ]
         ]
