Settings = {}

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

Settings.value = (listName, value) ->
  Settings[listName][value] or Settings[listName]["_#{value}"]

w = (commaSeparatedString) ->
  commaSeparatedString.split(/, |\n/)

_.extend Settings,
  dragonVersion: 4
  dontMessWithMyDragon: true
  slaveMode: false
  slaveModePort: 4444
  slaves: {
  # "name": ["host", "port"]
  }
  userAssetsPath: '~/voicecode_user'
  maximumRepetitionCount: 100
  # determine if auto spacing should be enabled (called within the default actions context, so you can check @currentApplication or any other context)
  autoSpacingEnabled: ->
    true
  defaultBrowser: 'Safari'
  defaultTerminal: 'Terminal'
  terminalApplications: []
  editorApplications: []
  browserApplications: []
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
    certificate: "cert"
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
    developer: "dev"
    development: "dev"
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
    location: "loc"
    locate: "loc"
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
    production: "prod"
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
    # months
    january: "jan"
    february: "feb"
    march: "mar"
    april: "apr"
    june: "jun"
    july: "jul"
    august: "aug"
    september: "sept"
    october: "oct"
    november: "nov"
    december: "dec"
    # multi word abbreviations
    "stripe test card": "4242424242424242"
  presetTexts: {}
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
  # this can be changed. tab, return, escape, etc
  codeSnippetCompletions:
    "Sublime Text": "tab"
  phoneNumbers: {}
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
    '1': 'one'
    '2': 'two'
    '3': 'three'
    '4': 'four'
    '5': 'five'
    '6': 'six'
    '7': 'seven'
    '8': 'eight'
    '9': 'nine'
    '0': 'zero'
    'return': 'return'
    '/': 'slash'
    '.': 'period'
    ',': 'comma'
    ';': 'sunk'
    'delete': 'junk'
    'forwarddelete': 'spunk'
    'space': 'skoosh'
    'escape': 'cape'
    'tab': 'tarp'
    '=': 'equal'
    '-': 'minus'
    'up': 'up'
    'down': 'down'
    'left': 'left'
    'right': 'right'
    ']': 'race'
    '[': 'lets'
    '\\': 'pike'
  chainRepetitionSuffix: 'way'
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
    "consol": "console"
    "consul": "console"
    "et cetera": "etc."
    "e-mail": "email"
  vocabulary: [
    "trello"
    "auto space"
    "add misspellings"
  ]
  vocabularyAlternate:
    # "spoken": "result"
    # "+get hub": "github"
    "get hub": "github"
    "I term": "iTerm"
    "HTTPS": "https"
  vocabularyListGenerators:
    fox: "applications"
    shrink: "abbreviations"
    shell: "shellCommands"
    dears: "directories"
    direct: "directories"
    windy: "windowPositions"
    webs: "websites"
    quinn: "codeSnippets"
  modes:
    global: "global"
    emacs: "emacs"
    mate: "textmate"
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
    "Citrix Viewer"
  ]
  applicationsThatNeedExplicitModifierPresses: [
    "Parallels Desktop"
    "Parallels Access"
    "iOS Simulator"
    "Anki"
  ]
  applicationsThatWillNotAllowArrowKeyTextSelection: [
    "Terminal"
    "iTerm"
  ]
  maxStringTypingLength: 9 # strings longer than this will be pasted instead of typed char by char
  modifierKeyDelay: 2 # ms
  keyDelay: 8 # ms delay between each key when called individually, like Return, UpArrow, etc.
  characterDelay: 4 # ms delay between each letter when typing a string of characters
  applicationsThatNeedLaunchingWithApplescript: [
    "Atom"
  ]
  clickDelayRequired:
    "Sublime Text": 0
    "Xcode": 100
    "default": 50
  mouseTracking: false
  debugMouseTracking: false
  mouseTrackingFrequency: 100 #ms (I don't recommend changing this)
  locale: "en"
  localeSettings:
    en:
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
    # "AppCode"
    # "IntelliJ IDEA"
    # "PhpStorm"
    # "PyCharm"
    # "RubyMine"
    # "WebStorm"
  ]
  # the delay for how long the stacked up commands may take to execute when switching away from an incompatible application
  dragonIncompatibleApplicationDelay: 5000
  notificationProvider: "applescript"
  commonSequences: {
    'symbol.brackets':
      [ 'symbol.doubleQuotes.surround',
        'symbol.singleQuotes.surround' ]
    'mouse.click':
      [ 'common.select.all',
        'common.deletion.backward',
        'duplicate-selected',
        'common.enter',
        'common.deletion.backward',
        'common.deletion.forward',
        'symbol.comma.padded.right',
        'symbol.dot',
        'common.newLineAbove',
        'mouse.shiftClick',
        'mouse.click' ]
    'cursor.right':
      [ 'symbol.comma.padded.right',
        'common.deletion.forward',
        'delete.all.right',
        'format.upper-camel',
        'format.camel',
        'format.snake',
        'symbols:space' ]
    'symbol.colon.padded.right':
      [ 'format.camel',
        'format.upper-camel',
        'format.snake',
        'symbol.doubleQuotes.surround',
        'symbol.singleQuotes.surround',
        'word.false',
        'word.true' ]
    'symbol.doubleQuotes.surround': [ 'clipboard.paste' ]
    'symbol.comma': [ 'common.enter' ]
    'cursor.left':
      [ 'common.deletion.backward',
        'symbols:space',
        'symbol.comma.padded.right',
        'format.upper-camel',
        'format.camel',
        'format.snake' ]
    'cursor.down':
      [ 'common.indentation.left',
        'common.indentation.right',
        'select.down',
        'line.move.up',
        'line.move.down',
        'common.newLineBelow',
        'delete.all.line' ]
    'symbol.dot':
      [ 'clipboard.paste',
        'format.camel',
        'format.upper-camel',
        'format.snake',
        'format.lower-no-space' ]
    'mouse.doubleClick':
      [ 'delete.all.right',
        'delete.all.left',
        'select.all.right',
        'common.deletion.backward',
        'format.camel',
        'format.upper-camel',
        'clipboard.cut',
        'mouse.shiftClick' ]
    'combo.double-clickThenCopy': [ 'combo.double-clickThenPaste', 'combo.double-clickThenCopy' ]
    'combo.double-clickThenPaste': [ 'combo.double-clickThenPaste' ]
    'combo.selectLineUnderMouse': [ 'mouse.shiftClick' ]
    'combo.selectLineUnderMouseThenCopy':
      [ 'combo.selectLineUnderMousesAndPaste',
        'combo.selectLineUnderMouseThenCopy',
        'combo.double-clickThenPaste' ]
    'combo.selectLineUnderMousesAndPaste':
      [ 'combo.selectLineUnderMousesAndPaste',
        'combo.selectLineUnderMouseThenCopy' ]
    'mouse.commandClick': [ 'mouse.commandClick' ]
    'cursor.up':
      [ 'common.indentation.left',
        'common.indentation.right',
        'select.up',
        'line.move.up',
        'line.move.down',
        'common.enter',
        'common.newLineAbove',
        'delete.all.line' ]
    'common.deletion.backward': [ 'common.deletion.forward', 'clipboard.paste' ]
    'symbol.surround.parentheses':
      [ 'clipboard.paste',
        'symbol.doubleQuotes.surround',
        'symbol.singleQuotes.surround',
        'symbol.braces.surround' ]
    'select.all.right': [ 'clipboard.copy', 'clipboard.cut' ]
    'cursor.way.right': [ 'common.deletion.backward' ]
    'common.save': [ 'applicationControl.switchToPrevious', 'common.close.window' ]
    'select.line.text': [ 'clipboard.cut' ]
    'common.enter': [ 'format.camel', 'format.upper-camel', 'common.tab.backward' ]
    'common.newLineAbove': [ 'clipboard.paste' ]
    'common.newLineBelow': [ 'clipboard.paste', 'format.camel', 'format.upper-camel' ]
    'select.up': [ 'common.indentation.left', 'common.indentation.right' ]
    'select.down': [ 'common.indentation.left', 'common.indentation.right' ]
    'symbols:space':
      [ 'format.camel',
        'format.upper-camel',
        'core.insertAbbreviation',
        'format.snake',
        'format.lower-no-space' ]
    'clipboard.cut': [ 'applicationControl.switchToPrevious' ]
    'clipboard.paste': [ 'common.enter' ]
    'common.deletion.forward': [ 'common.deletion.backward' ]
    'symbol.comma.padded.right':
      [ 'symbol.doubleQuotes.surround',
        'symbol.singleQuotes.surround',
        'format.camel',
        'format.upper-camel',
        'clipboard.paste',
        'word.false',
        'word.true' ]
    'common.open.tab': [ 'clipboard.paste' ]
    'delete.word.backward': [ 'common.deletion.backward', 'cursor.left' ]
    'smart.select':
      [ 'format.camel',
        'format.upper-camel',
        'format.title',
        'format.snake',
        'format.upper',
        'format.lower-no-space',
        'format.upper-no-space' ]
    'select.word.next': [ 'common.deletion.backward' ]
    'select.word.previous': [ 'common.deletion.backward' ]
    'mouse.shiftClick':
      [ 'clipboard.copy',
        'common.deletion.backward',
        'duplicate-selected',
        'common.indentation.left',
        'common.indentation.right' ] }

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


module.exports = Settings
