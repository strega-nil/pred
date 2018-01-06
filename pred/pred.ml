module Array = Array_
module Dynamic_array = Dynamic_array
module Interfaces = Interfaces
module Iter = Iter
module List = List_
module Option = Option
module Result = Result
module String_buffer = String_buffer

include Interfaces.Prelude

type 'a iter = 'a Iter.t
type string_buffer = String_buffer.t
type 'a dynamic_array = 'a Dynamic_array.t
