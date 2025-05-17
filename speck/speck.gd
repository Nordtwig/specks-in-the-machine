extends RigidBody2D
class_name Speck

@export var move_speed: float = 150
@export var max_speed: float = 200

var target: Node2D = null


func _ready() -> void:
	$LifespanTimer.timeout.connect(_on_lifespawn_timer_timeout)
	
	# on spawn, pushed in random direction at half move_speed
	apply_impulse(Vector2(move_speed / 2,0).rotated(randf() * 2.0 * PI), global_position)
	
	if get_tree().get_first_node_in_group("targets"):
		await get_tree().create_timer(.2).timeout
		target = get_tree().get_first_node_in_group("targets")


func _physics_process(delta: float) -> void:
	# If there's a target node present, pushed towards it at move_speed
	if target:
		apply_central_force(global_position.direction_to(target.global_position) * move_speed)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# clamp velocity to max_speed
	linear_velocity = linear_velocity.limit_length(sqrt(max_speed * max_speed))
	

func _on_lifespawn_timer_timeout() -> void:
	queue_free()
