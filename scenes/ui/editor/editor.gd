extends Control

signal peticion_ejecucion(code: String)

@onready var boton_abrir: Button = $BotonAbrir
@onready var boton_cerrar: Button = $PanelEditor/MarginContainer/VBoxContainer/HBoxContainer/BotonCerrar
@onready var boton_ejecutar: Button = $PanelEditor/MarginContainer/VBoxContainer/HBoxContainer/BotonEjecutar
@onready var seccion_codigo: TextEdit = $PanelEditor/MarginContainer/VBoxContainer/InputCodigo
@onready var panel_editor: PanelContainer = $PanelEditor


func _ready() -> void:
	panel_editor.hide()

	boton_abrir.pressed.connect(_abrir_editor)
	boton_cerrar.pressed.connect(_cerrar_editor)
	boton_ejecutar.pressed.connect(_ejecutar_codigo)

func _abrir_editor() -> void:
	panel_editor.show()
	seccion_codigo.grab_focus()


func _cerrar_editor() -> void:
	panel_editor.hide()


func _ejecutar_codigo() -> void:
	peticion_ejecucion.emit(seccion_codigo.text)


func _input(event: InputEvent) -> void:
	if not panel_editor.visible:
		return
		
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE and panel_editor.visible:
				_cerrar_editor()
				get_viewport().set_input_as_handled()
				
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var dentro_del_panel := panel_editor.get_global_rect().has_point(
				get_global_mouse_position()
			)

			if not dentro_del_panel:
				_cerrar_editor()
