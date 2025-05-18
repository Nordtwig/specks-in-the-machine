extends Node2D

@export var beacon_scene: PackedScene
@export var beacon_parent: Node
@export var max_devices: int = 3


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart_level"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("left_click"):
		if _count_number_of_devices() < max_devices:
			_place_beacon()


func _place_beacon() -> void:
	var new_beacon = beacon_scene.instantiate()
	beacon_parent.add_child(new_beacon)
	new_beacon.global_position = get_global_mouse_position()
	Events.beacon_placed.emit()


func _count_number_of_devices() -> int:
	return beacon_parent.get_child_count()
