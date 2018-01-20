module Caml = Pred_caml_stdlib.Array

type 'a t = 'a array

(* basic array operations *)

let length = Caml.length

let get = Caml.get
let unsafe_get = Caml.unsafe_get

let nth n arr =
  if n < length arr then
    Some (Caml.get arr n)
  else
    None

let set = Caml.set
let unsafe_set = Caml.unsafe_set

(* constructors *)

let make = Caml.make

let init = Caml.init

let append = Caml.append

let flatten = Caml.concat

let concat = Caml.concat

let sub start end_ arr =
  Caml.sub arr start (end_ - start)

let sub_from start arr = sub start (length arr) arr

let sub_to end_ = sub 0 end_

let copy = Caml.copy

(** {1 search} *)

let find p arr =
  let rec helper p arr len i =
    if i < len then
      (let x = unsafe_get arr i in
      if p x then
        Some (i, x)
      else
        (helper [@tailcall]) p arr len (i + 1))
    else
      None
  in
  helper p arr (length arr) 0

(** {1 mutation} *)

let fill start end_ el arr =
  Caml.fill arr start (end_ - start) el

let blit start1 end1 arr1 start2 arr2 =
  Caml.blit arr1 start1 arr2 start2 (end1 - start1)

let sort = Caml.sort

let stable_sort = Caml.stable_sort

let fast_sort = Caml.fast_sort

(** {1 iteration} *)

let iter arr =
  Iter.make 0
    (fun idx ->
      if idx < length arr then
        Some (idx + 1, get arr idx)
      else
        None)

let map f arr =
  init
    (length arr)
    (fun i -> f (unsafe_get arr i))

let fold acc f arr = Caml.fold_left f acc arr

(** {1 conversions with [list]} *)

let to_list = Caml.to_list

let of_list = Caml.of_list
