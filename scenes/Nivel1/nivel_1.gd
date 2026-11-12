extends Node2D

#@export var vampiro_escena: PackedScene
@export var orco_escena: PackedScene
func _ready() -> void:
	#var vampiro: Enemigo = vampiro_escena.instantiate()
#
	#add_child(vampiro)
#
	#vampiro.global_position = Vector2(-200, -100)
#
	#vampiro.establecer_camino([
		#Vector2(200, -100),
		#Vector2(200, 0),
		#Vector2(-200, 0),
		#Vector2(-200, 100),
		#Vector2(200, 100),
	#])
	
	var orco: Enemigo = orco_escena.instantiate()
	add_child(orco)

	orco.global_position = Vector2(-200, -100)

	orco.establecer_camino([
		Vector2(200, -100),
		Vector2(200, 0),
		Vector2(-200, 0),
		Vector2(-200, 100),
		Vector2(200, 100),
	])
