extends Control

@export var Levels : Array[PackedScene]

func _ready() -> void:
	for child_indx in %"Level Select Panel".get_node("BoxContainer").get_child_count():
		if child_indx > Savedata.unlocked_levels:
			%"Level Select Panel".get_node("BoxContainer").get_child(child_indx).invalid()

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		%"Level Select Panel".visible = false
		%"Credits Panel".visible = false
		%"Settings Panel".visible = false

func _on_level_select_button_down() -> void:
	%"Level Select Panel".visible = true
	%"Credits Panel".visible = false
	%"Settings Panel".visible = false


func _on_settings_button_down() -> void:
	%"Level Select Panel".visible = false
	%"Credits Panel".visible = false
	%"Settings Panel".visible = true


func _on_credits_button_down() -> void:
	%"Level Select Panel".visible = false
	%"Credits Panel".visible = true
	%"Settings Panel".visible = false


func _on_exit_button_down() -> void:
	get_tree().set_auto_accept_quit(false)
	get_tree().quit()


func _on_check_button_toggled(toggled_on: bool) -> void:
	Savedata.fastdeath = toggled_on
