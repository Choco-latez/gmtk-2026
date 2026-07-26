extends Node

# replace with actual levels in order
var Levels = [
	"res://Map/platformPart1.tscn",
	"res://Map/platformPart2.tscn",
	"res://Map/antiGravPart1.tscn",
	"res://Map/antigrav.tscn",
	"res://Map/level 4.tscn",
	"res://Map/antiGravPart2.tscn",
	"res://Map/double jumps.tscn",
	"res://Map/divePart1.tscn",
	"res://Map/double_jump.tscn",
	"res://Map/boss_battle.tscn"
]
var current_level : int = 0
var unlocked_levels : int = 0

var fastdeath : bool = false

var no_boss_cutscene : bool = false
