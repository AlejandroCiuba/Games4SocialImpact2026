extends Control

@export var credits: Control
@export var options: Control
@export var transition: Control
@export var transition_anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.play()
	show()
	transition.show()
	transition_anim.play_backwards("fadein")


func _on_start_shift_pressed() -> void:
	transition_anim.play("fadein")
	await transition_anim.animation_finished
	GameLoader.load_scene("res://scenes/game_stage.tscn")


func _on_options_pressed() -> void:
	hide()
	options.show()


func _on_credits_pressed() -> void:
	hide()
	credits.show()
