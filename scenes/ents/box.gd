extends RigidBody2D
class_name Box

signal delete_box(box: Box)

@export_category("Box Settings")
@export var value: int = 1

enum Status {
	NO_STATUS,
	PICKUP,
	DOLLY,
	DROPOFF
}

var curr_status: Status = Status.NO_STATUS


func _ready() -> void:

	var tween: Tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).from(0.0)


func _physics_process(_delta: float) -> void:
	if global_position.y >= 650.0:
		delete_box.emit(self)
		queue_free()
