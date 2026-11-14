extends Node2D
class_name DollyPickUp

signal request_boxes(amount: int)

@export var request_box_delay: float = 2.0
@export var request_box_amount: int = 1
@export var pick_up_area: Area2D

@onready var rbdt: Timer = %RequestBoxDelayTimer


func _on_entered(_body: Node2D) -> void:
	print_debug("Dolly Entered Pick Up Area")
	rbdt.start()


func _on_exited(_body: Node2D) -> void:
	print_debug("Dolly Exited Pick Up Area")
	rbdt.stop()


func _on_timeout() -> void:
	print_debug("Box Amount Requested: ", request_box_amount)
	request_boxes.emit(request_box_amount)


func _ready() -> void:

	if pick_up_area == null:
		return

	rbdt.wait_time = request_box_delay
	rbdt.timeout.connect(_on_timeout)

	pick_up_area.body_entered.connect(_on_entered)
	pick_up_area.body_exited.connect(_on_exited)
