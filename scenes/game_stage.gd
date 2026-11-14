extends Node2D

signal box_spawned(box: Box)


@export_category("Boxes")
@export var box_spawn_point: Node2D
@export var box_scene: PackedScene


@onready var dolly: Dolly = %Dolly

@onready var pickup: PickUp = %PickUpDest
@onready var dropoff: DropOff = %DropOffDest

@onready var box_dolly_point: Node2D = %BoxDollyMovePoint
@onready var box_dolly_drop_point: Node2D = %BoxDollyDropPoint

@onready var box_timer: Timer = %BoxTimer
@onready var boxes: Node2D = %Boxes


func _spawn_box() -> void:

	var b: Box = box_scene.instantiate() as Box
	boxes.add_child(b)

	if box_spawn_point != null:
		b.global_position = box_spawn_point.global_position
	else:
		print_debug("No box spawn point")
		b.global_position.y = global_position.y + 500.0

	await b.body_entered
	b.curr_status = Box.Status.PICKUP

	pickup.box_count += 1
	box_spawned.emit(b)


func _on_boxes_dropped(amount: int) -> void:

	if dropoff.box_count == dropoff.max_boxes:
		return

	if dropoff.out_for_delivery:
		return

	var sel: Array[Node] = boxes.get_children().filter(func(b: Box): return b.curr_status == Box.Status.DOLLY)

	if sel.size() == 0:
		return

	var box: Box = sel.pick_random() as Box

	dropoff.box_count += 1
	box.curr_status = Box.Status.DROPOFF

	PhysicsServer2D.body_set_state(
		box.get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(box_dolly_drop_point.global_position)
	)


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


func _on_box_timer_timeout() -> void:
	if pickup.box_count < pickup.max_boxes:
		_spawn_box()


func _ready() -> void:

	dolly.dolly_pick_up.request_boxes.connect(_on_boxes_requested)
	dolly.dolly_drop_off.drop_boxes.connect(_on_boxes_dropped)

	box_timer.wait_time = pickup.box_spawn_time
	box_timer.timeout.connect(_on_box_timer_timeout)
