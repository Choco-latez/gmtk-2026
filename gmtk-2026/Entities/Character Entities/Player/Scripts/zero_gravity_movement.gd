extends Node2D

@export var player : Player 
enum standing_directions {UPDOWN, LEFTRIGHT, BOTH, NONE}
var standing_dir : standing_directions = standing_directions.LEFTRIGHT

var jumping_dir:Vector2

func _physics_process(delta: float) -> void:
	get_standing_dir()
	handle_jump()
	handle_dive()
	calculate_movement()
	
	player.move_and_slide()
	
func get_standing_dir():
	var old_dir := standing_dir
	if player.is_on_floor_only():
		standing_dir = standing_directions.LEFTRIGHT
		reset_jump()
	elif player.is_on_wall_only():
		standing_dir = standing_directions.UPDOWN
		reset_jump()
	elif player.is_on_ceiling_only():
		standing_dir = standing_directions.LEFTRIGHT
		reset_jump()
	elif player.is_on_ceiling() and player.is_on_wall():
		standing_dir = standing_directions.BOTH
		reset_jump()
	elif player.is_on_floor() and player.is_on_wall():
		standing_dir = standing_directions.BOTH
		reset_jump()
	else:
		standing_dir = standing_directions.NONE
	coyote_time_manager(old_dir,standing_dir)

func reset_jump():
	player.can_jump = true
	player.additional_jumps_available = player.base_additional_jumps
	

func get_standing_vector()->Vector2:
	var vec = Vector2.ZERO
	if player.is_on_ceiling():
		vec.y += 1
	if player.is_on_floor():
		vec.y -= 1
	if player.is_on_wall():
		if %RaycastR.is_colliding():
			vec.y += 1
		if %RaycastL.is_colliding():
			vec.x -= 1
	return vec

func handle_dive():
	if Input.is_action_just_pressed("DIVE") and player.dive_available and  standing_dir == standing_directions.NONE:
		%"Dive Timer".wait_time = 0.5
		%"Dive Timer".start()
		player.dive_available = false
		player.diving = true
		player.velocity = Vector2.ZERO
		%"Dive Charge Particles".emitting = true
		
		await %"Dive Timer".timeout
		%"Dive Timer".wait_time = 0.05
		%"Dive Timer".start()
		%"Dive Charge Particles".emitting = false
		%"Dive Particles".emitting = true
		
		var input = Input.get_vector("LEFT","RIGHT","UP","DOWN")
		print(input)
		if input!= Vector2.ZERO:
			player.velocity = - (input.normalized())*player.JUMP_VELOCITY *4
		else:
			player.velocity = jumping_dir*player.JUMP_VELOCITY *4
			
		await %"Dive Timer".timeout
		player.diving = false
		player.dive_available = true
		%"Dive Timer".wait_time = 0.1
		%"Dive Timer".start()
		
		await %"Dive Timer".timeout
		%"Dive Particles".emitting = false
	
func handle_jump():
	if standing_dir != standing_directions.NONE:
		var input = Input.get_vector("LEFT","RIGHT","UP","DOWN")
		
		if Input.is_action_just_pressed("JUMP") and player.can_jump:
			%"Jump Timer".start()
			%"Coyote Time".stop()
			player.can_jump = false
			if input == Vector2.ZERO:
				jumping_dir = -get_standing_vector().normalized()
			else: 
				jumping_dir = - input.normalized()
			player.velocity = jumping_dir * player.JUMP_VELOCITY 
			player.jump_particles_instantiate()
		
	elif standing_dir == standing_directions.NONE:
		if Input.is_action_just_pressed("JUMP") and player.additional_jumps_available > 0:
			print("123")
			%"Jump Timer".start()
			var input = Input.get_vector("LEFT","RIGHT","UP","DOWN")
			if input == Vector2.ZERO:
				print("asd")
				player.velocity = jumping_dir*player.JUMP_VELOCITY
			else:
				print("asd")
				player.velocity -= (input.normalized()) * player.JUMP_VELOCITY
			player.jump_particles_instantiate()
			player.additional_jumps_available -=1
			


func coyote_time_manager(old_dir,new_dir):
	if old_dir==new_dir:
		return
	%"Coyote Time".start()
	player.can_jump=true
	

func calculate_movement():
	if standing_dir == standing_directions.LEFTRIGHT or standing_dir == standing_directions.BOTH:
		var direction := Input.get_axis("LEFT", "RIGHT")
		if direction:
			var dive_modifier = 1
			if player.diving:
				dive_modifier = 0.4
			player.velocity.x = direction * player.SPEED * dive_modifier
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
			
	if standing_dir == standing_directions.UPDOWN or standing_dir == standing_directions.BOTH:
		var direction := Input.get_axis("UP", "DOWN")
		if direction:
			var dive_modifier = 1
			if player.diving:
				dive_modifier = 0.4
			player.velocity.y = direction * player.SPEED * dive_modifier
		else:
			player.velocity.y = move_toward(player.velocity.y, 0, player.SPEED)
	


func _on_coyote_time_timeout() -> void:
	player.can_jump = false


func _on_dive_timer_timeout() -> void:
	pass # Replace with function body.
