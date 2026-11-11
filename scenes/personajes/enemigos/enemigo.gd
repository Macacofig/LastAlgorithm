class_name Enemigo
extends CharacterBody2D

signal danado(cantidad: float, vida_restante: float)
signal muerto
signal jugador_alcanzado(jugador: Node2D)

enum EstadoEnemigo {
	MOVIENDOSE,
	MUERTO,
}

const DISTANCIA_LLEGADA: float = 4.0

@export_group("Atributos")
@export var velocidad_base: float = 120.0
@export var vida_base: float = 100.0
@export_group("Animaciones")
@export var animaciones: SpriteFrames
@export var prefijo_animacion_movimiento: String
@export var animacion_muerte: StringName = &"muer"

var estado_actual: EstadoEnemigo = EstadoEnemigo.MOVIENDOSE
var velocidad_actual: float
var vida_actual: float
var _camino: Array[Vector2] = []
var _punto_actual: int = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var barra_vida: ProgressBar = $BarraVida
@onready var area_dano: Area2D = $AreaDano

func _ready() -> void:
	vida_actual = vida_base
	velocidad_actual = velocidad_base

	if animaciones != null:
		sprite.sprite_frames = animaciones

	barra_vida.max_value = vida_base
	barra_vida.value = vida_actual
	barra_vida.hide()

	area_dano.area_entered.connect(_al_area_dano_area_entered)
	area_dano.body_entered.connect(_al_area_dano_body_entered)
	sprite.animation_finished.connect(_al_animacion_finalizada)


func _physics_process(delta: float) -> void:
	if estado_actual != EstadoEnemigo.MOVIENDOSE:
		return

	_mover_por_camino(delta)


func establecer_camino(nuevo_camino: Array[Vector2]) -> void:
	_camino = nuevo_camino.duplicate()
	_punto_actual = 0


func _mover_por_camino(delta: float) -> void:
	if _camino.is_empty():
		velocity = Vector2.ZERO
		return

	if _punto_actual >= _camino.size():
		_alcanzar_jugador()
		return

	var destino: Vector2 = _camino[_punto_actual]
	var direccion: Vector2 = global_position.direction_to(destino)

	if global_position.distance_to(destino) <= DISTANCIA_LLEGADA:
		global_position = destino
		_punto_actual += 1

		if _punto_actual >= _camino.size():
			_alcanzar_jugador()

		return

	velocity = direccion * velocidad_actual

	actualizar_animacion(direccion)
	move_and_slide()


func actualizar_animacion(direccion: Vector2) -> void:
	var orientacion: String

	if absf(direccion.x) > absf(direccion.y):
		orientacion = "E" if direccion.x > 0 else "O"
	else:
		orientacion = "S" if direccion.y > 0 else "N"

	var nombre_animacion: StringName = StringName(
		prefijo_animacion_movimiento + "_" + orientacion
	)

	if sprite.sprite_frames.has_animation(nombre_animacion):
		if sprite.animation != nombre_animacion:
			sprite.play(nombre_animacion)


func recibir_dano(cantidad: float) -> void:
	if estado_actual == EstadoEnemigo.MUERTO or cantidad <= 0.0:
		return

	vida_actual = maxf(vida_actual - cantidad, 0.0)

	barra_vida.value = vida_actual
	barra_vida.show()

	danado.emit(cantidad, vida_actual)

	if vida_actual <= 0.0:
		_morir()


func _morir() -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		return

	estado_actual = EstadoEnemigo.MUERTO
	velocity = Vector2.ZERO

	set_physics_process(false)

	$CollisionShape2D.set_deferred("disabled", true)
	area_dano.set_deferred("monitoring", false)

	muerto.emit()

	if sprite.sprite_frames.has_animation(animacion_muerte):
		sprite.play(animacion_muerte)
	else:
		queue_free()


func _alcanzar_jugador() -> void:
	velocity = Vector2.ZERO

	set_physics_process(false)
	area_dano.set_deferred("monitoring", false)

	jugador_alcanzado.emit()

	queue_free()


func _al_area_dano_area_entered(area: Area2D) -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		return

	if area.is_in_group("proyectiles"):
		if area.has_method("obtener_dano"):
			recibir_dano(area.obtener_dano())


func _al_area_dano_body_entered(body: Node2D) -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		return

	if body.is_in_group("jugador"):
		jugador_alcanzado.emit(body)


func _al_animacion_finalizada() -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		queue_free()
