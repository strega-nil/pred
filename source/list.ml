module Caml = Pred_caml_stdlib.List

type 'a t = 'a list

(* list operations *)

let hd = function [] -> None | x :: _ -> Some x

let tl = function [] -> None | _ :: xs -> Some xs

let nth n lst =
  let rec helper n = function
    | [] -> None
    | x :: _ when n = 0 -> Some x
    | _ :: xs -> helper (n - 1) xs
  in
  if n < 0 then raise (Invalid_argument "List.nth") else helper n lst


let nth_exn n lst =
  match nth n lst with
  | Some el -> el
  | None -> raise (Invalid_argument "List.nth_exn")


let length lst =
  let rec helper n = function [] -> n | _ :: xs -> helper (n + 1) xs in
  helper 0 lst


let is_empty = function [] -> true | _ :: _ -> false

(** {1 constructors *)

let nil = []

let cons x xs = x :: xs

let map f xs =
  let rec helper f new_lst = function
    | x :: xs ->
        new_lst := f x :: !new_lst ;
        (helper [@tailcall]) f new_lst xs
    | [] -> !new_lst
  in
  helper f (ref []) xs


let rev lst =
  let rec helper cur = function
    | x :: xs -> (helper [@tailcall]) (x :: cur) xs
    | [] -> cur
  in
  helper [] lst


let rev_map f lst =
  let rec helper f acc = function
    | [] -> acc
    | x :: xs -> helper f (f x :: acc) xs
  in
  helper f [] lst


let append = Caml.append

let flatten = Caml.flatten

let concat = flatten

let flat_map f lst =
  let rec helper old ret f =
    match old with
    | x :: xs ->
        (*
        impl note - not tail recursive
        uses stack space on the order of O(len (f x))
      *)
        ret := append (f x) !ret ;
        (helper [@tailcall]) xs ret f
    | [] -> !ret
  in
  helper lst (ref []) f


(* iteration *)

let rec to_seq lst () =
  match lst with x :: xs -> Seq.Cons (x, to_seq xs) | [] -> Seq.Nil


let of_seq it = Seq.fold [] (fun acc el -> el :: acc) it

let fold acc f lst = Caml.fold_left f acc lst

module Monad = Interfaces.Monad.Make (struct
  type nonrec 'a t = 'a t

  type 'a comonad = 'a

  let wrap x = [x]

  let ( >>= ) xs f = flat_map f xs
end)
