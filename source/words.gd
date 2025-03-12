extends VBoxContainer
signal submit(string)

func set_index(index):
	get_node(str(index)).connection_form.emit()
	print("CONNECTING %s at index %s\nINDEX IS NOT 1? %s" % [get_node(str(index)),index,index != 1])
	if index != 1:
		get_node(str(index-1))._connection_terminate.emit()
		get_node(str(index)).reset()
		GameGlobal.active_index = index
		print("SETINDEXTO_",GameGlobal.active_index)
	else:
		GameGlobal.active_index = index
		get_node(str(index)).reset()

func _ready():
	get_node("1").accepting_keys = true

func set_active(index):
	if get_node_or_null(str(index)) != null:
		get_node(str(index)).accepting_keys = true

func _on__submit(string):
	submit.emit(string)


func _on_focus_entered():
	release_focus()


func funky_alt_letter_press_openBracket_the_cooler_alt_letter_press_closeBracket(letter):
	var input = InputEventKey.new()
	print("CURACTIVEINDEX ",GameGlobal.active_index)
	input.keycode = OS.find_keycode_from_string(letter)
	input.pressed = true
	input.unicode = letter.unicode_at(0)
	get_child(GameGlobal.active_index-1)._unhandled_input(input)
