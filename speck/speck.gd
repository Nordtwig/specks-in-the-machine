extends RigidBody2D
class_name Speck

@export var move_speed: float = 150
@export var max_speed: float = 200
@export var distance_to_touch: float = 100.0

var target_beacon: Node2D = null
var touched_beacons: Array[int] = []
var pulled_by_intake: bool = false


func _ready() -> void:
	$LifespanTimer.timeout.connect(_on_lifespawn_timer_timeout)
	Events.beacon_placed.connect(_on_beacon_placed)
	
	# on spawn, pushed in random direction at half move_speed
	apply_impulse(Vector2(move_speed / 2,0).rotated(randf() * 2.0 * PI), global_position)
	
	await get_tree().create_timer(.2).timeout
	_locate_nearest_beacon()


func _physics_process(delta: float) -> void:
	if !target_beacon:
		return
	
	if global_position.distance_to(target_beacon.global_position) <= distance_to_touch:
		if not pulled_by_intake:
			if not touched_beacons.has(target_beacon.get_instance_id()):
				touched_beacons.append(target_beacon.get_instance_id())
			_locate_nearest_beacon()

	# If there's a target node present, pushed towards it at move_speed
	if target_beacon:
		if pulled_by_intake:
			move_speed *= 1.2
		apply_central_force(global_position.direction_to(target_beacon.global_position) * move_speed)
	
	
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# clamp velocity to max_speed
	linear_velocity = linear_velocity.limit_length(sqrt(max_speed * max_speed))


func _locate_nearest_beacon() -> void:
	target_beacon = null
	var all_beacons: Array[Node] = get_tree().get_nodes_in_group("beacons")
	var compatible_beacons: Array[Node] = []
	for beacon: Node2D in all_beacons:
		if not touched_beacons.has(beacon.get_instance_id()):
				compatible_beacons.append(beacon)
	var nearest_beacon = null
	for beacon: Node2D in compatible_beacons:
		if !nearest_beacon:
			nearest_beacon = beacon
		if global_position.distance_to(beacon.global_position) < global_position.distance_to(nearest_beacon.global_position):
			nearest_beacon = beacon
		else: 
			continue
	if  nearest_beacon:
		target_beacon = nearest_beacon
	else:
		target_beacon = null


func score() -> void:
	$AudioStreamPlayer2D.play()
	visible = false
	await $AudioStreamPlayer2D.finished
	queue_free()


func in_sphere_of_influence(node: Node2D) -> void:
	target_beacon = node
	pulled_by_intake = true


func _on_lifespawn_timer_timeout() -> void:
	queue_free()


func _on_beacon_placed() -> void:
	_locate_nearest_beacon()
