class_name VirtualJoystick
extends Control

@export var pressed_color := Color.GRAY
@export_range(0, 300, 1) var deadzone_size: float = 20  # Ajusta la zona muerta
@export var clamp_factor: float = 0.4  # Aumentado el rango de movimiento

@export var action_left := "ui_left"
@export var action_right := "ui_right"

var is_pressed := false
var output := Vector2.ZERO
var _touch_index: int = -1

@onready var _base := $Base
@onready var _tip := $Base/Tip

@onready var _base_default_position: Vector2 = _base.global_position
@onready var _tip_default_position: Vector2 = _base.global_position + (_base.size / 2) # Mantener la posición correcta
@onready var _default_color: Color = _tip.modulate
@onready var clampzone_size: float = _base.size.x * clamp_factor  # Aumentado el rango permitido

func _ready():
	_reset()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_touch_near_joystick(event.position) and _touch_index == -1:
				_touch_index = event.index
				_tip.modulate = pressed_color
				_update_joystick(event.position)
				get_viewport().set_input_as_handled()
		elif event.index == _touch_index:
			_reset()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_update_joystick(event.position)
			get_viewport().set_input_as_handled()

func _is_touch_near_joystick(point: Vector2) -> bool:
	""" Ampliar el área de detección del joystick """
	var area_size = _base.size.x * 3.0  # Aumentar el área de detección
	var area = Rect2(_base.global_position - Vector2(area_size / 2, area_size / 2), Vector2(area_size, area_size))
	return area.has_point(point)

func _update_joystick(touch_position: Vector2):
	""" Mueve el tip y ajusta la salida del joystick """
	var center: Vector2 = _base_default_position + (_base.size / 2)
	var vector: Vector2 = touch_position - center
	vector.y = 0  # Bloquea el movimiento vertical
	vector = vector.limit_length(clampzone_size)  # Aumenta el rango permitido

	_tip.global_position = center + Vector2(vector.x, 0)  # Solo movimiento horizontal

	# Aplicar zona muerta para evitar movimientos indeseados
	if abs(vector.x) > deadzone_size:
		is_pressed = true
		output = Vector2((vector.x - sign(vector.x) * deadzone_size) / (clampzone_size - deadzone_size), 0)
	else:
		is_pressed = false
		output = Vector2.ZERO

	_handle_input_actions(output)

func _handle_input_actions(output: Vector2) -> void:
	""" Manejo optimizado de los inputs solo en el eje X """
	for action in [action_left, action_right]:
		Input.action_release(action)

	if output.x < 0:
		Input.action_press(action_left, -output.x)
	if output.x > 0:
		Input.action_press(action_right, output.x)

func _reset():
	""" Reinicia el joystick cuando el usuario suelta el dedo """
	is_pressed = false
	output = Vector2.ZERO
	_touch_index = -1
	_tip.modulate = _default_color
	_tip.global_position = _tip_default_position  # Mantiene la posición inicial

	for action in [action_left, action_right]:
		Input.action_release(action)
