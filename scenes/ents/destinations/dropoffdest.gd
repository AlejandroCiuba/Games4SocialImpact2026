extends Destination
class_name DropOffDest

signal give_payment(value: int)
signal delivery
signal returned

@export_category("Settings")
@export var max_boxes: int = 10
@export var delivery_time: float = 4.0

var box_count = 0
var out_for_delivery: bool = false


func return_for_delivery() -> void:
	returned.emit()
	out_for_delivery = false


func deliver_boxes(boxes: Array[Node]) -> void:

	out_for_delivery = true
	delivery.emit()

	var total_payment: int = 0
	for box in boxes:
		total_payment += box.value
		box.queue_free()

	print_debug("Payment Given: ", total_payment)
	give_payment.emit(total_payment)
	box_count = 0
