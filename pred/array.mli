val length: 'a array -> int

val get: 'a array -> int -> 'a

val set: 'a array -> int -> 'a -> unit

val make: int -> 'a -> 'a array

val append: 'a array -> 'a array -> 'a array

val concat: 'a array list -> 'a array

val flatten: 'a array list -> 'a array

val sub: 'a array -> int -> int -> 'a array

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
