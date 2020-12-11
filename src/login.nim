import strutils, sequtils

type Login* = object
  ## Structure for storing data of a Login.
  ## It also keeps old passwords.
  active*: bool
  portal*: string
  username*: string
  email*: string
  passwords: seq[string]


proc createLogin*(portal, username, email: string; active: bool = true): Login =
  ## Constructor creating a Login object.
  result.active    = active
  result.portal    = portal
  result.username  = username
  result.email     = email
  result.passwords = @[]

proc loginFromCSV*(line: string): Login =
  ## Reads a CSV line and creates a Login.
  ## CSV format: `<active>,<portal>,<username>,<email>,<password>[,<password> [, ...]]`
  let splitLine = line.split(',')
  result.active    = if splitLine[0] == "+": true else: false
  result.portal    = splitLine[1]
  result.username  = splitLine[2]
  result.email     = splitLine[3]
  result.passwords = splitLine[4..splitLine.high]

proc toCSV*(login: Login): string =
  ## Exports Login object to CSV format.
  ## CSV format: `<active>,<portal>,<username>,<email>,<password>[,<password> [, ...]]`
  result = ""
  result &= (if login.active: '+' else: '-') & ','
  result &= login.portal & ','
  result &= login.username & ','
  result &= login.email & ','
  result &= login.passwords.join(",")

proc `$`*(login: Login): string =
  ## To string operator.
  ## Gives nice format of a Login in a string.
  result = ""
  result &= "Login " & login.portal & "#" & login.username & ":\n"
  result &= "    Status:    " & (if login.active: "active" else: "inactive") & "\n"
  result &= "    Portal:    " & login.portal & "\n"
  result &= "    Username:  " & login.username & "\n"
  result &= "    E-Mail:    " & login.email & "\n"
  result &= "    Passwords: "
  for pw in login.passwords:
    result &= "        " & pw & "\n"

proc getTag*(login: Login): string =
  ## Resturns the *unique* Login tag.
  ## It is created by the portal name and the username.
  ## Format: `<portal>#<username>`
  return login.portal & "#" & login.username

proc getPassword*(login: Login): string =
  ## Returns actual(last) password
  return login.passwords[login.passwords.high]

proc addPassword*(login: var Login, password: string) =
  ## Adds a new password
  login.passwords.add password

