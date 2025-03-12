# langle
Wordle but for different languages on Godot.

Making custom mods:
The mod structure needs 3 files:\
  manifest.json,\
  allowed_words.txt,\
  answers.txt,

manifest.json:\
  translations (bool)\
    If true, application expects answers to be seperated by new line:\
      verde,green\
      negro,black\
      perro,dog

  uuid (string)\
    Any string would work

  title (string)\
    Name of the mod

  description (string)\
    Description of the mod

  valid_letters (string)\
    All letters (lowercase) which can be inputted, shown on the side of the screen

  translates_to (string)\
    Shows what language it translates to

answers.txt:\
  List of words seperated by new line:\
    aback \
    abase \
    abate 

  If translations is true (found in manifest.json): \
    Is instead seperated by commas and newlines: \
        word,meaning \
        negro,black \
        perro,dog \
        playa,beach

allowed_words.txt: \
  List of words seperated by new line: \
    word1 \
    word2 \
    word3
