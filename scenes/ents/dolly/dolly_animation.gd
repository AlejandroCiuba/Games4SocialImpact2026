extends Node2D

@export var dolly: CharacterBody2D
@export var dc: CollisionPolygon2D
@export var dolly_sprite: Sprite2D
@export var wheel_sprite: Sprite2D

@export var anim: AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	if dolly.velocity.x > 0.0:
		dolly_sprite.flip_h = false
	else:
		dolly_sprite.flip_h = true

	if dolly_sprite.flip_h == true:
		if not is_zero_approx(dolly.velocity.x):
			anim.play_backwards("wheel_spin")
		else:
			anim.pause()
		wheel_sprite.position.x = 12
	else:
		if not is_zero_approx(dolly.velocity.x):
			anim.play("wheel_spin")
		else:
			anim.pause()
		wheel_sprite.position.x = -12
		
