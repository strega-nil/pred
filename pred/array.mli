(**
  arrays are a mutable list of objects, with fixed size.

  they are represented as [[|a0; a1; ... an|]].
*)

(** {1 array operations} *)

type 'a t = 'a array
(** type alias *)

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

val make: int -> 'a -> 'a array
(**
  [make n el] creates the array [[|el; el; ... el|]] with length [n].

  each element in the new array is physically equal to each other element,
  in the sense of the [==] predicate.

  @raise Invalid_argument if [not (0 <= n < Sys.max_array_length)].
  if ['a = float], then the maximum size is halved.
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
  the sequence from [arr.(start)] to [arr.(end - 1)], inclusive.

  e.g.: [sub [|0, 1, 2, 3, 4|] 2 4] returns the array [[|2, 3|]]

  e.g.: [sub [|0, 1|] 0 0] returns the array [[||]]

  note: this is different from the ocaml standard library [sub].

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

val copy: 'a array -> 'a array

val fill: 'a array -> int -> int -> 'a -> unit

val blit: 'a array -> int -> 'a array -> int -> int -> unit

val to_list: 'a array -> 'a list

val of_list: 'a list -> 'a array

val iter: 'a array -> 'a Iter.t

val map: ('a -> 'b) -> 'a array -> 'b array

val fold: 'a -> ('a -> 'b -> 'a) -> 'b array -> 'a

val sort: ('a -> 'a -> int) -> 'a array -> unit

val stable_sort: ('a -> 'a -> int) -> 'a array -> unit
