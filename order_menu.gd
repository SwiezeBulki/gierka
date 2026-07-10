extends CanvasLayer
#Zmienna, która zapamięta, który NPC dostał rozkaz
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

	# Losujemy bazową liczbę surowców (np. od 3 do 5)
	var base_amount = randi_range(3, 5)
	var final_amount = base_amount

	match job_type:
		"tartak":
			# Wpływa SIŁA (strength)
			var bonus = npc_reference.strength if "strength" in npc_reference else 0
			final_amount += bonus
			
			# 0 = Drewno
			UiNotes.modify_resource(0, final_amount, "tartak")
			print("Tartak: Bazowo ", base_amount, " + Sila ", bonus, " = ", final_amount)

		"warsztat":
			# Wpływa ZRĘCZNOŚĆ (dexterity)
			var bonus = npc_reference.dexterity if "dexterity" in npc_reference else 0
			final_amount += bonus
			
			# 1 = Metal
			UiNotes.modify_resource(1, final_amount, "warsztat")
			print("Warsztat: Bazowo ", base_amount, " + Zrecznosc ", bonus, " = ", final_amount)

		"las":
			# Wpływa WYTRZYMAŁOŚĆ (endurance)
			var bonus = npc_reference.endurance if "endurance" in npc_reference else 0
			final_amount += bonus
			
			# 2 = Jedzenie
			UiNotes.modify_resource(2, final_amount, "las")
			print("Las: Bazowo ", base_amount, " + Wytrzymalosc ", bonus, " = ", final_amount)

	# Każe NPC zniknąć ze świata
	npc_reference.disappear()

	# Zamyka i usuwa to menu wyboru
	queue_free()
