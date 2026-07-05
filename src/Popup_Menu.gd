extends PopupMenu

var current_target = null

func _ready():
	add_item("Talk", 0)
	add_item("Help", 1)
	add_item("Order", 2)

	id_pressed.connect(_on_option_pressed)

func _on_option_pressed(id):
	if current_target == null:
		return

	match id:
		0:
			current_target.talk()
		1:
			current_target.help()
		2:
			current_target.order()
