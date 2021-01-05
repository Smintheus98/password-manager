import tables, strutils, strformat, sequtils
import myutils, interactionutils, pwGenerator, login, loginManager

type interfaceOptions_e = enum
  EXIT,
  LIST_LOGINS,
  SHOW_LOGIN,
  ADD_LOGIN,
  ADD_PASSWORD,
  CHANGE_LOGIN,

let interfaceOptions: seq[string] = @[
    "Exit",
    "List Logins",
    "Show Specific Login",
    "Add New Login",
    "Add New Password",
    "Change Login Data"]

doAssert(interfaceOptions_e.high.ord == interfaceOptions.high)

type Action* = object
  pwCreator*: PasswordCreator
  pwManager*: LoginManager


proc listLogins*(action: Action) =
  echo action.pwManager.getLogins

proc showLogin*(action: Action) =
  discard

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
    let option = getChoice(0, "Menu", interfaceOptions, false)
    case cast[interfaceOptions_e](option):
      of interfaceOptions_e.EXIT: 
        break
      of interfaceOptions_e.LIST_LOGINS:
        action.listLogins()
      of interfaceOptions_e.SHOW_LOGIN:
        action.showLogin()
      of interfaceOptions_e.ADD_LOGIN:
        action.addLogin()
      of interfaceOptions_e.ADD_PASSWORD:
        action.addPassword()
      of interfaceOptions_e.CHANGE_LOGIN:
        action.changeLogin()

    # process commandline
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
