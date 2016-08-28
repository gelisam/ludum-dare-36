module PrettyPrint exposing (pretty, view)

import Html exposing (Html)
import String


-- >>> print (toString {a = 1, b = 2})
-- {a = 1, b = 2}
-- >>> print (pretty {a = 1, b = 2})
-- {
--   a = 1
--   b = 2
-- }
pretty : a -> String
pretty = indent << split << toString

-- >>> separate "/" "1/2/3"
-- ["1","/","2","/","3"]
separate : String -> String -> List String
separate sep =
  String.split sep
  >> List.intersperse sep

split : String -> List String
split =
  String.split ", "
    >> List.concatMap (String.split ",")
    >> List.concatMap (separate "{")
    >> List.concatMap (separate "}")
    >> List.concatMap (separate "[")
    >> List.concatMap (separate "]")
    >> List.concatMap (separate "(")
    >> List.concatMap (separate ")")
    >> List.map String.trim

annotateIndentationLevel : Int -> List String -> List (Int, String)
annotateIndentationLevel indentationLevel list =
  case list of
    ("{" :: ss) -> (indentationLevel, "{") :: annotateIndentationLevel (indentationLevel + 1) ss
    ("}" :: ss) -> (indentationLevel - 1, "}") :: annotateIndentationLevel (indentationLevel - 1) ss
    ("[" :: ss) -> (indentationLevel, "[") :: annotateIndentationLevel (indentationLevel + 1) ss
    ("]" :: ss) -> (indentationLevel - 1, "]") :: annotateIndentationLevel (indentationLevel - 1) ss
    ("(" :: ss) -> (indentationLevel, "(") :: annotateIndentationLevel (indentationLevel + 1) ss
    (")" :: ss) -> (indentationLevel - 1, ")") :: annotateIndentationLevel (indentationLevel - 1) ss
    (s :: ss) -> (indentationLevel, s) :: annotateIndentationLevel indentationLevel ss
    [] -> []

addIndentation : (Int, String) -> String
addIndentation (n, s) =
  String.repeat n "  " ++ s

indent : List String -> String
indent =
  annotateIndentationLevel 0
    >> List.map addIndentation
    >> String.join "\n"


view : a -> Html msg
view x =
  Html.pre []
  [ Html.text (pretty x)
  ]
