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
    "app store": "App Store"
    activity: "Activity Monitor"
    adam: "Atom"
    atom: "Atom"
    automate: "Automator"
    billy: "Adobe Illustrator"
    calendar: "Calendar"
    chrome: "Google Chrome"
    drag: "Dragon Dictate"
    find: "Path Finder"
    logic: "Logic Pro X"
    mail: "Mail"
    message: "Messages"
    page: "Pages"
    parallels: "Parallels Desktop"
    pass: "1Password"
    preview: "Preview"
    quicktime: "QuickTime Player"
    robo: "Robomongo"
    safari: "Safari"
    shop: "Adobe Photoshop CC 2014"
    sky: "Skype"
    store: "App Store"
    sublime: "Sublime Text"
    system: "System Preferences"
    term: "iTerm"
    tree: "SourceTree"
    tune: "iTunes"
    web: "Google Chrome"
    xcode: "Xcode"
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
    configure: "config"
    configuration: "config"
    constant: "const"
    define: "def"
    descending: "desc"
    develop: "dev"
    directory: "dir"
    divider: "div"
    document: "doc"
    environment: "env"
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
    thanks: "thx"
    thinks: "thx"
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
  letters:
    a: "arch"
    b: "brov"
    c: "char"
    d: "dell"
    e: "etch"
    f: "fomp"
    g: "goof"
    h: "hark"
    i: "ice"
    j: "jinks"
    k: "koop"
    l: "lug"
    m: "mowsh"
    n: "nerb"
    o: "ork"
    p: "pooch"
    q: "quash"
    r: "rosh"
    s: "souk"
    t: "teek"
    u: "unks"
    v: "verge"
    w: "womp"
    x: "trex"
    y: "yang"
    z: "zooch"
  uppercaseLetterPrefix: "sky"
  singleLetterSuffix: "ling"
  modifierPrefixes:
    chom: "command"
    shoff: "command shift"
    shay: "command option"
    flock: "command option shift"
    crop: "option"
    snoop: "option shift"
    troll: "control"
    mack: "command control"
    triff: "control shift"
    prick: "command control shift"
  modifierSuffixes:
    "1": "one"
    "2": "two"
    "3": "three"
    "4": "four"
    "5": "five"
    "6": "six"
    "7": "seven"
    "8": "eight"
    "9": "nine"
    "0": "zero"
    Return: "return"
    "/": "slash"
    ".": "period"
    ",": "comma"
    ";": "sunk"
    Delete: "junk"
    ForwardDelete: "spunk"
    " ": "skoosh"
    Escape: "cape"
    Tab: "tarp"
    "=": "equal"
    "-": "minus"
    Up: "up"
    Down: "down"
    Left: "left"
    Right: "right"
    "]": "race"
    "[": "lets"
    "\\": "pike"
  repetitionWords:
    # you can add more repetition commands like this
    wink:
      times: 1
    soup:
      times: 2
    trace:
      times: 3
      aliases: ["traced"]
    quail:
      times: 4
      aliases: ["quell", "quarr"]
    fypes:
      times: 5
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
    "i'll": "I'll"
    "maine": "main"
    "o'clock": ":00"
    "adam": "atom"
  vocabulary: [
    "trello"
  ]
  vocabularyAlternate:
    # "spoken": "result"
    # "+get hub": "github"
    "get hub": "github"
    "I term": "iTerm"
  modes:
    global: "global"
    emacs: "emacs"
    mate: "textmate"
  dragonContexts: [
    "Global"
  ]
  workflows:
    "workflow test": "yellsnik it worked clamor"
  shellCommands:
    permissions: "chmod "
    access: "chmod "
    cat: "cat "
    chat: "cat " # dragon doesn't like the word 'cat'
    copy: "cp "
    cd: "cd "
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
    audio: "com.apple.preference.sound"
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
    rate:
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
    middle:
      x: "auto"
      y: "auto"
      width: 0.75
      height: 0.75
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
    "iTerm"
    "Terminal"
    "Sublime Text"
    "Google Chrome"
    "Parallels Desktop"
    "Atom"
    "IntelliJ IDEA"
    "PhpStorm"
    "PyCharm"
    "RubyMine"
    "WebStorm"
    "AppCode"
  ]
  applicationsThatNeedExplicitModifierPresses: [
    "Parallels Desktop"
    "iOS Simulator"
  ]
  clickDelayRequired:
    "Sublime Text": 0
    "Xcode": 100
    "default": 50
  locale: "en"
  localeSettings:
    en:
      dragonApplicationName: "Dragon Dictate"
      dragonCommandsWindowName: "Commands"
      dragonSaveButtonName: "Save"
      dragonGlobalName: "Global"
      dragonOsLanguage: "en_GB"
      dragonCommandSpokenLanguage: "en_US"
      dragonTriggerSpokenLanguage: "en_US"
    de:
      dragonOsLanguage: "de_DE"
      dragonCommandSpokenLanguage: "en_US"
      dragonTriggerSpokenLanguage: "en_US"

  # regex's for selection commands
  regex:
    symbols: /[\/\.,\?*&^%$#@:;\|\+\-\!\\]/
    quotes: /["'`]/
    parens: /[\(\)\{\}\[\]]/

  # delay for how long the clipboard takes to populate after a copy operation is different in different applications
  clipboardLatency:
    "Sublime Text": 300
    "Mail": 200

  # For JetBrains IDEs and possibly other applications that do not work with Dragon Dictate
  dragonIncompatibleApplications: [
    "IntelliJ IDEA"
    "PhpStorm"
    "PyCharm"
    "RubyMine"
    "WebStorm"
    "AppCode"
  ]
  # the delay for how long the stacked up commands may take to execute when switching away from an incompatible application
  dragonIncompatibleApplicationDelay: 5000
  emotions:
    smile: ":)"
    chagrin: ":P"
    sheep: ":}"
    frown: ":("
    winkle: ";)"
