class_name MapButton
extends Node

enum BUTTON_TYPES{BUTTON,LEVER,PROGRESS,SWITCH}
@export var button_type : BUTTON_TYPES
var is_on : bool = false

signal turned_on
signal turned_off
