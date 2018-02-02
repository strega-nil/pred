(* TODO(ubsan): support unicode *)

type t

val make : unit -> t

val with_capacity : int -> t

val clone : t -> t

val length : t -> int

val capacity : t -> int

val push : char -> t -> unit

val pop : t -> char

val get : int -> t -> char

val set : int -> char -> t -> unit

val to_string : t -> string
