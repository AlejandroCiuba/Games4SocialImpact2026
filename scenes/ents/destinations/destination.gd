extends Node2D
class_name Destination

signal destination_selected(stop_point: Node2D)

@export var stop_point: Node2D = null

@onready var mouse_area: Area2D = %MouseArea


func _on_mouse_area_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		print_debug("Destination selected: ", name)
		destination_selected.emit(stop_point)


func _ready() -> void:
	mouse_area.input_event.connect(_on_mouse_area_clicked)
