include List

let iter init = 
  Iter.make init 
    (function
    | x :: xs -> Some (xs, x)
    | [] -> None)

(* rewritten to be tail-recursive *)
let map f xs =
  let rec helper f new_lst = function
  | x :: xs ->
    new_lst := (f x) :: !new_lst;
    (helper [@tailcall]) f new_lst xs
  | [] -> !new_lst
  in
  helper f (ref []) xs

module Monad = struct
  type 'a t = 'a list

  let wrap x = [x]
  let (>>=) lst f =
    (* impl note - uses a ref in order to be tail recursive *)
    let rec helper old ret f =
      match old with
      | x :: xs ->
        (*
          impl note - not tail recursive
          uses stack space on the order of O(len (f x))
        *)
        ret := append (f x) !ret;
        (helper [@tailcall]) xs ret f
      | [] -> ()
    in
    let ret = ref [] in
    helper lst ret f;
    !ret

  module Let_syntax = struct
    let bind x ~f = x >>= f
  end
end
