extends Node2D
class_name BoxSpawner

signal box_spawned(box: Box)


@export_category("Boxes")
@export var boxes: Node2D
@export var box_spawn_point: Node2D
@export var box_scene: PackedScene

@export_category("Spawn_Information")
@export var box_spawn_time: float = 5.0
@export var max_boxes: int = 10

@onready var box_timer: Timer = %BoxTimer


func _spawn_box() -> void:

	var b: Box = box_scene.instantiate() as Box
	boxes.add_child(b)

	b.delete_box.connect(_on_box_deleted)

	if box_spawn_point != null:
		b.global_position = box_spawn_point.global_position
	else:
		print_debug("No box spawn point")
		b.global_position.y = global_position.y + 500.0

	await b.body_entered
	b.curr_status = Box.Status.PICKUP

	box_spawned.emit(b)


func _on_box_deleted(box: Box) -> void:
	pass
	#match box.curr_status:
		#Box.Status.PICKUP:
			#pickup.box_count -= 1
		#Box.Status.DROPOFF:
			#dropoff.box_count -= 1


func _on_box_timer_timeout() -> void:
	_spawn_box()


func _ready() -> void:
	box_timer.wait_time = box_spawn_time
	box_timer.timeout.connect(_on_box_timer_timeout)
