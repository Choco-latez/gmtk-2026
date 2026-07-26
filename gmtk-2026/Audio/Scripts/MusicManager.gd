extends AudioStreamPlayer

var Musics = [preload( "res://Audio/Area 1-1.mp3"),
preload("res://Audio/Area 2-1.mp3"),
preload("res://Audio/Area 3-1.mp3"),
preload("res://Audio/Boss.mp3")
]
var mute = false
var cur_music = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("new_music",swap_music)
	set_bus("Music")
	set_stream(Musics[0])
	play()

func swap_music(index):
	if index == -1:
		return
	if index != cur_music:
		cur_music = index
		set_stream(Musics[index])
		play()
		
func _process(delta: float) -> void:
	if not playing and not mute:
		play()
