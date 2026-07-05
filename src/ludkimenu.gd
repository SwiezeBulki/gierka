extends Area2D

@onready var menu = $"../PopupMenu"

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			menu.current_target = self
			menu.position = Vector2i(get_viewport().get_mouse_position())
			menu.popup()

func talk():
	pass

func help():
	pass

func order():
	pass
