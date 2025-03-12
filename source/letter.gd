extends Node2D
@onready var letter_background = $letter_background
@onready var letter = $letter_background/letter
@export var id = 2


func set_color(color):
	var panel = $letter_background.get_theme_stylebox("panel").duplicate()
	panel.bg_color = color
	$letter_background.add_theme_stylebox_override("panel",panel)

func set_text_color(color):
	letter.set("theme_override_colors/font_color", color)

func check_id(idv,color,character,_type):
	if id == idv:
		letter.text = character.to_upper()
		set_color(color[0])
		set_text_color(color[1])

func severe_connection():
	GameGlobal.disconnect("set_letter",check_id)

func _on_word_connection_form():
	GameGlobal.connect("set_letter",check_id)
