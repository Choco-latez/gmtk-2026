class_name ConnectedEntity
extends Node2D

@export var button : MapButton

func _ready() -> void:
	button.connect("turned_on",turned_on)
	button.connect("turned_off",turned_off)

func turned_on():
	pass

func turned_off():
	pass
