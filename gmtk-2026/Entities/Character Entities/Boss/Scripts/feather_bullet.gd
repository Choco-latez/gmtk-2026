extends Node2D

var dir :Vector2 = Vector2.ZERO
var speed : float = 2

func _physics_process(delta: float) -> void:
	position = position + dir * speed


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
