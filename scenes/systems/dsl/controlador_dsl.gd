extends Node

@export var dron: Node

@onready var editor = $"../CanvasEditor/Editor"

var parser: DSLParser
var ejecutor: DSLEjecutor

func _ready() -> void:
	parser = DSLParser.new()
	ejecutor = DSLEjecutor.new()
	add_child(ejecutor)

	editor.peticion_ejecucion.connect(_on_peticion_ejecucion)


func _on_peticion_ejecucion(codigo: String) -> void:
	if not parser.parsear(codigo):
		for error in parser.errores:
			push_warning(error)

		return

	ejecutor.ejecutar(parser.instrucciones, dron)
