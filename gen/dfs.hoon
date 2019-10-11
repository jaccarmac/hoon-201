:-  %say
::  $oak: tree to search
::  $leaf: element to search for
::
|=  [* [oak=(tree) leaf=*]]
:-  %noun
^-  (unit @ud)
=<  (dfs ~[[1 oak]] leaf)
|%
::  $tree-queue: type of a list of trees with depth attached
::
+$  tree-queue  (list [@ud (tree)])
::  $dfs: do a recursive depth-first search of forest for leaf
::
++  dfs
  ::  $forest: trees remaining to search, with addresses
  ::  $leaf: element to search for
  ::
  |=  [forest=tree-queue leaf=*]
  ^-  (unit @ud)
  ?~  forest  ~
  ::  $oak: tree to check
  ::  $adr: address of oak in ^oak
  ::
  =/  oak  +:(snag 0 `tree-queue`forest)
  =/  adr  -:(snag 0 `tree-queue`forest)
  ?~  oak  ~
  ?:  =(leaf n.oak)  (some (peg adr 2))
  %_  $
    forest  %-  weld
            :_  (slag 1 `tree-queue`forest)
              :~
                [(peg adr 6) l.oak]
                [(peg adr 7) r.oak]
              ==
  ==
--
