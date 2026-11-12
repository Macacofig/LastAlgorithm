extends Control

@onready var boton_abrir: Button = $BotonAbrir
@onready var boton_cerrar: Button = $PanelEditor/MarginContainer/VBoxContainer/HBoxContainer/BotonCerrar
@onready var panel_editor: PanelContainer = $PanelEditor


func _ready() -> void:
	panel_editor.hide()

	boton_abrir.pressed.connect(_abrir_editor)
	boton_cerrar.pressed.connect(_cerrar_editor)


func _abrir_editor() -> void:
	panel_editor.show()


func _cerrar_editor() -> void:
	panel_editor.hide()


func _input(event: InputEvent) -> void:
	if not panel_editor.visible:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var dentro_del_panel := panel_editor.get_global_rect().has_point(
				get_global_mouse_position()
			)

			if not dentro_del_panel:
				_cerrar_editor()
