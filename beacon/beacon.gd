extends Node2D


func _ready() -> void:
	$OverlapArea.mouse_entered.connect(_on_mouse_entered)
	$OverlapArea.mouse_exited.connect(_on_mouse_exited)
	

func _on_mouse_entered() -> void:
	Events.mouse_over_beacon.emit()


func _on_mouse_exited() -> void:
	Events.mouse_left_beacon.emit()
