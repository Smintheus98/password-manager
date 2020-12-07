## My utilities

proc toCharSet*(s: string): set[char] =
  ## Turns string into set of characters
  result = {}
  for ch in s:
    result.incl ch

proc toStrSeq*[T](): seq[string] =
  ## Turns iterable type (enum) into set of strings
  result = @[]
  for pq in T:
    result.add $pq

