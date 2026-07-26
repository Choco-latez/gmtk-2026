extends Button

var unlocked = true

func _ready() -> void:
	button_down.connect(_on_button_down)

func invalid():
	visible = false
	unlocked = false
	



func _on_button_down() -> void:
	if unlocked:
		SignalBus.load_scene( int(name)-1 )
