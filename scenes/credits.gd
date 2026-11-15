extends Control

@export var title: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	
	


func _on_title_screen_pressed() -> void:
	hide()
	title.show()
