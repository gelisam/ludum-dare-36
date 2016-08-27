module Main exposing (main)

import Html.App as App

import UI


-- This fails at runtime. Elm bug?
--main : Program Never
--main = UI.main

main : Program Never
main =
  App.beginnerProgram
  { model = UI.init
  , view = UI.view
  , update = UI.update
  }
