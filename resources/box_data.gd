extends Resource
class_name BoxData

@export var value: int = 0
@export var width: float = 1.0
@export var height: float = 1.0


func _init(box_value: int, box_width: float, box_height: float) -> void:
	value = box_value
	width = box_width
	height = box_height
