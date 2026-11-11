extends CharacterBody2D

func _ready() -> void:
	add_to_group("torretas")

func recibir_dano(cantidad: float) -> void:
	print("Dummy recibió ", cantidad, " de daño")
