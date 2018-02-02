val unwrap : 'a option -> 'a
(**
  takes an optional value, and unwraps it.

  @raise Invalid_argument "Option.unwrap" if the argument is [None]
*)

val unwrap_unsafe : 'a option -> 'a
(**
  takes an optional value, and unwraps it {b unsafely}.

  {4 DO NOT USE}

  this function {b does} invoke undefined behavior if the argument is [None] -
  only use it if it is {b impossible} for the argument to be [None],
  and the code requires that extra amount of speed.

  this is not a good function.
*)

val to_seq : 'a option -> 'a Seq.t

module Monad :
  Interfaces.Monad.Interface
  with type 'a t = 'a option
   and type 'a comonad = 'a
