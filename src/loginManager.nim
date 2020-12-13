## This module implements a login manager

import strformat
import pwGenerator, login

type LoginManager* = object
  ## A structure to store several Logins and write to/read from a CSV file
  filename*: string
  logins*: seq[Login]
  writeBack*: bool

proc readLogins*(lm: var LoginManager) =
  ## Reads Logins from a CSV file
  let file = open(lm.filename, fmRead)
  while not file.endOfFile:
    lm.logins.add(loginFromCSV(file.readLine))
  file.close
  lm.writeBack = false

proc writeLogins*(lm: var LoginManager) =
  ## Writes back all logins
  if lm.writeBack:
    lm.writeBack = false
    let file = open(lm.filename & ".new", fmWrite)
    for login in lm.logins:
      file.writeLine(login.toCSV)
    file.close
    # cpy file

proc createLoginManager*(filename: string): LoginManager =
  ## Constructor setting silename and reading logins from this file
  result.filename = filename
  result.readLogins()

proc `=destroy`*(lm: var LoginManager) =
  ## Destructor executed when the object gets deleted
  lm.writeLogins

proc getLogins*(lm: LoginManager): string =
  ## String listing of stored logins
  result = "Logins:"
  for index, login in lm.logins.pairs:
    result &= &"\n ({index+1:>03}) Login: " & (if login.active: "+" else: "-") & &"{login.getTag}"

proc containsLogin*(lm: LoginManager; portal, username: string): bool =
  ## Checks if login manager already contains a portal-username kombination
  let tag = portal & "#" & username
  for login in lm.logins:
    if login.getTag == tag:
      return true
  return false

proc addLogin*(lm: var LoginManager; login: Login): bool =
  ## Adds a new login to the list of logins
  for li in lm.logins:
    if li.portal == login.portal and li.username == login.username:
      # Login already exists
      return false
  lm.logins.add(login)
  lm.writeBack = true
  return true

proc addPassword*(lm: var LoginManager; portal, username, password: string): bool =
  ## Adds a new Password to an already existing login indicated by portal and username
  let tag = portal & "#" & username
  for li in lm.logins.mitems:
    if li.getTag == tag:
      li.addPassword(password)
      lm.writeBack = true
      return true
  # Login does not exist
  return false

proc addPassword*(lm: var LoginManager, loginNumber: int, password: string): bool =
  ## Adds a new Password to an already existing login indicated by its index
  let loginIdx = loginNumber-1
  if loginIdx < 0 and loginIdx > lm.logins.high:
    return false
  lm.logins[loginIdx].addPassword(password)
  lm.writeBack = true
  return true

#proc editLogin(lm: LoginManager, page: string): bool
