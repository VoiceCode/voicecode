module.exports =
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

    clickDelayRequired:
        "Sublime Text": 0
        "Xcode": 100
        "default": 50
    mouseTracking: false
    debugMouseTracking: false
    mouseTrackingFrequency: 100 #ms (I don't recommend changing this)

    #
    # # regex's for selection commands
    # regex:
    #   symbols: /[\/\.,\?*&^%$#@:;\|\+\-\!\\]/
    #   quotes: /["'`]/
    #   parens: /[\(\)\{\}\[\]]/

    # the delay for how long the stacked up commands may take to execute when switching away from an incompatible application


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
