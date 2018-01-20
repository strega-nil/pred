val to_seq: 'a option -> 'a Seq.t

module Monad: Interfaces.Monad.Interface with type 'a t = 'a option
