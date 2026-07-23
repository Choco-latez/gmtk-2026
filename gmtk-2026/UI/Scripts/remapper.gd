extends HBoxContainer


var is_remapping : bool = false
var remapping_button = null
var old_but_text = ""
var can_exit = true

func _ready() -> void:
	InputMap.load_from_project_settings()
	

func button_clicked(button):
	can_exit = false
	is_remapping = true
	remapping_button = button
	old_but_text = button.text
	button.text = "Press Button to Remap"
	
	
func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey:
			InputMap.action_erase_events(remapping_button.name)
			InputMap.action_add_event(remapping_button.name, event)
			
			remapping_button.text = remapping_button.name + " : " + event.as_text().trim_suffix(" (Physical)")
			is_remapping = false
			remapping_button = null
			






func _on_up_button_down() -> void:
	button_clicked($VBoxContainer/UP)


func _on_down_button_down() -> void:
	button_clicked($VBoxContainer/DOWN)


func _on_left_button_down() -> void:
	button_clicked($VBoxContainer/LEFT)


func _on_right_button_down() -> void:
	button_clicked($VBoxContainer/RIGHT)


func _on_jump_button_down() -> void:
	button_clicked($VBoxContainer2/JUMP)


func _on_dive_button_down() -> void:
	button_clicked($VBoxContainer2/DIVE)


func _on_interact_button_down() -> void:
	button_clicked($VBoxContainer2/USE)


func _on_menu_button_down() -> void:
	button_clicked($VBoxContainer2/MENU)
