extends Node

# replace with actual levels in order
# number corresponds to music playing
var Levels = [
	["res://Map/Tutorial.tscn",0],
	["res://Map/map_test.tscn",0],
	]
var current_level : int = 0
var unlocked_levels : int = 0

var fastdeath : bool = false
