/+  playing-cards
=,  playing-cards
:-  %say
|=  [[* eny=@uvJ *] *]
:-  %noun
=<  =/  shuffled  (shuffle-deck make-deck eny)
    =^  hand-1    shuffled  (draw 5 shuffled)
    =^  hand-2    shuffled  (draw 5 shuffled)
    =/  results   (sort ~[hand-1 hand-2] poker-sort)
    =/  winner    (snag 0 results)
    =/  loser     (snag 1 results)
    ^-  tape
    (weld (weld (pretty winner) " beats ") (pretty loser))
|%
++  poker-sort
  |=  [p=deck q=deck]
  ^-  ?
  &
++  pretty
  |=  d=deck
  ^-  tape
  (weld "[" (weld (join ' ' (turn d pretty-darc)) "]"))
++  pretty-darc
  |=  c=darc
  ^-  @t
  (crip (weld (trip (pretty-val val.c)) (trip (pretty-sut sut.c))))
++  pretty-val
  |=  v=@ud
  ^-  @t
  ?+  v  ~|(%bad-val-in-darc !!)
    %1   '1'
    %2   '2'
    %3   '3'
    %4   '4'
    %5   '5'
    %6   '6'
    %7   '7'
    %8   '8'
    %9   '9'
    %10  '10'
    %11  'J'
    %12  'Q'
    %13  'K'
  ==
++  pretty-sut
  |=  s=suit
  ^-  @t
  ?-  s
    %hearts    '♥'
    %spades    '♠'
    %clubs     '♣'
    %diamonds  '♦'
  ==
--
