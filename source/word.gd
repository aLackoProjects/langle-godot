extends Control
signal _connection_terminate()
signal connection_form()
signal submit(string)
var string = ''
var accepting_keys = false
@export var max_length = 5


func _ready():
	GameGlobal.connect("set_letter",_check_valid)
	for child in get_children():
		child.set_color(Color.WHITE)
		child.set_text_color(Color.BLACK)

func _check_valid(_a,_b,_c,_d):
	if str(GameGlobal.active_index) == name:
		smooth_criminal()

func _unhandled_input(event):
	if event is InputEventKey and accepting_keys:
		if event.pressed:
			var key = OS.get_keycode_string(event.keycode)
			if key == "":
				key = String.chr(event.unicode)
			if event.keycode == KEY_BACKSPACE:
				string = string.left(len(string)-1)
				get_node(str(len(string))).letter.text = ''
			elif len(key) == 1 and len(string) < max_length and key.to_lower() in GameGlobal.valid_letters:
				string += key
				get_node(str(len(string)-1)).letter.text = string[len(string)-1]
			elif event.keycode == KEY_ENTER:
				var valid_word = (string.to_lower() in GameGlobal.valid_words)
				if valid_word:
					if len(string) == max_length:
						accepting_keys = false
						submit.emit(string.to_lower())
					else:
						for num in range(max_length-len(string)):
							var child = get_node(str(max_length-num-1))
							shake(0.1,10,child)
				else:
					for child in get_children():
						shake(0.1,20,child)


func clear():
	for child in get_children():
		child.letter.text = ''
		string = ''

func shake(time,degrees,child):
	var tween = get_tree().create_tween()
	tween.tween_property(child,"rotation_degrees",degrees,time)
	tween.tween_property(child,"rotation_degrees",-degrees,time)
	tween.tween_property(child,"rotation_degrees",0,time)

func reset():
	for child in get_children():
		child.set_text_color(Color.WHITE)

func smooth_criminal():
	var children = get_children()
	for i in range(len(children)):
		var child = children[i]
		var tween = get_tree().create_tween()
		tween.tween_property(child,"position",child.position-Vector2(0,20),0.1*(i+1))
		tween.tween_property(child,"position",child.position,0.1)
