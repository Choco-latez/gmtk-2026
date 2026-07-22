extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -100.0
var can_jump : bool
var continue_jump : bool

var base_additional_jumps : int = 1
var additional_jumps_available : int


var dive_available : bool = true
var diving : bool = false



func _physics_process(delta: float) -> void:
	gravity(delta)
	handle_dive()
	handle_jump()
	calculate_movement()

	move_and_slide()
	
	print(diving)


func gravity(delta:float):
	# Add the gravity.
	if not is_on_floor():
		if not diving:
			velocity += get_gravity() * delta
	else:
		additional_jumps_available = base_additional_jumps
		can_jump = true
		$"Coyote Time".start()

func handle_jump():
		# Handle jump.
	if diving:
		return
	if Input.is_action_just_pressed("JUMP") and can_jump:
		velocity.y = JUMP_VELOCITY
		$"Jump Timer".start()
		$"Coyote Time".stop()
		can_jump = false
		continue_jump = true
	elif Input.is_action_just_pressed("JUMP") and additional_jumps_available > 0:
		$"Jump Timer".start()
		continue_jump = true
		velocity.y = JUMP_VELOCITY
		additional_jumps_available -=1
	elif Input.is_action_pressed("JUMP") and continue_jump:
		velocity.y += JUMP_VELOCITY/18
	if Input.is_action_just_released("JUMP"):
		$"Jump Timer".stop()
		continue_jump = false

func calculate_movement():
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		var dive_modifier = 1
		if diving:
			dive_modifier = 0.4
		velocity.x = direction * SPEED * dive_modifier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_dive():
	if Input.is_action_just_pressed("DIVE") and dive_available and not is_on_floor():
		$"Dive Timer".wait_time = 0.5
		$"Dive Timer".start()
		dive_available = false
		diving = true
		velocity.y = 0
		await $"Dive Timer".timeout
		$"Dive Timer".wait_time = 0.05
		$"Dive Timer".start()
		velocity.y = -JUMP_VELOCITY *4
		await $"Dive Timer".timeout
		diving = false
		dive_available = true
		

func _on_coyote_time_timeout() -> void:
	can_jump = false


func _on_jump_timer_timeout() -> void:
	continue_jump = false


func _on_dive_timer_timeout() -> void:
	pass # Replace with function body.
