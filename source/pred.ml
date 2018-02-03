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
