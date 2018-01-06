type 'a t

val make: unit -> 'a t

val with_capacity: int -> 'a t

val clone: 'a t -> 'a t

val length: 'a t -> int

val capacity: 'a t -> int

val push: 'a t -> 'a -> unit

val pop: 'a t -> 'a

val get: 'a t -> int -> 'a

val set: 'a t -> int -> 'a -> unit

val to_array: 'a t -> 'a array
