let to_seq self () =
  match self with Some x -> Seq.Cons (x, fun () -> Seq.Nil) | None -> Seq.Nil


module Monad = Interfaces.Monad.Make (struct
  type 'a t = 'a option

  let ( >>= ) x f = match x with Some x -> f x | None -> None

  let wrap x = Some x
end)
