type 'a t = 'a list
(** type alias *)

(** {1 list operations }  *)

val hd: 'a list -> 'a option
(**
  @return the first element of the given list.
  @return [None] if the given list is empty.
*)

val tl: 'a list -> 'a list option
(**
  @return the given list without its first element.
  @return [None] if the given list is empty.
*)

val nth: int -> 'a list -> 'a option
(**
  @return the [n]-th element of the given list.
  the first element is at position [0].
  @return [None] if the list is too short.
  @raise Invalid_argument if [n] is negative.
*)

val rev: 'a list -> 'a list
(**
  @return the reverse of the parameter.
*)

val flatten: 'a list list -> 'a list
(**
  Concatenates a list of lists.
  tail recursive in the size of the overarching list;
  not tail recursive in the size of each element list.
*)

val concat: 'a list list -> 'a list
(** an alias for [flatten] *)

(** {2 iterators} *)

val map: ('a -> 'b) -> 'a list -> 'b list
(**
 [List.map f [a0; ... an]] applies [f] to each of [am]
 @return [[f a0; ... f an]].
 tail recursive, unlike the standard library's implementation.
*)

val iter: 'a list -> 'a Iter.t
(** iterates over all the elements of the list *)

val collect: 'a Iter.t -> 'a list
(** collects the elements of the iterator into a list *)

val fold: 'a -> ('a -> 'b -> 'a) -> 'b list -> 'a
(**
  [fold a f [b0; b1; ... bn]] is [f (... (f (f a b0) b1) ...) bn].
*)


module Monad: Interfaces.Monad with type 'a t = 'a t
