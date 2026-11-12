class_name DSLInstruction
extends RefCounted

var nombre: String
var parametros: Array

func _init(p_nombre: String, p_parametros: Array = []) -> void:
	nombre = p_nombre
	parametros = p_parametros
