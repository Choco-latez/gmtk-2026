class_name SignEntity
extends Node2D

#
#   NOTE!!!
#  Add a Sign Popup to the map and add the sign entity to the sign popup's array
# sign popup is a canvaslayer

@export var sign_title : String
@export_multiline var Signtext : String
var can_interact :bool = false
signal sign_interacted(title:String,info:String)
signal exited

func _physics_process(delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("USE"):
		sign_interacted.emit(sign_title, Signtext)
func _on_area_2d_body_entered(body: Node2D) -> void:
	can_interact = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	can_interact = false
	exited.emit()
