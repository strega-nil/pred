include module type of List

type 'a t = 'a list

(**
  t operations.
*)

val hd: 'a t -> 'a option
(**
  returns the first element of the given t.
  returns [None] if the given t is empty.
*)

val tl: 'a t -> 'a t option
(**
  returns the given t without its first element.
  returns [None] if the given t is empty.
*)

val nth: int -> 'a t -> 'a option
(**
  returns the [n]-th element of the given t.
  the first element is at position [0].
  returns [None] if the t is too short.
  raises [Invalid_argument "List.nth"] if [n] is negative.
*)

val rev: 'a t -> 'a t
(**
  returns the reverse of the parameter.
*)

val flatten: 'a t t -> 'a t
(**
  Concatenates a t of ts.
  tail recursive in the size of the overarching t;
  not tail recursive in the size of each element t.
*)

val concat: 'a t t -> 'a t
(** an alias for [flatten] *)

(** {1 iterators} *)

val map: ('a -> 'b) -> 'a t -> 'b t
(**
 [List.map f [a0; ... an]] applies [f] to each of [am], and returns
 [[f a0; ... f an]]. tail recursive, unlike the standard library's
 implementation.
*)

val iter: 'a t -> 'a Iter.t
(** iterates over all the elements of the t *)

val collect: 'a Iter.t -> 'a t
(** collects the elements of the iterator into a t *)


module Monad: Interfaces.Monad with type 'a t = 'a t
