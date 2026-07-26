class_name Boss
extends Node2D

@export var decisionmaking : bool = false
@export var feather_bullet : PackedScene
@export var debris_fall: PackedScene

#basic weighted list to choose an action from
var acts = ["Idle","Idle","Idle","Shoot","Smack","Honk"]
#var acts =["Honk","Honk","Honk","Honk","Honk"]
var last_anim ="Init"
var HP = 3

@onready var boss_yell: AudioStreamPlayer2D = %BossYell
@onready var boss_beam: AudioStreamPlayer2D = %BossBeam

func start_music():
	MusicManager.mute = false
	MusicManager.swap_music(3)
	MusicManager.play()

func debris():
	var debris = debris_fall.instantiate()
	debris.position = Vector2(%Player.position.x ,0)
	boss_beam.play()
	$Bullets.add_child(debris)

func shoot_bullet(pos:Vector2, rot: float):
	var bullet = feather_bullet.instantiate()
	bullet.dir = Vector2.from_angle(deg_to_rad(rot))
	bullet.position = pos
	bullet.rotation = rot
	boss_yell.play()
	$Bullets.add_child(bullet)

func shoot_bullets():
	var type = randi_range(1,3)
	#type 1: all at once, type 2: one after the other, type 3: random
	
	var target = %Player.position
	var init_rot = rad_to_deg( ($Bullet_Spawnpoint.global_position.direction_to(target).angle() ) )
	var spread = randi_range(5,10)
	var amount = randi_range(3,5)
	var length = randi_range(3,5)
	
	if type == 1:
		for x in amount:
			spread += 5
			var calc = float(x)/float(amount-1)
			if amount -1 == 0: calc = 0
			var rot = lerp(init_rot -(spread* amount/2.0), init_rot +(spread* amount/2.0), calc)
			
			shoot_bullet($Bullet_Spawnpoint.position, rot)
		for y in (length -1):
			var tween = get_tree().create_tween()
			#shitty wait
			tween.tween_property($Wait_node,"position",Vector2.ZERO,0.1)
			await tween.finished
			$Wait_node.position = Vector2(1,1)
			
			for x in amount:
				var calc = float(x)/float(amount-1)
				if amount -1 == 0: calc = 0
				var rot = lerp(init_rot -(spread* amount/2.0), init_rot +(spread* amount/2.0), calc)
				shoot_bullet($Bullet_Spawnpoint.position, rot)
	
	elif type == 2:
		spread += 5
		for y in amount-2:
			for x in length:
				var calc = float(x)/float(amount-1)
				if amount -1 == 0: calc = 0
				var rot = lerp(init_rot -(spread* amount/2.0), init_rot +(spread* amount/2.0),calc)
				shoot_bullet($Bullet_Spawnpoint.position, rot)
				
			var tween = get_tree().create_tween()
			#shitty wait
			tween.tween_property($Wait_node,"position",Vector2.ZERO,1)
			await tween.finished
			$Wait_node.position = Vector2(1,1)
	elif type == 3:
		for x in 12:
			var rot = randf_range( init_rot -(spread* amount/2.0), init_rot +(spread* amount/2.0)) 
			shoot_bullet($Bullet_Spawnpoint.position, rot)
			var tween = get_tree().create_tween()
			#shitty wait
			tween.tween_property($Wait_node,"position",Vector2.ZERO,0.8)
			await tween.finished
			$Wait_node.position = Vector2(1,1)




func make_decision():
	if last_anim == "Idle":
		last_anim = ["Idle","Shoot","Smack","Honk"]
		#["Honk","Honk","Honk","Honk","Honk"]
	elif last_anim == "Honk":
		last_anim = ["Idle","Idle","Idle","Shoot","Smack","Honk","Honk","Honk","Honk","Honk"]
		#["Honk","Honk","Honk","Honk","Honk"]
	elif last_anim == "Shoot":
		last_anim = ["Idle","Idle","Idles","Shoot","Honk"]
		#["Honk","Honk","Honk","Honk","Honk"]
		#["Honk","Honk","Honk","Honk","Honk"]
	else:
		last_anim = ["Idle","Idle","Idle","Shoot","Smack","Honk"]
		#["Honk","Honk","Honk","Honk","Honk"]
	return acts.pick_random()


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.die()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if decisionmaking:
		last_anim = make_decision()
		%AnimationPlayer.play(last_anim)
