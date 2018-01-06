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

module Monad(E: Interfaces.Type) = struct
  type nonrec 'o t = ('o, E.t) t
  type error = E.t

  let (>>=) self f = and_then f self
  let pure ok = Ok ok
  let pure_err err = Error err
end
