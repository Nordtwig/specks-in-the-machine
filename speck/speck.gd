extends RigidBody2D
class_name Speck

@export var move_speed: float = 150
@export var max_speed: float = 200
@export var distance_to_touch: float = 50.0

var target_beacon: Node2D = null
var touched_beacons: Array[Node] = []


func _ready() -> void:
	$LifespanTimer.timeout.connect(_on_lifespawn_timer_timeout)
	Events.beacon_placed.connect(_on_beacon_placed)
	
	# on spawn, pushed in random direction at half move_speed
	apply_impulse(Vector2(move_speed / 2,0).rotated(randf() * 2.0 * PI), global_position)
	
	await get_tree().create_timer(.2).timeout
	_locate_nearest_beacon()


func _physics_process(delta: float) -> void:
	# TODO This isn't working, find out why
	if !target_beacon:
		return
	
	print(global_position.distance_to(target_beacon.global_position))
	
	if global_position.distance_to(target_beacon.global_position) <= distance_to_touch:
		touched_beacons.append(target_beacon)
		target_beacon = null
		_locate_nearest_beacon()

	# If there's a target node present, pushed towards it at move_speed
	if target_beacon:
		apply_central_force(global_position.direction_to(target_beacon.global_position) * move_speed)
		
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# clamp velocity to max_speed
	linear_velocity = linear_velocity.limit_length(sqrt(max_speed * max_speed))


func _locate_nearest_beacon() -> void:
	var all_beacons = get_tree().get_nodes_in_group("beacons")
	for beacon in all_beacons:
		for touched_beacon in touched_beacons:
			if beacon == touched_beacon:
				all_beacons.erase(beacon)
	var nearest_beacon
	for beacon: Node2D in all_beacons:
		if !nearest_beacon:
			nearest_beacon = beacon
		if global_position.distance_to(beacon.global_position) < global_position.distance_to(nearest_beacon.global_position):
			nearest_beacon = beacon
		else: 
			continue
	if nearest_beacon:
		target_beacon = nearest_beacon


func score() -> void:
	print(name + " reached intake and scored!")
	queue_free()


func _on_lifespawn_timer_timeout() -> void:
	print(name + " reached end of life...")
	queue_free()


func _on_beacon_placed() -> void:
	_locate_nearest_beacon()
