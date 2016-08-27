module CommentSchedule exposing (..)


type GameVar
  = Level
  | ButtonCount
  | YellowCount
  | YellowMultiplier
  | BlackCount


type Event
  = Reseting
  | Is GameVar Int
  | IsAbove GameVar Int
  | IncreaseIn GameVar
  | DecreaseIn GameVar
  | OneOf (List Event)
  | Never

-- Because "`is`" is allowed but "`Is`" isn't.
is : GameVar -> Int -> Event
is = Is

-- Because "`isAbove`" is allowed but "`IsAbove`" isn't.
isAbove : GameVar -> Int -> Event
isAbove = IsAbove


type CommentSchedule
  = Stop
  | Comment String CommentSchedule
  | WaitFor Event CommentSchedule
  | Parallel (List CommentSchedule) CommentSchedule
  | Choice (List (Event, CommentSchedule)) CommentSchedule


lastLevel : Int
lastLevel = 5

maxCount : Int
maxCount = 30

half : Int
half = maxCount // 2

oneThird : Int
oneThird = maxCount // 3

twoThirds : Int
twoThirds = 2 * oneThird


commentSchedule : CommentSchedule
commentSchedule =
  Comment "It's an archeological miracle! Not only have we discovered an ancient site belonging to an advanced-but-extinct civilization, it turns out one of their machines still work. If only we could figure out what it does..." <|
  Parallel
  [ WaitFor (IncreaseIn ButtonCount) <| Comment "Okay, so this button reveals more buttons. What do those do?" <|
    WaitFor (OneOf [IncreaseIn YellowCount, Reseting]) <| Stop
  , Choice
    [ (YellowCount `is`      1, Comment "Congratulations, you now have a yellow rectangle. Yay?" <| Stop)
    , (YellowCount `isAbove` 1, Comment "Congratulations, you now have some yellow rectangles. Yay?" <| Stop)
    ] <|
    WaitFor (IncreaseIn YellowCount) <| Comment "More yellow rectangles." <|
    WaitFor (YellowCount `isAbove` twoThirds) <| Comment "We have a lot of yellow rectangles now! I think we're... winning?" <|
    WaitFor (OneOf [IncreaseIn Level, Reseting]) <| Stop
  , WaitFor (YellowMultiplier `is` 2) <| Comment "2 times the Bihurax, hurray! What's a Bihurax?" <|
    WaitFor (OneOf [IncreaseIn YellowMultiplier, IncreaseIn YellowCount, Reseting]) <| Stop

  , WaitFor (BlackCount `is` 1) <| Comment "A black rectangle appears." <|
    WaitFor (IncreaseIn BlackCount) <| Comment "More black rectangles." <|
    WaitFor (DecreaseIn YellowCount) <| Comment "I think these black rectangles are pushing against our yellow rectangles." <|
    WaitFor (DecreaseIn YellowCount) <| Comment "I don't like those black rectangles. Maybe try pushing back?" <|
    WaitFor (OneOf [YellowCount `isAbove` half, BlackCount `isAbove` twoThirds, Reseting]) <| Stop
  , WaitFor (BlackCount `isAbove` twoThirds) <| Comment "These black rectangles sure multiply quickly. Should we be worried?" <|
    WaitFor (OneOf [YellowCount `isAbove` half, Reseting]) <| Stop
  , WaitFor Reseting <| Comment "Ah, I see: when the black rectangles reach the left side of the screen, the machine resets. Maybe a safety feature?" <|
    WaitFor (YellowCount `isAbove` oneThird) <| Stop

  , WaitFor (IncreaseIn Level) <| Comment "Oh look! Completely new buttons. We're making progress!" <|
    WaitFor (OneOf [YellowCount `isAbove` oneThird, Reseting]) <| Stop
  , WaitFor (Level `is` (lastLevel - 1)) <| Comment "The machine is rumbling! I think the activation procedure is almost complete..." <|
    WaitFor (Level `is` lastLevel) <| Comment "The machine became silent all of a sudden. Did we break it? Oh well. We were lucky to even get that far, you know. Technologies this ancient are usually completely broken and unusable. I guess we should go back to dusting off teapots fragments..." <|
    WaitFor Never <| Stop
  ] <|
  Stop
