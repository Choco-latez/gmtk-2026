extends Node

# replace with actual levels in order
var Levels = [
	"res://Map/Tutorial.tscn",
	"res://Map/Level2.tscn",
	"res://Map/level 3.tscn",
	"res://Map/level 4.tscn"
]
var current_level : int = 0
var unlocked_levels : int = 0

var fastdeath : bool = false

var no_boss_cutscene : bool = false
