extends Area2D
#npc
@onready var menu = $"../PopupMenu"
@export var npc_name = ""
@export var current_room_name = ""

func _ready() -> void:
	NpcManager.time_changed.connect(_check_schedule)
	_check_schedule(GameLoop.current_day)

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
	
#func go_to_location(location, x=800, y=400):
	#var path_to_scene = NpcManager.scenecs[location]
	#get_tree().change_scene_to_file(path_to_scene)
	#position.x = x
	#position.y = y

func _check_schedule(day):
	var my_real_location = NpcManager.get_target_location(npc_name)
	print("npc_loctaion " ,my_real_location)
	if my_real_location != current_room_name:
		hide()
		monitorable = false 
		monitoring = false
	else:
		show()
		monitorable = true
		monitoring = true
