::  $oak: tree to search
::  $leaf: element to search for
:-  %say
|=  [* [oak=(tree) leaf=*]]
:-  %noun
^-  (unit @ud)
=<  (dfs ~[[1 oak]] leaf)
|%
::  $dfs: do a recursive depth-first search of forest for leaf
++  dfs
  ::  $forest: trees remaining to search, with addresses
  ::  $leaf: element to search for
  |=  [forest=(list [@ud (tree)]) leaf=*]
  ^-  (unit @)
  ?~  forest  ~
  ::  $oak: tree to check
  ::  $adr: address of oak in ^oak
  =/  oak  +:(snag 0 forest)
  =/  adr  -:(snag 0 forest)
  ?~  oak  ~
  ?:  =(leaf n.oak)  [~ (peg adr 2)]
  =.  forest  (slag 1 forest)
  =.  forest
    %-  weld
      :_  forest
        :~
          [(peg adr 6) l.oak]
          [(peg adr 7) r.oak]
        ==
  $
--
