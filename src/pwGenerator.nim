## This module serves the generation of random passwords.

import random
import myutils

const
  ## Set definitions for different password standards.
  alpha_lower*: set[char] = { 'a' .. 'z' }
  alpha_upper*: set[char] = { 'A' .. 'Z' }
  digits*:      set[char] = { '0' .. '9' }
  symbols*:     set[char] = "!?@#$%^&*;()\"<>:-_+=".toCharSet() 
  alpha*:       set[char] = alpha_lower + alpha_upper
  alphanum*:    set[char] = alpha + digits
  alphanumsym*: set[char] = alphanum + symbols


type PasswordCreator* = object
  ## Password creator type.
  password*: string

type PasswordQuality* = enum
  ## Enumeration type to specify the characters to use for password generation.
  ALPHALOWER, ALPHAUPPER, ALPHA, ALPHANUM, ALPHANUMSYM


proc containsOneOf*(password: string; selection: set[char]): bool =
  ## Tests if the `password` string contains at least one of the elements in `selection`.
  for ch in password:
    if ch in selection:
      return true
  return false

proc isGood*(pc: PasswordCreator; quality: PasswordQuality): bool =
  ## Tests if the (generated) password fulfills the required quality.
  let pw = pc.password
  case quality:
    of ALPHALOWER:  return  pw.containsOneOf(alpha_lower)
    of ALPHAUPPER:  return  pw.containsOneOf(alpha_upper)
    of ALPHA:       return  pw.containsOneOf(alpha_lower) and 
                            pw.containsOneOf(alpha_upper)
    of ALPHANUM:    return  pw.containsOneOf(alpha_lower) and 
                            pw.containsOneOf(alpha_upper) and 
                            pw.containsOneOf(digits)
    of ALPHANUMSYM: return  pw.containsOneOf(alpha_lower) and 
                            pw.containsOneOf(alpha_upper) and 
                            pw.containsOneOf(digits) and 
                            pw.containsOneOf(symbols)

proc generate*(pc: var PasswordCreator; length = 8; quality: PasswordQuality = ALPHANUMSYM;
        forceQuality = false; exclude: set[char] = {}): string =
  ## Generates random password.
  randomize()
  var signs: set[char]
  case quality:
    of ALPHALOWER:  signs = alpha_lower
    of ALPHAUPPER:  signs = alpha_upper
    of ALPHA:       signs = alpha
    of ALPHANUM:    signs = alphanum
    of ALPHANUMSYM: signs = alphanumsym
  signs = signs - exclude
  while true:
    pc.password = ""
    for i in 0..<length:
      pc.password &= sample(signs)
    if not forceQuality or pc.isGood(quality):
      return pc.password



when isMainModule:
  ## when compiled as main module just create a password.
  import strutils
  stdout.write "Password length: "
  let pwLen = stdin.readLine.strip.parseInt
  stdout.write "Quality: \n"
  for i in PasswordQuality:
    echo " ", i.int, " ", i
  let pwQual = cast[PasswordQuality](stdin.readLine.strip.parseInt)
  stdout.write "Force quality? [y/N]: "
  let pwForceQual = stdin.readLine.strip.toLowerAscii.startsWith("y")
  stdout.write "Exclude Signs (eg: abc$#5): "
  let pwExclude = stdin.readLine.strip.toCharSet
  var pc: PasswordCreator
  echo "Passwords:"
  while true:
    stdout.write "  ", pc.generate(pwLen, pwQual, pwForceQual, pwExclude), " "
    discard stdin.readLine

