class_name MapButton
extends Node2D

enum BUTTON_TYPES{BUTTON,LEVER,PROGRESS,SWITCH}
@export var button_type : BUTTON_TYPES
@export var undo_timer_length : float
var is_on : bool = false

signal turned_on
signal turned_off

func turn_on(on_or_off:bool):
	is_on = on_or_off
	if on_or_off:
		$Sprite2D.frame_coords.x = 0
		turned_on.emit()
		if button_type == BUTTON_TYPES.BUTTON or button_type == BUTTON_TYPES.PROGRESS:
			await $Area2D.body_exited
			$Timer.start()
		
		
	else:
		$Sprite2D.frame_coords.x = 1
		turned_off.emit()
		
	

func set_type(type:BUTTON_TYPES):
	button_type = type
	if type == BUTTON_TYPES.BUTTON:
		$Sprite2D.frame_coords.y = 0
		
	if type == BUTTON_TYPES.LEVER:
		$Sprite2D.frame_coords.y = 1
		
	if type == BUTTON_TYPES.PROGRESS:
		$Sprite2D.frame_coords.y = 2
		$ProgressBar.visible = true
		$ProgressBar.max_value = $Timer.wait_time
		$ProgressBar.value = $Timer.wait_time
		
	if type == BUTTON_TYPES.SWITCH:
		$Sprite2D.frame_coords.y = 3

func _physics_process(delta: float) -> void:
	if button_type == BUTTON_TYPES.PROGRESS:
		$ProgressBar.value = $Timer.time_left

func _on_timer_timeout() -> void:
	turn_on(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		turn_on(true)
