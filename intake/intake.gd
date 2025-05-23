extends Area2D
class_name Intake


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$SphereOfInfluence.body_entered.connect(_on_sphere_of_influence_entered)
	$SphereOfInfluence.mouse_entered.connect(_on_mouse_entered)
	$SphereOfInfluence.mouse_exited.connect(_on_mouse_exited)
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("specks"):
		body.score()


func _on_sphere_of_influence_entered(body: Node2D) -> void:
	if body.is_in_group("specks"):
		body.in_sphere_of_influence(self)


func _on_mouse_entered() -> void:
	Events.mouse_over_beacon.emit()


func _on_mouse_exited() -> void:
	Events.mouse_left_beacon.emit()
