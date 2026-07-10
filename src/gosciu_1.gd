extends "res://src/npc.gd"
var day = GameLoop.current_day

func talk():
	DialogManager.display_line(npc_name, day, "o siema")
	print("o siema")

func help():
	DialogManager.display_line(npc_name, day, "czy chcesz pomoc gosciowi na dachu?")
	print("czy chcesz pomoc gosciowi na dachu?")

func order():
	DialogManager.display_line(npc_name, day, "co ma zrobic gosciu?")
	print("co ma zrobic gosciu?")
	
	# Instancjonujemy menu wyboru pracy
	# Upewnij się, że ścieżka do sceny OrderMenu jest poprawna!
	var order_menu_scene = load("res://src/order_menu.tscn") 
	var order_menu = order_menu_scene.instantiate()
	
	# Przekazujemy referencję do samego siebie (this NPC), aby menu wiedziało kogo usunąć
	order_menu.npc_reference = self
	
	# Dodajemy menu do drzewa sceny, żeby się wyświetliło
	get_tree().root.add_child(order_menu)

# Funkcja wywoływana przez menu, gdy gracz podejmie decyzję
func disappear():
	print(npc_name + " idzie do pracy i znika.")
	
	# Informujemy manager NPC, że ten konkretny NPC poszedł do pracy
	if NpcManager.has_method("send_to_work"):
		NpcManager.send_to_work(npc_name)
	
	queue_free()
