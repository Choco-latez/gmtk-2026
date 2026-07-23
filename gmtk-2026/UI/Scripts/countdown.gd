class_name Countdown
extends Control

@export var countdown_time: float
@export var gravity_working :bool = true
var pause_timer : bool = false
signal change_gravity(gravity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("change_gravity",SignalBus.ch_gravity)
	SignalBus.connect("used_ability",skill_used)
	
	$Timer.wait_time = countdown_time
	
	%ProgressBar.max_value = countdown_time
	%ProgressBar.value = countdown_time
	

func start():
	%ProgressBar.visible = true
	$Timer.start()

func skill_used():
	if not pause_timer:
		var time = $Timer.time_left/2
		$Timer.start(time)
		#play sound

func _physics_process(delta: float) -> void:
	if not pause_timer:
		if gravity_working:
			%ProgressBar.value = $Timer.time_left
			%ProgressLabel.text = str(int(round($Timer.time_left))) + " seconds left until gravity's out!"
		else:
			%ProgressBar.value = countdown_time - $Timer.time_left
			%ProgressLabel.text = str(int (round($Timer.time_left))) + " seconds left until gravity's back!"

func _on_timer_timeout() -> void:
	gravity_working = !gravity_working
	change_gravity.emit(gravity_working)
	$WaitTimer.start()
	pause_timer = true
	%ProgressLabel.visible=false
	$Timer.wait_time = countdown_time


func _on_wait_timer_timeout() -> void:
	$Timer.start()
	pause_timer = false
	%ProgressLabel.visible=true
