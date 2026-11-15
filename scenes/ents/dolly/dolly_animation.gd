extends Node2D
class_name DollyAnimation

@export var dolly: CharacterBody2D
@export var person: Person
@export var dolly_sprite: Sprite2D
@export var wheel_sprite: Sprite2D

@export var anim: AnimationPlayer

var flip_h: bool = false:
	set(value):
		dolly_sprite.flip_h = value
		person.flip_h = value
		
		if value:
			wheel_sprite.position.x = 12
			person.position.x = 49
		else:
			wheel_sprite.position.x = -12
			person.position.x = -49


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:

	if dolly_sprite.flip_h == true:
		if not is_zero_approx(dolly.velocity.x):
			person.anim.play("walk")
			anim.play_backwards("wheel_spin")
		else:
			person.anim.pause()
			anim.pause()
	else:
		if not is_zero_approx(dolly.velocity.x):
			person.anim.play("walk")
			anim.play("wheel_spin")
		else:
			person.anim.pause()
			anim.pause()
