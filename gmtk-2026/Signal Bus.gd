extends Node


signal exit_anim(pos)
func start_exit_anim(pos):
	exit_anim.emit(pos)

signal new_music(index)
func swap_scene():
	print("changed scene")
	Savedata.current_level+=1
	Savedata.unlocked_levels = max(Savedata.current_level,Savedata.unlocked_levels)
	var next_level : String = Savedata.Levels.get(Savedata.current_level) # Get the path of next level's file
	print(next_level)
	get_tree().  call_deferred("change_scene_to_file",next_level) # Change scene

	#new_music.emit((Savedata.Levels.rfind(next_level))) # Get its index from the list, then emit that index for music
	#^^^changed to be controlled by map
	

func load_scene(level_index:int):
	print("did thing")
	Savedata.current_level= level_index
	get_tree().change_scene_to_file(Savedata.Levels.get(level_index))
	
func load_finish():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	await get_tree().scene_changed
	get_tree().current_scene.add_child(load("res://UI/thank u for play.tscn").instantiate())
	MusicManager.swap_music(0)

signal change_gravity(gravity)
func ch_gravity(gravity):
	change_gravity.emit(gravity, false)

signal used_ability
func use_ability():
	used_ability.emit()
