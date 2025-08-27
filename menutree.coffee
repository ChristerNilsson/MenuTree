echo = console.log
tree = null
buttons = []

current = null # pekar på ett delträd

path = [] # anger hela trädet
indexes = [0] # default markeras första valet

class Button
	constructor : (@text, @x, @y, @index) ->
	draw : () -> 
		fill if @index == _.last indexes then 'yellow' else 'black'
		text @text,@x,@y

window.preload = -> tree = loadJSON 'menutree.json'

window.setup = ->
	createCanvas 200, 300
	noStroke()
	current = if path.length == 0 then tree else _.get tree, path
	echo 'path',path
	echo 'current', current

	keys = _.keys current
	buttons = (new Button keys[i],10,40+20*i,i for i in _.range keys.length)
	echo 'buttons',buttons

	draw()

draw = ->

	echo 'draw', typeof current
	background 'gray'
	if 'string' == typeof current
		text current,10,200
	if 'object' == typeof current
		for button in buttons
			button.draw()
	s = path.join ' • '
	fill 'white'
	echo 's',s
	text s, 10, 20

update = ->
	current = if path.length == 0 then tree else _.get tree, path
	keys = _.keys current
	buttons = (new Button keys[i],10,40+20*i,i for i in _.range keys.length)

window.keyPressed = () ->
	echo key

	n = indexes.length
	echo 'n',n
	index = indexes[n-1]
	if key == 'ArrowDown' then index = (index + 1) %% buttons.length
	if key == 'ArrowUp'   then index = (index - 1) %% buttons.length
	indexes[n-1] = index
	echo 'indexes',indexes,n

	if key in 'Escape ArrowLeft'.split ' '
		if path.length == 0 or indexes.length == 1 then return
		path.pop()
		indexes.pop()
		update()

	if key in 'Enter ArrowRight'.split ' '
		path.push buttons[_.last indexes].text
		indexes.push 0
		update()

	draw()
