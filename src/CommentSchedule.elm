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
  | Clear
  | Comment String CommentSchedule
  | WaitFor Event CommentSchedule
  | Parallel (List CommentSchedule) CommentSchedule
  | Choice (List (Event, CommentSchedule)) CommentSchedule


lastLevel : Int
lastLevel = 5

maxYellow : Int
maxYellow = 30

maxPurple : Int
maxPurple = 8

half : Int
half = maxYellow // 2

oneThird : Int
oneThird = maxYellow // 3

twoThirds : Int
twoThirds = 2 * oneThird


commentSchedule : CommentSchedule
commentSchedule =
  Comment "It's an archeological miracle! Not only have we discovered an ancient site belonging to an advanced-but-extinct civilization, it turns out one of their machines still work. If only we could figure out what it does..." <|
  Parallel
  [ WaitFor (IncreaseIn ButtonCount) <| Comment "Okay, so this button reveals more buttons. What do those do?" <|
    WaitFor (OneOf [IncreaseIn YellowCount, Reseting]) <| Clear
  , Choice
    [ (YellowCount `is`      1, Comment "Congratulations, you now have a yellow rectangle. Yay?" <| Stop)
    , (YellowCount `isAbove` 1, Comment "Congratulations, you now have some yellow rectangles. Yay?" <| Stop)
    ] <|
    WaitFor (IncreaseIn YellowCount) <| Comment "More yellow rectangles." <|
    WaitFor (YellowCount `isAbove` twoThirds) <| Comment "We have a lot of yellow rectangles now! I think we're... winning?" <|
    WaitFor (OneOf [IncreaseIn Level, Reseting]) <| Clear
  , WaitFor (YellowMultiplier `is` 2) <| Comment "Okay, we now have two purple rectangles. What effect does this have?" <|
    Choice
    [ (IncreaseIn YellowCount, Comment "Aha! We get two yellow rectangles at a time now." <| Stop)
    , (IncreaseIn YellowMultiplier, Comment "Okay, we now have many purple rectangles. What effect does this have?" <|
       WaitFor (IncreaseIn YellowCount) <| Comment "Aha! We get as many new yellow rectangles at a time as we have purple ones." <| Stop)
    , (Reseting, Clear)
    ] <|
    WaitFor (OneOf [IncreaseIn YellowMultiplier, IncreaseIn YellowCount, Reseting]) <| Clear

  , WaitFor (BlackCount `is` 1) <| Comment "A black rectangle appears." <|
    WaitFor (IncreaseIn BlackCount) <| Comment "More black rectangles." <|
    WaitFor (DecreaseIn YellowCount) <| Comment "I think these black rectangles are pushing against our yellow rectangles." <|
    WaitFor (DecreaseIn YellowCount) <| Comment "I don't like those black rectangles. Maybe try pushing back?" <|
    WaitFor (OneOf [YellowCount `isAbove` half, BlackCount `isAbove` twoThirds, Reseting]) <| Clear
  , WaitFor (BlackCount `isAbove` twoThirds) <| Comment "These black rectangles sure multiply quickly. Should we be worried?" <|
    WaitFor (OneOf [YellowCount `isAbove` half, Reseting]) <| Clear
  , WaitFor Reseting <| Comment "Ah, I see: when the black rectangles reach the left side of the screen, the machine resets. Maybe a safety feature?" <|
    WaitFor (YellowCount `isAbove` oneThird) <| Clear

  , WaitFor (IncreaseIn Level) <| Comment "Oh look! Completely new buttons. We're making progress!" <|
    WaitFor (OneOf [YellowCount `isAbove` oneThird, Reseting]) <| Clear
  , WaitFor (Level `is` (lastLevel - 1)) <| Comment "The machine is rumbling! I think the activation procedure is almost complete..." <|
    WaitFor (Level `is` lastLevel) <| Comment "The machine became silent all of a sudden. Did we break it? Oh well. We were lucky to even get that far, you know. Technologies this ancient are usually completely broken and unusable. I guess we should go back to dusting off teapots fragments..." <|
    Stop
  ] <|
  Stop
