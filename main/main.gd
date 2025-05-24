extends Node2D

@export var beacon_scene: PackedScene
@export var beacon_parent: Node
@export var max_devices: int = 3

var mouse_is_over_beacon: bool = false


func _ready() -> void:
	Events.mouse_over_beacon.connect(_on_mouse_over_beacon)
	Events.mouse_left_beacon.connect(_on_mouse_left_beacon)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		if _count_number_of_devices() < max_devices and not mouse_is_over_beacon:
			_place_beacon()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart_level"):
		get_tree().reload_current_scene()
		$Utils/RestartSound.play()


func _place_beacon() -> void:
	var new_beacon = beacon_scene.instantiate()
	beacon_parent.add_child(new_beacon)
	new_beacon.global_position = get_global_mouse_position()
	
	Events.beacon_placed.emit()


func _count_number_of_devices() -> int:
	return beacon_parent.get_child_count()


func _on_mouse_over_beacon() -> void:
	mouse_is_over_beacon = true
	
	
func _on_mouse_left_beacon() -> void:
	mouse_is_over_beacon = false
	
