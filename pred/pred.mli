(**
  {1 [Pred]}

  [Pred] is intended as a replacement for the OCaml standard library.

  in order to use it with a jbuilder project,
  you may want to [open] it by default.
  you can do this with the [-open Pred] compiler flag.

  {2 sample jbuild file}

  {[
(jbuild_version 1)

(executables
 ((names (main))
  (libraries (pred))
  (flags (:standard -w @a-4 -open Pred))))
  ]}
*)

module Array = Array
module Interfaces = Interfaces
module Iter = Iter
module List = List
module Option = Option
module Result = Result
module String_buffer = String_buffer

module Caml = Pred_caml_stdlib

type 'a iter = 'a Iter.t
type string_buffer = String_buffer.t
