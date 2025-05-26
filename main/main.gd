extends Node2D

@export_group("Level")
@export_range(0, 999) var max_devices: int = 3
@export_range(0, 99999) var max_score: int = 10
@export var next_level: PackedScene

@export_category("Utils")
@export var beacon_scene: PackedScene
@export var beacon_parent: Node
@export var anim_player: AnimationPlayer

var mouse_is_over_beacon: bool = false


func _ready() -> void:
	Events.mouse_over_beacon.connect(_on_mouse_over_beacon)
	Events.mouse_left_beacon.connect(_on_mouse_left_beacon)
	Events.max_score_reached.connect(_on_max_score_reached)
	anim_player.play("fade_in")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		if _count_number_of_devices() < max_devices and not mouse_is_over_beacon:
			_place_beacon()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://main/start_menu.tscn")
	if Input.is_action_just_pressed("restart_level"):
		AudioManager.get_node("RestartSound").play()
		anim_player.play("fade_out")
		await anim_player.animation_finished
		get_tree().reload_current_scene()


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
	

func _on_max_score_reached() -> void:
	AudioManager.get_node("WinSound").play()
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_packed(next_level)
