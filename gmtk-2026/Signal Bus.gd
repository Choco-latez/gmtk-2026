extends Node


signal exit_anim(pos)
func start_exit_anim(pos):
	exit_anim.emit(pos)

signal new_music(index)
func swap_scene():
	print("changed scene")
	Savedata.unlocked_levels = max(Savedata.current_level+1,Savedata.unlocked_levels)
	Savedata.current_level+=1
	var next_level : String = Savedata.Levels.get(Savedata.current_level+1) # Get the path of next level's file
	get_tree().change_scene_to_file(next_level) # Change scene
	#new_music.emit((Savedata.Levels.rfind(next_level))) # Get its index from the list, then emit that index for music
	#^^^changed to be controlled by map
	

func load_scene(level_index:int):
	Savedata.current_level= level_index
	get_tree().change_scene_to_file(Savedata.Levels.get(level_index))
	
signal change_gravity(gravity)
func ch_gravity(gravity):
	change_gravity.emit(gravity)

signal used_ability
func use_ability():
	used_ability.emit()
