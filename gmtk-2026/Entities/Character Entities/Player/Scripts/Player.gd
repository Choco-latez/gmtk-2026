class_name Player
extends CharacterBody2D

signal died

@export var jump_particle_instance : PackedScene

const SPEED = 120.0
const JUMP_VELOCITY = -100.0
var can_jump : bool
var continue_jump : bool

var base_additional_jumps : int = 1
var additional_jumps_available : int


var dive_available : bool = true
var diving : bool = false

var gravity:bool = true

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
