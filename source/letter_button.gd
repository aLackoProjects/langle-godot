extends Panel
@export var letter = "E"
@export var offset = 0
@onready var button = $letter
var color = [Color.WHITE,Color.BLACK]
var type = -1
signal letter_pressed(letter)
# Called when the node enters the scene tree for the first time.
func set_color(color):
	var panel = get_theme_stylebox("panel").duplicate()
	panel.bg_color = color
	add_theme_stylebox_override("panel",panel)

func change_text_color(color):
	button.set("theme_override_colors/font_color", color[1])
	button.set("theme_override_colors/font_pressed_color", color[1])
	button.set("theme_override_colors/font_hover_color", color[0])


func _on_pressed():
	letter_pressed.emit(letter)
	$letter.release_focus()

func _ready():
	GameGlobal.connect("set_letter",set_total)
	$letter.text = letter
	$letter.position.x = offset


func set_total(_id,c,character,settype):
	if character == letter.to_lower() and settype > type:
		set_color(c[0])
		change_text_color(c)
		color = c
		type = settype



func _on_letter_mouse_entered():
	set_color(color[1])


func _on_letter_mouse_exited():
	set_color(color[0])
