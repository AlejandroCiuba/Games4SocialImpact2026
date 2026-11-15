extends Node2D
class_name Person

@onready var anim: AnimationPlayer = $AnimationPlayer

var flip_h: bool = false:
	set(value):
		$Person.flip_h = value
		$Legs/RightLeg.flip_h = value
		$Legs/LeftLeg.flip_h = value

		if $Person.flip_h == true:
			$Legs.position.x = 5
		else:
			$Legs.position.x = -5
			
		flip_h = value
