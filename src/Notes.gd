extends CanvasLayer

@onready var notebook_image = $NotebookUI/NotebookImage
@onready var page_text = $NotebookUI/NotebookImage/PageText
@onready var prev_button = $NotebookUI/NotebookImage/PrevButton
@onready var next_button = $NotebookUI/NotebookImage/NextButton

# --- NOWE REFERENCJE DO PRZYCISKÓW TESTOWYCH ---
@onready var add_test_npc_button = $NotebookUI/NotebookImage/AddTestNpcButton
@onready var remove_npc_button = $NotebookUI/NotebookImage/RemoveNpcButton

# --- REFERENCJE UI DLA POSTACI ---
@onready var character_page = $NotebookUI/NotebookImage/CharacterPage
@onready var char_texture = $NotebookUI/NotebookImage/CharacterPage/CharTexture
@onready var char_name = $NotebookUI/NotebookImage/CharacterPage/CharTexture/CharName
@onready var char_stats = $NotebookUI/NotebookImage/CharacterPage/CharTexture/CharStats
@onready var char_backstory = $NotebookUI/NotebookImage/CharacterPage/CharTexture/CharBackstory

var is_open = false
var visible_position : Vector2
var hidden_position : Vector2

var current_page = 0

var resources_data = [
	{
		"name": "Drewno",
		"amount": 0,
		"history": []
	},
	{
		"name": "Metal",
		"amount": 0,
		"history": []
	},
	{
		"name": "elektryczne części",
		"amount": 0,
		"history": []
	},
	{
		"name": "Gotowe posiłki",
		"amount": 0,
		"history": []
	},
	{
		"name": "surowe składniki",
		"amount": 0,
		"history": []
	},
	{
		"name": "Prąd",
		"amount": 0,
		"history": []
	},
]

# --- NIEZALEŻNA LISTA NPC ZAPISANYCH W NOTESIE ---
# Ta lista przechowuje słowniki z danymi postaci. 
# Nawet jeśli NPC zniknie ze świata gry, jego dane tutaj zostaną!
var discovered_npcs = []

func _ready():
	visible_position = notebook_image.position
	hidden_position = visible_position + Vector2(0, 1000)
	notebook_image.position = hidden_position
	
	prev_button.pressed.connect(_on_prev_pressed)
	next_button.pressed.connect(_on_next_pressed)
	
	# Podłączenie przycisków testowych
	add_test_npc_button.pressed.connect(_on_add_test_npc_pressed)
	remove_npc_button.pressed.connect(_on_remove_npc_pressed)
	
	# --- PRZYKŁADY UŻYCIA Z POWODEM ---
	modify_resource(0, 5, "tartak")      
	modify_resource(0, -2, "budowa domu") 
	modify_resource(2, 10, "zbiory")     
	
	update_page()

func _input(event):
	if event.is_action_pressed("toggle_notebook"):
		toggle_notebook()

func toggle_notebook():
	is_open = !is_open
	var target_pos = visible_position if is_open else hidden_position
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(notebook_image, "position", target_pos, 0.5)

func register_npc(npc_node: Node):
	# Sprawdzamy nazwę postaci w kolejności priorytetów:
	# 1. Nowe 'NPCname'
	# 2. Starsze 'npc_name'
	# 3. Domyślna nazwa węzła w Godocie (npc_node.name)
	var name_to_check = ""
	if "NPCname" in npc_node and npc_node.NPCname != "":
		name_to_check = npc_node.NPCname
	elif "npc_name" in npc_node and npc_node.npc_name != "":
		name_to_check = npc_node.npc_name
	else:
		name_to_check = npc_node.name
	
	# Sprawdzamy, czy ten NPC nie jest już zapisany w notesie
	for npc in discovered_npcs:
		if npc["name"] == name_to_check:
			return # NPC już istnieje w notesie, unikamy dublowania
	
	# Pobieramy dane z obiektu NPC i zapisujemy jako bezpieczny słownik
	var npc_data = {
		"name": name_to_check,
		"backstory": npc_node.backstory if "backstory" in npc_node else "Brak historii.",
		"portrait": npc_node.portrait_path if "portrait_path" in npc_node else "res://icon.svg",
		"stats": {
			"Siła": npc_node.strength if "strength" in npc_node else 0,
			"Zręczność": npc_node.dexterity if "dexterity" in npc_node else 0,
			"Wytrzymałość": npc_node.endurance if "endurance" in npc_node else 0,
			"Inteligencja": npc_node.inteligence if "inteligence" in npc_node else 0,
		}
	}
	
	discovered_npcs.append(npc_data)
	update_page()
func update_page():
	var total_resources = resources_data.size()
	var total_characters = discovered_npcs.size()
	var total_pages = total_resources + total_characters
	
	# Zabezpieczenie indeksu strony
	if current_page >= total_pages:
		current_page = max(0, total_pages - 1)
		
	# Pokazuj przycisk usuwania tylko wtedy, gdy jesteśmy na stronie jakiejś postaci
	remove_npc_button.visible = (current_page >= total_resources)
	
	# --- 1. STRONY SUROWCÓW ---
	if current_page < total_resources:
		page_text.visible = true
		character_page.visible = false
		
		var res = resources_data[current_page]
		var page_content = "Surowiec: " + res["name"] + "\n"
		page_content += "Ilość: " + str(res["amount"]) + "\n"
		page_content += "-------------------\n"
		page_content += "Historia zmian:\n"
		
		if res["history"].is_empty():
			page_content += "(brak zmian)"
		else:
			for change in res["history"]:
				page_content += change + "\n"
				
		page_text.text = page_content
		
	# --- 2. STRONY DYNAMICZNYCH POSTACI ---
	else:
		page_text.visible = false
		character_page.visible = true
		
		var npc_index = current_page - total_resources
		var npc = discovered_npcs[npc_index]
		
		char_name.text = npc["name"]
		char_backstory.text = npc["backstory"]
		
		var stats_text = ""
		for stat_name in npc["stats"]:
			stats_text += stat_name + ": " + str(npc["stats"][stat_name]) + "\n"
		char_stats.text = stats_text
		
		if ResourceLoader.exists(npc["portrait"]):
			char_texture.texture = load(npc["portrait"])
		else:
			char_texture.texture = load("res://icon.svg")
	
	prev_button.disabled = (current_page == 0)
	next_button.disabled = (current_page == total_pages - 1 or total_pages == 0)

# --- REAKCJE NA BUTTONY TESTOWE ---

func _on_add_test_npc_pressed():
	# 1. Tworzymy nowy, czysty obiekt Area2D (ponieważ gosciu_1 dziedziczy po npc.gd, który dziedziczy po Area2D)
	var dummy_npc = Area2D.new()
	
	# 2. Ładujemy skrypt konkretnej postaci
	var npc_script_path = "res://src/gosciu_1.gd" # Upewnij się, że ścieżka do pliku gosciu_1.gd jest poprawna!
	if ResourceLoader.exists(npc_script_path):
		var npc_script = load(npc_script_path)
		dummy_npc.set_script(npc_script)
		
		# UWAGA: W Godocie po przypisaniu skryptu poprzez set_script(), zmienne skryptu 
		# są automatycznie inicjalizowane na ich domyślne wartości z kodu (np. strength = 2).
		# Wymusza to też wywołanie wewnętrznej inicjalizacji silnika.
		
		# 3. Ustawiamy nazwę, jeśli 'npc_name' nie zostało zdefiniowane bezpośrednio w skrypcie, 
		# lub pobieramy ją (np. jeśli Twój bazowy npc.gd ma taką zmienną).
		if "npc_name" in dummy_npc and dummy_npc.npc_name != "":
			dummy_npc.name = dummy_npc.npc_name
		else:
			# Jeśli nie ma npc_name, używamy nazwy pliku jako nazwy wyświetlanej
			dummy_npc.name = "Gosciu_1"
		
		# Opcjonalnie: Jeśli chcesz mieć dla niego portret, możesz dodać go dynamicznie,
		# albo dopisać w pliku gosciu_1.gd zmienną: var portrait_path = "res://obrazki/gosciu1.png"
		if not "portrait_path" in dummy_npc:
			dummy_npc.set("portrait_path", "res://icon.svg")
			
		# 4. Rejestrujemy naszego wirtualnego NPC w notesie. 
		# Funkcja register_npc sama wyciągnie z niego strength, dexterity, backstory itp.!
		register_npc(dummy_npc)
		
		print("Pomyślnie wczytano postać ze skryptu " + npc_script_path + " do notesu.")
	else:
		printerr("Nie znaleziono skryptu NPC pod ścieżką: ", npc_script_path)
		
	# 5. Usuwamy obiekt tymczasowy z pamięci RAM – dane zostały już skopiowane do notesu!
	dummy_npc.free()
	

func _on_remove_npc_pressed():
	var total_resources = resources_data.size()
	if current_page >= total_resources:
		var npc_index = current_page - total_resources
		discovered_npcs.remove_at(npc_index)
		# Cofamy stronę o 1, aby nie wyjść poza zakres
		if current_page > 0:
			current_page -= 1
		update_page()

# --- FUNKCJA MODYFIKACJI ---
func modify_resource(resource_index: int, amount_change: int, reason: String = ""):
	if resource_index < 0 or resource_index >= resources_data.size():
		return
		
	var res = resources_data[resource_index]
	res["amount"] += amount_change
	
	var sign_str = "+" if amount_change > 0 else ""
	var history_entry = sign_str + str(amount_change)
	
	if reason != "":
		history_entry += " (" + reason + ")"
	
	res["history"].insert(0, history_entry)
	
	if res["history"].size() > 5:
		res["history"].resize(5)
	
	update_page()

func _on_prev_pressed():
	if current_page > 0:
		current_page -= 1
		update_page()

func _on_next_pressed():
	var total_pages = resources_data.size() + discovered_npcs.size()
	if current_page < total_pages - 1:
		current_page += 1
		update_page()
