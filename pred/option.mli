val iter: 'a option -> 'a Iter.t

module Monad: Interfaces.Monad.Interface with type 'a t = 'a option
