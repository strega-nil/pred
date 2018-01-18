type 'a t =
| Iter: 'state * ('state -> ('state * 'a) option) -> 'a t


(* constructors *)

let make state func = Iter (state, func)

let empty = Iter ((), fun () -> None)

let once el =
  let state = Some el in
  let func = function
  | Some el -> Some (None, el)
  | None -> None
  in
  Iter (state, func)

let repeat el =
  let state = el in
  let func el = Some (el, el) in
  Iter (state, func)

let range init fin =
  let state = (init, fin) in
  let func (cur, fin) =
    if cur < fin then
      Some ((cur + 1, fin), cur + 1)
    else
      None
  in
  Iter (state, func)


(* transformations *)

let map f (Iter (state, func')) =
  let func state =
    match func' state with
    | Some (state, el) -> Some (state, f el)
    | None -> None
  in
  Iter (state, func)

let flatten (Iter (main_state, main_func)) =
  match main_func main_state with
  | Some (main_state, iter) ->
    let state = (iter, main_state) in
    let rec func (Iter (iter_state, iter_func), main_state) =
      match iter_func iter_state with
      | Some (iter_state, el) ->
        Some ((Iter (iter_state, iter_func), main_state), el)
      | None ->
        (match main_func main_state with
        | Some (main_state, iter) ->
          (func [@tailcall]) (iter, main_state)
        | None -> None)
    in
    Iter (state, func)
  | None -> empty

let zip (Iter (state1, func1)) (Iter (state2, func2)) =
  let state = (state1, state2) in
  let func (state1, state2) =
    match (func1 state1, func2 state2) with
    | (Some (state1, el1), Some (state2, el2)) ->
      Some ((state1, state2), (el1, el2))
    | _ -> None
  in
  Iter (state, func)

let enumerate (Iter (state', func')) =
  let state = (0, state') in
  let func (i, state') =
    match (func' state') with
    | Some (state', el') -> Some ((i + 1, state'), (i + 1, el'))
    | None -> None
  in
  Iter (state, func)


(* misc *)

let take final (Iter (state', func')) =
  let state = (0, state') in
  let func (n, state') =
    if n < final then
      match func' state' with
      | Some (state', el) -> Some((n + 1, state'), el)
      | None -> None
    else
      None
  in
  Iter (state, func)

let take_while pred (Iter (state, func')) =
  let func state =
    match func' state with
    | Some (state, el) when pred el -> Some (state, el)
    | Some _
    | None -> None
  in
  Iter (state, func)


(* use *)

let next (Iter (state, func)) =
  match func state with
  | Some (new_state, el) -> Some (Iter (new_state, func), el)
  | None -> None

let nth n (Iter (state, func)) =
  let rec helper n state =
    match func state with
    | Some (state, _) when n > 0 -> (helper [@tailcall]) (n - 1) state
    | Some (_, el) -> Some el
    | None -> None
  in
  helper n state

let fold init f (Iter (state, func)) =
  let rec helper acc state =
    match func state with
    | Some (state, el) ->
      let acc = f acc el in
      (helper [@tailcall]) acc state
    | None -> acc
  in
  helper init state

let for_each f (Iter (state, func)) =
  let rec helper state =
    match func state with
    | Some (state, el) -> f el; (helper [@tailcall]) state
    | None -> ()
  in
  helper state

let for_each_break f (Iter (state, func)) =
  let rec helper state =
    match func state with
    | Some (state, el) ->
      (match f el with
      | Some ret -> Some ret
      | None -> (helper [@tailcall]) state)
    | None -> None
  in
  helper(state)

module Monad = struct
  type nonrec 'a t = 'a t

  let wrap = once

  let (>>=) iter f = flatten (map f iter)

  module Let_syntax = struct
    let bind x ~f = x >>= f
  end
end
