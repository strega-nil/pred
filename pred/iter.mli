type 'a t

(** {1 constructors} *)

val make: 'state -> ('state -> ('state * 'a) option) -> 'a t
(**
  creates an iterator from state and a function.

  each element of the iterator is accessed lazily;
  the next element of the iterator is created by calling the supplied function
  on the state returned with each element.

  the iterator is considered finished when the function returns [None].
*)

val empty: 'a t
(**
  creates an empty iterator, with no elements.
*)

val once: 'a -> 'a t
(**
  creates an iterator of size [1], containing just the value passed.
*)

val repeat: 'a -> 'a t
(**
  creates an iterator which repeats the value passed forever.
*)

val range: int -> int -> int t
(**
  [range n m], for [n < m], creates an iterator [n, n + 1, ... m - 1].

  for [m <= n], creates an empty iterator.
*)

(** {1 transformations} *)

val map: ('a -> 'b) -> 'a t -> 'b t

val flatten: 'a t t -> 'a t

val zip: 'a t -> 'b t -> ('a * 'b) t
(**
  given two iterators [x] of size [n], and [y] of size [n],
  with elements [x0, x1, ...xn]
  and [y0, y1, ...ym].

  where [n < m], returns an iterator [(x0, y0), (y1, x1), ...(xn, yn)]
  where [m < n], returns an iterator [(x0, y0), (y1, x1), ...(xm, ym)]
*)

val enumerate: 'a t -> (int * 'a) t

(** {1 size transformations} *)
val take: int -> 'a t -> 'a t
val take_while: ('a -> bool) -> 'a t -> 'a t

(** {1 use} *)
val next: 'a t -> ('a t * 'a) option
val nth: int -> 'a t -> 'a option
val fold: 'a -> ('a -> 'b -> 'a) -> 'b t -> 'a
val for_each: ('a -> unit) -> 'a t -> unit

(**
  if the inner closure returns Some(v), then for_each_break returns Some(v).
  else, if the inner closure returns None for all iterated values, return None
 *)
val for_each_break: ('a -> 'b option) -> 'a t -> 'b option

module Monad: Interfaces.Monad with type 'a t = 'a t
