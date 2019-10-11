:-  %say
::  $oak: tree to search
::  $leaf: element to search for
::
|=  [* [oak=(tree) leaf=*]]
:-  %noun
^-  (unit @ud)
=<  (dfs ~[[1 oak]] leaf)
|%
::  $dfs: do a recursive depth-first search of forest for leaf
::
++  dfs
  ::  $forest: trees remaining to search, with addresses
  ::  $leaf: element to search for
  ::
  |=  [forest=(list [@ud (tree)]) leaf=*]
  ^-  (unit @ud)
  ?~  forest  ~
  ::  $oak: tree to check
  ::  $adr: address of oak in ^oak
  ::
  =/  oak  +:(snag 0 `(list [@ud (tree)])`forest)
  =/  adr  -:(snag 0 `(list [@ud (tree)])`forest)
  ?~  oak  ~
  ?:  =(leaf n.oak)  (some (peg adr 2))
  %_  $
    forest  %-  weld
            :_  (slag 1 forest)
              :~
                [(peg adr 6) l.oak]
                [(peg adr 7) r.oak]
              ==
  ==
--
