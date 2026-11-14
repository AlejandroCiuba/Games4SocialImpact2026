extends Node2D
class_name DollyDropOff

signal drop_boxes(amount: int)

@export var box_drop_time: float = 2.0
@export var box_drop_amount: int = 1
@export var drop_off_area: Area2D

@onready var ddt: Timer = %DropOffDelayTimer


func _on_entered(_body: Node2D) -> void:
	print_debug("Dolly Entered Drop Off Area")
	ddt.start()


func _on_exited(_body: Node2D) -> void:
	print_debug("Dolly Exited Drop Off Area")
	ddt.stop()


func _on_timeout() -> void:
	print_debug("Box Amount Requested: ", box_drop_amount)
	drop_boxes.emit(box_drop_amount)


func _ready() -> void:

	if drop_off_area == null:
		return

	ddt.wait_time = box_drop_time
	ddt.timeout.connect(_on_timeout)

	drop_off_area.body_entered.connect(_on_entered)
	drop_off_area.body_exited.connect(_on_exited)
