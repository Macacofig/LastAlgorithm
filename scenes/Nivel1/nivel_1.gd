extends Node2D

@export var vampiro_escena: PackedScene

func _ready() -> void:
	var vampiro: Enemigo = vampiro_escena.instantiate()

	add_child(vampiro)

	vampiro.global_position = Vector2(1100, 300)

	vampiro.establecer_camino([
		Vector2(900, 300),
		Vector2(900, 600),
		Vector2(600, 600),
		Vector2(600, 100),
		Vector2(200, 100),
		Vector2(200, 300),
		Vector2(100, 300),
	])
