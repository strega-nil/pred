type 'a t =
| Iter: 'state * ('state -> ('state * 'a) option) -> 'a t

let for_each f (Iter (state, iter)) =
  let rec helper state =
    match iter state with
    | Some (state, el) -> f(el); helper(state)
    | None -> ()
  in
  helper state

let for_each_break f (Iter (state, iter)) =
  let rec helper state =
    match iter state with
    | Some((state, el)) -> (
      match f(el) with
      | Some(ret) -> Some(ret)
      | None -> helper(state))
    | None -> None
  in
  helper(state)

let next (Iter (state, func)) =
  match func state with
  | Some (new_state, el) -> Some (Iter (new_state, func), el)
  | None -> None

let make state func = Iter (state, func)

let empty = Iter ((), fun () -> None)

let map f (Iter (state, iter')) =
  let iter state =
    match iter' state with
    | Some (state, el) -> Some (state, f el)
    | None -> None
  in
  Iter (state, iter)

let flatten (Iter (main_state, main_iter)) =
  match main_iter main_state with
  | Some (main_state, cur_iter) ->
    let state = (cur_iter, main_state) in
    let rec iter (Iter (iter_state, iter_iter), main_state) =
      match iter_iter iter_state with
      | Some (iter_state, el) ->
        Some ((Iter (iter_state, iter_iter), main_state), el)
      | None ->
        (match main_iter main_state with
        | Some (main_state, cur_iter) ->
          iter (cur_iter, main_state)
        | None -> None)
    in
    Iter (state, iter)
  | None -> empty

exception Iter_zipped_iterators_of_different_lengths
let zip (Iter (state1, iter1)) (Iter (state2, iter2)) =
  let state = (state1, state2) in
  let iter (state1, state2) =
    match (iter1 state1, iter2 state2) with
    | (Some (state1, el1), Some (state2, el2)) ->
      Some ((state1, state2), (el1, el2))
    | (None, None) -> None
    | _ -> raise Iter_zipped_iterators_of_different_lengths
  in
  Iter (state, iter)

let enumerate (Iter (state', iter')) =
  let state = (0, state') in
  let iter (i, state') =
    match (iter' state') with
    | Some (state', el') -> Some ((i + 1, state'), (i + 1, el'))
    | None -> None
  in
  Iter (state, iter)

let range init fin =
  let state = (init, fin) in
  let iter (cur, fin) =
    if cur < fin then
      Some ((cur + 1, fin), cur + 1)
    else
      None
  in
  Iter (state, iter)

module Monad = struct
  type nonrec 'a t = 'a t

  let wrap x =
    let state = Some x in
    let iter = function
    | Some x -> Some (None, x)
    | None -> None
    in
    Iter (state, iter)

  let (>>=) iter f = flatten (map f iter)
      
  module Let_syntax = struct
    let bind x ~f = x >>= f
  end
end
