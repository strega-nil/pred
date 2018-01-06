let iter x =
  let helper = function
  | Some x -> Some (None, x)
  | None -> None
  in
  Iter.make x helper

module Monad = struct
  type 'a t = 'a option

  let (>>=) x f =
    match x with
    | Some x -> f x
    | None -> None
  let pure x = Some x
end
