let iter x =
  let func = function
  | Some x -> Some (None, x)
  | None -> None
  in
  Iter.make x func

module Monad = Interfaces.Monad.Make(struct
  type 'a t = 'a option

  let (>>=) x f =
    match x with
    | Some x -> f x
    | None -> None
  let wrap x = Some x
end)
