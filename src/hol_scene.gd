extends Node2D
@export var room_name = ""
@onready var spawn_points = $SpawnPoints
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_npcs_in_room()

func spawn_npcs_in_room():
	print("--- DEBUG SPAWNOWANIA ---")
	print("Pokój: ", room_name)
	var npcs_to_spawn = NpcManager.get_npcs_for_room(room_name)
	print("NPC, którzy powinni tu być według Managera: ", npcs_to_spawn)
	for npc in npcs_to_spawn:
		if NpcManager.npc_scenes.has(npc):
			var npc_instance = NpcManager.npc_scenes[npc].instantiate()
			npc_instance.current_room_name = room_name
			var point = spawn_points.get_node_or_null(npc)
			if point :
				npc_instance.global_position = point.global_position
			else :
				npc_instance.global_position = Vector2(100, 100) 
			add_child(npc_instance)
