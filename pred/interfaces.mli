module type Type = sig
  type t
end

module type Monad = sig
  type 'a t
  val (>>=): 'a t -> ('a -> 'b t) -> 'b t
  val wrap: 'a -> 'a t

  module Let_syntax: sig
    val bind: 'a t -> f: ('a -> 'b t) -> 'b t
  end
end

module type Result_monad = sig
  include Monad

  type error
  val wrap_err: error -> 'a t
end
