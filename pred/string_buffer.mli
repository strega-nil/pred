(* TODO(ubsan): support unicode *)
type t

val make: unit -> t

val with_capacity: int -> t

val clone: t -> t

val length: t -> int

val capacity: t -> int

val push: t -> char -> unit

val pop: t -> char

val get: t -> int -> char

val set: t -> int -> char -> unit

val to_string: t -> string
