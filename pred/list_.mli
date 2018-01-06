include module type of List

val iter: 'a list -> 'a Iter.t

module Monad: Interfaces.Monad with type 'a t = 'a list
