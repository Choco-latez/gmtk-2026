extends Node

# replace with actual levels in order
var Levels = [
	"res://Map/map_test.tscn",
	"res://Map/map_test.tscn",
]
var current_level : int = 0
var unlocked_levels : int = 0

var fastdeath : bool = true
