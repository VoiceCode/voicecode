@Settings = {}

extendArray = (original, extension) ->
  original.concat extension

Settings.extend = (key, map) ->
  # check if we are extending an array
  if Object::toString.call(map) is '[object Array]'
    Settings[key] ?= []
    Settings[key] = extendArray Settings[key], map
  # check if we are extending an object
  else if typeof map is "object"
    Settings[key] ?= {}
    _.deepExtend Settings[key], map

Settings.addContext = (determiningFunction) ->
  Settings.contextChain.unshift determiningFunction

Settings.getSpokenOptionsForList = (listName, filtered=true) ->
  list = Settings[listName]
  if list?
    if Object.prototype.toString.call(list) is '[object Array]'
      if filtered
        _.filter list, (item) ->
          item[0] != "_"
      else
        _.map list, (item) ->
          item.replace("_", '')
    else if typeof list is "object"
      if filtered
        _.filter _.keys(list), (item) ->
          item[0] != "_"
      else
        _.map _.keys(list), (item) ->
          item.replace("_", '')
  else
    []

Settings.value = (listName, value) ->
  Settings[listName][value] or Settings[listName]["_#{value}"]

w = (commaSeparatedString) ->
  commaSeparatedString.split(/, |\n/)

_.extend Settings,
  maximumRepetitionCount: 100
  websites:
    "amazon": "http://www.amazon.com"
    "google docs": "http://docs.google.com"
    amazon: "http://www.amazon.com"
    craigslist: "http://craigslist.com"
    github: "https://github.com"
    gmail: "http://mail.google.com"
    "voicecode wiki": "https://github.com/VoiceCode/docs/wiki"
    "voicecode github": "https://github.com/stratogee/voicecode"
    "voicecode": "http://voicecode.io"
  applications:
    "app store": "App Store"
    activity: "Activity Monitor"
    atom: "Atom"
    _adam: "Atom" # an alias - it's not what we want to train dragon to hear, but if it hears it, still trigger this item.
    automate: "Automator"
    calendar: "Calendar"
    chrome: "Google Chrome"
    dragon: "Dragon Dictate"
    finder: "Finder"
    firefox: "Firefox"
    illustrator: "Adobe Illustrator"
    logic: "Logic Pro X"
    mail: "Mail"
    message: "Messages"
    pages: "Pages"
    parallels: "Parallels Desktop"
    password: "1Password"
    preview: "Preview"
    quicktime: "QuickTime Player"
    safari: "Safari"
    photoshop: "Adobe Photoshop"
    simulator: "iOS Simulator"
    skype: "Skype"
    smartnav: "SmartNav"
    sublime: "Sublime Text"
    system: "System Preferences"
    term: "iTerm"
    tree: "SourceTree"
    tune: "iTunes"
    web: "Google Chrome"
    xcode: "Xcode"
  abbreviations:
    "inc.": "inc"
    administrator: "admin"
    administrators: "admins"
    allocate: "alloc"
    alternate: "alt"
    apartment: "apt"
    application: "app"
    applications: "apps"
    architecture: "arch"
    argument: "arg"
    arguments: "args"
    attribute: "attr"
    attributes: "attrs"
    authentic: "auth"
    authenticate: "auth"
    author: "auth"
    binary: "bin"
    button: "btn"
    _c: "char"
    calculate: "calc"
    call: "col"
    car: "char"
    care: "char"
    character: "char"
    column: "col"
    command: "cmd"
    concatenate: "concat"
    configuration: "config"
    configure: "config"
    constant: "const"
    define: "def"
    descending: "desc"
    develop: "dev"
    directory: "dir"
    divider: "div"
    document: "doc"
    environment: "env"
    execute: "exec"
    extension: "ext"
    extend: "ext"
    favorite: "fav"
    function: "func"
    image: "img"
    imager: "int"
    increment: "inc"
    initialize: "init"
    integer: "int"
    iterate: "iter"
    jason: "json"
    large: "lg"
    length: "len"
    library: "lib"
    medium: "md"
    minimum: "min"
    navigate: "nav"
    navigation: "nav"
    number: "num"
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
    standing: "stdin"
    standout: "stdout"
    string: "str"
    system: "sys"
    temporary: "tmp"
    text: "txt"
    thanks: "thx"
    utilities: "utils"
    utility: "util"
    value: "val"
    variable: "var"
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
    flan: "command option control"
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
    wink: 1
    soup: 2
    trace: 3
    quarr: 4
    fypes: 5
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
  vocabularyListGenerators:
    fox: "applications"
    shrink: "abbreviations"
    shell: "shellCommands"
    dears: "directories"
    direct: "directories"
    windy: "windowPositions"
    webs: "websites"
    quinn: "codeSnippets"
  commonSequences:
    brax: w 'coif, posh'
    chiff: w 'olly, junk, jolt, shock, junk, spunk, swipe, dot, shockey, shicks, chiff'
    chris: w 'swipe, spunk, snipper, criffed, cram, snake'
    coalgap: w 'cram, criffed, snake, coif, posh, false, true'
    coif: w 'spark'
    comma: w 'shock'
    crimp: w 'junk, skoosh, swipe, criffed, cram, snake'
    doom: w 'shabble, shabber, shroom, switchy, switcho, shockoon, snipline'
    dot: w 'spark, cram, criffed, snake, smash'
    duke: w 'snipper, snipple, ricksy, junk, cram, criffed, snatch, shicks'
    dookoosh: w 'doopark, dookoosh'
    doopark: w 'doopark'
    chibble: w 'shicks'
    chibloosh: w 'chiblark, chibloosh, doopark'
    chiblark: w 'chiblark, chibloosh'
    "chom lick": w 'chom lick'
    jeep: w 'shabble, shabber, shreep, switchy, switcho'
    jeep: w 'shock, shockey, snipline'
    junk: w 'spunk, spark'
    prex: w 'spark, coif, posh, kirk'
    ricksy: w 'stoosh, snatch'
    ricky: w 'junk'
    sage: w 'swick, totch'
    shackle: w 'snatch'
    shock: w 'cram, criffed, tarp'
    shockey: w 'spark'
    shockoon: w 'spark, cram, criffed'
    shreep: w 'shabble, shabber'
    shroom: w 'shabble, shabber'
    skoosh: w 'cram, criffed, shrink, snake, smash'
    snatch: w 'swick'
    spark: w 'shock'
    spunk: w 'junk'
    swipe: w 'coif, posh, cram, criffed, spark, false, true'
    talky: w 'spark'
    tragic:  w 'cram, criffed, tridal, senchen, snake, yeller, smash, yellsmash'
    wordneck: w 'junk'
    wordpreev: w 'junk'
    shicks: w 'stoosh, junk, jolt, shabble, shabber'
  modes:
    global: "global"
    emacs: "emacs"
    mate: "textmate"
  contextChain: [
    -> @currentApplication()
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
    # you can use fractions as well (1/3)
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
  digits:
    zero: 0
    one: 1
    two: 2
    three: 3
    four: 4
    five: 5
    six: 6
    seven: 7
    eight: 8
    nine: 9
  applicationsThatCanNotHandleBlankSelections: [
    "AppCode"
    "Atom"
    "Google Chrome"
    "IntelliJ IDEA"
    "iTerm"
    "Parallels Desktop"
    "PhpStorm"
    "PyCharm"
    "RubyMine"
    "Sublime Text"
    "Terminal"
    "WebStorm"
    "DrRacket"
    "Firefox"
  ]
  applicationsThatNeedExplicitModifierPresses: [
    "Parallels Desktop"
    "Parallels Access"
    "iOS Simulator"
    "Anki"
  ]
  applicationsThatNeedLaunchingWithApplescript: [
    "Atom"
  ]
  clickDelayRequired:
    "Sublime Text": 0
    "Xcode": 100
    "default": 50
  mouseTracking: false
  debugMouseTracking: false
  mouseTrackingFrequency: 100 #ms
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
    "AppCode"
    "IntelliJ IDEA"
    "PhpStorm"
    "PyCharm"
    "RubyMine"
    "WebStorm"
  ]
  # the delay for how long the stacked up commands may take to execute when switching away from an incompatible application
  dragonIncompatibleApplicationDelay: 5000
  emotions:
    chagrin: ":P"
    frown: ":("
    sheep: ":}"
    smile: ":)"
    winkle: ";)"
  notificationProvider: "applescript"
  dateFormats:
    yammer: "YYYYMMDD"
    timestamp: "X"
    time: "LT"
    today: "LL"
    date: "l"
  strictModes:
    default: w """
      strict off
      swick
      chiff
      chipper
      duke
      spark
      stoosh
      dookoosh
      doopark
      webseek
      webs
      fox
      """
    all: ["strict off"] # nothing is allowed except disabling strict mode
  homonyms: [
    
    w "there, their, they're"
    w "are, our, hour"
    w "ad, add"
  ]

# tens =
#   ten: 10
#   eleven: 11
#   twelve: 12
#   thirteen: 13
#   fourteen: 14
#   fifteen: 15
#   sixteen: 16
#   seventeen: 17
#   eighteen: 18
#   nineteen: 19
#   twenty: 20
#   thirty: 30
#   fourty: 40
#   fifty: 50
#   sixty: 60
#   seventy: 70
#   eighty: 80
#   ninety: 90

# hundreds =
#   hundred:
# _.extend Settings,
#   digits: digits

# _.extend Settings,
#   integerFirst: digits

# _.extend Settings.integerFirst
#   integerFirst:
