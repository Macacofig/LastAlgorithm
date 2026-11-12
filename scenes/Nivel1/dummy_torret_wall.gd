extends CharacterBody2D

var vida : float = 100
func _ready() -> void:
	add_to_group("torretas")

func recibir_dano(cantidad: float) -> void:
	vida -= cantidad
	if vida > 0:
		print("Dummy recibió ", cantidad, " de daño")
		print("Vida actual", vida)
	else:
		remove_from_group("torretas")
		set_collision_layer_value(5, false)
		$CollisionShape2D.set_deferred("disabled", true)
