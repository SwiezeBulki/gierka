extends CanvasLayer

@onready var panel = $Panel
@onready var name_label = $Panel/Label
@onready var text_label = $Panel/RichTextLabel

var dialogue = [


	{
		"name":"Alice",
		"text":"Hej."
	},

	{
		"name":"Bob",
		"text":"Witaj."
	},

	{
		"name":"Alice",
		"text":"Gotowy?"
	},

	{
		"name":"Bob",
		"text":"Tak."
	}

]
var current_line = 0

func _ready():
	panel.hide()
	Sygnaly.request_dialogue_start.connect(start_dialogue)


func start_dialogue(new_dialogue):
	dialogue = new_dialogue
	current_line = 0

	panel.show()

	show_current_line()


func show_current_line():

	if current_line >= dialogue.size():
		end_dialogue()
		return

	var line = dialogue[current_line]

	name_label.text = line.name
	text_label.text = line.text


func next_line():

	current_line += 1

	if current_line >= dialogue.size():
		end_dialogue()
		return

	show_current_line()


func end_dialogue():

	panel.hide()

	dialogue.clear()

	current_line = 0


func _unhandled_input(event):

	if !panel.visible:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			next_line()
