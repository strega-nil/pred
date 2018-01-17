type 'a t

val for_each: ('a -> unit) -> 'a t -> unit

(**
  if the inner closure returns Some(v), then for_each_break returns Some(v).
  else, if the inner closure returns None for all iterated values, return None
 *)
val for_each_break: ('a -> 'b option) -> 'a t -> 'b option

val next: 'a t -> ('a t * 'a) option

val make: 'state -> ('state -> ('state * 'a) option) -> 'a t
val empty: 'a t
val map: ('a -> 'b) -> 'a t -> 'b t
val flatten: 'a t t -> 'a t

exception Iter_zipped_iterators_of_different_lengths
val zip: 'a t -> 'b t -> ('a * 'b) t
val enumerate: 'a t -> (int * 'a) t
val range: int -> int -> int t

module Monad: Interfaces.Monad with type 'a t = 'a t
