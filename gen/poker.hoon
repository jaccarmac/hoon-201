/+  playing-cards
=,  playing-cards
:-  %say
::  $eny: entropy from outside
::
|=  [[* eny=@uvJ *] *]
:-  %noun
::  $shuffled: a shuffled deck of cards
::  $hand-1: five-card poker hand
::  $hand-2: five-card poker hand drawn after hand-1
::  $result: result of poker rules comparsion between the hands
::  $winner: the better hand
::  $loser: the worse hand
::
=<  =/  shuffled  (shuffle-deck make-deck eny)
    =^  hand-1   shuffled  (draw 5 shuffled)
    =^  hand-2   shuffled  (draw 5 shuffled)
    =/  result   (cmp-poker-hand hand-1 hand-2)
    =/  winner   ?:(result hand-1 hand-2)
    =/  loser    ?:(result hand-2 hand-1)
    ^-  tape
    (weld (weld (pretty winner) " beats ") (pretty loser))
|%
+$  poker-hand-kind  $?
  %straight-flush
  %four-of-a-kind
  %full-house
  %flush
  %straight
  %three-of-a-kind
  %two-pair
  %pair
  %high-card
==
::  $cmp-poker-hand: compare two five-card poker hands
::
++  cmp-poker-hand
  ::  $p: a hand of five cards
  ::  $q: another hand of five cards
  ::
  |=  [p=deck q=deck]
  ^-  ?
  ?.  &(=(5 (lent p)) =(5 (lent q)))
    ~|(%bad-hand-size !!)
  =.  p       (sort p cmp-darc)
  =.  q       (sort q cmp-darc)
  =/  p-kind  (hand-to-kind p)
  =/  q-kind  (hand-to-kind q)
  ?.  =(p-kind q-kind)
    (gte (kind-to-num p-kind) (kind-to-num q-kind))
  ?-  p-kind
    %straight-flush   (cmp-high-card p q)
    %four-of-a-kind   (cmp-four-of-a-kind p q)
    %full-house       (cmp-full-house p q)
    %flush            (cmp-high-card p q)
    %straight         (cmp-high-card p q)
    %three-of-a-kind  (cmp-three-of-a-kind p q)
    %two-pair         (cmp-two-pair p q)
    %pair             (cmp-pair p q)
    %high-card        (cmp-high-card p q)
  ==
++  hand-to-kind
  |=  d=deck
  ^-  poker-hand-kind
  =/  c1  (snag 0 d)
  =/  c2  (snag 1 d)
  =/  c3  (snag 2 d)
  =/  c4  (snag 3 d)
  =/  c5  (snag 4 d)
  ?:  &((hand-is-straight d) (hand-is-flush d))
    %straight-flush
  ?:  ?|
        &(=(val.c1 val.c2) =(val.c1 val.c3) =(val.c1 val.c4))
        &(=(val.c2 val.c3) =(val.c3 val.c4) =(val.c3 val.c5))
      ==
    %four-of-a-kind
  ?:  ?|
        &(=(val.c1 val.c2) =(val.c3 val.c4) =(val.c3 val.c5))
        &(=(val.c1 val.c2) =(val.c1 val.c3) =(val.c4 val.c5))
      ==
    %full-house
  ?:  (hand-is-flush d)
    %flush
  ?:  (hand-is-straight d)
    %straight
  ?:  ?|
        &(=(val.c1 val.c2) =(val.c1 val.c3))
        &(=(val.c2 val.c3) =(val.c2 val.c4))
        &(=(val.c3 val.c4) =(val.c3 val.c5))
      ==
    %three-of-a-kind
  ?:  ?|
        &(=(val.c1 val.c2) =(val.c3 val.c4))
        &(=(val.c1 val.c2) =(val.c4 val.c5))
        &(=(val.c2 val.c3) =(val.c4 val.c5))
      ==
    %two-pair
  ?:  ?|
        =(val.c1 val.c2)
        =(val.c2 val.c3)
        =(val.c3 val.c4)
        =(val.c4 val.c5)
      ==
    %pair
  %high-card
++  hand-is-straight
  |=  d=deck
  ^-  ?
  =/  c1  (snag 0 d)
  =/  c2  (snag 1 d)
  =/  c3  (snag 2 d)
  =/  c4  (snag 3 d)
  =/  c5  (snag 4 d)
  ?|
    &(=(val.c1 13) =(val.c2 12) =(val.c3 11) =(val.c4 10) =(val.c5 1))
    &(=(val.c1 13) =(val.c2 12) =(val.c3 11) =(val.c4 2) =(val.c5 1))
    &(=(val.c1 13) =(val.c2 12) =(val.c3 3) =(val.c4 2) =(val.c5 1))
    &(=(val.c1 13) =(val.c2 4) =(val.c3 3) =(val.c4 2) =(val.c5 1))
    ?&
      =(val.c1 +(val.c2))
      =(val.c2 +(val.c3))
      =(val.c3 +(val.c4))
      =(val.c4 +(val.c5))
    ==
  ==
++  hand-is-flush
  |=  d=deck
  ^-  ?
  =/  c1  (snag 0 d)
  =/  c2  (snag 1 d)
  =/  c3  (snag 2 d)
  =/  c4  (snag 3 d)
  =/  c5  (snag 4 d)
  ?&
    =(sut.c1 sut.c2)
    =(sut.c1 sut.c3)
    =(sut.c1 sut.c4)
    =(sut.c1 sut.c5)
  ==
++  cmp-four-of-a-kind
  |=  [p=deck q=deck]
  ^-  ?
  &
++  cmp-full-house
  |=  [p=deck q=deck]
  ^-  ?
  &
++  cmp-three-of-a-kind
  |=  [p=deck q=deck]
  ^-  ?
  &
++  cmp-two-pair
  |=  [p=deck q=deck]
  ^-  ?
  &
++  cmp-pair
  |=  [p=deck q=deck]
  ^-  ?
  &
++  cmp-high-card
  |=  [p=deck q=deck]
  ^-  ?
  &
++  cmp-darc
  |=  [p=darc q=darc]
  ^-  ?
  (gte val.p val.q)
++  kind-to-num
  |=  k=poker-hand-kind
  ^-  @ud
  ?-  k
    %straight-flush   8
    %four-of-a-kind   7
    %full-house       6
    %flush            5
    %straight         4
    %three-of-a-kind  3
    %two-pair         2
    %pair             1
    %high-card        0
  ==
::  $pretty: pretty print a list of cards
::
++  pretty
  ::  $d: a deck (of any size)
  ::
  |=  d=deck
  ^-  tape
  %+  weld
    "["
  %+  weld
    (reel (turn d pretty-darc) |=([p=tape q=tape] (weld p q)))
  "]"
::  $pretty-darc: pretty print a card (playing-cards:darc)
::
++  pretty-darc
  ::  $c: a card
  ::
  |=  c=darc
  ^-  tape
  (weld (pretty-val val.c) (pretty-sut sut.c))
::  $pretty-val: pretty print the value of a card
::
++  pretty-val
  ::  $v: card value: per playing-cards, should be in the range 1-13
  ::
  |=  v=@ud
  ^-  tape
  ?+  v  ~|(%bad-val-in-darc !!)
    %1   "A"
    %2   "2"
    %3   "3"
    %4   "4"
    %5   "5"
    %6   "6"
    %7   "7"
    %8   "8"
    %9   "9"
    %10  "10"
    %11  "J"
    %12  "Q"
    %13  "K"
  ==
::  $pretty-sut: pretty print the suit of a card
::
++  pretty-sut
  ::  $s: a suit constant from playing-cards
  ::
  |=  s=suit
  ^-  tape
  ?-  s
    %hearts    "♥"
    %spades    "♠"
    %clubs     "♣"
    %diamonds  "♦"
  ==
--
