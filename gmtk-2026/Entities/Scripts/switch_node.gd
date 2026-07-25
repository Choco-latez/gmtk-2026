class_name SwitchNode
extends MapButton

var player_inside = false
var on = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_inside = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("USE") and player_inside:
		turn_on()
		
func turn_on():
	if on:
		$Sprite2D.frame_coords.x = 0
		turned_off.emit()
	else:
		$Sprite2D.frame_coords.x = 1
		turned_on.emit()
	on = not on
	
