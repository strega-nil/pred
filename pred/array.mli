(**
  arrays are a mutable list of objects, with fixed size.

  they are represented as [[|a0; a1; ... an|]].

  size arguments are passed as [int] -
  however, the size of an array is not allowed to be the full range of [int].
  
  [0 <= size < Sys.max_array_length] for most array types,
  but [0 <= size < Sys.max_array_length / 2] for [float array]
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
*)

(** {1 search} *)

val find: ('a -> bool) -> 'a array -> (int * 'a) option

(* note: mem and memq will be added later *)

(* val mem: 'a -> 'a array -> (int * 'a) option *)

(* val memq: 'a -> 'a array -> (int * 'a) option *)

(** {1 mutation} *)

val fill: 'a array -> int -> int -> 'a -> unit

val blit: 'a array -> int -> 'a array -> int -> int -> unit

val sort: ('a -> 'a -> int) -> 'a array -> unit

val stable_sort: ('a -> 'a -> int) -> 'a array -> unit

(** {1 iteration} *)

val iter: 'a array -> 'a Iter.t

val map: ('a -> 'b) -> 'a array -> 'b array

val fold: 'a -> ('a -> 'b -> 'a) -> 'b array -> 'a

(** {1 conversions with [list]} *)

val to_list: 'a array -> 'a list

val of_list: 'a list -> 'a array
