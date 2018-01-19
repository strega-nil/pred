let iter x =
  let helper = function
  | Some x -> Some (None, x)
  | None -> None
  in
  Iter.make x helper

module Monad = Interfaces.Make_monad(struct
  type 'a t = 'a option

  let (>>=) x f =
    match x with
    | Some x -> f x
    | None -> None
  let wrap x = Some x
end)
