extends Area2D
class_name Intake

@export var intake_progress: TextureProgressBar
@export var score_to_win: int = 20

var score: int = 0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$SphereOfInfluence.body_entered.connect(_on_sphere_of_influence_entered)
	$SphereOfInfluence.mouse_entered.connect(_on_mouse_entered)
	$SphereOfInfluence.mouse_exited.connect(_on_mouse_exited)
	
	intake_progress.max_value = score_to_win
	intake_progress.value = score
	

func add_score() -> void:
	score += 1
	if score >= score_to_win:
		win()
	intake_progress.value = score


func win() -> void:
	Events.max_score_reached.emit()
	$IntakeSprite.visible = false
	$IntakeWonSprite.visible = true

	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("specks"):
		if score < score_to_win:
			add_score()
		body.score()


func _on_sphere_of_influence_entered(body: Node2D) -> void:
	if body.is_in_group("specks"):
		body.in_sphere_of_influence(self)


func _on_mouse_entered() -> void:
	Events.mouse_over_beacon.emit()


func _on_mouse_exited() -> void:
	Events.mouse_left_beacon.emit()
