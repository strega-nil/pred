(**
  arrays are mutable lists of objects, with fixed size.

  they are represented syntactically as [[|a0; a1; ... an|]].

  size arguments are passed as [int] -
  however, the size of an array is not allowed to be the full range of [int].
  
  [0 <= size < Sys.max_array_length] for most array types,
  but [0 <= size < Sys.max_array_length / 2] for [float array]
*)

module Caml: module type of Pred_caml_stdlib.Array
(**
  an alias for the original [Array] module from the OCaml standard library.
*)

type 'a t = 'a array
(** type alias *)

(** {1 basic array operations} *)

val length: 'a array -> int
(**
  returns the number of elements which are stored in the array
*)

val get: 'a array -> int -> 'a
(**
  returns the [n]-th value in the array.
  used for the [arr.(n)] syntax sugar.
  one should not use this function by itself;
  always use the syntax sugar.

  note: the parameter ordering is "backwards" due to the syntax sugar

  @raise Invalid_argument if [not (0 <= n < length arr)] 
*)

val unsafe_get: 'a array -> int -> 'a
(**
  [unsafe_get arr n] is equivalent to [get arr n],
  except that an instead of raising an exception,
  [not (0 <= n < length arr)] will result in undefined behavior.
*)

val nth: int -> 'a array -> 'a option
(**
  returns the [n]-th value in the array.
  if [n > length arr], then returns [None].
  
  @raise Invalid_argument if [n < 0]
*)

val set: 'a array -> int -> 'a -> unit
(**
  sets the [n]-th object in the array to the provided value.
  used for the [arr.(n) <- value] syntax sugar.
  one should not use this function by itself;
  always use the syntax sugar.

  note: the parameter ordering is "backwards" due to the syntax sugar

  @raise Invalid_argument if [not (0 <= n < length arr)]
*)

val unsafe_set: 'a array -> int -> 'a -> unit
(**
  [unsafe_set arr n el] is equivalent to [set arr n el],
  except that an instead of raising an exception,
  [not (0 <= n < length arr)] will result in undefined behavior.
*)

(** {1 constructors} *)

val make: int -> 'a -> 'a array
(**
  [make n el] creates the array [[|el; el; ... el|]] with length [n].

  each element in the new array is physically equal to each other element,
  in the sense of the [==] predicate.

  @raise Invalid_argument if n is an invalid size
*)

val init: int -> (int -> 'a) -> 'a array
(**
  [init n f] creates the array [[|f 0; f 1; ... f (n - 1)|]].

  @raise Invalid argument if n is an invalid size
*)

val map: ('a -> 'b) -> 'a array -> 'b array
(**
  [map f arr] is equivalent to
  [init (length arr) (fun i -> f arr.(i))].
*)

val append: 'a array -> 'a array -> 'a array
(**
  [append [|x0; x1; ... xn|] [|y0; y1; ... yn|]]
  returns a new array
  [[|x0; x1; ... xn; y0; y1; ... yn|]].
*)

val flatten: 'a array list -> 'a array
(**
  [flatten [[|x0; x1; ... xn|]; [|y0; y1; ... yn|]; ...]]
  is equivalent to {!append} for each [array] in the [list].
*)

val concat: 'a array list -> 'a array
(** an alias for {!flatten} *)

val sub: int -> int -> 'a array -> 'a array
(**
  [sub start end arr] returns the new array from a subslice of [arr]:
  the sequence from [arr.(start)] to [arr.(end - 1)].

  e.g.: [sub [|0; 1; 2; 3; 4|] 2 4] returns the array [[|2; 3|]]

  e.g.: [sub [|0; 1|] 0 0] returns the array [[||]]

  note: this is different from {!Caml.sub},
  but implements the same functionality.

  @raise Invalid_parameter if
    [start < 0],
    [end < start],
    or [end > length arr]
*)

val sub_from: int -> 'a array -> 'a array
(**
  [sub_from start arr] returns the new array defined by the sequence from
  [arr.(start)] to the end.

  equivalent to [sub start (length arr) arr]

  @raise Invalid_parameter if
    [start < 0],
    [start > length arr]
*)

val sub_to: int -> 'a array -> 'a array
(**
  [sub_to end arr] returns the new array defined by the sequence from
  [arr.(0)] to [arr.(end - 1)].

  equivalent to [sub 0 end arr]

  @raise Invalid_parameter if
    [end < 0],
    [end > length arr]
*)

val copy: 'a array -> 'a array
(**
  [copy arr] returns a new array with the same elements as [arr].
*)

(** {1 search} *)

val find: ('a -> bool) -> 'a array -> (int * 'a) option
(**
  [find p arr] finds the first element in [arr] that satisfies [p],
  and returns both its index,
  and the element itself.

  if no element satisfies the predicate,
  then [find] returns [None].
*)

(* note: mem and memq will be added later *)

(* val mem: 'a -> 'a array -> (int * 'a) option *)

(* val memq: 'a -> 'a array -> (int * 'a) option *)

(** {1 mutation} *)

val fill: int -> int -> 'a -> 'a array -> unit
(**
  [fill start end el arr] sets each element
  from [arr.(start)] to [arr.(end - 1)] to [el].

  @raise Invalid_argument if
    [start < 0],
    [end < start],
    or [end > length arr]
*)

val blit: int -> int -> 'a array -> int -> 'a array -> unit
(**
  [blit start1 end1 arr1 start2 arr2]
  copies the elements from [arr1.(start1)] to [arr1.(end1 - 1)],
  to the range starting at [arr2.(start2)].

  @raise Invalid_argument if
    [start1 < 0], [start2 < 0],
    [end1 < start1],
    [end1 > length arr1],
    or [start1 + (end1 - start1) > length arr2]
*)

val sort: ('a -> 'a -> int) -> 'a array -> unit
(**
  [sort c arr] sorts [arr] using [c] as a comparison function.

  if [c a1 a2 < 0], then [a1] will sort before [a2].

  if [c a1 a2 > 0], then [a1] will sort after [a2].

  if [c a1 a2 = 0], then ordering is not guaranteed.

  [c] must be a total order on the set of elements in the array.

  [sort] is guaranteed to run in constant heap space,
  and at most logarithmic stack space.
*)

val stable_sort: ('a -> 'a -> int) -> 'a array -> unit
(**
  equivalent to {!sort}, except that elements that compare equal
  will have the same order as in the original array.

  not guaranteed to run in constant heap space.
*)

val fast_sort: ('a -> 'a -> int) -> 'a array -> unit
(**
  equivalent to either {!sort} or {!stable_sort},
  whichever is faster on typical input.
*)

(** {1 iteration} *)

val to_seq: 'a array -> 'a Seq.t
(**
  [to_seq [|a0; a1; ... an|]] generates the sequence [<a0; a1; ... an>].

  note: there is no [of_seq] for [array].
  this is due to the inherent nature of sequences being of unknown size.
  it would require an intermediate allocation.
  
  if one wants something similar,
  they can use [of_list (List.of_seq seq)]
*)

val fold: 'a -> ('a -> 'b -> 'a) -> 'b array -> 'a
(**
  [fold a f [|b0; b1; ... bn|]] is [f (... (f (f a b0) b1) ...) bn].
*)

(** {1 conversions with [list]} *)

val to_list: 'a array -> 'a list
(**
  [to_list [|a0; a1; ... an|]] creates the list [[a0; a1; ... an]].
*)

val of_list: 'a list -> 'a array
(**
  [of_list [a0; a1; ... an]] creates the array [[|a0; a1; ... an|]].
*)
