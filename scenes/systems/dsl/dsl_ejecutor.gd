class_name DSLEjecutor
extends Node

var dron: Node
var instrucciones: Array[DSLInstruction] = []
var indice_actual: int = 0
var ejecutando: bool = false

func ejecutar(
	nuevas_instrucciones: Array[DSLInstruction],
	objetivo: Node
) -> void:

	if ejecutando:
		push_warning("Ya existe una ejecución en curso.")
		return

	instrucciones = nuevas_instrucciones
	dron = objetivo
	indice_actual = 0
	ejecutando = true

	_ejecutar_siguiente()


func _ejecutar_siguiente() -> void:
	if indice_actual >= instrucciones.size():
		_finalizar()
		return

	var instruccion := instrucciones[indice_actual]

	match instruccion.nombre:
		"PARAR":
			_ejecutar_parar()

		"ESCANEAR":
			_ejecutar_escanear()

		"MOVER":
			_ejecutar_mover(instruccion.parametros)

		"EXPLORAR":
			_ejecutar_explorar(instruccion.parametros)

		_:
			push_error(
				"Instrucción no implementada: " + instruccion.nombre
			)
			_finalizar()


func _ejecutar_parar() -> void:
	dron.parar()
	_avanzar()


func _ejecutar_escanear() -> void:
	dron.escanear()
	_avanzar()


func _ejecutar_mover(parametros: Array) -> void:
	var direccion := Vector2(
		parametros[0],
		parametros[1]
	)

	dron.mover(direccion)
	_avanzar()


func _ejecutar_explorar(parametros: Array) -> void:
	var direccion := Vector2(
		parametros[0],
		parametros[1]
	)

	dron.explorar(direccion)
	_avanzar()


func _avanzar() -> void:
	indice_actual += 1
	_ejecutar_siguiente()


func _finalizar() -> void:
	ejecutando = false
	instrucciones.clear()
	indice_actual = 0
	dron = null
	print("Ejecución del DSL finalizada.")
