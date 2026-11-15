extends Node2D


@export_category("Main Actors")
@export var dolly: Dolly
@export var pickup: PickUpDest
@export var dropoff: DropOffDest
@export var box_spawner: BoxSpawner

@export_category("Move Locations")
@export var box_dolly_point: Node2D
@export var box_dolly_drop_point: Node2D

@onready var delivery_timer: Timer = %DeliveryTimer
@onready var boxes: Node2D = %Boxes


func _get_boxes(type: Box.Status, amount: int) -> Array[Node]:

	var box_filter: Array[Node] = boxes.get_children().filter(func (box: Box): return box.curr_status == type)
	if amount < 0:
		return box_filter
	var box_slice: Array[Node] = box_filter.slice(0, amount)
	return box_slice


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
	
	for box in _get_boxes(Box.Status.DOLLY, amount):

		$Destinations/DropOff/DropOffAnimations/AnimationPlayer2.play("smoke")

		box.curr_status = Box.Status.DROPOFF
		dropoff.box_count += 1

		PhysicsServer2D.body_set_state(
			box.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(box_dolly_drop_point.global_position)
		)
		
		if dropoff.box_count == dropoff.max_boxes:
			print_debug("DELIVERY SCHEDULED")
			delivery_scheduled()
			return


func delivery_scheduled() -> void:
	dropoff.deliver_boxes(_get_boxes(Box.Status.DROPOFF, -1))
	delivery_timer.start()


func _on_boxes_requested(amount: int) -> void:

	if pickup.box_count == 0:
		return

	for box in _get_boxes(Box.Status.PICKUP, amount):
		
		$Destinations/PickUp/AnimationPlayer.play("smoke")
		
		box.curr_status = Box.Status.DOLLY
		pickup.box_count -= 1
		# https://stackoverflow.com/questions/77721286/set-a-rigid-body-position-in-godot-4
		PhysicsServer2D.body_set_state(
			box.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(box_dolly_point.global_position)
		)
		
	if pickup.box_count < pickup.max_boxes and box_spawner.box_timer.is_stopped():
		box_spawner.start_spawning()


func _on_box_spawned(box: Box) -> void:
	box.curr_status = Box.Status.PICKUP
	pickup.box_count += 1
	
	if pickup.box_count == pickup.max_boxes:
		box_spawner.stop_spawning()


func _on_delivery_timer_timeout() -> void:
	dropoff.return_for_delivery()


func _ready() -> void:

	dolly.dolly_pick_up.request_boxes.connect(_on_boxes_requested)
	dolly.dolly_drop_off.drop_boxes.connect(_on_boxes_dropped)
	
	box_spawner.box_spawned.connect(_on_box_spawned)

	delivery_timer.wait_time = dropoff.delivery_time
	delivery_timer.timeout.connect(_on_delivery_timer_timeout)
