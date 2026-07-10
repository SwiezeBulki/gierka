extends Node
# npc Manager
signal time_changed(current_day)

var npc_scenes = {
	"Gosc2": preload("res://src/gosciu_2.tscn"), 
	"Gosc1": preload("res://src/gosciu_1.tscn")
}

var npc_schedules = {
	"Gosc1": { 1: "Hol", 2: "DomOut" },
	"Gosc2": { 1: "DomOut", 2: "Hol"}
}

var current_locations = {
	"Gosc1": "DomOut",
	"Gosc2": "Hol"
}

var current_day: int = 0

# Nowa funkcja: NPC idzie do pracy, więc ustawiamy jego lokację na pustą,
# dzięki czemu get_npcs_for_room() go nie zwróci.
func send_to_work(npc_name: String):
	if current_locations.has(npc_name):
		current_locations[npc_name] = "Praca" # lub "" 
		print(npc_name + " został usunięty z mapy na resztę dnia.")

func update_time(new_day):
	current_day = new_day
	_update_npc_locations()
	time_changed.emit(new_day)

func _update_npc_locations():
	for npc_name in npc_schedules.keys(): # Zmieniono na npc_schedules.keys(), żeby przywracać też tych z "Pracy"
		if npc_schedules[npc_name].has(current_day):
			current_locations[npc_name] = npc_schedules[npc_name][current_day]
		else:
			# Jeśli NPC nie ma planu na dany dzień, opcjonalnie możesz go gdzieś ukryć
			current_locations[npc_name] = "BrakLokacji"

func get_target_location(npc_name: String) -> String:
	if current_locations.has(npc_name):
		return current_locations[npc_name]
	return ""

func get_npcs_for_room(room_name: String) -> Array:
	var npcs_to_spawn = []
	for npc_name in current_locations.keys():
		if current_locations[npc_name] == room_name:
			npcs_to_spawn.append(npc_name)
	return npcs_to_spawn
