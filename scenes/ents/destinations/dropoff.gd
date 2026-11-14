extends Destination
class_name DropOff

@export_category("Settings")
@export var max_boxes: int = 10
@export var delivery_time: float = 10.0

var box_count = 0
var out_for_delivery: bool = false
