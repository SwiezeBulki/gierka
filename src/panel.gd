extends Panel

@onready var name_label: Label = $NameLabel
@onready var text_label: RichTextLabel = $TextLabel

var dialogue = [
	{"name": "Alicja", "text": "Hej... gdzie my jesteśmy?"},
	{"name": "Bohater", "text": "Nie wiem. Ale coś tu jest dziwne..."},
	{"name": "Alicja", "text": "Musimy iść dalej."}
]

var index := 0
var typing := false
var char_index := 0
var current_text := ""
var typing_speed := 0.03

func _ready():
	show_line()

func show_line():
	var line = dialogue[index]
	name_label.text = line["name"]
	current_text = line["text"]
	char_index = 0
	text_label.text = ""
	typing = true
	type_text()

func type_text():
	if char_index < current_text.length():
		text_label.text += current_text[char_index]
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		type_text()
	else:
		typing = false

func next_line():
	if typing:
		# szybkie pominięcie animacji
		text_label.text = current_text
		typing = false
	else:
		index += 1
		if index >= dialogue.size():
			index = 0
		show_line()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_line()
