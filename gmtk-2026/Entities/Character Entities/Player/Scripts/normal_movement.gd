extends Node2D

@export var player : Player 


func _physics_process(delta: float) -> void:
	gravity(delta)
	handle_dive()
	handle_jump()
	calculate_movement()

	player.move_and_slide()
	


func gravity(delta:float):
	# Add the gravity.
	if not player.is_on_floor():
		if not player.diving:
			player.velocity += player.get_gravity() * delta
	else:
		player.additional_jumps_available = player.base_additional_jumps
		player.can_jump = true
		%"Coyote Time".start()

func handle_jump():
		# Handle jump.
	if player.diving:
		return
	if Input.is_action_just_pressed("JUMP") and player.can_jump:
		player.velocity.y = player.JUMP_VELOCITY
		%"Jump Timer".start()
		%"Coyote Time".stop()
		player.can_jump = false
		player.continue_jump = true
	elif Input.is_action_just_pressed("JUMP") and player.additional_jumps_available > 0:
		%"Jump Timer".start()
		player.continue_jump = true
		player.velocity.y = player.JUMP_VELOCITY
		player.additional_jumps_available -=1
		player.jump_particles_instantiate()
	elif Input.is_action_pressed("JUMP") and player.continue_jump and not player.is_on_floor():
		player.velocity.y += player.JUMP_VELOCITY* 3.5 * get_physics_process_delta_time()
	if Input.is_action_just_released("JUMP"):
		%"Jump Timer".stop()
		player.continue_jump = false

func calculate_movement():
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		var dive_modifier = 1
		if player.diving:
			dive_modifier = 0.2
		player.velocity.x = direction * player.SPEED * dive_modifier 
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)

func handle_dive():
	if not player.dive_unlocked:
		return
	
	if Input.is_action_just_pressed("DIVE") and player.dive_available and not player.is_on_floor():
		%"Dive Timer".wait_time = 0.5
		%"Dive Timer".start()
		%"Dive Charge Particles".emitting = true
		player.dive_available = false
		player.diving = true
		player.velocity.y = 0
		
		await %"Dive Timer".timeout
		%"Dive Charge Particles".emitting = false
		%"Dive Particles".emitting = true
		%"Dive Timer".wait_time = 0.05
		%"Dive Timer".start()
		player.velocity.y = -player.JUMP_VELOCITY *3 
		%Sprite2D.visible = false
		
		await %"Dive Timer".timeout
		player.diving = false
		player.dive_available = true
		%"Dive Timer".wait_time = 0.1
		%"Dive Timer".start()
		
		if Input.is_action_pressed("JUMP") and player.additional_jumps_available > 0:
			%"Jump Timer".start()
			player.continue_jump = true
			player.velocity.y = player.JUMP_VELOCITY
			player.additional_jumps_available -=1
			player.jump_particles_instantiate()
		
		await %"Dive Timer".timeout
		%Sprite2D.visible = true
		%"Dive Particles".emitting = false
		

func _on_coyote_time_timeout() -> void:
	player.can_jump = false


func _on_jump_timer_timeout() -> void:
	player.continue_jump = false


func _on_dive_timer_timeout() -> void:
	pass # Replace with function body.
