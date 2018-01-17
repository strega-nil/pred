include List

let iter init = 
  Iter.make init 
    (function
    | x :: xs -> Some (xs, x)
    | [] -> None)

module Monad = struct
  type 'a t = 'a list

  let wrap x = [x]
  let (>>=) lst f =
    (* impl note - uses a ref in order to be tail recursive *)
    let rec helper old ret f =
      match old with
      | x :: xs ->
        (* second impl note - not tail recursive *)
        ret := append (f x) !ret;
        helper xs ret f
      | [] -> ()
    in
    let ret = ref [] in
    helper lst ret f;
    !ret

  module Let_syntax = struct
    let bind x ~f = x >>= f
  end
end
