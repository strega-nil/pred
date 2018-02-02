type t = {mutable buff: bytes; mutable length: int}

let make () = {buff= Bytes.create 8; length= 0}

let with_capacity cap =
  if cap < 8 then make () else {buff= Bytes.create cap; length= 0}


let clone {buff; length} = {buff= Bytes.copy buff; length}

let length {length; _} = length

let capacity {buff; _} = Bytes.length buff

let pop self =
  assert (self.length > 0) ;
  self.length <- self.length - 1 ;
  Bytes.get self.buff self.length


let push ch self =
  let resize new_size self =
    assert (self.length <= new_size) ;
    let new_buff = Bytes.create new_size in
    Bytes.blit self.buff 0 new_buff 0 self.length ;
    self.buff <- new_buff
  in
  if self.length == capacity self then resize (self.length * 2) self ;
  Bytes.set self.buff self.length ch ;
  self.length <- self.length + 1


let get idx self =
  assert (idx < self.length) ;
  Bytes.get self.buff idx


let set idx ch self =
  assert (idx < self.length) ;
  Bytes.set self.buff idx ch


let to_string self = Bytes.sub_string self.buff 0 self.length
