extends CanvasLayer # Zmieniliśmy z Control na CanvasLayer

# Dodaliśmy "$NotebookUI/" przed każdą ścieżką, bo skrypt jest teraz wyżej w strukturze
@onready var notebook_image = $NotebookUI/NotebookImage
@onready var page_text = $NotebookUI/NotebookImage/PageText
@onready var prev_button = $NotebookUI/NotebookImage/PrevButton
@onready var next_button = $NotebookUI/NotebookImage/NextButton

# Zmienne pozycji – teraz puste, bo uzupełni je kod
var is_open = false
var visible_position : Vector2
var hidden_position : Vector2

# Dane stron (bez zmian)
var current_page = 0
var pages = [
	"witaj mój pamiętniczku!\npierwsza strona.",
	"Druga strona.\n- dfgddfg\n- geddfg",
	"Trzecia strona. hsdjhfdi..."
]

func _ready():
	# 1. Kod automatycznie zapamiętuje pozycję, którą ustawiłeś myszką w edytorze!
	visible_position = notebook_image.position
	
	# 2. Obliczamy pozycję ukrytą: bierzemy pozycję ze środka i przesuwamy ją w dół o np. 1000 pikseli
	hidden_position = visible_position + Vector2(0, 1000)
	
	# 3. Na start gry chowamy notes na dół
	notebook_image.position = hidden_position
	
	# Podłączamy sygnały (bez zmian)
	prev_button.pressed.connect(_on_prev_pressed)
	next_button.pressed.connect(_on_next_pressed)
	update_page()

func _input(event):
	# Sprawdzamy, czy wciśnięto klawisz "i"
	if event.is_action_pressed("toggle_notebook"):
		toggle_notebook()

func toggle_notebook():
	is_open = !is_open
	var target_pos = visible_position if is_open else hidden_position
	
	# Tworzymy Tween dla płynnego wysunięcia/schowania
	var tween = create_tween()
	# Ustawiamy płynne przejście (Ease Out sprawia, że notes zwalnia na końcu)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Animujemy właściwość "position" naszego TextureRect
	tween.tween_property(notebook_image, "position", target_pos, 0.5)

func update_page():
	# Aktualizujemy tekst
	page_text.text = pages[current_page]
	
	# Wyłączamy lewy przycisk, jeśli to pierwsza strona
	prev_button.disabled = (current_page == 0)
	
	# Wyłączamy prawy przycisk, jeśli to ostatnia strona
	next_button.disabled = (current_page == pages.size() - 1)

func _on_prev_pressed():
	if current_page > 0:
		current_page -= 1
		update_page()

func _on_next_pressed():
	if current_page < pages.size() - 1:
		current_page += 1
		update_page()
