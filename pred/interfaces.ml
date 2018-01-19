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

  module Let_syntax: sig
    val bind: 'a t -> f: ('a -> 'b t) -> 'b t
    val map: 'a t -> f: ('a -> 'b) -> 'b t
    module Open_on_rhs: sig
      val wrap: 'a -> 'a t
    end
  end

  module Operator_syntax: sig
    val (>>=): 'a t -> ('a -> 'b t) -> 'b t
    val wrap: 'a -> 'a t
  end
end

module type Result_monad = sig
  type error
  type 'a t

  module Let_syntax: sig
    val bind: 'a t -> f: ('a -> 'b t) -> 'b t
    val map: 'a t -> f: ('a -> 'b) -> 'b t
    module Open_on_rhs: sig
      val wrap: 'a -> 'a t
      val wrap_err: error -> 'a t
    end
  end

  module Operator_syntax: sig
    val (>>=): 'a t -> ('a -> 'b t) -> 'b t
    val wrap: 'a -> 'a t
    val wrap_err: error -> 'a t
  end
end

module Make_monad(M: Monad_impl) = struct
  type 'a t = 'a M.t

  module Let_syntax = struct
    let bind x ~f = M.(x >>= f)
    let map x ~f = M.(x >>= fun x -> wrap (f x))

    module Open_on_rhs = struct
      let wrap = M.wrap
    end
  end

  module Operator_syntax = struct
    let ((>>=), wrap) = M.((>>=), wrap)
  end
end

module Make_result_monad(M: Result_monad_impl) = struct
  type error = M.error
  type 'a t = 'a M.t

  module Let_syntax = struct
    let bind x ~f = M.(x >>= f)
    let map x ~f = M.(x >>= fun x -> wrap (f x))

    module Open_on_rhs = struct
      let wrap = M.wrap
      let wrap_err = M.wrap_err
    end
  end

  module Operator_syntax = struct
    let ((>>=), wrap, wrap_err) = M.(((>>=), wrap, wrap_err))
  end
end
