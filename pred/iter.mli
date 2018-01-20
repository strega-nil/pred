(**
  iterators are a sequence of values, either finite or infinite.

  a finite iterator is denoted by the syntax
    [<value1; value2; ... valuen>],
  while an infinite iterator is denoted
    [<value1; value2; ...>].

  for mapping functions, the infinite iterator syntax is used in examples,
  but is meant to describe both infinite and finite iterators.
*)

type 'a t
(**
  the type of an iterator with elements of type ['a].

  e.g., [<0; 1; ...>] is an [int t].
*)

(** {1 constructors} *)

val make: 'state -> ('state -> ('state * 'a) option) -> 'a t
(**
  the most general way of defining an iterator.

  when [f state] returns [Some (new_state, element)],
  the next element of the iterator is [element],
  and the next element will be found by calling [f new_state].
  this is repeated until the function returns [None],
  in which case the iterator is finished.

  returns the iterator defined by the function and initial state.
*)

val empty: 'a t
(**
  generates [<>] for all ['a].
*)

val once: 'a -> 'a t
(**
  given the value [x], generates [<x>].
*)

val repeat: 'a -> 'a t
(**
  given the value [x], generates [<x; x; ... >].
*)

val range: int -> int -> int t
(**
  [range n m], where [n < m], generates [<n; n + 1; ... m - 1>].

  where [m <= n], generates [<>].
*)

(** {1 transformations} *)

val map: ('a -> 'b) -> 'a t -> 'b t
(**
  [map f <a0; a1; ... >] will call the function [f] on each of [a0, a1, ...],
  and generates [<f a0; f a1; ... >].
*)

val flatten: 'a t t -> 'a t
(**
  [flatten <<a0; a1; ... >; <b0; b1; ... >; ... >]
  generates [<a0; a1; ... ; b0; b1; ... ; ...>].
*)

val zip: 'a t -> 'b t -> ('a * 'b) t
(**
  [zip <x0; x1; ... > <y0; y1; ... >]
  generates [<(x0, y0); (x1, y1); ... >].

  the generated iterator will finish when either of the zipped iterators finish.
*)

val enumerate: 'a t -> (int * 'a) t
(**
  [enumerate <a0; a1; ... >] generates [<(0, a0); (1, a1); ... >]
*)

(** {1 size transformations} *)

val take: int -> 'a t -> 'a t
(**
  [take n <a0; a1; ... >] generates the first [n] elements of the iterator.
*)

val take_while: ('a -> bool) -> 'a t -> 'a t
(**
  [take_while p <a0; a1; ... >]
  generates the elements until [p an] returns false.

  e.g. [take_while (fun x -> x > 0) <1; 4; 2; 3; -1; 3>]
  will generate [<1; 4; 2; 3>].
*)

(**
  {1 use}

  note that iterators may be functionally impure behind the scenes.
  the API is intended to be useable in a functionally pure way,
  but OCaml is fundamentally an impure language.
  this means that, given an arbitrary [it: 'a t],
  [(next it) = (next it)] is not necessarily [true].
*)

val next: 'a t -> ('a t * 'a) option
(**
  iterates the iterator by one,
  and returns the generated element,
  plus the new iterator.
*)

val nth: int -> 'a t -> 'a option
(**
  returns the [n]-th element of the iterator.
  if the iterator does not have at least [n] elements,
  then returns [None].
*)

val fold: 'a -> ('a -> 'b -> 'a) -> 'b t -> 'a
(**
  [fold initial f <b0; b1; ... bn>]
  returns [f ( ... (f (f initial b0) b1) ... ) bn]
*)

val for_each: ('a -> unit) -> 'a t -> unit
(**
  [for_each f <a0; a1; ... an>] calls [f] on each element in the iterator,
  as if by [(f a0; f a1; ... f an; ())]
*)

val for_each_break: ('a -> 'b option) -> 'a t -> 'b option
(**
  [for_each_break f <a0; a1; ... >] calls [f] on each element in the iterator,
  until the function returns [None],
  as if by [
    match f a0 with
    | Some x -> Some x
    | None ->
      match f a1 with
      | Some x -> Some x
      | None -> ...
  ]
*)

module Monad: Interfaces.Monad.Interface with type 'a t = 'a t
