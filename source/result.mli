type ('o, 'e) t = ('o, 'e) result

val map : ('o -> 'o2) -> ('o, 'e) t -> ('o2, 'e) t

val map_err : ('e -> 'e2) -> ('o, 'e) t -> ('o, 'e2) t

val and_then : ('o -> ('o2, 'e) t) -> ('o, 'e) t -> ('o2, 'e) t

val expect : ('e -> 'o) -> ('o, 'e) t -> 'o

module Monad (E : Interfaces.Type) :
  Interfaces.Result_monad.Interface
  with type error = E.t
   and type 'o t = ('o, E.t) t
   and type 'a comonad = 'a
