
class_name AreaEscaner
extends Area2D

signal escaneo_completado(coordenadas: Array[Vector2i])

@export var mapa_minerales: TileMapLayer
@export var duracion_escaneo: float = 1.0

var coordenadas_detectadas: Array[Vector2i] = []


func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)

	print("[ESCANER] Inicializado")
	print("[ESCANER] Mapa asignado: ", mapa_minerales)


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

	print("[ESCANER] Colisión detectada: ", body.name)

	if body != mapa_minerales:
		print("[ESCANER] El cuerpo no es el mapa de minerales")
		return

	var celda := mapa_minerales.get_coords_for_body_rid(body_rid)

	print("[ESCANER] Celda detectada: ", celda)

	if not coordenadas_detectadas.has(celda):
		coordenadas_detectadas.append(celda)
