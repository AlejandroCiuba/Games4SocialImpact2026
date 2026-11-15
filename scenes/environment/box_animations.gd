extends Node2D

@export var box_spawner: BoxSpawner
@onready var anim: AnimationPlayer = $AnimationPlayer


func _on_box_spawned(box: Box) -> void:
	anim.play("shake")

func _ready() -> void:
	box_spawner.box_spawned.connect(_on_box_spawned)
