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

func into_place(pos:Vector2):
	cutscene_control = true
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position",pos, 0.1)

func transform():
	$AnimManager.queue_free()
	%AnimationPlayer.play("transform")
func honk():
	%AnimationPlayer.play("honk")
func honk_run():
	%AnimationPlayer.play("swan run")
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2( position.x + 300  ,position.y), 2)

func start_cutscene():
	cutscene_control = true

	
func stop_cutscene():
	cutscene_control = false


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
	apply_gravity(true, true)
	SignalBus.connect("change_gravity",apply_gravity)
	connect("ability_used",SignalBus.use_ability)

func _physics_process(delta: float) -> void:
	swan_time()
	
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

@onready var grav_switch: AudioStreamPlayer2D = %GravSwitch
func apply_gravity(true_or_false:bool, first_run : bool):
	if not first_run:
		grav_switch.play()
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
