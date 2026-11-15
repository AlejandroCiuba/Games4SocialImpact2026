extends Control

@export var title: Control

var sound_muted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _on_title_screen_pressed() -> void:
	hide()
	title.show()


func _on_mute_pressed() -> void:
	sound_muted = not sound_muted
	var ind: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(ind, sound_muted)
