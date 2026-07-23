extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CharacterBody2D.died.connect(die)
	
	if not Savedata.fastdeath:
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property($CanvasLayer/Panel, "modulate", Color8(0,0,0,0), 0.5 )
	
func die():
	if Savedata.fastdeath:
		get_tree().reload_current_scene()
	else:
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property($CanvasLayer/Panel, "modulate", Color8(0,0,0,255), 0.5)
		await tween.finished
		get_tree().reload_current_scene()
