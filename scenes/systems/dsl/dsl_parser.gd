class_name DSLParser
extends RefCounted

# Instrucciones permitidas y cantidad de parámetros.
const INSTRUCCIONES := {
	"PARAR": 0,
	"ESCANEAR": 0,
	"MOVER": 2,
	"EXPLORAR": 2
}

var instrucciones: Array[DSLInstruction] = []
var errores: Array[String] = []

func parsear(codigo: String) -> bool:
	instrucciones.clear()
	errores.clear()

	var lineas := codigo.split("\n")

	for i in range(lineas.size()):
		var linea := lineas[i].strip_edges()

		# Ignorar líneas vacías y comentarios.
		if linea.is_empty() or linea.begins_with("#"):
			continue

		var instruccion := _parsear_linea(linea, i + 1)

		if instruccion != null:
			instrucciones.append(instruccion)

	return errores.is_empty()


func _parsear_linea(
	linea: String,
	numero_linea: int
) -> DSLInstruction:

	var nombre := ""
	var parametros: Array = []

	# Identificar instrucciones con parámetros.
	if linea.contains("("):
		var apertura := linea.find("(")
		var cierre := linea.rfind(")")

		if cierre == -1 or cierre < apertura:
			_agregar_error(numero_linea, "Paréntesis sin cerrar.")
			return null

		if cierre != linea.length() - 1:
			_agregar_error(numero_linea, "Contenido inesperado después de ')'.")
			return null

		nombre = linea.substr(0, apertura).strip_edges()

		var contenido := linea.substr(
			apertura + 1,
			cierre - apertura - 1
		)

		if not contenido.strip_edges().is_empty():
			parametros = _parsear_parametros(contenido)

			if parametros.is_empty():
				_agregar_error(numero_linea, "Parámetros inválidos.")
				return null

	else:
		nombre = linea

	nombre = nombre.to_upper()

	# Validar existencia de la instrucción.
	if not INSTRUCCIONES.has(nombre):
		_agregar_error(
			numero_linea,
			"Instrucción desconocida: " + nombre
		)
		return null

	# Validar cantidad de parámetros.
	var cantidad_esperada: int = INSTRUCCIONES[nombre]

	if parametros.size() != cantidad_esperada:
		_agregar_error(
			numero_linea,
			"%s requiere %d parámetros." % [
				nombre,
				cantidad_esperada
			]
		)
		return null

	# Validar que todos los parámetros sean numéricos.
	for parametro in parametros:
		if typeof(parametro) != TYPE_FLOAT \
		and typeof(parametro) != TYPE_INT:
			_agregar_error(
				numero_linea,
				"Los parámetros de %s deben ser numéricos." % nombre
			)
			return null

	return DSLInstruction.new(nombre, parametros)


func _parsear_parametros(contenido: String) -> Array:
	var resultado: Array = []

	var valores := contenido.split(",")

	for valor in valores:
		valor = valor.strip_edges()

		if not valor.is_valid_float():
			return []

		resultado.append(float(valor))

	return resultado


func _agregar_error(numero_linea: int, mensaje: String) -> void:
	errores.append("Línea %d: %s" % [numero_linea, mensaje])
