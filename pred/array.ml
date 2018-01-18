include Pred_caml_stdlib.Array

let iter arr =
  Iter.make 0
    (fun idx ->
      if idx < length(arr) then
        Some (idx + 1, get arr idx)
      else
        None)

let fold acc f arr = fold_left f acc arr

let flatten = concat
