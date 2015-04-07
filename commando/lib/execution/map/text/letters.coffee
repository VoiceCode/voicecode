letters = 
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

_.each letters, (value, key) ->
	Commands.mapping[value] = 
    kind: "action"
    grammarType: "textCapture"
    description: "Enters the single letter: #{key}"
    tags: ["letter"]
    action: (input) ->
      @string "#{key}#{(input or []).join('')}"

# _.each letters, (value, key) ->
# 	Commands.mapping["sky#{value}"] = 
#     kind: "action"
#     grammarType: "textCapture"
#     description: "Enters capital letter: #{key}"
#     tags: ["letter"]
#     actions: [
#       kind: "script"
#       script: (input) ->
#         Scripts.singleLetter(key.toUpperCase(), input)
#     ]