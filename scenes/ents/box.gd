extends RigidBody2D
class_name Box

@export var box_data: BoxData

enum Status {
	PICKUP,
	DOLLY,
	DROPOFF
}

var curr_status: Status
