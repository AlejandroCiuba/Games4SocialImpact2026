extends Control

@export var credits: Control
@export var options: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()


func _on_start_shift_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	hide()
	options.show()


func _on_credits_pressed() -> void:
	hide()
	credits.show()
