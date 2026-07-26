class_name PlatformEntity
extends ConnectedEntity

@export var tween_time:float
@export var tween_type:Tween.TransitionType


@export var loop : bool
@export var end_wait:float
var at_basis := true

var tween : Tween


func turned_on():
	if tween:
		tween.kill() # Abort the previous animation.
		
	tween = get_tree().create_tween()
	tween.set_trans(tween_type)
	tween.tween_property($AnimatableBody2D,"position",$"Position 2".position,tween_time)
	if loop:
		$Timer.wait_time = tween_time
		$Timer.start()
	
	
func turned_off():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = get_tree().create_tween()
	tween.tween_property($AnimatableBody2D,"position",$"Position 1".position,tween_time)
	tween.set_trans(tween_type)



func _ready() -> void:
	super()
	#$AnimatableBody2D/CollisionPolygon2D.polygon = $AnimatableBody2D/Polygon2D.polygon
	$AnimatableBody2D.position = $"Position 1".position	
	
	$"Line Outer".add_point($"Position 1".position - $"Position 1".position.direction_to($"Position 2".position) * 0.3)
	$"Line Outer".add_point($"Position 2".position - $"Position 2".position.direction_to($"Position 1".position) * 0.3)
	$"Line Inner".add_point($"Position 1".position)
	$"Line Inner".add_point($"Position 2".position)
	
	if loop and end_wait > 0:
		$Timer.one_shot = true


func _on_timer_timeout() -> void:
	at_basis = !at_basis
	if not end_wait > 0:
		if at_basis:
			tween = get_tree().create_tween()
			tween.tween_property($AnimatableBody2D,"position",$"Position 2".position,tween_time)		
		else:
			tween = get_tree().create_tween()
			tween.tween_property($AnimatableBody2D,"position",$"Position 1".position,tween_time)
	else:
		$"End Wait Timer".start()


func _on_end_wait_timer_timeout() -> void:
	$Timer.start()
	if at_basis:
		tween = get_tree().create_tween()
		tween.tween_property($AnimatableBody2D,"position",$"Position 2".position,tween_time)		
	else:
		tween = get_tree().create_tween()
		tween.tween_property($AnimatableBody2D,"position",$"Position 1".position,tween_time)
