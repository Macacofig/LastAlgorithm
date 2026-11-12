extends Node2D

@onready var dron: Drone = $Camera2D/Marker2D/Drone
@onready var mapa_minerales: TileMapLayer = $Minerales


func _ready() -> void:
	print("[NIVEL] Dron: ", dron)
	print("[NIVEL] Mapa: ", mapa_minerales)

	dron.area_escaneo.mapa_minerales = mapa_minerales

	print("[NIVEL] Referencia asignada: ", dron.area_escaneo.mapa_minerales)
