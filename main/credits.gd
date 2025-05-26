extends Control

@onready var return_button: Button = %ReturnButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	return_button.pressed.connect(_on_return_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/start_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
