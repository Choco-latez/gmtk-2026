class_name ProgressNode
extends MapButton
@export var time : float = 1.0
var active : bool = false
var player_inside = false

func _ready() -> void:
	$Timer.wait_time = time
	$ProgressBar.max_value = time
	$ProgressBar.value = time
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_inside = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("INTERACT") and not active:
		turn_on()
	if active:
		$ProgressBar.value = $Timer.time_left
	else:
		$ProgressBar.value = $ProgressBar.max_value
		
func turn_on():
	active = true
	turned_on.emit()
	$Timer.start()


func _on_timer_timeout() -> void:
	turned_off.emit()
	active = false
