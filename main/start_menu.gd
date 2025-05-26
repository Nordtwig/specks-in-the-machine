extends Control

@export var anim_player: AnimationPlayer

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	anim_player.play("fade_in")
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/level1.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
