include Pred_caml_stdlib.List

type 'a t = 'a list

let hd = function
| x :: _ -> Some x
| [] -> None

let tl = function
| _ :: xs -> Some xs
| [] -> None

let nth idx lst = nth_opt lst idx

let rev lst =
  let rec helper cur = function
  | x :: xs -> (helper [@tailcall]) (x :: cur) xs
  | [] -> cur
  in
  helper [] lst

let flatten xs =
  let rec helper new_lst = function
  | x :: xs ->
    new_lst := append x !new_lst;
    (helper [@tailcall]) new_lst xs
  | [] -> !new_lst
  in
  helper (ref []) xs

let concat = flatten

let iter init = 
  Iter.make init 
    (function
    | x :: xs -> Some (xs, x)
    | [] -> None)

let map f xs =
  let rec helper f new_lst = function
  | x :: xs ->
    new_lst := (f x) :: !new_lst;
    (helper [@tailcall]) f new_lst xs
  | [] -> !new_lst
  in
  helper f (ref []) xs

let collect it =
  Iter.fold [] (fun acc el -> el :: acc) it

let fold acc f lst = fold_left f acc lst

module Monad = Interfaces.Monad.Make(struct
  type nonrec 'a t = 'a t

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
end)
