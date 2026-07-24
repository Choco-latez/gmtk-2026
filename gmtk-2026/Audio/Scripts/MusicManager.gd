extends AudioStreamPlayer

var Musics = [preload( "res://Audio/Area 1-1.mp3"),
preload("res://Audio/Area 2-1.mp3"),
preload("res://Audio/Area 3-1.mp3")]
var cur_music = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_bus("Music")
	set_stream(Musics[0])
	play()

func swap_music(index):
	if index != cur_music:
		set_stream(Musics[index])
		
func _process(delta: float) -> void:
	if not playing:
		play()
