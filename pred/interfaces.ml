module type Type = sig
  type t
end

module Monad = struct
  module type Implementation = sig
    type 'a t

    val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t

    val wrap : 'a -> 'a t
  end

  module type Interface = sig
    type 'a t

    val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t

    val wrap : 'a -> 'a t

    module Let_syntax : sig
      val bind : 'a t -> f:('a -> 'b t) -> 'b t

      val map : 'a t -> f:('a -> 'b) -> 'b t

      val both : 'a t -> 'b t -> ('a * 'b) t
    end
  end

  module Make (M : Implementation) = struct
    include M

    module Let_syntax = struct
      let bind x ~f = x >>= f

      let map x ~f = x >>= fun x -> wrap (f x)

      let both x y = x >>= fun x -> y >>= fun y -> wrap (x, y)
    end
  end
end

module Result_monad = struct
  module type Implementation = sig
    type error

    include Monad.Implementation

    val wrap_err : error -> 'a t
  end

  module type Interface = sig
    type error

    include Monad.Interface

    val wrap_err : error -> 'a t
  end

  module Make (M : Implementation) = struct
    type error = M.error

    include Monad.Make (M)

    let wrap_err = M.wrap_err
  end
end
