::  TODO: simplify the code at the top (remove results, winner, loser i think)
::  TODO: convert @t gates to tape (allows removing crip/trip trick)
::
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
::  $results: hand-1 and hand-2 sorted according to poker rules
::  $winner: the better hand (first element of results)
::  $loser: the worse hand (last element of results)
::
=<  =/  shuffled  (shuffle-deck make-deck eny)
    =^  hand-1    shuffled  (draw 5 shuffled)
    =^  hand-2    shuffled  (draw 5 shuffled)
    =/  results   (sort ~[hand-1 hand-2] poker-sort)
    =/  winner    (snag 0 results)
    =/  loser     (snag 1 results)
    ^-  tape
    (weld (weld (pretty winner) " beats ") (pretty loser))
|%
+$  poker-hand-kind  $?
::  %straight-flush
::  %four-of-a-kind
::  %full-house
::  %flush
::  %straight
::  %three-of-a-kind
::  %two-pair
::  %pair
  %high-card
==
::  $poker-sort: sort hands according to poker rules
::
++  poker-sort
  ::  $p: a hand of five cards
  ::  $q: another hand of five cards
  ::
  |=  [p=deck q=deck]
  ^-  ?
  ?.  &(=(5 (lent p)) =(5 (lent q)))
    ~|(%bad-hand-size !!)
  =/  p-kind  (hand-to-kind p)
  =/  q-kind  (hand-to-kind q)
  ?.  =(p-kind q-kind)
    (gte (kind-to-num p-kind) (kind-to-num q-kind))
  ?-  p-kind
::    %straight-flush
::    %four-of-a-kind
::    %full-house
::    %flush
::    %straight
::    %three-of-a-kind
::    %two-pair
::    %pair
    %high-card  (cmp-high-card p q)
  ==
++  kind-to-num
  |=  k=poker-hand-kind
  ^-  @ud
  ?-  k
::    %straight-flush
::    %four-of-a-kind
::    %full-house
::    %flush
::    %straight
::    %three-of-a-kind
::    %two-pair
::    %pair
    %high-card  0
  ==
++  cmp-high-card
  |=  [p=deck q=deck]
  &
++  hand-to-kind
  |=  d=deck
  ^-  poker-hand-kind
  %high-card
::  $pretty: pretty print a list of cards
::
++  pretty
  ::  $d: a deck (of any size)
  ::
  |=  d=deck
  ^-  tape
  (weld "[" (weld (join ' ' (turn d pretty-darc)) "]"))
::  $pretty-darc: pretty print a card (playing-cards:darc)
::
++  pretty-darc
  ::  $c: a card
  ::
  |=  c=darc
  ^-  @t
  (crip (weld (trip (pretty-val val.c)) (trip (pretty-sut sut.c))))
::  $pretty-val: pretty print the value of a card
::
++  pretty-val
  ::  $v: card value: per playing-cards, should be in the range 1-13
  ::
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
::  $pretty-sut: pretty print the suit of a card
::
++  pretty-sut
  ::  $s: a suit constant from playing-cards
  ::
  |=  s=suit
  ^-  @t
  ?-  s
    %hearts    '♥'
    %spades    '♠'
    %clubs     '♣'
    %diamonds  '♦'
  ==
--
