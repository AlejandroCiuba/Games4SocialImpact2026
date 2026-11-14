extends Destination
class_name DropOff

signal give_payment(value: int)

@export_category("Settings")
@export var max_boxes: int = 10
@export var delivery_time: float = 10.0

var box_count = 0
var out_for_delivery: bool = false


func return_for_delivery() -> void:
	out_for_delivery = false
	show()


func deliver_boxes(boxes: Array[Node]) -> void:

	hide()

	box_count = 0
	out_for_delivery = true

	var total_payment: int = 0
	for box in boxes:
		total_payment += box.value
		box.queue_free()

	print_debug("Payment Given: ", total_payment)
	give_payment.emit(total_payment)
