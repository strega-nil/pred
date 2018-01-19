type ('t, 'e) t = ('t, 'e) result =
  | Ok of 't
  | Error of 'e

let map f = function
| Ok ok -> Ok (f ok)
| Error e -> Error e

let map_err f = function
| Ok ok -> Ok ok
| Error e -> Error (f e)

let and_then f = function
| Ok ok -> f ok
| Error e -> Error e

let expect f = function
| Ok ok -> ok
| Error e -> f e

module Monad(E: Interfaces.Type) = Interfaces.Make_result_monad(struct
  type error = E.t
  type nonrec 'o t = ('o, E.t) t

  let (>>=) self f = and_then f self
  let wrap ok = Ok ok
  let wrap_err err = Error err
end)
