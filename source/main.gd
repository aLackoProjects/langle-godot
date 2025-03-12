extends Control
var index = 1
var wordle_square = preload("res://words.tscn")
var letter_button = preload("res://letter_button.tscn")
const words_per_row:int = 4
@export var letter_button_root:VBoxContainer
@export var words_parent:MarginContainer
@export var words:Control
@export var scrollCon:ScrollContainer

func submit(new_text):
	words.set_index(index)
	index += 1
	GameGlobal.check(new_text)
	words.set_active(index)
	if index == 6 or (GameGlobal.cur_guessed_word.to_upper() == GameGlobal.answer_word):
		$timerThing.start()
	GameGlobal.active_index = index

func reset():
	print("Resetting game using MAIN method")
	
	words_parent.get_child(0).queue_free()
	var ws = wordle_square.instantiate()
	ws.connect("submit",submit)
	ws.name = "words"
	words = ws
	words_parent.add_child(ws)
	index = 1
	for letter in letter_button_root.get_children():
		letter.queue_free()
	
	print(len(GameGlobal.valid_letters))
	for row in ceili(float(len(GameGlobal.valid_letters))/words_per_row):
		var rowCon = HBoxContainer.new()
		rowCon.add_theme_constant_override("separation",20)
		
		for lI in words_per_row:
			var letter_index:int = (row*words_per_row)+lI
			if letter_index < len(GameGlobal.valid_letters):
				var letter = GameGlobal.valid_letters[letter_index]
				
				
				var lb = letter_button.instantiate()
				lb.letter = letter.to_upper()
				lb.connect("letter_pressed",on_alt_letter_press)
				rowCon.add_child(lb)
		letter_button_root.add_child(rowCon)


func _ready():
	scrollCon.get_v_scroll_bar().custom_minimum_size.x = 35;
	reset()

#OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://mods"))
func on_alt_letter_press(letter):
	words_parent.get_child(0).funky_alt_letter_press_openBracket_the_cooler_alt_letter_press_closeBracket(letter)

func scuffed_fix():
	$hud.end_game()
