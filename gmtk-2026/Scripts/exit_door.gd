extends Node2D

signal end_scene(location)

func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("close")
	connect("end_scene",SignalBus.start_exit_anim)
	end_scene.emit(global_position)
