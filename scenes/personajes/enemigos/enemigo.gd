class_name Enemigo
extends CharacterBody2D

signal danado(cantidad: float, vida_restante: float)
signal muerto
signal jugador_alcanzado(jugador: Node2D)

const DISTANCIA_LLEGADA: float = 4.0
const SUFIJOS: Dictionary = {
	Orientacion.NORTE: "N",
	Orientacion.SUR: "S",
	Orientacion.ESTE: "E",
	Orientacion.OESTE: "O",
}

enum Comportamiento {
	NORMAL,
	ASEDIO,
}

enum EstadoEnemigo {
	MOVIENDOSE,
	ATACANDO,
	MUERTO,
}

enum Orientacion {
	NORTE,
	SUR,
	ESTE,
	OESTE,
}

@export_group("Atributos")
@export var velocidad_base: float = 100.0
@export var vida_base: float = 100.0
@export var comportamiento: Comportamiento = Comportamiento.NORMAL
@export_group("Animaciones")
@export var animaciones: SpriteFrames
@export var prefijo_movimiento: String
@export var prefijo_muerte: String
@export var prefijo_ataque: String
@export_group("Combate")
@export var dano: float = 10.0
@export var alcance_ataque: float = 32.0
@export var intervalo_ataque: float = 1.0

var objetivo: Node2D = null
var estado_actual: EstadoEnemigo = EstadoEnemigo.MOVIENDOSE
var vida_actual: float
var velocidad_actual: float
var orientacion_actual: Orientacion = Orientacion.SUR
var reproduciendo_ataque: bool = false
var tiempo_ataque_restante: float = 0.0
var animaciones_movimiento: Dictionary = {}
var animaciones_ataque: Dictionary = {}
var animaciones_muerte: Dictionary = {}

var _camino: Array[Vector2] = []
var _punto_actual: int = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var barra_vida: ProgressBar = $BarraVida
@onready var area_dano: Area2D = $AreaDano
@onready var area_deteccion: Area2D = $AreaDeteccion


func _ready() -> void:
	if animaciones != null:
		sprite.sprite_frames = animaciones
		
	var forma := CircleShape2D.new()
	forma.radius = alcance_ataque
	$AreaDeteccion/CollisionShape2D.shape = forma

	animaciones_movimiento = _construir_animaciones(prefijo_movimiento)
	animaciones_ataque = _construir_animaciones(prefijo_ataque)
	animaciones_muerte = _construir_animaciones(prefijo_muerte)

	vida_actual = vida_base
	velocidad_actual = velocidad_base

	barra_vida.max_value = vida_base
	barra_vida.value = vida_actual
	barra_vida.hide()

	area_dano.area_entered.connect(_al_area_dano_area_entered)
	area_dano.body_entered.connect(_al_area_dano_body_entered)
	sprite.animation_finished.connect(_al_animacion_finalizada)


func _construir_animaciones(prefijo: String) -> Dictionary:
	var resultado: Dictionary = {}

	for orientacion in SUFIJOS:
		var nombre := StringName("%s_%s" % [prefijo, SUFIJOS[orientacion]])

		if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(nombre):
			resultado[orientacion] = nombre

	return resultado


func _physics_process(delta: float) -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		return

	if reproduciendo_ataque:
		velocity = Vector2.ZERO
		return

	if tiempo_ataque_restante > 0.0:
		tiempo_ataque_restante = maxf(tiempo_ataque_restante - delta, 0.0)

	if comportamiento == Comportamiento.ASEDIO:
		if not is_instance_valid(objetivo):
			objetivo = _obtener_objetivo_cercano()

		if is_instance_valid(objetivo):
			velocity = Vector2.ZERO
			if tiempo_ataque_restante <= 0.0:
				_atacar_objetivo()

			return

	else:
		objetivo = _obtener_objetivo_cercano()
		if is_instance_valid(objetivo) and tiempo_ataque_restante <= 0.0:
			_atacar_objetivo()
			return

	_mover_por_camino()


func actualizar_orientacion(direccion: Vector2) -> void:
	if absf(direccion.x) > absf(direccion.y):
		orientacion_actual = Orientacion.ESTE if direccion.x > 0.0 else Orientacion.OESTE
	else:
		orientacion_actual = Orientacion.SUR if direccion.y > 0.0 else Orientacion.NORTE


## Reproduce la animación de la orientación actual del diccionario dado.
## Con reiniciar = false no reinicia la animación si ya se está reproduciendo
## (útil para movimiento, que se llama en cada frame de física).
func _reproducir(nombres: Dictionary, reiniciar: bool = false) -> void:
	if not nombres.has(orientacion_actual):
		return

	var nombre: StringName = nombres[orientacion_actual]

	if reiniciar or sprite.animation != nombre or not sprite.is_playing():
		sprite.play(nombre)


func _obtener_objetivo_cercano() -> Node2D:
	var objetivo_cercano: Node2D = null
	var distancia_minima := INF

	for body in area_deteccion.get_overlapping_bodies():
		if not body.is_in_group("jugador") and not body.is_in_group("torretas"):
			continue

		var distancia := global_position.distance_to(body.global_position)

		if distancia <= alcance_ataque and distancia < distancia_minima:
			objetivo_cercano = body
			distancia_minima = distancia

	return objetivo_cercano


func _atacar_objetivo() -> void:
	if not is_instance_valid(objetivo) or not objetivo.has_method("recibir_dano"):
		return

	velocity = Vector2.ZERO

	actualizar_orientacion(global_position.direction_to(objetivo.global_position))

	reproduciendo_ataque = true
	tiempo_ataque_restante = intervalo_ataque

	_reproducir(animaciones_ataque, true)

	objetivo.recibir_dano(dano)


func establecer_camino(nuevo_camino: Array[Vector2]) -> void:
	_camino = nuevo_camino.duplicate()
	_punto_actual = 0


func _mover_por_camino() -> void:
	if _camino.is_empty():
		velocity = Vector2.ZERO
		return

	if _punto_actual >= _camino.size():
		_alcanzar_jugador()
		return

	var destino: Vector2 = _camino[_punto_actual]

	if global_position.distance_to(destino) <= DISTANCIA_LLEGADA:
		global_position = destino
		_punto_actual += 1

		if _punto_actual >= _camino.size():
			_alcanzar_jugador()

		return

	var direccion: Vector2 = global_position.direction_to(destino)
	velocity = direccion * velocidad_actual

	actualizar_orientacion(direccion)

	if not reproduciendo_ataque:
		_reproducir(animaciones_movimiento)

	move_and_slide()


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
	area_deteccion.set_deferred("monitoring", false)

	muerto.emit()

	if is_instance_valid(objetivo):
		actualizar_orientacion(global_position.direction_to(objetivo.global_position))

	if animaciones_muerte.has(orientacion_actual):
		_reproducir(animaciones_muerte, true)
	else:
		queue_free()


func _alcanzar_jugador() -> void:
	velocity = Vector2.ZERO

	set_physics_process(false)
	area_dano.set_deferred("monitoring", false)

	jugador_alcanzado.emit(objetivo)

	queue_free()


func _al_area_dano_area_entered(area: Area2D) -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		return

	if area.is_in_group("proyectiles") and area.has_method("obtener_dano"):
		recibir_dano(area.obtener_dano())


func _al_area_dano_body_entered(body: Node2D) -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		return

	if body.is_in_group("jugador"):
		jugador_alcanzado.emit(body)


func _al_animacion_finalizada() -> void:
	if estado_actual == EstadoEnemigo.MUERTO:
		queue_free()
		return

	if reproduciendo_ataque:
		reproduciendo_ataque = false

		if comportamiento == Comportamiento.NORMAL:
			_reproducir(animaciones_movimiento, true)
