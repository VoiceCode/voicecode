pack = Packages.register
  name: 'modifiers'
  platforms: ['darwin']
  description: 'Modifier key combinations'
pack.settings
  dynamicModifiers: true
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

pack.ready ->
  if @settings().dynamicModifiers
    @settings
      modifierSuffixes:
        'return': (Commands.get('common:enter')?.spoken or 'return')
        '/': (Commands.get('symbols:slash')?.spoken or 'slash')
        ';': (Commands.get('symbols:semicolon')?.spoken or 'sunk')
        'delete': (Commands.get('common:deletion.backward')?.spoken or 'junk')
        'forwarddelete': (Commands.get('common:deletion.forward')?.spoken or 'spunk')
        'space': (Commands.get('symbols:space')?.spoken or 'space')
        'escape': (Commands.get('common:escape')?.spoken or 'cape')
        'tab': (Commands.get('common:tab.backward')?.spoken or 'tarp')
        '=': (Commands.get('symbols:equal')?.spoken or 'equal')
        ']': (Commands.get('symbols:right-bracket')?.spoken or 'race')
        '[': (Commands.get('symbols:left-bracket')?.spoken or 'lets')
        '\\': (Commands.get('symbols:backslash')?.spoken or 'shals')


pack.commands
  'modifiers':
    grammarType: 'custom'
    rule: '(modifierPrefix) (modifierSuffix)'
    variables:
      modifierPrefix: -> pack.settings().modifierPrefixes
      modifierSuffix: -> _.invert _.extend {},
        Settings.letters, pack.settings().modifierSuffixes
    action: ({modifierPrefix, modifierSuffix}) ->
      @key modifierSuffix, modifierPrefix
