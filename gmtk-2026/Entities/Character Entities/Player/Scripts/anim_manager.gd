extends Node
@export var player: Player


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction == 1:
		%Sprite2D.flip_h = false
	elif direction == -1:
		%Sprite2D.flip_h = true
	
	if player.gravity:
		determine_anim_gravity()
	else:
		determine_anim_zgravity()


func determine_anim_gravity():
	if player.diving:
		%AnimationPlayer.play("charge")
		return
	#elif Input.is_action_just_pressed("INTERACT"):
		#%AnimationPlayer.play("interact")
		#return
	if player.velocity == Vector2.ZERO:
		if %AnimationPlayer.current_animation != "idle":
			%AnimationPlayer.play("idle")
		return
	if player.velocity.y>0:
		%AnimationPlayer.play("fall")
	elif player.velocity.y<0:
		%AnimationPlayer.play("jump")
	else:
		if %AnimationPlayer.current_animation != "walk":
			%AnimationPlayer.play("walk")

		
	
func determine_anim_zgravity():
	if player.diving:
		%AnimationPlayer.play("charge")
		return
	#elif Input.is_action_just_pressed("INTERACT"):
		#%AnimationPlayer.play("interact")
		#return
		
	if player.velocity == Vector2.ZERO:
		if %AnimationPlayer.current_animation != "idle":
			%AnimationPlayer.play("idle")
		return
	elif %"Zero Gravity Movement".standing_dir == %"Zero Gravity Movement".standing_directions.NONE:
		if %AnimationPlayer.current_animation!= "fall" or %AnimationPlayer.current_animation!= "jump":
			if Input.is_action_just_pressed("JUMP"):
				%AnimationPlayer.play("jump")
			else:
				%AnimationPlayer.play("fall")
	else:
		%AnimationPlayer.play("walk")
