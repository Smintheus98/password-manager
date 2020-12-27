## This module implements some usefull procedures to simplify 
## getting information from the user (interactive)

import strutils, strformat

proc getSpacing(size: int): string =
  result = ""
  for i in 0..<size:
    result &= " "

proc getStrInput*(indent: int; prompt: string; inline: bool = true): string =
  let spacing = getSpacing(indent)
  if inline:
    stdout.write(spacing, prompt, " = ")
  else:
    echo(spacing, prompt, ":")
    stdout.write(spacing, " > ")
  return stdin.readLine.strip

proc getNumInput*(indent: int; prompt: string; onlyPositive = false, inline: bool = true): int =
  let spacing = getSpacing(indent)
  while true:
    if inline:
      stdout.write(spacing, prompt, " = ")
    else:
      echo(spacing, prompt, ":")
      stdout.write(spacing, " > ")
    try:
      result = stdin.readLine.strip.parseInt
      if onlyPositive and result < 0:
        raise newException(ValueError, "Only Positive")
    except ValueError:
      echo "Give Numerical Value" & (if onlyPositive: " Greater Than 0" else: "")
      continue

proc getConfirm*(indent: int, question: string, preferNo = true): bool =
  let spacing = getSpacing(indent)
  stdout.write(spacing, question)
  if preferNo:
    stdout.write("[y/N]: ")
    return stdin.readLine.strip.toLowerAscii.startsWith('y')
  else:
    stdout.write("[Y/n]: ")
    return not stdin.readLine.strip.toLowerAscii.startsWith('n')

proc getChoice*(indent: int, preInstruction = "", options: openArray[string]): int =
  let spacing = getSpacing(indent)
  let optionspacing = spacing & "  "
  while true:
    if preInstruction != "":
      echo(spacing, preInstruction, ":")
    for index, option in options:
      echo(optionspacing, &"({index+1:>02}) ", option)
    stdout.write(spacing, "> ")
    try:
      result = stdin.readLine.strip.parseInt
      if result < 1 or result > options.len:
        raise newException(ValueError, "OutOfRange")
    except ValueError:
      echo(spacing, "Invalid Input!")
      echo(spacing, "Give Numerical Value Of {", 1, ",", options.len, "}")
      continue
    result.dec
