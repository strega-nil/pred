include Array

let iter arr =
  Iter.make 0
    (fun idx ->
      if idx < length(arr) then
        Some (idx + 1, arr.(idx))
      else
        None)
