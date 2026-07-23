extends Node2D

@export var wait_time : float

func _ready() -> void:
	$Timer.wait_time = wait_time
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("asd")
	body.additional_jumps_available +=1
	$Timer.start()
	$GPUParticles2D.emitting = false
	$Sprite2D.visible = false
	$Area2D.monitoring = false


func _on_timer_timeout() -> void:
	$GPUParticles2D.emitting = true
	$Sprite2D.visible = true
	$Area2D.monitoring = true
