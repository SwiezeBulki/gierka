extends Area2D
@onready var sprite: Sprite2D = $wyjscie_sprite
#@onready var camera: Camera2D = $"../Camera2D"# Dostosuj ścieżkę, jeśli kamera jest gdzie indziej.

func _ready():
	sprite.visible = false
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	sprite.visible = true

func _on_mouse_exited():
	sprite.visible = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file("res://src/dom_out.tscn")
