class_name Player
extends CharacterBody2D

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
	queue_free()

func _ready() -> void:
	apply_gravity(true)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		apply_gravity(!gravity)
	
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
