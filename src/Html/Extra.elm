module Html.Extra exposing (..)

import Html exposing (Attribute, Html)


grid : List (Attribute msg) -> List (List (Html msg)) -> Html msg
grid attrs =
  List.map (List.map (\x -> Html.td [] [x]))
    >> List.map (Html.tr [])
    >> Html.table attrs

horizontal : List (Attribute msg) -> List (Html msg) -> Html msg
horizontal attrs row =
  grid attrs [row]
