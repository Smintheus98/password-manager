import tables, strutils, strformat, sequtils
import myutils, interactionutils, pwGenerator, login, loginManager

#type choice = enum
#  EXIT,
#  PRINT_HELP,
#  LIST_LOGINS,
#  SHOW_LOGIN,
#  ADD_LOGIN,
#  ADD_PASSWORD,
#  CHANGE_LOGIN,
#
#let desciption = {
#  choice.EXIT         : "Exit",
#  choice.PRINT_HELP   : "Print Help Message",
#  choice.LIST_LOGINS  : "List Logins",
#  choice.SHOW_LOGIN   : "Show Specific Login",
#  choice.ADD_LOGIN    : "Add New Login",
#  choice.ADD_PASSWORD : "Add New Password",
#  choice.CHANGE_LOGIN : "Change Login Data",
#  }.toTable

let interfaceOptions: seq[string] = @["Exit",
    "Print Help Message",
    "List Logins",
    "Show Specific Login",
    "Add New Login",
    "Add New Password",
    "Change Login Data"]

type Action* = object
  pwCreator*: PasswordCreator
  pwManager*: LoginManager


#proc printMenu*(action: Action) =
#  echo "Menu:"
#  for ch in choice:
#    echo &"({ch.int}) {desciption[ch]}"

proc listLogins*(action: Action) =
  echo action.pwManager.getLogins

proc addLogin*(action: var Action) =
  echo "New Login:"
  let page = getStrInput(2, "Page")
  let username = getStrInput(2, "Username")
  if action.pwManager.containsLogin(page, username):
    echo "Login Already Exists!"
    return
  let email = getStrInput(2, "E-Mail")
  let pwCreationChoice = getChoice(2, "Password", ["Generate", "Give Individual Password"])
  var password: string
  if pwCreationChoice == 0:
    # Generate
    let length = getNumInput(2, "Password Length", true)
    let quality = cast[PasswordQuality](getChoice(2, "Password Quality", toStrSeq[PasswordQuality]()))
    let forceQuality = getConfirm(2, "Force Quality?") 
    let excludeSymbols = getStrInput(2, "Symbols to exclude").toCharSet

    var password: string
    while true:
      password = action.pwCreator.generate(length.int, quality, forceQuality, excludeSymbols)
      stdout.write &"  Password: {password}  [y/N]: "
      if stdin.readLine.strip.toLowerAscii.startsWith('y'):
        break
    stdout.write "  Modifi (Enter for no changes): "
    let modPw = stdin.readLine.strip
    if not action.pwManager.addLogin(createLogin(page, username, email)):
      echo "Adding Login Failed!"
      return
    if modPw != "":
      action.pwManager.logins[^1].addPassword(modPw)
    else:
      action.pwManager.logins[^1].addPassword(password)
  else:
    while true:
      password = getStrInput(2, "Password")
      let passwordConfirmation = getStrInput(2, "Confirm Password")
      if password == stdin.readLine:
        break
      else:
        echo "  Password confirmation failed"
        continue
  if not action.pwManager.addLogin(createLogin(page, username, email)):
    echo "Adding Login Failed!"
    return
  action.pwManager.logins[^1].addPassword(password)
  
proc addPassword*(action: Action) =
  discard
proc changeLogin*(action: Action) =
  discard
proc interactive*(action: var Action) =
  while true:
    let opt = getChoice(0, "Menu", interfaceOptions)

    # process commandline
#void print_menu();
#void exit();
#void print_help();
#void list_logins();
#void add_login();
#void add_password();
#void change_login();
#public:
#void start_interactive();
#bool process_commandline(std::vector<std::string> argv);

when isMainModule:
  var action: Action
  # read passwordmanager
  interactive(action)
