extends Node
var answer_word = "HELLO"
var cur_guessed_word = ""
var color_parameters = [[Color.html('#333333'),Color.WHITE],[Color.html("#DDD8B8"),Color.BLACK],[Color.html('#B3CBB9'),Color.BLACK]]
var valid_words = PackedStringArray([])
var valid_answers = PackedStringArray([])
var valid_translations = PackedStringArray([])
var used_letters = {}
var active_index = 1
var rng = RandomNumberGenerator.new()
var valid_letters = 'abcdefghijklmnopqrstuvwxyz'
var current_mod = ""
var mod_info = {}
var translate_index = 0
var translates_to = ""
signal set_letter(id,color,character,type)
signal invalid_word()

func _ready():
	read_mods_in_both_dirs()
	print("Mod info:\n %s" % mod_info)

func read_and_process_mod_files(root_dir = "user://mods/"):
	print("Reading file %s" % ProjectSettings.globalize_path(root_dir))
	var dir = DirAccess.open(root_dir)
	if dir == null and root_dir == "user://mods/":
		print("MAKING DIR")
		var dirMake = DirAccess.open("user://")
		dirMake.make_dir("mods")
		dir = DirAccess.open("user://mods")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			print("READING %s" % file_name)
			var manifest_destiny = FileAccess.file_exists(root_dir+file_name+"/manifest.json")
			if manifest_destiny:
				var manifest = FileAccess.get_file_as_string(root_dir+file_name+"/manifest.json")
				var manifest_data = JSON.parse_string(manifest)
				var uuid = manifest_data['uuid']
				manifest_data.erase('uuid')
				mod_info[uuid] = {}
				mod_info[uuid] = manifest_data
				mod_info[uuid]['filepath'] = ""
				mod_info[uuid]['filepath'] = root_dir+file_name
			else:
				print("No manifest.json file found for mod file: %s\nIf this is meant to happen, please ignore" % file_name)
		file_name = dir.get_next()

func read_mods_in_both_dirs():
	mod_info = {}
	read_and_process_mod_files("res://mods/")

func reset():
	cur_guessed_word = ''
	active_index = 1
	translate_index = rng.randi_range(0,len(valid_answers)-1)
	answer_word = crop_invalid_answer(valid_answers[translate_index])

func get_words(current_file,translate = false):
	valid_words = PackedStringArray([])
	valid_answers = PackedStringArray([])
	valid_translations = PackedStringArray([])
	if translate:
		var unprocessedAnswers:PackedStringArray = FileAccess.open(current_file+"/answers.txt", FileAccess.READ).get_as_text().split("\n")
		for uAnswer in unprocessedAnswers:
			if uAnswer != "":
				var splitThing = uAnswer.split(",")
				if not splitThing.is_empty():
					valid_translations.append(splitThing[1])
					valid_answers.append(splitThing[0])
	else:
		valid_answers = FileAccess.open(current_file+"/answers.txt", FileAccess.READ).get_as_text().split("\n")
	valid_words = FileAccess.open(current_file+"/allowed_words.txt", FileAccess.READ).get_as_text().split("\n")+GameGlobal.valid_answers


func crop_invalid_answer(word):
	return word.left(5).to_upper()

func check_word(guessed_word):
	guessed_word = guessed_word.to_upper()
	var checked_letters = {}
	var check_array = []
	for i in range(len(guessed_word)):
		var letter = guessed_word[i]
		if not letter in checked_letters:
			checked_letters[letter] = 0
		if answer_word[i] == letter:
			check_array.append(2)
			if letter in checked_letters:
				checked_letters[letter] += 1
		else:
			check_array.append(4)
			
	for i in range(len(check_array)):
		if check_array[i] == 4:
			var letter = guessed_word[i]
			if (letter in answer_word) and (checked_letters[letter] < answer_word.count(letter)):
				check_array[i] = 1
				checked_letters[letter] += 1
			else:
				check_array[i] = 0
	return check_array

func color_letters(checked_letters):
	for i in range(len(checked_letters)):
		print("CHECK PARAMETERS: \nCHAR index: %s\nParameters: %s\nCurrent guessed letter: %s\nChecked Letters: %s\n" % [i,color_parameters[checked_letters[i]],cur_guessed_word[i],checked_letters[i]])
		set_letter.emit(i,color_parameters[checked_letters[i]],cur_guessed_word[i],checked_letters[i])

func check(guess):
	cur_guessed_word = guess
	color_letters(check_word(cur_guessed_word))
