@Settings = {}

Settings.extend = (key, map) ->
  if Object.prototype.toString.call(map) is '[object Array]'
    Settings[key] ?= []
    Settings[key] = Settings[key].concat map
  else if typeof map is "object"
    Settings[key] ?= {}
    _.extend Settings[key], map

_.extend Settings,
  maximumRepetitionCount: 100
  websites:
    amazon: "http://www.amazon.com"
    "amazon console": "https://console.aws.amazon.com"
    craigslist: "http://craigslist.com"
    github: "https://github.com"
    gmail: "http://mail.google.com"
    "google docs": "http://docs.google.com"
  applications:
    term: "iTerm"
    web: "Google Chrome"
    chrome: "Google Chrome"
    sky: "Skype"
    billy: "Adobe Illustrator"
    shop: "Adobe Photoshop CC 2014"
    calendar: "Calendar"
    drag: "Dragon Dictate"
    find: "Path Finder"
    logic: "Logic Pro X"
    mail: "Mail"
    message: "Messages"
    pass: "1Password"
    page: "Pages"
    robo: "Robomongo"
    system: "System Preferences"
    tree: "SourceTree"
    tune: "iTunes"
    preview: "Preview"
    sublime: "Sublime Text"
    activity: "Activity Monitor"
    safari: "Safari"
    xcode: "Xcode"
    automate: "Automator"
    store: "App Store"
    quicktime: "QuickTime Player"
    parallels: "Parallels Desktop"
  abbreviations:
    standing: "stdin"
    standout: "stdout"
    administrator: "admin"
    administrators: "admins"
    alternate: "alt"
    apartment: "apt"
    application: "app"
    applications: "apps"
    architecture: "arch"
    argument: "arg"
    arguments: "args"
    attribute: "attr"
    attributes: "attrs"
    allocate: "alloc"
    authenticate: "auth"
    authentic: "auth"
    author: "auth"
    binary: "bin"
    button: "btn"
    calculate: "calc"
    call: "col"
    character: "char"
    c: "char"
    car: "char"
    care: "char"
    column: "col"
    command: "cmd"
    constant: "const"
    define: "def"
    descending: "desc"
    develop: "dev"
    directory: "dir"
    divider: "div"
    document: "doc"
    execute: "exec"
    favorite: "fav"
    function: "func"
    image: "img"
    initialize: "init"
    integer: "int"
    imager: "int"
    iterate: "iter"
    jason: "json"
    large: "lg"
    length: "len"
    library: "lib"
    medium: "md"
    minimum: "min"
    number: "num"
    navigate: "nav"
    navigation: "nav"
    object: "obj"
    parameter: "param"
    parameters: "params"
    position: "pos"
    previous: "prev"
    pseudo: "sudo"
    reference: "ref"
    references: "refs"
    request: "req"
    result: "res"
    revision: "rev"
    source: "src"
    standard: "std"
    string: "str"
    system: "sys"
    temporary: "tmp"
    text: "txt"
    utilities: "utils"
    utility: "util"
    value: "val"
    variable: "var"
    increment: "inc"
    "inc.": "inc"
    # multi word abbreviations
    "stripe test card": "4242424242424242"
  codeSnippets:
    "if else": "ife"
    if: "if"
    switch: "swi"
    for: "for"
    log: "log"
    else: "el"
    "else if": "elif"
    require: "req"
    ternary: "ter"
    "try catch": "try"
    unless: "unl"
    class: "cla"
    define: "def"
    "define initializer": "defi"
    "define self": "defs"
    "while": "while"
    "each": "ea"
    "each pair": "eap"
    "each with index": "eawi"
    "find all": "fina"
  # this can be changed. Tab, Return, Escape, etc
  codeSnippetCompletions: 
    "Sublime Text": "Tab"
  directories:
    home: "~"
    applications: "/Applications"
    users: "/Users"
    desktop: "~/Desktop"
    documents: "~/Documents"
    music: "~/Music"
    downloads: "~/Downloads"
  passwords:
    example: "password"
  emails:
    example: "email@example.com"
  usernames:
    example: "username1"
  translations:
    "january": "January"
    "february": "February"
    "i'm": "I'm"
    "isobject": "object"
    "maine": "main"
    "o'clock": ":00"
  modes:
    global: "global"
    emacs: "emacs"
    mate: "textmate"
  dragonContexts: [
    "Global"
    "iTerm"
  ]
  workflows:
    "workflow test": "yellsnik it worked clamor"
  shellCommands:
    permissions: "chmod "
    access: "chmod "
    cat: "cat "
    chat: "cat " # dragon doesn't like the word 'cat'
    copy: "cp "
    move: "mv "
    remove: "rm "
    "remove recursive": "rm -rf "
    "remove directory": "rmdir "
    "make directory": "mkdir "
    link: "ln "
    man: "man "
    list: "ls "
    "list all": "ls -al"
    ls: "ls "
  menuItemAliases:
    review: "view"
  systemPreferences:
    universal: "com.apple.preference.universalaccess"
    "app store": "com.apple.preferences.appstore"
    bluetooth: "com.apple.preferences.Bluetooth"
    "date time": "com.apple.preference.datetime"
    desktop: "com.apple.preference.desktopscreeneffect"
    speech: "com.apple.preference.speech"
    display: "com.apple.preference.displays"
    dock: "com.apple.preference.dock"
    energy: "com.apple.preference.energysaver"
    extensions: "com.apple.preferences.extensions"
    general: "com.apple.preference.general"
    icloud: "com.apple.preferences.icloud"
    "internet accounts": "com.apple.preferences.internetaccounts"
    keyboard: "com.apple.preference.keyboard"
    localization: "com.apple.Localization"
    expose: "com.apple.preference.expose"
    mouse: "com.apple.preference.mouse"
    network: "com.apple.preference.network"
    notifications: "com.apple.preference.notifications"
    "parental controls": "com.apple.preferences.parentalcontrols"
    print: "com.apple.preference.printfax"
    security: "com.apple.preference.security"
    sharing: "com.apple.preferences.sharing"
    sound: "com.apple.preference.sound"
    spotlight: "com.apple.preference.spotlight"
    "startup disk": "com.apple.preference.startupdisk"
    backup: "com.apple.prefs.backup"
    trackpad: "com.apple.preference.trackpad"
    users: "com.apple.preferences.users"
  windowPositions:
    # units <= 1 are proportions
    # units > 1 are absolute
    max: 
      x: 0
      y: 0
      width: 1
      height: 1
    left: 
      x: 0
      y: 0
      width: 0.5
      height: 1
    right: 
      x: 0.5
      y: 0
      width: 0.5
      height: 1
    top:
      x: 0
      y: 0
      width: 1
      height: 0.5
    bottom:
      x: 0
      y: 0.5
      width: 1
      height: 0.5
    "top left":
      x: 0
      y: 0
      width: 0.5
      height: 0.5
    "top right":
      x: 0.5
      y: 0
      width: 0.5
      height: 0.5
    "bottom left":
      x: 0
      y: 0.5
      width: 0.5
      height: 0.5
    "bottom right":
      x: 0.5
      y: 0.5
      width: 0.5
      height: 0.5
    ipad:
      x: "auto" # center
      y: "auto" # center
      width: 1024
      height: 768
  applicationsThatCanNotHandleBlankSelections: [
    "Sublime Text"
    "Google Chrome"
  ]
  applicationsThatNeedExplicitModifierPresses: [
    "Parallels Desktop"
  ]
