extends CanvasLayer


# Zmienna, która zapamięta, który NPC dostał rozkaz
var npc_reference = null

@onready var lumbermill_btn = $ButtonTartak
@onready var workshop_btn = $ButtonWarsztat
@onready var forest_btn = $ButtonLas

func _ready():
	lumbermill_btn.pressed.connect(_on_job_selected.bind("tartak"))
	workshop_btn.pressed.connect(_on_job_selected.bind("warsztat"))
	forest_btn.pressed.connect(_on_job_selected.bind("las"))

func _on_job_selected(job_type: String):
	if npc_reference == null:
		queue_free()
		return

	# Losowanie liczby surowców od 4 do 6
	var random_amount = randi_range(4, 6)

	match job_type:
		"tartak":
			# 0 = Drewno (zgodnie z poprzednim skryptem)
			UiNotes.modify_resource(0, random_amount, "tartak")
		"warsztat":
			# 1 = Metal
			UiNotes.modify_resource(1, random_amount, "warsztat")
		"las":
			# 2 = Jedzenie (np. zbieractwo w lesie)
			UiNotes.modify_resource(2, random_amount, "las")

	# Każe NPC zniknąć ze świata
	npc_reference.disappear()

	# Zamyka i usuwa to menu wyboru
	queue_free()
