extends Node2D

@onready var drone: Drone = $Marker2D/Drone

func _ready() -> void:
	test_drone()


func test_drone() -> void:
	drone.parar()
	await get_tree().create_timer(3.0).timeout
	
	await move_drone(Vector2(500, 250))
	await get_tree().create_timer(3.0).timeout

	drone.escanear()
	await get_tree().create_timer(3.0).timeout

	await scout(Vector2(-500, -250))
	await get_tree().create_timer(3.0).timeout

	await move_drone(Vector2(0, 0))


func move_drone(target: Vector2) -> void:
	var global_target = $Marker2D.to_global(target)
	drone.mover(global_target)

	while drone.en_movimiento:
		await get_tree().physics_frame
		
func scout(target: Vector2) -> void:
	var global_target = $Marker2D.to_global(target)
	drone.explorar(global_target)

	while drone.en_movimiento:
		await get_tree().physics_frame
