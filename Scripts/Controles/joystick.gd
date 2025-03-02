class_name Virtualjoystick
extends Control

@export var pressed_color := Color.GRAY
@export_range(0, 200, 1) var deadzone_size : float = 10
@export_range(0, 500, 1) var clampzone_size : float = 75

@export var action_left := "ui_left"
@export var action_right := "ui_right"
@export var action_up := "ui_up"
@export var action_down := "ui_down"

var is_pressed := false
var output := Vector2.ZERO
var _touch_index : int = -1

@onready var _base := $Base
@onready var _tip := $Base/Tip

@onready var _base_default_position : Vector2 = _base.global_position
@onready var _tip_default_position : Vector2 = _tip.global_position
@onready var _default_color : Color = _tip.modulate

func _ready():
	# Asegurar que el joystick esté en la posición correcta al iniciar
	_reset()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_joystick_area(event.position) and _touch_index == -1:
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

func _move_base(new_position: Vector2) -> void:
	_base.global_position = new_position

func _move_tip(new_position: Vector2) -> void:
	_tip.global_position = new_position

func _is_point_inside_joystick_area(point: Vector2) -> bool:
	var area = Rect2(global_position, size)
	return area.has_point(point)

func _get_base_radius() -> Vector2:
	return _base.size * _base.get_global_transform_with_canvas().get_scale() / 2

func _update_joystick(touch_position: Vector2) -> void:
	var _base_radius = _get_base_radius()
	var center : Vector2 = _base.global_position + _base_radius
	var vector : Vector2 = touch_position - center
	vector = vector.limit_length(clampzone_size)

	_move_tip(center + vector)

	if vector.length_squared() > deadzone_size * deadzone_size:
		is_pressed = true
		output = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
	else:
		is_pressed = false
		output = Vector2.ZERO

	# Manejo de acciones más eficiente
	_handle_input_actions(output)

func _handle_input_actions(output: Vector2) -> void:
	# Soltar todas las acciones primero
	for action in [action_left, action_right, action_down, action_up]:
		Input.action_release(action)

	# Luego, presionar las necesarias
	if output.x < 0:
		Input.action_press(action_left, -output.x)
	if output.x > 0:
		Input.action_press(action_right, output.x)
	if output.y < 0:
		Input.action_press(action_up, -output.y)
	if output.y > 0:
		Input.action_press(action_down, output.y)

func _reset():
	is_pressed = false
	output = Vector2.ZERO
	_touch_index = -1
	_tip.modulate = _default_color
	_base.global_position = _base_default_position
	_tip.global_position = _tip_default_position

	# Liberar cualquier acción en caso de que el joystick se quedara "enganchado"
	for action in [action_left, action_right, action_down, action_up]:
		Input.action_release(action)
