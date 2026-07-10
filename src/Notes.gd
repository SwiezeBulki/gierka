extends CanvasLayer

@onready var notebook_image = $NotebookUI/NotebookImage
@onready var page_text = $NotebookUI/NotebookImage/PageText
@onready var prev_button = $NotebookUI/NotebookImage/PrevButton
@onready var next_button = $NotebookUI/NotebookImage/NextButton

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

func _ready():
	visible_position = notebook_image.position
	hidden_position = visible_position + Vector2(0, 1000)
	notebook_image.position = hidden_position
	
	prev_button.pressed.connect(_on_prev_pressed)
	next_button.pressed.connect(_on_next_pressed)
	
	# --- PRZYKŁADY UŻYCIA Z POWODEM ---
	modify_resource(0, 5, "tartak")      # Zobaczysz: +5 (tartak)
	modify_resource(0, -2, "budowa domu") # Zobaczysz: -2 (budowa domu)
	modify_resource(2, 10, "zbiory")     # Zobaczysz: +10 (zbiory)
	
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

func update_page():
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
	
	prev_button.disabled = (current_page == 0)
	next_button.disabled = (current_page == resources_data.size() - 1)

# --- ZMODYFIKOWANA FUNKCJA ---
# Dopisaliśmy trzeci argument: reason (powód) jako String
func modify_resource(resource_index: int, amount_change: int, reason: String = ""):
	if resource_index < 0 or resource_index >= resources_data.size():
		return
		
	var res = resources_data[resource_index]
	res["amount"] += amount_change
	
	var sign_str = "+" if amount_change > 0 else ""
	
	# Tworzymy podstawowy wpis np. "+5"
	var history_entry = sign_str + str(amount_change)
	
	# Jeśli podano powód, doklejamy go w nawiasie np. " (+5 (tartak))"
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
	if current_page < resources_data.size() - 1:
		current_page += 1
		update_page()
