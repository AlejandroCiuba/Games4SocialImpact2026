extends RigidBody2D
class_name Box

@export var box_data: BoxData

enum Status {
	PICKUP,
	DOLLY,
	DROPOFF
}

var curr_status: Status


func _physics_process(delta: float) -> void:
	if global_position.y >= 650.0:
		queue_free()
