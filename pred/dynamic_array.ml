(*
 TODO(nicole): figure out whether I'd be able to use un-optional arrays, with smth like
 Array.make(10, Obj.magic(0))?
 *)
type 'a t = {
  mutable buff: 'a option array;
  mutable length: int;
}

let make () = {buff = [||]; length = 0}

let with_capacity cap = {buff = Array.make cap None; length = 0}

let clone {buff; length} = {buff = Array.copy(buff); length}

let length {length; _} = length

let capacity {buff; _} = Array.length buff

let unwrap = function
| None -> assert false
| Some(el) -> el

let resize self new_size =
  assert (self.length <= new_size);
  let new_buff = Array.make new_size None in
  Array.blit self.buff 0 new_buff 0 self.length;
  self.buff <- new_buff

let pop self =
  assert (self.length > 0);
  self.length <- self.length - 1;
  let ret = self.buff.(self.length) in
  self.buff.(self.length) <- None; (* GC purposes *)
  unwrap ret

let push el self =
  if self.length == capacity self then (
    if (self.length != 0) then (
      resize self (self.length * 2)
    ) else (
      resize self 4
    );
  );
  self.buff.(self.length) <- Some(el);
  self.length <- self.length + 1

let get idx self =
  assert (idx < self.length);
  unwrap self.buff.(idx)

let set idx el self =
  assert (idx < self.length);
  self.buff.(idx) <- Some(el)

let to_array self =
  Array.init
    self.length
    (fun i -> unwrap self.buff.(i))

