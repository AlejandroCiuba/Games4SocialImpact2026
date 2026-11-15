extends Node

@export var song: AudioStreamWAV

@onready var music: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.stream = song
	music.play()
