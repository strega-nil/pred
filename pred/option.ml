let unwrap = function
| Some el -> el
| None -> raise (Invalid_argument "Option.unwrap")

let unwrap_unsafe opt =
  Obj.obj (Obj.field (Obj.repr opt) 0)

let to_seq self () =
  match self with Some x -> Seq.Cons (x, fun () -> Seq.Nil) | None -> Seq.Nil


module Monad = Interfaces.Monad.Make (struct
  type 'a t = 'a option
  type 'a comonad = 'a

  let ( >>= ) x f = match x with Some x -> f x | None -> None

  let wrap x = Some x
end)
