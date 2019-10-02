/+  playing-cards
=,  playing-cards
:-  %say
|=  [[* eny=@uvJ *] *]
:-  %noun
=<  =/  shuffled  (shuffle-deck make-deck eny)
    =^  hand-1   shuffled  (draw 5 shuffled)
    =^  hand-2   shuffled  (draw 5 shuffled)
    =/  result   (cmp-poker-hand hand-1 hand-2)
    =/  winner   ?:(result hand-1 hand-2)
    =/  loser    ?:(result hand-2 hand-1)
    ^-  tape
    %+  weld
      (weld (pretty winner) " beats ")
    (pretty loser)
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
++  cmp-poker-hand
  |=  [p=deck q=deck]
  ^-  ?
  ?.  ?&
        .=  5  (lent p)
        .=  5  (lent q)
      ==
    ~|(%bad-hand-size !!)
  =.  p       (sort p cmp-darc)
  =.  q       (sort q cmp-darc)
  =/  p-kind  (hand-to-kind p)
  =/  q-kind  (hand-to-kind q)
  ?.  =(p-kind q-kind)
    %+  gte
      (kind-to-num p-kind)
    (kind-to-num q-kind)
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
  =/  is-straight
    ?&
      .=  val.c1  +(val.c2)
      .=  val.c2  +(val.c3)
      .=  val.c3  +(val.c4)
      ?|
        .=  val.c4  +(val.c5)
        ?&
          .=  val.c1  13
          .=  val.c5  1
        ==
      ==
    ==
  =/  is-flush
    ?&
      =(sut.c1 sut.c2)
      =(sut.c1 sut.c3)
      =(sut.c1 sut.c4)
      =(sut.c1 sut.c5)
    ==
  ?:  &(is-straight is-flush)
    %straight-flush
  ?:  ?|
        ?&
          .=  val.c1  val.c2
          .=  val.c1  val.c3
          .=  val.c1  val.c4
        ==
        ?&
          .=  val.c2  val.c3
          .=  val.c3  val.c4
          .=  val.c3  val.c5
        ==
      ==
    %four-of-a-kind
  ?:  ?|
        ?&
          .=  val.c1  val.c2
          .=  val.c3  val.c4
          .=  val.c3  val.c5
        ==
        ?&
          .=  val.c1  val.c2
          .=  val.c1  val.c3
          .=  val.c4  val.c5
        ==
      ==
    %full-house
  ?:  is-flush
    %flush
  ?:  is-straight
    %straight
  ?:  ?|
        ?&
          .=  val.c1  val.c2
          .=  val.c1  val.c3
        ==
        ?&
          .=  val.c2  val.c3
          .=  val.c2  val.c4
        ==
        ?&
          .=  val.c3  val.c4
          .=  val.c3  val.c5
        ==
      ==
    %three-of-a-kind
  ?:  ?|
        ?&
          .=  val.c1  val.c2
          .=  val.c3  val.c4
        ==
        ?&
          .=  val.c1  val.c2
          .=  val.c4  val.c5
        ==
        ?&
          .=  val.c2  val.c3
          .=  val.c4  val.c5
        ==
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
++  cmp-four-of-a-kind
  |=  [p=deck q=deck]
  ^-  ?
  =/  parse
    |=  d=deck
    ^-  [quad=darc kicker=darc]
    =/  c1  (snag 0 d)
    =/  c2  (snag 1 d)
    =/  c3  (snag 2 d)
    =/  c4  (snag 3 d)
    =/  c5  (snag 4 d)
    ?:  ?&
          .=  val.c1  val.c2
          .=  val.c1  val.c3
          .=  val.c1  val.c4
        ==
      [c1 c5]
    [c2 c1]
  =/  p-vals  (parse p)
  =/  q-vals  (parse q)
  ?:  (poker-gte quad.p-vals quad.q-vals)
    &
  ?.  =(val.quad.p-vals val.quad.q-vals)
    |
  (poker-gte kicker.p-vals kicker.q-vals)
++  cmp-full-house
  |=  [p=deck q=deck]
  ^-  ?
  =/  parse
    |=  d=deck
    ^-  [triplet=darc pair=darc]
    =/  c1  (snag 0 d)
    =/  c2  (snag 1 d)
    =/  c3  (snag 2 d)
    =/  c4  (snag 3 d)
    =/  c5  (snag 4 d)
    ?:  ?&
          .=  val.c1  val.c2
          .=  val.c3  val.c4
          .=  val.c3  val.c5
        ==
      [c3 c1]
    [c1 c4]
  =/  p-vals  (parse p)
  =/  q-vals  (parse q)
  ?:  (poker-gte triplet.p-vals triplet.q-vals)
    &
  ?.  =(val.triplet.p-vals val.triplet.q-vals)
    |
  (poker-gte pair.p-vals pair.q-vals)
++  cmp-three-of-a-kind
  |=  [p=deck q=deck]
  ^-  ?
  =/  parse
    |=  d=deck
    ^-  [triplet=darc hi-kicker=darc lo-kicker=darc]
    =/  c1  (snag 0 d)
    =/  c2  (snag 1 d)
    =/  c3  (snag 2 d)
    =/  c4  (snag 3 d)
    =/  c5  (snag 4 d)
    ?:  ?&
          .=  val.c1  val.c2
          .=  val.c1  val.c3
        ==
      :+  c1
        (poker-max c4 c5)
      (poker-min c4 c5)
    ?:  ?&
          .=  val.c2  val.c3
          .=  val.c2  val.c4
        ==
      :+  c2
        (poker-max c1 c5)
      (poker-min c1 c5)
    [c3 c1 c2]
  =/  p-vals  (parse p)
  =/  q-vals  (parse q)
  ?:  (poker-gte triplet.p-vals triplet.q-vals)
    &
  ?.  =(val.triplet.p-vals val.triplet.q-vals)
    |
  ?:  (poker-gte hi-kicker.p-vals hi-kicker.q-vals)
    &
  ?.  =(val.hi-kicker.p-vals val.hi-kicker.q-vals)
    |
  (poker-gte lo-kicker.p-vals lo-kicker.q-vals)
++  cmp-two-pair
  |=  [p=deck q=deck]
  ^-  ?
  =/  parse
    |=  d=deck
    ^-  [hi-pair=darc lo-pair=darc kicker=darc]
    =/  c1  (snag 0 d)
    =/  c2  (snag 1 d)
    =/  c3  (snag 2 d)
    =/  c4  (snag 3 d)
    =/  c5  (snag 4 d)
    ?:  ?&
          .=  val.c1  val.c2
          .=  val.c3  val.c4
        ==
      :+  (poker-max c1 c3)
        (poker-min c1 c3)
      c5
    ?:  ?&
          .=  val.c1  val.c2
          .=  val.c4  val.c5
        ==
      :+  (poker-max c1 c4)
        (poker-min c1 c4)
      c3
    :+  (poker-max c2 c4)
      (poker-min c2 c4)
    c1
  =/  p-vals  (parse p)
  =/  q-vals  (parse q)
  ?:  (poker-gte hi-pair.p-vals hi-pair.q-vals)
    &
  ?.  =(val.hi-pair.p-vals val.hi-pair.q-vals)
    |
  ?:  (poker-gte lo-pair.p-vals lo-pair.q-vals)
    &
  ?.  =(val.lo-pair.p-vals val.lo-pair.q-vals)
    |
  (poker-gte kicker.p-vals kicker.q-vals)
++  cmp-pair
  |=  [p=deck q=deck]
  ^-  ?
  =/  parse
    |=  d=deck
    ^-  [pair=darc hi-kicker=darc mi-kicker=darc lo-kicker=darc]
    =/  c1  (snag 0 d)
    =/  c2  (snag 1 d)
    =/  c3  (snag 2 d)
    =/  c4  (snag 3 d)
    =/  c5  (snag 4 d)
    ?:  =(val.c1 val.c2)
      =/  kickers  %+  sort
                      ~[c3 c4 c5]
                   poker-gte
      :^    c1
          (snag 0 kickers)
        (snag 1 kickers)
      (snag 2 kickers)
    ?:  =(val.c2 val.c3)
      =/  kickers  %+  sort
                      ~[c1 c4 c5]
                   poker-gte
      :^    c2
          (snag 0 kickers)
        (snag 1 kickers)
      (snag 2 kickers)
    ?:  =(val.c3 val.c4)
      =/  kickers  %+  sort
                      ~[c1 c2 c5]
                   poker-gte
      :^    c3
          (snag 0 kickers)
        (snag 1 kickers)
      (snag 2 kickers)
    =/  kickers  %+  sort
                    ~[c1 c2 c3]
                 poker-gte
    :^    c4
        (snag 0 kickers)
      (snag 1 kickers)
    (snag 2 kickers)
  =/  p-vals  (parse p)
  =/  q-vals  (parse q)
  ?:  (poker-gte pair.p-vals pair.q-vals)
    &
  ?.  =(val.pair.p-vals val.pair.q-vals)
    |
  ?:  (poker-gte hi-kicker.p-vals hi-kicker.q-vals)
    &
  ?.  =(val.hi-kicker.p-vals val.hi-kicker.q-vals)
    |
  ?:  (poker-gte mi-kicker.p-vals mi-kicker.q-vals)
    &
  ?.  =(val.mi-kicker.p-vals val.mi-kicker.q-vals)
    |
  (poker-gte lo-kicker.p-vals lo-kicker.q-vals)
++  cmp-high-card
  |=  [p=deck q=deck]
  ^-  ?
  =.  p  (sort p poker-gte)
  =.  q  (sort q poker-gte)
  =/  p1  (snag 0 p)
  =/  p2  (snag 1 p)
  =/  p3  (snag 2 p)
  =/  p4  (snag 3 p)
  =/  p5  (snag 4 p)
  =/  q1  (snag 0 q)
  =/  q2  (snag 1 q)
  =/  q3  (snag 2 q)
  =/  q4  (snag 3 q)
  =/  q5  (snag 4 q)
  ?:  (is-wheel p)
    |
  ?:  (is-wheel q)
    &
  ?:  (poker-gte p1 q1)
    &
  ?.  =(val.p1 val.q1)
    |
  ?:  (poker-gte p2 q2)
    &
  ?.  =(val.p2 val.q2)
    |
  ?:  (poker-gte p3 q3)
    &
  ?.  =(val.p3 val.q3)
    |
  ?:  (poker-gte p4 q4)
    &
  ?.  =(val.p4 val.q4)
    |
  (poker-gte p5 q5)
++  is-wheel
  |=  d=deck
  ^-  ?
  =/  c1  (snag 0 d)
  =/  c2  (snag 1 d)
  =/  c3  (snag 2 d)
  =/  c4  (snag 3 d)
  =/  c5  (snag 4 d)
  ?&
    .=  val.c1  1
    .=  val.c2  5
    .=  val.c3  4
    .=  val.c4  3
    .=  val.c5  2
  ==
++  poker-gte
  |=  [p=darc q=darc]
  ^-  ?
  ?:  .=  val.p  1
    &
  ?:  .=  val.q  1
    |
  (gte val.p val.q)
++  poker-max
  |=  [p=darc q=darc]
  ^-  darc
  ?:  (poker-gte p q)
    p
  q
++  poker-min
  |=  [p=darc q=darc]
  ^-  darc
  ?:  (poker-gte p q)
    q
  p
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
++  pretty
  |=  d=deck
  ^-  tape
  %+  weld
    "["
  %+  weld
    %+  reel
      (turn d pretty-darc)
    |=  [p=tape q=tape]  (weld p q)
  "]"
++  pretty-darc
  |=  c=darc
  ^-  tape
  %+  weld
    (pretty-val val.c)
  (pretty-sut sut.c)
++  pretty-val
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
++  pretty-sut
  |=  s=suit
  ^-  tape
  ?-  s
    %hearts    "♥"
    %spades    "♠"
    %clubs     "♣"
    %diamonds  "♦"
  ==
--
