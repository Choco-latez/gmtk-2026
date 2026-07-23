class_name Player
extends CharacterBody2D

signal died
signal ability_used

@export var jump_particle_instance : PackedScene

const SPEED = 120.0
var JUMP_VELOCITY = -100.0
var can_jump : bool
var continue_jump : bool

@export var base_additional_jumps : int = 1
var additional_jumps_available : int

@export var dive_unlocked :bool = false

var dive_available : bool = true
var diving : bool = false
var grav_norm = true

var gravity:bool = true

@export var swan_time_unlocked: bool = false
var swan_time_available :bool = true

var cutscene_control : bool = false


func start_cutscene():
	cutscene_control = true
	%"Normal Movement".process_mode = Node.PROCESS_MODE_DISABLED
	%"Zero Gravity Movement".process_mode = Node.PROCESS_MODE_DISABLED
	
func stop_cutscene():
	cutscene_control = false
	apply_gravity(gravity)


func swan_time():
	if not swan_time_unlocked:
		return
	
	if swan_time_available and Input.is_action_pressed("USE"):
		Engine.time_scale = 0.4
		AudioServer.playback_speed_scale = 0.4
		swan_time_available = false
		%"Swan Time".start()
	if Input.is_action_just_released("USE"):
		Engine.time_scale = 1
		AudioServer.playback_speed_scale = 1

func die() -> void:
	if cutscene_control:
		return
	if Savedata.fastdeath:
		died.emit()
		return
	
	$"Particles/Death Particles".emitting = true
	$"Death Anim Timer".start()
	%MoveParticles.emitting = false
	%Sprite2D.visible = false
	
	%"Normal Movement".process_mode = Node.PROCESS_MODE_DISABLED
	%"Zero Gravity Movement".process_mode = Node.PROCESS_MODE_DISABLED
	
	await $"Death Anim Timer".timeout
	$"Particles/Death Particles".emitting = false
	$"Death Anim Timer".start()
	await $"Death Anim Timer".timeout
	
	died.emit()

func _ready() -> void:
	apply_gravity(true)
	SignalBus.connect("change_gravity",apply_gravity)
	connect("ability_used",SignalBus.use_ability)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		apply_gravity(!gravity)
	if Input.is_action_just_pressed("debug2"):
		die()

func change_gravity(new_grav : Vector2) -> void:
	JUMP_VELOCITY *= -1
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, new_grav)

func _change_player_grav() -> void:
	if Input.is_action_just_pressed("InvertGrav"):
		if grav_norm == true:
			change_gravity(Vector2.UP)
			grav_norm = false
		else:
			change_gravity(Vector2.DOWN)
			grav_norm = true

func _physics_process(delta: float) -> void:
	_change_player_grav()
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

		
	swan_time()
	
func apply_gravity(true_or_false:bool):
	if true_or_false:
		%"Normal Movement".process_mode = Node.PROCESS_MODE_INHERIT
		%"Zero Gravity Movement".process_mode = Node.PROCESS_MODE_DISABLED
		gravity = true
	else:
		%"Normal Movement".process_mode = Node.PROCESS_MODE_DISABLED
		%"Zero Gravity Movement".process_mode = Node.PROCESS_MODE_INHERIT
		gravity = false

func jump_particles_instantiate():
	var jp = jump_particle_instance.instantiate()
	$Particles.add_child(jp)


func _on_swan_time_timeout() -> void:
	Engine.time_scale = 1
	AudioServer.playback_speed_scale = 1


func _on_swan_time_recharge_timeout() -> void:
	swan_time_available = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("asdasdasdasdasda")
	die()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("asdasdasdasdasda")
	die()
