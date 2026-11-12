class_name AreaEscaner
extends Area2D

signal escaneo_completado(coordenadas: Array[Vector2i])

@export var duracion_escaneo: float = 1.0

var coordenadas_detectadas: Array[Vector2i] = []


func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)

	print("[ESCANER] Inicializado")


func iniciar_escaneo() -> void:
	if monitoring:
		print("[ESCANER] Ya está escaneando")
		return

	print("[ESCANER] Iniciando escaneo")

	coordenadas_detectadas.clear()
	monitoring = true

	await get_tree().create_timer(duracion_escaneo).timeout

	finalizar_escaneo()


func finalizar_escaneo() -> void:
	monitoring = false

	print("[ESCANER] Finalizando escaneo")
	print("[ESCANER] Celdas detectadas: ", coordenadas_detectadas)

	escaneo_completado.emit(coordenadas_detectadas.duplicate())


func _on_body_shape_entered(
	body_rid: RID,
	body: Node2D,
	_body_shape_index: int,
	_local_shape_index: int
) -> void:

	if not body is TileMapLayer:
		return

	if not body.is_in_group("mapas_minerales"):
		return

	var mapa := body as TileMapLayer
	var celda := mapa.get_coords_for_body_rid(body_rid)

	if not coordenadas_detectadas.has(celda):
		coordenadas_detectadas.append(celda)
		print("[ESCANER] Mineral detectado en: ", celda)
