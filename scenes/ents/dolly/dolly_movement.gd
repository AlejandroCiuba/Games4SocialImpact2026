extends Node2D
class_name DollyMovement


signal arrived(target: Vector2)

@export var dolly: CharacterBody2D

@export_category("Dolly Settings")

@export var speed: float = 500.0
@export var destination_tolerance: float = 10.0

@export var dolly_sprite: Sprite2D

@export var destinations: Array[Destination]

@onready var _target: Vector2 = global_position


func set_target(target: Vector2) -> void:
	print_debug("Global Position: ", global_position)
	print_debug("Target: ", target)
	_target = target


func _on_destination_selected(stop_point: Node2D) -> void:

	if stop_point == null:
		return

	set_target(stop_point.global_position)


func _ready() -> void:

	print_debug(_target)

	for dest in destinations:
		dest.destination_selected.connect(_on_destination_selected)


func _physics_process(delta: float) -> void:

	if global_position.distance_to(_target) > destination_tolerance:
		dolly.velocity = global_position.direction_to(_target) * speed * delta
		dolly.move_and_collide(dolly.velocity)

		if dolly.velocity.x > 0.0:
			dolly_sprite.flip_h = false
		else:
			dolly_sprite.flip_h = true


	else:
		dolly.velocity = Vector2.ZERO
		global_position = _target
		arrived.emit(_target)
