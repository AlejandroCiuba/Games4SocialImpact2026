extends RigidBody2D
class_name Box

signal delete_box(box: Box)

@export_category("Box Settings")
@export var value: int = 1

enum Status {
	PICKUP,
	DOLLY,
	DROPOFF
}

var curr_status: Status


func _physics_process(_delta: float) -> void:

	if global_position.y >= 650.0:

		delete_box.emit(self)
		queue_free()
