(**
  [Pred] is intended as a replacement for the OCaml standard library.

  in order to use it with a jbuilder project,
  one may want to [open] it by default.
  this is possible with the [-open Pred] compiler flag.

  {3 sample jbuild file}

  {[
(jbuild_version 1)

(executables
 ((names (main))
  (libraries (pred))
  (flags (:standard -w @a-4 -open Pred))))
  ]}

  it is recommended that one uses this library with Jane Street's [ppx_let];
  this allows for nice monadic bind syntax,
  instead of using [>>=] everywhere.

  to do this, add [ppx_let] as a dependency,
  and add [(preprocess (pps (ppx_let)))]
  to the [library] or [executables] section.
*)

module Array = Pred_array
module Interfaces = Pred_interfaces
module List = Pred_list
module Option = Pred_option
module Result = Pred_result
module Seq = Pred_seq
module String_buffer = Pred_string_buffer
module Caml = Pred_caml

type 'a seq = 'a Seq.t

type string_buffer = String_buffer.t
type ('o, 'e) result = ('o, 'e) Result.t
