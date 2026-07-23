extends Node2D
@export var player : Player 



var location : Vector2
var location_reached : bool = false
signal loc_reached
signal change_map()

func _ready() -> void:
	SignalBus.connect("exit_anim",exit)


func exit(pos):
	$"../AnimManager".process_mode = Node.PROCESS_MODE_DISABLED
	player.start_cutscene()
	%AnimationPlayer.play("exit")
	await %AnimationPlayer.animation_finished
	connect("change_map",SignalBus.swap_scene)
	change_map.emit()
