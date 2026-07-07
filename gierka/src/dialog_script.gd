extends CanvasLayer
@onready var _speaker = $Control/VBoxContainer/HBoxContainer/Speaker
@onready var _day = $Control/VBoxContainer/HBoxContainer/day
@onready var _dialog =  $Control/VBoxContainer/dialog
@onready var _continue = $Control/Box/Button

func display_line(Speaker : String, day: int, line : String):
	print()
	_speaker.text = Speaker
	_day.text = "dzien: " + str(day)
	_dialog.text = line
	open()
	_continue.grab_focus()
	
func open():
	visible = true
	
func close():
	visible= false

func _on_button_pressed() -> void:
	close()
