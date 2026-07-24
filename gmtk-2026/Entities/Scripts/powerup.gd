class_name powerup
extends SignEntity

enum powerups{ADDITIONAL_JUMPS,DIVE,TIME_SLOW, BOSS}
@export var powerup_type : powerups
var info = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if powerup_type == powerups.ADDITIONAL_JUMPS:
		body.base_additional_jumps +=1
	elif powerup_type == powerups.DIVE:
		body.dive_unlocked = true
	elif powerup_type == powerups.TIME_SLOW:
		body.swan_time_unlocked = true
	else:
		body.base_additional_jumps +=1
	$GPUParticles2D.emitting = false
	$GPUParticles2D2.emitting = false
	$Area2D.monitoring = false
	
	if powerup_type == powerups.ADDITIONAL_JUMPS:
		sign_interacted.emit("NEW ABILITY","   Additional Air jump
		Jump again in the air!
		Be careful, it messes with the gravitational forcefield...")
	elif powerup_type == powerups.DIVE:
		sign_interacted.emit("NEW ABILITY","   Dive/Dash
		Press Z to dive, or if in zero gravity, dash.
		Be careful, it messes with the gravitational forcefield...")
	elif powerup_type == powerups.TIME_SLOW:
		sign_interacted.emit("NEW ABILITY","   Swan time
		Press C to slow down time.
		It seems to affect everything but the gravitional forcefield...")
	

	
	queue_free()
