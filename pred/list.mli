(**
  lists are singly-linked, immutable lists of objects.

  they are represented syntactically as [[a0; a1; ... an]].

  the base constructors for ['a list] are:
    - [[]], which creates an empty list
    - [(x: 'a) :: (xs: 'a list)],
      which returns the list [xs] with [x] appended to the front.
      [xs] is not mutated at all.
*)

(**
  an alias for the original [List] module from the OCaml standard library.
*)
module Caml : module type of Pred_caml_stdlib.List

(** type alias *)
type 'a t = 'a list

(** {1 list operations }  *)

val hd : 'a list -> 'a option
(**
  [hd xs] returns the first element of [xs] if it isn't empty;
  otherwise, it returns [None].
*)

val tl : 'a list -> 'a list option
(**
  [tl xs] returns [xs] without the first element,
  if [xs] isn't empty.
  otherwise, it returns [None].

  e.g., [tl (x :: xs)] returns [Some xs]
*)

val nth : int -> 'a list -> 'a option
(**
  [nth n [a0; a1; ... am]] returns [Some an],
  if there is an [n]-th element.
  if [n >= length xs], then returns [None].

  has [O(n)] time complexity.

  @raise Invalid_argument if [n < 0]
*)

val nth_exn : int -> 'a list -> 'a
(**
  [nth_exn n lst] is equivalent to [nth n lst],
  except that if [nth] would return [None],
  [nth_exn] raises an exception.

  has [O(n)] time complexity.

  @raise Invalid_argument if [not (0 <= n < length lst)]
*)

val length : _ list -> int
(**
  [length xs] returns the number of elements in [xs].
  has [O(length xs)] time complexity.
*)

val is_empty : _ list -> bool
(**
  equivalent to [length xs = 0],
  except that it has [O(1)] time complexity.
*)

(** {1 constructors} *)

val nil : 'a list
(**
  returns the empty list, [[]], for any type.
*)

val cons : 'a -> 'a list -> 'a list
(**
  [cons x xs] is equivalent to [x :: xs] -
  basically, appends [x] to the front of [xs],
  and returns the new list.
*)

val map : ('a -> 'b) -> 'a list -> 'b list
(**
  [map f as] returns a new list,
  created by applying [f] to each element in [as].

  i.e., [map f [a0; a1; ... an]] returns [[f a0; f a1; ... f an]].

  unlike [Caml.map], this version is tail recursive,
  and guaranteed to run in [O(1)] stack space.
*)

val rev : 'a list -> 'a list
(**
  [rev xs] returns a new list, created by reversing [xs].

  i.e., [rev [a0; a1; ... an]] returns [[an; a(n - 1); ... a0]]
*)

val rev_map : ('a -> 'b) -> 'a list -> 'b list
(**
  [rev_map f as] returns a new list,
  created by applying [f] to each element in [as],
  applied from the back to the front of the list.

  i.e., [rev_map f [a0; a1; ... an]] returns [[f an; f a(n - 1); ... f a0]].

  equivalent to [map f (rev as)], but more efficient.
*)

val append : 'a list -> 'a list -> 'a list
(**
  [append xs ys] returns a new list with each element in [xs] in front of [ys].

  i.e., [append [a0; a1; ... an] [b0; b1; ... bn]]
  returns [[a0; a1; ... an; b0; b1; ... bn]].

  has [O(length xs)] time complexity,
  and uses [O(length xs)] stack space.
*)

val flatten : 'a list list -> 'a list
(**
  [flatten xs] returns a new list,
  created by expanding out each element of [xs] into the new list.

  i.e., [flatten [[a0; a1; ... an]; [b0; b1; ... bn]; ... xn]]
  returns [[a0; a1; ... an; b0; b1; ... bn; ... ]].

  uses [O(n)] stack space, where [n] is the longest list in [xs].
*)

val concat : 'a list list -> 'a list
(** an alias for {!flatten} *)

val flat_map : ('a -> 'b list) -> 'a list -> 'b list
(**
  [flat_map f [a0; a1; ... an]],
  where [f an] generates [[bn0; bn1; ... bnn]],
  generates [[b00; b11; ... ; b10; b11; ... ; ...]].

  equivalent to {!map} followed by {!flatten},
  but more efficient.

  uses [O(n)] stack space,
  where [n] is the longest list returned by [f].
*)

(** {1 iteration} *)

val to_seq : 'a list -> 'a Seq.t
(**
  [to_seq [a0; a1; ... an]] generates the sequence [<a0; a1; ... an>].
*)

val of_seq : 'a Seq.t -> 'a list
(**
  [of_seq <a0; a1; ... an>] creates the list [[a0; a1; ... an]].
*)

val fold : 'a -> ('a -> 'b -> 'a) -> 'b list -> 'a
(**
  [fold a f [b0; b1; ... bn]] is [f (... (f (f a b0) b1) ...) bn].
*)

module Monad : Interfaces.Monad.Interface with type 'a t = 'a t
