extends Control
@onready var background = get_node('background')
@onready var score = get_node('score')
@onready var score2 = get_node('score2')
@export var res_button:Button
var uuids = []
signal reset()
var resetting = false

func _ready():
	print("READING MOD INFO")
	for id in GameGlobal.mod_info:
		uuids.append(id)
		print(GameGlobal.mod_info[id]['title'])
		$background/mods/select.add_item(GameGlobal.mod_info[id]['title'].left(16))
	select_mod(0)
	get_tree().paused = false

func _on_button_pressed():
	$open.release_focus()
	var tween = get_tree().create_tween().set_parallel()
	var node = get_node('open')
	tween.bind_node(node)
	if get_tree().paused:
		get_tree().paused = false
		tween.tween_property(node,"rotation_degrees",0,0.5)
		tween.tween_property(background,'position',Vector2(0,-972),0.5)
		if resetting:
			resetting = false
			reset.emit()
	else:
		get_tree().paused = true
		tween.tween_property(node,"rotation_degrees",180,0.5)
		tween.tween_property(background,'position',Vector2(0,0),0.5)



func select_mod(index):
	var mod = GameGlobal.mod_info[uuids[index]]
	var current_file = mod['filepath']
	var title = $background/mods/s2/name
	var description = $background/mods/s/description
	title.text = mod['title']
	GameGlobal.current_mod = current_file
	GameGlobal.valid_letters = mod['valid_letters']
	if "translates_to" in mod:
		GameGlobal.translates_to = mod["translates_to"]
	else:
		GameGlobal.translates_to = ""
	GameGlobal.get_words(current_file,mod['translations'])
	description.text = "%s\n\nAnswer Count: %s\nValid Word Count: %s\n\nVersion: %s" % [mod['description'],len(GameGlobal.valid_answers),len(GameGlobal.valid_words),mod['version']]
	GameGlobal.reset()

func open_main_mod_directory():
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://mods"))

func emit_reset(_a):
	resetting = true

func open_local_mod_folder():
	var path = ProjectSettings.globalize_path(GameGlobal.current_mod)
	OS.shell_show_in_file_manager(path)

func end_screen_visibility(set_v):
	var tween = get_tree().create_tween().set_parallel()
	if set_v:
		tween.tween_property(score,"position",Vector2(691,53),0.2)
		if GameGlobal.translates_to != "":
			tween.tween_property(score2,"position",Vector2(20,573),0.2)
	else:
		tween.tween_property(score,"position",Vector2(691,971),0.2)
		if GameGlobal.translates_to != "":
			tween.tween_property(score2,"position",Vector2(-658,573),0.2)
	$score/restart.disabled = not set_v


func _on_restart_pressed():
	end_screen_visibility(false)
	GameGlobal.reset()
	reset.emit()
	$open.disabled = false
	res_button.release_focus()

func end_game():
	$open.disabled = true
	end_screen_visibility(true)
	$score/edit_word.text = GameGlobal.answer_word.to_upper()
	if GameGlobal.translates_to != "":
		$score2/s2/edit_word.text = GameGlobal.valid_translations[GameGlobal.translate_index].to_upper()
		$score2/edit_lang.text = "in %s" % GameGlobal.translates_to.to_upper()

func spinny_boiiiiii():
	var tween = get_tree().create_tween()
	tween.tween_property($reset,"rotation_degrees",360,0.5)
	tween.tween_property($reset,"rotation_degrees",0,0)
