module Prelude = struct
  module type Type = sig
    type t
  end
end

include Prelude

module type Monad = sig
  type 'a t
  val (>>=): 'a t -> ('a -> 'b t) -> 'b t
  val pure: 'a -> 'a t
end

module type Monad_result = sig
  include Monad
  type error
  val pure_err: error -> 'a t
end
