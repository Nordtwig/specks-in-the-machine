extends Node2D

@export var target: Node2D


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		target.global_position = get_global_mouse_position()
