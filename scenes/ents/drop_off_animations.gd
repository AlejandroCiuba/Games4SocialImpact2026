extends Node2D

@export var drop_off: DropOffDest
@export var anim: AnimationPlayer


func _on_returned() -> void:
	anim.play("gate_opened")


func _on_delivery() -> void:
	anim.play("gate_closed")


func _ready() -> void:
	anim.play("gate_opened")
	drop_off.delivery.connect(_on_delivery)
	drop_off.returned.connect(_on_returned)
