type 'a t

val make: unit -> 'a t

val with_capacity: int -> 'a t

val clone: 'a t -> 'a t

val length: 'a t -> int

val capacity: 'a t -> int

val push: 'a -> 'a t -> unit

val pop: 'a t -> 'a

val get: int -> 'a t -> 'a

val set: int -> 'a -> 'a t -> unit

val to_array: 'a t -> 'a array
