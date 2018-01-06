val iter: 'a option -> 'a Iter.t

module Monad: Interfaces.Monad with type 'a t = 'a option
