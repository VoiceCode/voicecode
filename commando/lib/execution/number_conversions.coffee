lt20 = [
  ''
  'one'
  'two'
  'three'
  'four'
  'five'
  'six'
  'seven'
  'eight'
  'nine'
  'ten'
  'eleven'
  'twelve'
  'thirteen'
  'fourteen'
  'fifteen'
  'sixteen'
  'seventeen'
  'eighteen'
  'nineteen'
]
tens = [
  ''
  'ten'
  'twenty'
  'thirty'
  'fourty'
  'fifty'
  'sixty'
  'seventy'
  'eighty'
  'ninety'
]
scales = [
  ''
  'thousand'
  'million'
  'billion'
  'trillion'
  'quadrillion'
  'quintillion'
  'sextillion'
  'septillion'
  'octillion'
  'nonillion'
  'decillion'
]
max = scales.length * 3

@numberToWords = (val) ->
  len = undefined
  if val[0] == '-'
    return 'negative ' + convert(val.slice(1))
  if val == '0'
    return 'zero'
  val = trim_zeros(val)
  len = val.length
  if len < max
    return convert_lt_max(val)
  if len >= max
    return convert_max(val)
  return

convert_max = (val) ->
  split_rl(val, max).map((val, i, arr) ->
    if i < arr.length - 1
      return convert_lt_max(val) + ' ' + scales.slice(-1)
    convert_lt_max val
  ).join ' '

convert_lt_max = (val) ->
  l = val.length
  if l < 4
    convert_lt1000(val).trim()
  else
    split_rl(val, 3).map(convert_lt1000).reverse().map(with_scale).reverse().join(' ').trim()

convert_lt1000 = (val) ->
  rem = undefined
  l = undefined
  val = trim_zeros(val)
  l = val.length
  if l == 0
    return ''
  if l < 3
    return convert_lt100(val)
  if l == 3
    rem = val.slice(1)
    if rem
      return lt20[val[0]] + ' hundred ' + convert_lt1000(rem)
    else
      return lt20[val[0]] + ' hundred'
  return

convert_lt100 = (val) ->
  if is_lt20(val)
    # less than 20
    lt20[val]
  else if val[1] == '0'
    tens[val[0]]
  else
    tens[val[0]] + '-' + lt20[val[1]]

split_rl = (str, n) ->
  # takes a string 'str' and an integer 'n'. Splits 'str' into
  # groups of 'n' chars and returns the result as an array. Works
  if str
    Array::concat.apply split_rl(str.slice(0, -n), n), [ str.slice(-n) ]
  else
    []

with_scale = (str, i) ->
  scale = undefined
  if str and i > -1
    scale = scales[i]
    if scale != undefined
      str.trim() + ' ' + scale
    else
      convert str.trim()
  else
    ''

trim_zeros = (val) ->
  val.replace /^0*/, ''

is_lt20 = (val) ->
  parseInt(val, 10) < 20
