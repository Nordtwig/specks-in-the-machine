extends Node2D
class_name Spawner

@export var speck: PackedScene
@export var time_between_spawns: float = 0.5

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = time_between_spawns
	spawn_timer.start()
	

func spawn_speck() -> void:
	var new_speck = speck.instantiate()
	add_child(new_speck)
	new_speck.global_position = global_position


func _on_spawn_timer_timeout() -> void:
	spawn_speck()
	
