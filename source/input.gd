extends Control
var string = ''
var accepting_keys = true
@export var max_length = 6
signal submit(string)

func _ready():
	GameGlobal.answer_word = "EASNLP"
	for child in get_children():
		child.set_color(Color.WHITE)
		child.set_text_color(Color.BLACK)
		child._on_word_connection_form()

func _unhandled_input(event):
	if event is InputEventKey and accepting_keys:
		if event.pressed:
			var key = OS.get_keycode_string(event.keycode)
			if event.keycode == KEY_BACKSPACE:
				string = string.left(len(string)-1)
				get_node(str(len(string))).letter.text = ''
			elif len(key) == 1 and len(string) < max_length:
				string += key
				get_node(str(len(string)-1)).letter.text = string[len(string)-1]
			elif event.keycode == KEY_ENTER:
				accepting_keys = false
				submit.emit(string)
				GameGlobal.check(string)

func clear():
	for child in get_children():
		child.letter.text = ''
		string = ''
