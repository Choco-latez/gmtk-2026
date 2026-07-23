class_name Player
extends CharacterBody2D

signal died

@export var jump_particle_instance : PackedScene

const SPEED = 120.0
const JUMP_VELOCITY = -100.0
var can_jump : bool
var continue_jump : bool

@export var base_additional_jumps : int = 1
var additional_jumps_available : int

@export var dive_unlocked :bool = false

var dive_available : bool = true
var diving : bool = false

var gravity:bool = true

@export var swan_time_unlocked: bool = false
var swan_time_available :bool = true

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

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		apply_gravity(!gravity)
	if Input.is_action_just_pressed("debug2"):
		die()
		
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
