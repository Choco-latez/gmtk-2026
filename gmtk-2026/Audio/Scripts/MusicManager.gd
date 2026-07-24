extends AudioStreamPlayer

var Musics = [preload( "res://Audio/Area 1-1.mp3"),
preload("res://Audio/Area 2-1.mp3"),
preload("res://Audio/Area 3-1.mp3")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_bus("Music")
	set_max_polyphony(2)
	set_stream(Musics[0])
	play()
