class_name ButtonEntity
extends MapButton

var prev_state :bool = false

func turn_on(on_or_off:bool):
	is_on = on_or_off
	if on_or_off:
		$Sprite2D.frame_coords.x = 0
		turned_on.emit()
	else:
		$Sprite2D.frame_coords.x = 1
		turned_off.emit()
		
	



func _physics_process(delta: float) -> void:
	if !$Area2D.has_overlapping_bodies() and prev_state == true:
		turn_on(false)
		prev_state = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if prev_state == false:
		prev_state = true
		turn_on(true)
