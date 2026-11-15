extends Node2D


@export_category("Main Actors")
@export var dolly: Dolly
@export var pickup: PickUpDest
@export var dropoff: DropOffDest
@export var box_spawner: BoxSpawner
@export var menu: UpgradeMenu

@export_category("Move Locations")
@export var box_dolly_point: Node2D
@export var box_dolly_drop_point: Node2D

@export var stats: Dictionary = {
	UpgradeMenu.Stat.SPEED: [100.0, 2],
	UpgradeMenu.Stat.TABLECAP: [5, 1],
	UpgradeMenu.Stat.BPPU: [1, 5],
	UpgradeMenu.Stat.DC: [5, 10],
	UpgradeMenu.Stat.BPDO: [1, 4],
	UpgradeMenu.Stat.BST: [6.0, 15],
	UpgradeMenu.Stat.DT: [5.0, 15],
	UpgradeMenu.Stat.BP: ["GET PAID", 100]
}

@onready var delivery_timer: Timer = %DeliveryTimer
@onready var boxes: Node2D = %Boxes


func starting_stats() -> void:

	# Speed
	dolly.dolly_movement.speed = stats[UpgradeMenu.Stat.SPEED][0]
	menu.set_stat(UpgradeMenu.Stat.SPEED, stats[UpgradeMenu.Stat.SPEED][0])
	# Table Capacity
	pickup.max_boxes = stats[UpgradeMenu.Stat.TABLECAP][0]
	menu.set_stat(UpgradeMenu.Stat.TABLECAP, stats[UpgradeMenu.Stat.TABLECAP][0])
	# Boxes Per Pick Up
	dolly.dolly_pick_up.request_box_amount = stats[UpgradeMenu.Stat.BPPU][0]
	menu.set_stat(UpgradeMenu.Stat.BPPU, stats[UpgradeMenu.Stat.BPPU][0])
	# Delivery Capacity
	dropoff.max_boxes = stats[UpgradeMenu.Stat.DC][0]
	menu.set_stat(UpgradeMenu.Stat.DC, stats[UpgradeMenu.Stat.DC][0])
	# Boxes Per Drop Off
	dolly.dolly_drop_off.box_drop_amount = stats[UpgradeMenu.Stat.BPDO][0]
	menu.set_stat(UpgradeMenu.Stat.BPDO, stats[UpgradeMenu.Stat.BPDO][0])
	# Box Spawn
	box_spawner.box_spawn_time = stats[UpgradeMenu.Stat.BST][0]
	menu.set_stat(UpgradeMenu.Stat.BST, stats[UpgradeMenu.Stat.BST][0])
	# Delivery Time
	delivery_timer.wait_time = stats[UpgradeMenu.Stat.DT][0]
	menu.set_stat(UpgradeMenu.Stat.DT, stats[UpgradeMenu.Stat.DT][0])


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
		$Destinations/DropOff/AudioStreamPlayer.play()

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
		$Destinations/PickUp/AudioStreamPlayer.play()

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


func _on_give_payment(value: int) -> void:
	menu.update_money(value)


func _on_stat_updated(stat: UpgradeMenu.Stat) -> void:

	var cost: int = stats[stat][1]
	if cost > menu.money:
		return

	match stat:
		UpgradeMenu.Stat.SPEED:
			if is_equal_approx(dolly.dolly_movement.speed, 400.0):
				return
			dolly.dolly_movement.speed += 50.0
			menu.set_stat(UpgradeMenu.Stat.SPEED, dolly.dolly_movement.speed)
			print_debug("SPEED UPGRADED")
		UpgradeMenu.Stat.TABLECAP:
			if pickup.max_boxes == 40:
				return
			pickup.max_boxes += 1
			menu.set_stat(UpgradeMenu.Stat.TABLECAP, pickup.max_boxes)
			print_debug("TABLECAP UPGRADED")
		UpgradeMenu.Stat.BPPU:
			if dolly.dolly_pick_up.request_box_amount == 10:
				return
			dolly.dolly_pick_up.request_box_amount += 1
			menu.set_stat(UpgradeMenu.Stat.BPPU, dolly.dolly_pick_up.request_box_amount)
			print_debug("BPPU UPGRADED")
		UpgradeMenu.Stat.DC:
			if dropoff.max_boxes == 30:
				return
			dropoff.max_boxes += 1
			menu.set_stat(UpgradeMenu.Stat.DC, dropoff.max_boxes)
			print_debug("DC UPGRADED")
		UpgradeMenu.Stat.BPDO:
			if dolly.dolly_drop_off.box_drop_amount == 5:
				return
			dolly.dolly_drop_off.box_drop_amount += 1
			menu.set_stat(UpgradeMenu.Stat.BPDO, dolly.dolly_drop_off.box_drop_amount)
			print_debug("BPDO UPGRADED")
		UpgradeMenu.Stat.BST:
			if is_equal_approx(box_spawner.box_spawn_time, 1.0):
				return
			box_spawner.box_spawn_time -= 0.5
			menu.set_stat(UpgradeMenu.Stat.BST, box_spawner.box_spawn_time)
			print_debug("BST UPGRADED")
		UpgradeMenu.Stat.DT:
			if is_equal_approx(delivery_timer.wait_time, 1.0):
				return
			delivery_timer.wait_time -= 0.5
			menu.set_stat(UpgradeMenu.Stat.DT, delivery_timer.wait_time)
			print_debug("DT UPGRADED")
		UpgradeMenu.Stat.BP:
			print_debug("YOU WIN")
			GameLoader.load_scene("res://scenes/end_screen.tscn")

	menu.update_money(-cost)


func _ready() -> void:

	dolly.dolly_pick_up.request_boxes.connect(_on_boxes_requested)
	dolly.dolly_drop_off.drop_boxes.connect(_on_boxes_dropped)

	box_spawner.box_spawned.connect(_on_box_spawned)

	dropoff.give_payment.connect(_on_give_payment)

	delivery_timer.wait_time = dropoff.delivery_time
	delivery_timer.timeout.connect(_on_delivery_timer_timeout)

	menu.stat_updated.connect(_on_stat_updated)

	menu.override_money(0)
	starting_stats()

	$Control/Transition.show()
	$Control/Transition/AnimationPlayer.play_backwards("fadein")
