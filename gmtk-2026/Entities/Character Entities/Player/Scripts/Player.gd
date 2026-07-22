extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -100.0
var can_jump : bool
var continue_jump : bool


func _physics_process(delta: float) -> void:
	gravity(delta)

	handle_jump()
	calculate_movement()

	move_and_slide()
	
	print(continue_jump)


func gravity(delta:float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_jump = true
		$"Coyote Time".start()

func handle_jump():
		# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = JUMP_VELOCITY
		$"Jump Timer".start()
		$"Coyote Time".stop()
		continue_jump = true
	elif Input.is_action_pressed("ui_accept") and continue_jump:
		velocity.y += JUMP_VELOCITY/7
	if Input.is_action_just_released("ui_accept"):
		$"Jump Timer".stop()
		continue_jump = false

func calculate_movement():
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _on_coyote_time_timeout() -> void:
	can_jump = false


func _on_jump_timer_timeout() -> void:
	continue_jump = false
