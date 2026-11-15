extends Node2D
class_name BoxSpawner

signal box_spawned(box: Box)


@export_category("Boxes")
@export var boxes: Node2D
@export var box_spawn_point: Node2D
@export var box_scene: PackedScene

@export_category("Spawn_Information")
@export var box_spawn_time: float = 5.0

@onready var box_timer: Timer = %BoxTimer


func start_spawning() -> void:
	box_timer.start()


func stop_spawning() -> void:
	box_timer.stop()


func _spawn_box() -> void:

	var b: Box = box_scene.instantiate() as Box
	boxes.add_child(b)
	

	if box_spawn_point != null:
		b.global_position = box_spawn_point.global_position
	else:
		print_debug("No box spawn point")
		b.global_position.y = global_position.y + 500.0

	box_spawned.emit(b)


func _on_box_timer_timeout() -> void:
	_spawn_box()


func _ready() -> void:
	box_timer.wait_time = box_spawn_time
	box_timer.timeout.connect(_on_box_timer_timeout)
