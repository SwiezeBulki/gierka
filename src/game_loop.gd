extends CanvasLayer
#game_loop
var max_days = 3
var current_day = 0
@onready var end_day_button = $Button
@onready var day_label = $Day

func _ready() -> void:
	NpcManager.update_time(current_day)

func _on_button_pressed() -> void:
	if current_day < max_days:
		current_day += 1
		print("Rozpoczynamy dzień: ", current_day)
		
		NpcManager.update_time(current_day)
		day_label.text = "DAY: " + str(current_day)
	else:
		print("To już koniec gry!")
