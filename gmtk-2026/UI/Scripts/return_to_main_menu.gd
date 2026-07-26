extends Control

var held : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MENU"):
		$Timer.start()
		held = true
		visible = true
	if Input.is_action_just_released("MENU"):
		held = false
		$Timer.stop()
		visible = false
	


func _on_timer_timeout() -> void:
	if held:
		print("asdsasdasdasda")
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
