extends Node


signal exit_anim(pos)
func start_exit_anim(pos):
	exit_anim.emit(pos)

func swap_scene():
	print("changed scene")
	#get_tree().change_scene_to_file("")
