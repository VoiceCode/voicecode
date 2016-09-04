@DoubleMetaphone = ->
    @maxCodeLen = DEFAULT_CODE_LEN
    return

#-- BEGIN HANDLERS --//

###*
# Handles 'A', 'E', 'I', 'O', 'U', and 'Y' cases
###

handleAEIOUY = (result, index) ->
  if index == 0
    result.append 'A'
  index + 1

###*
# Handles 'C' cases
###

handleC = (value, result, index) ->
  if conditionC0(value, index)
    # very confusing, moved out
    result.append 'K'
    index += 2
  else if index == 0 and contains(value, index, 6, 'CAESAR')
    result.append 'S'
    index += 2
  else if contains(value, index, 2, 'CH')
    index = handleCH(value, result, index)
  else if contains(value, index, 2, 'CZ') and !contains(value, index - 2, 4, 'WICZ')
    #-- "Czerny" --//
    result.append 'S', 'X'
    index += 2
  else if contains(value, index + 1, 3, 'CIA')
    #-- "focaccia" --//
    result.append 'X'
    index += 3
  else if contains(value, index, 2, 'CC') and !(index == 1 and charAt(value, 0) == 'M')
    #-- double "cc" but not "McClelland" --//
    return handleCC(value, result, index)
  else if contains(value, index, 2, 'CK', 'CG', 'CQ')
    result.append 'K'
    index += 2
  else if contains(value, index, 2, 'CI', 'CE', 'CY')
    #-- Italian vs. English --//
    if contains(value, index, 3, 'CIO', 'CIE', 'CIA')
      result.append 'S', 'X'
    else
      result.append 'S'
    index += 2
  else
    result.append 'K'
    if contains(value, index + 1, 2, ' C', ' Q', ' G')
      #-- Mac Caffrey, Mac Gregor --//
      index += 3
    else if contains(value, index + 1, 1, 'C', 'K', 'Q') and !contains(value, index + 1, 2, 'CE', 'CI')
      index += 2
    else
      index++
  index

###*
# Handles 'CC' cases
###

handleCC = (value, result, index) ->
  if contains(value, index + 2, 1, 'I', 'E', 'H') and !contains(value, index + 2, 2, 'HU')
    #-- "bellocchio" but not "bacchus" --//
    if index == 1 and charAt(value, index - 1) == 'A' or contains(value, index - 1, 5, 'UCCEE', 'UCCES')
      #-- "accident", "accede", "succeed" --//
      result.append 'KS'
    else
      #-- "bacci", "bertucci", other Italian --//
      result.append 'X'
    index += 3
  else
    # Pierce's rule
    result.append 'K'
    index += 2
  index

###*
# Handles 'CH' cases
###

handleCH = (value, result, index) ->
  if index > 0 and contains(value, index, 4, 'CHAE')
    # Michael
    result.append 'K', 'X'
    index + 2
  else if conditionCH0(value, index)
    #-- Greek roots ("chemistry", "chorus", etc.) --//
    result.append 'K'
    index + 2
  else if conditionCH1(value, index)
    #-- Germanic, Greek, or otherwise 'ch' for 'kh' sound --//
    result.append 'K'
    index + 2
  else
    if index > 0
      if contains(value, 0, 2, 'MC')
        result.append 'K'
      else
        result.append 'X', 'K'
    else
      result.append 'X'
    index + 2

###*
# Handles 'D' cases
###

handleD = (value, result, index) ->
  if contains(value, index, 2, 'DG')
    #-- "Edge" --//
    if contains(value, index + 2, 1, 'I', 'E', 'Y')
      result.append 'J'
      index += 3
      #-- "Edgar" --//
    else
      result.append 'TK'
      index += 2
  else if contains(value, index, 2, 'DT', 'DD')
    result.append 'T'
    index += 2
  else
    result.append 'T'
    index++
  index

###*
# Handles 'G' cases
###

handleG = (value, result, index, slavoGermanic) ->
  if charAt(value, index + 1) == 'H'
    index = handleGH(value, result, index)
  else if charAt(value, index + 1) == 'N'
    if index == 1 and isVowel(charAt(value, 0)) and !slavoGermanic
      result.append 'KN', 'N'
    else if !contains(value, index + 2, 2, 'EY') and charAt(value, index + 1) != 'Y' and !slavoGermanic
      result.append 'N', 'KN'
    else
      result.append 'KN'
    index = index + 2
  else if contains(value, index + 1, 2, 'LI') and !slavoGermanic
    result.append 'KL', 'L'
    index += 2
  else if index == 0 and (charAt(value, index + 1) == 'Y' or contains(value, index + 1, 2, ES_EP_EB_EL_EY_IB_IL_IN_IE_EI_ER))
    #-- -ges-, -gep-, -gel-, -gie- at beginning --//
    result.append 'K', 'J'
    index += 2
  else if (contains(value, index + 1, 2, 'ER') or charAt(value, index + 1) == 'Y') and !contains(value, 0, 6, 'DANGER', 'RANGER', 'MANGER') and !contains(value, index - 1, 1, 'E', 'I') and !contains(value, index - 1, 3, 'RGY', 'OGY')
    #-- -ger-, -gy- --//
    result.append 'K', 'J'
    index += 2
  else if contains(value, index + 1, 1, 'E', 'I', 'Y') or contains(value, index - 1, 4, 'AGGI', 'OGGI')
    #-- Italian "biaggi" --//
    if contains(value, 0, 4, 'VAN ', 'VON ') or contains(value, 0, 3, 'SCH') or contains(value, index + 1, 2, 'ET')
      #-- obvious germanic --//
      result.append 'K'
    else if contains(value, index + 1, 3, 'IER')
      result.append 'J'
    else
      result.append 'J', 'K'
    index += 2
  else if charAt(value, index + 1) == 'G'
    index += 2
    result.append 'K'
  else
    index++
    result.append 'K'
  index

###*
# Handles 'GH' cases
###

handleGH = (value, result, index) ->
  if index > 0 and !isVowel(charAt(value, index - 1))
    result.append 'K'
    index += 2
  else if index == 0
    if charAt(value, index + 2) == 'I'
      result.append 'J'
    else
      result.append 'K'
    index += 2
  else if index > 1 and contains(value, index - 2, 1, 'B', 'H', 'D') or index > 2 and contains(value, index - 3, 1, 'B', 'H', 'D') or index > 3 and contains(value, index - 4, 1, 'B', 'H')
    #-- Parker's rule (with some further refinements) - "hugh"
    index += 2
  else
    if index > 2 and charAt(value, index - 1) == 'U' and contains(value, index - 3, 1, 'C', 'G', 'L', 'R', 'T')
      #-- "laugh", "McLaughlin", "cough", "gough", "rough", "tough"
      result.append 'F'
    else if index > 0 and charAt(value, index - 1) != 'I'
      result.append 'K'
    index += 2
  index

###*
# Handles 'H' cases
###

handleH = (value, result, index) ->
  #-- only keep if first & before vowel or between 2 vowels --//
  if (index == 0 or isVowel(charAt(value, index - 1))) and isVowel(charAt(value, index + 1))
    result.append 'H'
    index += 2
    #-- also takes car of "HH" --//
  else
    index++
  index

###*
# Handles 'J' cases
###

handleJ = (value, result, index, slavoGermanic) ->
  if contains(value, index, 4, 'JOSE') or contains(value, 0, 4, 'SAN ')
    #-- obvious Spanish, "Jose", "San Jacinto" --//
    if index == 0 and charAt(value, index + 4) == ' ' or value.length == 4 or contains(value, 0, 4, 'SAN ')
      result.append 'H'
    else
      result.append 'J', 'H'
    index++
  else
    if index == 0 and !contains(value, index, 4, 'JOSE')
      result.append 'J', 'A'
    else if isVowel(charAt(value, index - 1)) and !slavoGermanic and (charAt(value, index + 1) == 'A' or charAt(value, index + 1) == 'O')
      result.append 'J', 'H'
    else if index == value.length - 1
      result.append 'J', ' '
    else if !contains(value, index + 1, 1, L_T_K_S_N_M_B_Z) and !contains(value, index - 1, 1, 'S', 'K', 'L')
      result.append 'J'
    if charAt(value, index + 1) == 'J'
      index += 2
    else
      index++
  index

###*
# Handles 'L' cases
###

handleL = (value, result, index) ->
  if charAt(value, index + 1) == 'L'
    if conditionL0(value, index)
      result.appendPrimary 'L'
    else
      result.append 'L'
    index += 2
  else
    index++
    result.append 'L'
  index

###*
# Handles 'P' cases
###

handleP = (value, result, index) ->
  if charAt(value, index + 1) == 'H'
    result.append 'F'
    index += 2
  else
    result.append 'P'
    index = if contains(value, index + 1, 1, 'P', 'B') then index + 2 else index + 1
  index

###*
# Handles 'R' cases
###

handleR = (value, result, index, slavoGermanic) ->
  if index == value.length - 1 and !slavoGermanic and contains(value, index - 2, 2, 'IE') and !contains(value, index - 4, 2, 'ME', 'MA')
    result.appendAlternate 'R'
  else
    result.append 'R'
  if charAt(value, index + 1) == 'R' then index + 2 else index + 1

###*
# Handles 'S' cases
###

handleS = (value, result, index, slavoGermanic) ->
  if contains(value, index - 1, 3, 'ISL', 'YSL')
    #-- special cases "island", "isle", "carlisle", "carlysle" --//
    index++
  else if index == 0 and contains(value, index, 5, 'SUGAR')
    #-- special case "sugar-" --//
    result.append 'X', 'S'
    index++
  else if contains(value, index, 2, 'SH')
    if contains(value, index + 1, 4, 'HEIM', 'HOEK', 'HOLM', 'HOLZ')
      #-- germanic --//
      result.append 'S'
    else
      result.append 'X'
    index += 2
  else if contains(value, index, 3, 'SIO', 'SIA') or contains(value, index, 4, 'SIAN')
    #-- Italian and Armenian --//
    if slavoGermanic
      result.append 'S'
    else
      result.append 'S', 'X'
    index += 3
  else if index == 0 and contains(value, index + 1, 1, 'M', 'N', 'L', 'W') or contains(value, index + 1, 1, 'Z')
    #-- german & anglicisations, e.g. "smith" match "schmidt" //
    # "snider" match "schneider" --//
    #-- also, -sz- in slavic language altho in hungarian it //
    #   is pronounced "s" --//
    result.append 'S', 'X'
    index = if contains(value, index + 1, 1, 'Z') then index + 2 else index + 1
  else if contains(value, index, 2, 'SC')
    index = handleSC(value, result, index)
  else
    if index == value.length - 1 and contains(value, index - 2, 2, 'AI', 'OI')
      #-- french e.g. "resnais", "artois" --//
      result.appendAlternate 'S'
    else
      result.append 'S'
    index = if contains(value, index + 1, 1, 'S', 'Z') then index + 2 else index + 1
  index

###*
# Handles 'SC' cases
###

handleSC = (value, result, index) ->
  if charAt(value, index + 2) == 'H'
    #-- Schlesinger's rule --//
    if contains(value, index + 3, 2, 'OO', 'ER', 'EN', 'UY', 'ED', 'EM')
      #-- Dutch origin, e.g. "school", "schooner" --//
      if contains(value, index + 3, 2, 'ER', 'EN')
        #-- "schermerhorn", "schenker" --//
        result.append 'X', 'SK'
      else
        result.append 'SK'
    else
      if index == 0 and !isVowel(charAt(value, 3)) and charAt(value, 3) != 'W'
        result.append 'X', 'S'
      else
        result.append 'X'
  else if contains(value, index + 2, 1, 'I', 'E', 'Y')
    result.append 'S'
  else
    result.append 'SK'
  index + 3

###*
# Handles 'T' cases
###

handleT = (value, result, index) ->
  if contains(value, index, 4, 'TION')
    result.append 'X'
    index += 3
  else if contains(value, index, 3, 'TIA', 'TCH')
    result.append 'X'
    index += 3
  else if contains(value, index, 2, 'TH') or contains(value, index, 3, 'TTH')
    if contains(value, index + 2, 2, 'OM', 'AM') or contains(value, 0, 4, 'VAN ', 'VON ') or contains(value, 0, 3, 'SCH')
      result.append 'T'
    else
      result.append '0', 'T'
    index += 2
  else
    result.append 'T'
    index = if contains(value, index + 1, 1, 'T', 'D') then index + 2 else index + 1
  index

###*
# Handles 'W' cases
###

handleW = (value, result, index) ->
  if contains(value, index, 2, 'WR')
    #-- can also be in middle of word --//
    result.append 'R'
    index += 2
  else
    if index == 0 and (isVowel(charAt(value, index + 1)) or contains(value, index, 2, 'WH'))
      if isVowel(charAt(value, index + 1))
        #-- Wasserman should match Vasserman --//
        result.append 'A', 'F'
      else
        #-- need Uomo to match Womo --//
        result.append 'A'
      index++
    else if index == value.length - 1 and isVowel(charAt(value, index - 1)) or contains(value, index - 1, 5, 'EWSKI', 'EWSKY', 'OWSKI', 'OWSKY') or contains(value, 0, 3, 'SCH')
      #-- Arnow should match Arnoff --//
      result.appendAlternate 'F'
      index++
    else if contains(value, index, 4, 'WICZ', 'WITZ')
      #-- Polish e.g. "filipowicz" --//
      result.append 'TS', 'FX'
      index += 4
    else
      index++
  index

###*
# Handles 'X' cases
###

handleX = (value, result, index) ->
  if index == 0
    result.append 'S'
    index++
  else
    if !(index == value.length - 1 and (contains(value, index - 3, 3, 'IAU', 'EAU') or contains(value, index - 2, 2, 'AU', 'OU')))
      #-- French e.g. breaux --//
      result.append 'KS'
    index = if contains(value, index + 1, 1, 'C', 'X') then index + 2 else index + 1
  index

###*
# Handles 'Z' cases
###

handleZ = (value, result, index, slavoGermanic) ->
  if charAt(value, index + 1) == 'H'
    #-- Chinese pinyin e.g. "zhao" or Angelina "Zhang" --//
    result.append 'J'
    index += 2
  else
    if contains(value, index + 1, 2, 'ZO', 'ZI', 'ZA') or slavoGermanic and index > 0 and charAt(value, index - 1) != 'T'
      result.append 'S', 'TS'
    else
      result.append 'S'
    index = if charAt(value, index + 1) == 'Z' then index + 2 else index + 1
  index

#-- BEGIN CONDITIONS --//

###*
# Complex condition 0 for 'C'
###

conditionC0 = (value, index) ->
  c = undefined
  if contains(value, index, 4, 'CHIA')
    true
  else if index <= 1
    false
  else if isVowel(charAt(value, index - 2))
    false
  else if !contains(value, index - 1, 3, 'ACH')
    false
  else
    c = charAt(value, index + 2)
    c != 'I' and c != 'E' or contains(value, index - 2, 6, 'BACHER', 'MACHER')

###*
# Complex condition 0 for 'CH'
###

conditionCH0 = (value, index) ->
  if index != 0
    false
  else if !contains(value, index + 1, 5, 'HARAC', 'HARIS') and !contains(value, index + 1, 3, 'HOR', 'HYM', 'HIA', 'HEM')
    false
  else if contains(value, 0, 5, 'CHORE')
    false
  else
    true

###*
# Complex condition 1 for 'CH'
###

conditionCH1 = (value, index) ->
  contains(value, 0, 4, 'VAN ', 'VON ') or contains(value, 0, 3, 'SCH') or contains(value, index - 2, 6, 'ORCHES', 'ARCHIT', 'ORCHID') or contains(value, index + 2, 1, 'T', 'S') or (contains(value, index - 1, 1, 'A', 'O', 'U', 'E') or index == 0) and (contains(value, index + 2, 1, L_R_N_M_B_H_F_V_W_SPACE) or index + 1 == value.length - 1)

###*
# Complex condition 0 for 'L'
###

conditionL0 = (value, index) ->
  if index == value.length - 3 and contains(value, index - 1, 4, 'ILLO', 'ILLA', 'ALLE')
    true
  else if (contains(value, value.length - 2, 2, 'AS', 'OS') or contains(value, value.length - 1, 1, 'A', 'O')) and contains(value, index - 1, 4, 'ALLE')
    true
  else
    false

###*
# Complex condition 0 for 'M'
###

conditionM0 = (value, index) ->
  if charAt(value, index + 1) == 'M'
    return true
  contains(value, index - 1, 3, 'UMB') and (index + 1 == value.length - 1 or contains(value, index + 2, 2, 'ER'))

#-- BEGIN HELPER FUNCTIONS --//

###*
# Determines whether or not a value is of slavo-germanic orgin. A value is
# of slavo-germanic origin if it contians any of 'W', 'K', 'CZ', or 'WITZ'.
###

isSlavoGermanic = (value) ->
  value.indexOf('W') > -1 or value.indexOf('K') > -1 or value.indexOf('CZ') > -1 or value.indexOf('WITZ') > -1

###*
# Determines whether or not a character is a vowel or not
###

isVowel = (ch) ->
  VOWELS.indexOf(ch) >= 0

###*
# Determines whether or not the value starts with a silent letter.  It will
# return <code>true</code> if the value starts with any of 'GN', 'KN',
# 'PN', 'WR' or 'PS'.
###

isSilentStart = (value) ->
  i = undefined
  l = undefined
  twoChars = undefined
  if value.length < 2
    return false
  twoChars = value.substring(0, 2)
  i = 0
  l = SILENT_START.length
  while i < l
    if twoChars == SILENT_START[i]
      return true
    i++
  false

###*
# Cleans the input
###

cleanInput = (input) ->
  if input == null
    return null
  input = input.toString().replace(/^\s+/, '').replace(/\s+$/, '')
  if input.length == 0
    return null
  input.toLocaleUpperCase()

###*
# Gets the character at index <code>index</code> if available, otherwise
# it returns <code>Character.MIN_VALUE</code> so that there is some sort
# of a default
###

charAt = (value, index) ->
  if index < 0 or index >= value.length
    return '\u0000'
  value.charAt index

###*
# Determines whether <code>value</code> contains any of the criteria starting at index <code>start</code> and
# matching up to length <code>length</code>
###

contains = (value, start, length, criteria) ->
  i = undefined
  l = undefined
  target = undefined
  if start >= 0 and start + length <= value.length
    target = value.substring(start, start + length)
    if 'string' == typeof criteria
      i = 3
      l = arguments.length
      while i < l
        if target == arguments[i]
          return true
        i++
    else
      # criteria is an array of strings
      i = 0
      l = criteria.length
      while i < l
        if target == criteria[i]
          return true
        i++
  false

#-- BEGIN INNER CLASSES --//

###*
# Inner class for storing results, since there is the optional alternate
# encoding.
###

DoubleMetaphoneResult = (pMaxLength) ->
  @primary = ''
  @alternate = ''
  @maxLength = pMaxLength
  return

'use strict'

###*
# "Vowels" to test for
###

VOWELS = 'AEIOUY'
SILENT_START = [
  'GN'
  'KN'
  'PN'
  'WR'
  'PS'
]
L_R_N_M_B_H_F_V_W_SPACE = [
  'L'
  'R'
  'N'
  'M'
  'B'
  'H'
  'F'
  'V'
  'W'
  ' '
]
ES_EP_EB_EL_EY_IB_IL_IN_IE_EI_ER = [
  'ES'
  'EP'
  'EB'
  'EL'
  'EY'
  'IB'
  'IL'
  'IN'
  'IE'
  'EI'
  'ER'
]
L_T_K_S_N_M_B_Z = [
  'L'
  'T'
  'K'
  'S'
  'N'
  'M'
  'B'
  'Z'
]
DEFAULT_CODE_LEN = 4

###*
# Encode a value with Double Metaphone (primary and alternate encoding).
#
# @param value {String} String to encode
# @return an object <code>{ primary: 'XXXX', alternate: 'YYYY' }</code>;
#         <tt>null</tt> if input is null, empty or blank.
###

DoubleMetaphone::doubleMetaphone = (value) ->
  value = cleanInput(value)
  if !value
    return null
  slavoGermanic = isSlavoGermanic(value)
  index = if isSilentStart(value) then 1 else 0
  result = new DoubleMetaphoneResult(@maxCodeLen)
  while !result.isComplete() and index <= value.length - 1
    switch value.charAt(index)
      when 'A', 'E', 'I', 'O', 'U', 'Y'
        index = handleAEIOUY(result, index)
      when 'B'
        result.append 'P'
        index = if charAt(value, index + 1) == 'B' then index + 2 else index + 1
      when 'Ç'
        # A C with a Cedilla
        result.append 'S'
        index++
      when 'C'
        index = handleC(value, result, index)
      when 'D'
        index = handleD(value, result, index)
      when 'F'
        result.append 'F'
        index = if charAt(value, index + 1) == 'F' then index + 2 else index + 1
      when 'G'
        index = handleG(value, result, index, slavoGermanic)
      when 'H'
        index = handleH(value, result, index)
      when 'J'
        index = handleJ(value, result, index, slavoGermanic)
      when 'K'
        result.append 'K'
        index = if charAt(value, index + 1) == 'K' then index + 2 else index + 1
      when 'L'
        index = handleL(value, result, index)
      when 'M'
        result.append 'M'
        index = if conditionM0(value, index) then index + 2 else index + 1
      when 'N'
        result.append 'N'
        index = if charAt(value, index + 1) == 'N' then index + 2 else index + 1
      when 'Ñ'
        # N with a tilde (spanish ene)
        result.append 'N'
        index++
      when 'P'
        index = handleP(value, result, index)
      when 'Q'
        result.append 'K'
        index = if charAt(value, index + 1) == 'Q' then index + 2 else index + 1
      when 'R'
        index = handleR(value, result, index, slavoGermanic)
      when 'S'
        index = handleS(value, result, index, slavoGermanic)
      when 'T'
        index = handleT(value, result, index)
      when 'V'
        result.append 'F'
        index = if charAt(value, index + 1) == 'V' then index + 2 else index + 1
      when 'W'
        index = handleW(value, result, index)
      when 'X'
        index = handleX(value, result, index)
      when 'Z'
        index = handleZ(value, result, index, slavoGermanic)
      else
        index++
        break
  {
    primary: result.primary
    alternate: result.alternate
  }

###*
# Returns the maxCodeLen.
# @return int
###

DoubleMetaphone::getMaxCodeLen = ->
  @maxCodeLen

###*
# Sets the maxCodeLen.
# @param pMaxCodeLen The maxCodeLen to set
###

DoubleMetaphone::setMaxCodeLen = (pMaxCodeLen) ->
  @maxCodeLen = pMaxCodeLen
  return

resultFn = DoubleMetaphoneResult.prototype

resultFn.append = (value, alternate) ->
  @appendPrimary value
  @appendAlternate alternate or value
  return

resultFn.appendPrimary = (value) ->
  addChars = @maxLength - (@primary.length)
  if value.length <= addChars
    @primary += value
  else
    @primary += value.substring(0, addChars)
  return

resultFn.appendAlternate = (value) ->
  addChars = @maxLength - (@alternate.length)
  if value.length <= addChars
    @alternate += value
  else
    @alternate += value.substring(0, addChars)
  return

resultFn.isComplete = ->
  @primary.length >= @maxLength and @alternate.length >= @maxLength
