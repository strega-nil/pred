type +'a node = Nil | Cons of 'a * 'a t
 and 'a t = unit -> 'a node

(* constructors *)

let empty () = Nil

let once el () = Cons (el, empty)

let rec repeat el () = Cons (el, repeat el)

let rec range start end_ () =
  if start < end_ then Cons (start, range (start + 1) end_) else Nil


(* transformations *)

let rec map f seq () =
  match seq () with Cons (el, seq) -> Cons (f el, map f seq) | Nil -> Nil


let rec flatten seq () =
  match seq () with
  | Cons (inner_seq, seq) -> flatten_and_append inner_seq seq ()
  | Nil -> Nil


and flatten_and_append seq tail () =
  match seq () with
  | Cons (el, seq) -> Cons (el, flatten_and_append seq tail)
  | Nil -> flatten tail ()


let rec flat_map f seq () =
  match seq () with
  | Cons (el, seq) -> flat_map_append f (f el) seq ()
  | Nil -> Nil


and flat_map_append f seq tail () =
  match seq () with
  | Cons (el, seq) -> Cons (el, flat_map_append f seq tail)
  | Nil -> flat_map f tail ()


let rec zip seq1 seq2 () =
  match (seq1 (), seq2 ()) with
  | Cons (el1, seq1), Cons (el2, seq2) -> Cons ((el1, el2), zip seq1 seq2)
  | Cons _, Nil
  | Nil, Cons _
  | Nil, Nil -> Nil


let enumerate seq =
  let rec helper idx seq () =
    match seq () with
    | Cons (el, seq) -> Cons ((idx, el), helper (idx + 1) seq)
    | Nil -> Nil
  in
  helper 1 seq


(* size transformations *)

let take n seq =
  let rec helper n seq () =
    if n = 0 then Nil
    else
      match seq () with
      | Cons (el, seq) -> Cons (el, helper (n - 1) seq)
      | Nil -> Nil
  in
  if n < 0 then raise (Invalid_argument "negative n") else helper n seq


let rec take_while p seq () =
  match seq () with
  | Cons (el, seq) when p el -> Cons (el, take_while p seq)
  | Cons _ | Nil -> Nil


(* use *)

let nth n seq =
  let rec helper n seq =
    match seq () with
    | Cons (el, _) when n = 0 -> Some el
    | Cons (_, seq) -> (helper [@tailcall]) (n - 1) seq
    | Nil -> None
  in
  if n < 0 then raise (Invalid_argument "negative n") else helper n seq


let rec fold init f seq =
  match seq () with
  | Cons (el, seq) -> (fold [@tailcall]) (f init el) f seq
  | Nil -> init


let rec for_each f seq =
  match seq () with Cons (el, seq) -> f el ; for_each f seq | Nil -> ()


let rec for_each_break f seq =
  match seq () with
  | Cons (el, seq) -> (
    match f el with
    | Some ret -> Some ret
    | None -> (for_each_break [@tailcall]) f seq )
  | Nil -> None


module Monad = Interfaces.Monad.Make (struct
  type nonrec 'a t = 'a t

  type 'a comonad = 'a

  let wrap = once

  let ( >>= ) seq f = flat_map f seq
end)
