extends Node2D


@export_category("Main Actors")
@export var dolly: Dolly
@export var pickup: PickUpDest
@export var dropoff: DropOffDest
@export var box_spawner: BoxSpawner

@export_category("Locations")
@export var box_dolly_point: Node2D
@export var box_dolly_drop_point: Node2D

@onready var delivery_timer: Timer = %DeliveryTimer
@onready var boxes: Node2D = %Boxes


func _on_box_deleted(box: Box) -> void:
	match box.curr_status:
		Box.Status.PICKUP:
			pickup.box_count -= 1
		Box.Status.DROPOFF:
			dropoff.box_count -= 1


func _on_boxes_dropped(amount: int) -> void:

	if dropoff.box_count == dropoff.max_boxes:
		return

	if dropoff.out_for_delivery:
		return

	var sel: Array[Node] = boxes.get_children().filter(func(b: Box): return b.curr_status == Box.Status.DOLLY)

	if sel.size() == 0:
		return

	var box: Box = sel.pick_random() as Box

	PhysicsServer2D.body_set_state(
		box.get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(box_dolly_drop_point.global_position)
	)

	await box.body_entered

	dropoff.box_count += 1
	box.curr_status = Box.Status.DROPOFF

	if dropoff.box_count == dropoff.max_boxes:

		dropoff.deliver_boxes(boxes.get_children().filter(func(b: Box): return b.curr_status == Box.Status.DROPOFF))
		delivery_timer.start()


func _on_boxes_requested(amount: int) -> void:

	if pickup.box_count == 0:
		return

	var sel: Array[Node] = boxes.get_children().filter(func(b: Box): return b.curr_status == Box.Status.PICKUP)
	var box: Box = sel.pick_random() as Box

	pickup.box_count -= 1
	box.curr_status = Box.Status.DOLLY
	# https://stackoverflow.com/questions/77721286/set-a-rigid-body-position-in-godot-4
	PhysicsServer2D.body_set_state(
		box.get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(box_dolly_point.global_position)
	)


func _on_box_spawned(box: Box) -> void:
	match box.curr_status:
		Box.Status.PICKUP:
			pickup.box_count += 1
		Box.Status.DROPOFF:
			dropoff.box_count += 1


func _on_delivery_timer_timeout() -> void:
	dropoff.return_for_delivery()


func _ready() -> void:

	dolly.dolly_pick_up.request_boxes.connect(_on_boxes_requested)
	dolly.dolly_drop_off.drop_boxes.connect(_on_boxes_dropped)

	delivery_timer.wait_time = dropoff.delivery_time
	delivery_timer.timeout.connect(_on_delivery_timer_timeout)

	box_spawner.box_spawned.connect(_on_box_spawned)
