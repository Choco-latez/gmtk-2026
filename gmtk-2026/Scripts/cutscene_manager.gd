extends Node2D

@export var beginning : bool = true
@export var fight_begin_anim : bool = false
@export var in_fight : bool = false
@export var ending_fight_anim : bool = false

func _ready() -> void:
	stop_music()
	%"Time Bar".max_value = $Timer.wait_time
	
func stop_music():
	MusicManager.mute = true
	MusicManager.stop()

func fin():
	SignalBus.load_finish()

func _physics_process(delta: float) -> void:
	if beginning:
		if Input.is_action_just_pressed("USE"):
			%Player.apply_gravity(!%Player.gravity, false)
		if %Camera2D.position.x != %Player.position.x + 150:
			if %Player.position.x + 150 > %Camera2D.position.x:
				%Camera2D.position.x = %Player.position.x + 150
		if %Player.velocity.x <0:
			%Player.velocity.x=0
		
		if %Camera2D.position.x > -1 and %Camera2D.position.x < 1 :
			%Camera2D.position.x = 0
			beginning = false
			fight_begin_anim = true
			%Player.start_cutscene()
			%AnimationPlayer.play("Init")
			
	if fight_begin_anim:
		%Hitbox.monitoring = true
		%Hitbox.monitorable = true
	if in_fight:
		%"Time Bar".value = $Timer.time_left
		if Input.is_action_just_pressed("USE"):
			%Player.apply_gravity(!%Player.gravity, false)
	if ending_fight_anim:
		pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(%Camera2D,"position",Vector2.ZERO,1)
	$Area2D.set_deferred("monitoring", false)


func _on_timer_timeout() -> void:
	%BOSS.HP -=1
	
	if %BOSS.HP == 0:
		$Timer.stop()
		%"Time Bar".visible = false
		ending_fight_anim = true
		%BOSS.decisionmaking = false
		%AnimationPlayer.play("died")
		$"../BOSS/Bullets".visible = false
		%Player.start_cutscene()
	if %BOSS.HP == 3:
		%"Time Bar".modulate = Color8(255,255,0)
	elif %BOSS.HP ==2:
		%"Time Bar".modulate = Color8(255,120,0)
		$AnimationPlayer.play("drop powerup 1")
	else:
		%"Time Bar".modulate = Color8(255,0,0)
		$AnimationPlayer.play("drop powerup 2")
		
	

	
