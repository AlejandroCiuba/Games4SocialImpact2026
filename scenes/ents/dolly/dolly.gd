extends CharacterBody2D
class_name Dolly

@export var dolly_movement: DollyMovement
@export var dolly_pick_up: DollyPickUp
@export var dolly_drop_off: DollyDropOff

var box_count: int = 0

func _on_dolly_box_area_body_entered(body: Node2D) -> void:
	if body is Box:
		box_count += 1
		body.curr_status = Box.Status.DOLLY


func _on_dolly_box_area_body_exited(body: Node2D) -> void:
	if body is Box:
		box_count -= 1
		body.curr_status = Box.Status.NO_STATUS
