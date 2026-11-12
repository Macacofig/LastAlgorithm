class_name Drone
extends Area2D

@export var velocidad: float = 150.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_escaneo: AreaEscaner = $AreaEscaner

enum AccionesDron {
	PARAR,
	MOVER,
	ESCANEAR,
	EXPLORAR
}

var accion_actual: AccionesDron = AccionesDron.PARAR

var objetivo: Vector2
var en_movimiento: bool = false


func _ready() -> void:
	area_escaneo.escaneo_completado.connect(_on_escaneo_completado)

	print("[DRONE] Señal de escaneo conectada")


#func _on_escaneo_completado(coordenadas: Array[Vector2i]) -> void:
	#cambiar_accion(AccionesDron.PARAR)
#
	#print("Escaneo completado: ", coordenadas.size())
#
	#for celda in coordenadas:
		#print("Mineral en: ", celda)

func _on_escaneo_completado(coordenadas: Array[Vector2i]) -> void:
	print("[DRONE] Señal recibida")
	print("[DRONE] Minerales detectados: ", coordenadas.size())

	for celda in coordenadas:
		print("[DRONE] Coordenada: ", celda)

	cambiar_accion(AccionesDron.PARAR)


func cambiar_accion(nueva_accion: AccionesDron) -> void:
	if accion_actual == nueva_accion:
		return

	accion_actual = nueva_accion
	cambiar_animacion()


func escanear() -> void:
	en_movimiento = false
	cambiar_accion(AccionesDron.ESCANEAR)
	area_escaneo.iniciar_escaneo()


func explorar(lugar: Vector2) -> void:
	objetivo = lugar
	en_movimiento = true
	cambiar_accion(AccionesDron.EXPLORAR)


func mover(lugar: Vector2) -> void:
	objetivo = lugar
	en_movimiento = true
	cambiar_accion(AccionesDron.MOVER)


func parar() -> void:
	en_movimiento = false
	cambiar_accion(AccionesDron.PARAR)


func cambiar_animacion() -> void:
	match accion_actual:
		AccionesDron.PARAR:
			sprite.play("parar")

		AccionesDron.MOVER:
			sprite.play("mover")

		AccionesDron.ESCANEAR:
			sprite.play("escanear")

		AccionesDron.EXPLORAR:
			sprite.play("explorar")


func _physics_process(delta: float) -> void:
	if not en_movimiento:
		return

	var direccion := global_position.direction_to(objetivo)

	global_position += direccion * velocidad * delta

	if global_position.distance_to(objetivo) < 5.0:
		global_position = objetivo
		match accion_actual:
			AccionesDron.MOVER:
				parar()
			AccionesDron.EXPLORAR:
				escanear()
