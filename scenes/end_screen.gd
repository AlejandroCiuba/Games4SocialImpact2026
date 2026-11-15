extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ZoomIn.hide()
	$ZoomIn/OpenedBox.hide()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		$ZoomIn.show()


func _on_closed_box_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		$ZoomIn/ClosedBox/ClosedBoxArea.input_pickable = false
		$Music.play()
		var tween: Tween = get_tree().create_tween().bind_node(self)
		tween.set_loops(7)
		tween.tween_property($ZoomIn/ClosedBox, "position:x", 10, 0.25).as_relative()
		tween.tween_property($ZoomIn/ClosedBox, "position:x", 0, 0.25).as_relative()
		tween.tween_property($ZoomIn/ClosedBox, "position:x", -10, 0.25).as_relative()
		tween.tween_property($ZoomIn/ClosedBox, "position:x", 0, 0.25).as_relative()
		await get_tree().create_timer(7.0).timeout
		$ZoomIn/OpenedBox.show()
