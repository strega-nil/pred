module type Type = sig
  type t
end

module type Monad_impl = sig
  type 'a t
  val (>>=): 'a t -> ('a -> 'b t) -> 'b t
  val wrap: 'a -> 'a t
end

module type Result_monad_impl = sig
  include Monad_impl

  type error
  val wrap_err: error -> 'a t
end

module type Monad = sig
  type 'a t

  val (>>=): 'a t -> ('a -> 'b t) -> 'b t
  val wrap: 'a -> 'a t

  module Let_syntax: sig
    val bind: 'a t -> f: ('a -> 'b t) -> 'b t
    val map: 'a t -> f: ('a -> 'b) -> 'b t
    val both: 'a t -> 'b t -> ('a * 'b) t
  end
end

module type Result_monad = sig
  type error

  include Monad
  val wrap_err: error -> 'a t
end

module Make_monad(M: Monad_impl) = struct
  type 'a t = 'a M.t

  let ((>>=), wrap) = M.((>>=), wrap)

  module Let_syntax = struct
    let bind x ~f = x >>= f
    let map x ~f = x >>= fun x -> wrap (f x)
    let both x y = x >>= fun x -> y >>= fun y -> wrap (x, y)
  end
end

module Make_result_monad(M: Result_monad_impl) = struct
  type error = M.error

  include Make_monad(M)

  let wrap_err = M.wrap_err
end
